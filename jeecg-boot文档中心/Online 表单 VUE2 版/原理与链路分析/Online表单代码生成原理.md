# Online 表单代码生成原理（VUE2 端）——基于反编译源码的全链路说明

> 前端在线表单核心组件未开源，打包于 `ant-design-vue-jeecg/node_modules/@jeecg/antd-online-mini/dist/OnlineForm.umd.min.js`；  
> 后端源码未开源，已反编译保存于仓库根 `jeecg-decomp/`：  
> - `jeecg-decomp/hibernate-re-3.6.1-RC`：在线表单接口与服务实现  
> - `jeecg-decomp/codegenerate-1.4.7`：代码生成引擎与模板渲染基类  
> 模板文件本身在仓库：`jeecg-module-system/jeecg-system-biz/src/main/resources/jeecg/code-template-online`

## 1. 页面截图（核对 UI 与文档一致性）
- 在线表单列表页：![](images/Online表单开发页面.png)  
  按钮含：新增、自定义按钮、JS/SQL/JAVA 增强、导入数据库表、代码生成，与文中描述一致。
- 新增表单弹窗：![](images/Online表单开发新增表单.png)  
  关键字段：表名、表描述、表类型、主键策略、分页、树/一对多配置等，正对应元数据存储章节。
- 代码生成弹窗：![](images/Online表单开发代码生成.png)  
  字段：代码生成目录、页面风格(jspMode)、表名/实体名/包名/功能说明/代码类型，与前端采集参数章节一致。

## 2. 数据到模板的总流程
前端生成器表单 JSON → `OnlCgformApiController`(`/online/cgform/api/codeGenerate`) → `IOnlCgformHeadService.generateCode` / `generateOneToMany` → 组装 TableVo/ColumnVo/SubTableVo → `codegenerate` 模块 BaseCodeGenerate + FreeMarker 读取 `code-template-online` 模板 → 输出 Java/Vue/Mapper/XML/SQL 到指定 projectPath。

## 3. 元数据存储（在线表单配置）
- 表头：`onl_cgform_head`（表名/类型/模板/树参数/分页/滚动/复制标记/同步标记 is_db_synch 等）
- 字段：`onl_cgform_field`（db 字段类型、长度、小数、是否主键/必填/查询/列表/表单、控件 showType、字典配置、默认值、校验、href、排序、外键 mainTable/mainField、扩展 JSON）
- 辅助：`onl_cgform_button`（自定义按钮）、`onl_cgform_enhance_{js,sql,java}`、`onl_cgform_index`

## 4. 前端生成器采集参数（CodeGenerator 弹窗）
- `projectPath`（本地存储记忆）
- `jspMode`（模板风格：default/jvxe/erp/tab/inner-table/tree 等）
- `jformType`（1 单表 / 3 一对多）
- `entityName`、`entityPackage`、`tableName_tmp`、`ftlDescription`
- `packageStyle`（service vs project 仅影响包路径）
- `codeTypes`（controller/service/dao/mapper/entity/vue）
- 子表列表：表名/实体名/说明（来自 head.sub_table_str）

## 5. 后端生成实现（基于反编译源码）
### 5.1 控制器：`jeecg-decomp/hibernate-re-3.6.1-RC/org/jeecg/modules/online/cgform/c/a.java`
- 路径 `/online/cgform/api/codeGenerate`
- 防护：若开启 firewall.dataSourceSafe，强制使用全局 projectPath；生成后把 `pathKey`→`projectPath` 写 Redis(30 分钟)，用于下载/预览校验。
- 分流：`jformType==1` 调 `generateCode`；否则 `generateOneToMany`。
- 下载接口 `/downGenerateCode` / `/codeView` 校验请求路径必须在 Redis 记录的 projectPath 且包含 `src/main/java`，防目录穿越。

### 5.2 服务：`jeecg-decomp/hibernate-re-3.6.1-RC/org/jeecg/modules/online/cgform/service/a/d.java`
- **generateCode（单表）**
  1) 取 head、字段列表（`db_is_persist=1` 按 order_num）。
  2) 映射 ColumnVo：dbName→camelName、dbType→javaType、长度/小数、isKey/isShow/isShowList/isQuery/queryMode/showType/字典/默认值/校验/href/排序/外键等。
  3) 组装 TableVo：entityName/entityPackage/tableName/描述/fieldRowNum、扩展参数 scroll、树 pid/id/text、vueStyle。
  4) 模板枚举 `CgformEnum.getCgformEnumByConfig(jspMode)` → templatePath/stylePath。
  5) `new CodeGenerateOne(...).generateCodeFile(projectPath, templatePath, stylePath)` 渲染并返回文件列表。
  6) 若生成失败，返回两条排错提示（路径含中文/空格；jar 部署需额外配置）。
- **generateOneToMany（主从）**
  1) 主表同上。子表遍历 front 传入的 `subList`，查 head/field。
  2) 找出子表外键字段（mainTable 非空的字段），设置 `foreignKeys/foreignMainKeys`，relationType==1 视为一对一。
  3) 组装 SubTableVo 列表，调用 `CodeGenerateOneToMany(...).generateCodeFile(...)`。
  4) 若主表但未传子表，直接抛 `JeecgBootException`。
- 字段类型映射：内部 `b(dbType)` 将 string→String，int→Integer/Long，BigDecimal/double/Datetime 等。

### 5.3 模板引擎：`jeecg-decomp/codegenerate-1.4.7/org/jeecgframework/codegenerate/generate/impl/a/a.java` (BaseCodeGenerate)
- 遍历模板根目录，按 `stylePath` 过滤（Vue2/Vue3/JVXE）。
- 相对路径前缀 `java` → 输出到 `src/main/java/{packagePath}/...`；前缀 `webapp` → 输出到 `src/main/resources`/前端路径（常量 h/i）。
- 使用 FreeMarker 渲染，上下文 Map 由 TableVo/SubTableVo/fieldList 等填充。

## 6. 模板目录与选择（细化到模板文件）
### 6.1 枚举 → 模板路径 → 结构类型（来自 `CgformEnum`）
- 模板根：`jeecg-module-system/jeecg-system-biz/src/main/resources/jeecg/code-template-online/`
- `jspMode` → `stylePath` → 模板子目录；`packageStyle` 只影响 Java 包路径，不影响模板目录。

| type | jspMode(code) | 结构 | stylePath | 说明 | 支持的 vueStyle |
| --- | --- | --- | --- | --- | --- |
| 1 | `one` | 单表 | `default.one` | 经典风格 | `vue3` / `vue` / `vue3Native` |
| 2 | `many` | 一对多 | `default.onetomany` | 经典风格 | `vue` |
| 2 | `jvxe` | 一对多 | `jvxe.onetomany` | JVXE 风格 | `vue3` / `vue` / `vue3Native` |
| 2 | `erp` | 一对多 | `erp.onetomany` | ERP 风格 | `vue3` / `vue` / `vue3Native` |
| 2 | `innerTable` | 一对多 | `inner-table.onetomany` | 内嵌子表风格 | `vue3` / `vue` |
| 2 | `tab` | 一对多 | `tab.onetomany` | Tab 风格 | `vue3` / `vue` |
| 3 | `tree` | 树表 | `default.tree` | 树形列表 | `vue3` / `vue` / `vue3Native` |

> 注意：`default/onetomany` 目录仅有 Vue2 模板文件，与 `CgformEnum.MANY` 的 vueStyle（仅 `vue`）一致；  
> 其它一对多风格按各自模板目录（`jvxe/erp/inner-table/tab`）区分。

### 6.2 目录分层与结构含义
- `default/one`：单表（经典）
- `default/tree`：树表（经典）
- `default/onetomany`：一对多（经典，Vue2）
- `jvxe/onetomany`：一对多（JVXE 子表）
- `erp/onetomany`：一对多（ERP 结构）
- `inner-table/onetomany`：一对多（子表内嵌）
- `tab/onetomany`：一对多（子表 Tab）
- `common/`：公共 FreeMarker 片段（表单、校验、初始化、SQL 片段）

### 6.3 各模板对应的模板文件清单（相对 `code-template-online/`）
> 说明：`[1-n]` 代表子表实体占位符，`*.javai`/`*.vuei` 是 FreeMarker 模板文件后缀。

#### 6.3.1 `default.one`（单表 / 经典）
- Java：  
  `default/one/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `default/one/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `default/one/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `default/one/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `default/one/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `default/one/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`
- Vue2：  
  `default/one/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Form.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal__Style#Drawer.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3：  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3/${entityName}List.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Form.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Modal.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__api.tsi`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__data.tsi`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3Native：  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}List.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Form.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Modal.vuei`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__api.tsi`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__data.tsi`  
  `default/one/java/${bussiPackage}/${entityPackage}/vue3Native/V${currentDate}_1__menu_insert_${entityName}.sql`
- UniApp：  
  `default/one/java/${bussiPackage}/${entityPackage}/uniapp/${entityName}List.vue`  
  `default/one/java/${bussiPackage}/${entityPackage}/uniapp/${entityName}Form.vue`

#### 6.3.2 `default.tree`（树表 / 经典）
- Java：  
  `default/tree/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `default/tree/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `default/tree/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `default/tree/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `default/tree/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `default/tree/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`
- Vue2：  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3：  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3/${entityName}List.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Form.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Modal.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__api.tsi`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__data.tsi`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3Native：  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}List.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Form.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Modal.vuei`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__api.tsi`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__data.tsi`  
  `default/tree/java/${bussiPackage}/${entityPackage}/vue3Native/V${currentDate}_1__menu_insert_${entityName}.sql`

#### 6.3.3 `default.onetomany`（一对多 / 经典）
- Java：  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/service/[1-n]Service.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/[1-n]ServiceImpl.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/mapper/[1-n]Mapper.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/[1-n]Mapper.xml`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/entity/[1-n]Entity.javai`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/vo/${entityName}Page.javai`
- Vue2：  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Form.vuei`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/[1-n]Form.vuei`  
  `default/onetomany/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`

#### 6.3.4 `jvxe.onetomany`（一对多 / JVXE）
- Java：  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/service/[1-n]Service.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/[1-n]ServiceImpl.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/mapper/[1-n]Mapper.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/[1-n]Mapper.xml`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/entity/[1-n]Entity.javai`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vo/${entityName}Page.javai`
- Vue2：  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Form.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/[1-n]Form.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3：  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}List.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Form.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Modal.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/[1-n]Form.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__api.tsi`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__data.tsi`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3Native：  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}List.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Form.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Modal.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/[1-n]Form.vuei`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__api.tsi`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__data.tsi`  
  `jvxe/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/V${currentDate}_1__menu_insert_${entityName}.sql`

#### 6.3.5 `erp.onetomany`（一对多 / ERP）
- Java：  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/service/[1-n]Service.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/[1-n]ServiceImpl.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/mapper/[1-n]Mapper.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/[1-n]Mapper.xml`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/entity/[1-n]Entity.javai`
- Vue2：  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue/[1-n]List.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/[1-n]Modal.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3：  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}List.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/[1-n]List.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Modal.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/[1-n]Modal.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__api.tsi`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__data.tsi`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3Native：  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}List.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/[1-n]List.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Form.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/${entityName}Modal.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/[1-n]Form.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/components/[1-n]Modal.vuei`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__api.tsi`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/${entityName}__data.tsi`  
  `erp/onetomany/java/${bussiPackage}/${entityPackage}/vue3Native/V${currentDate}_1__menu_insert_${entityName}.sql`

#### 6.3.6 `inner-table.onetomany`（一对多 / 内嵌子表）
- Java：  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/service/[1-n]Service.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/[1-n]ServiceImpl.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/mapper/[1-n]Mapper.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/[1-n]Mapper.xml`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/entity/[1-n]Entity.javai`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vo/${entityName}Page.javai`
- Vue2：  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Form.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/[1-n]Form.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue/subTables/[1-n]SubTable.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3：  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}List.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Form.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Modal.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/[1-n]Form.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/subTables/[1-n]SubTable.vuei`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__api.tsi`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__data.tsi`  
  `inner-table/onetomany/java/${bussiPackage}/${entityPackage}/vue3/V${currentDate}_1__menu_insert_${entityName}.sql`

#### 6.3.7 `tab.onetomany`（一对多 / Tab）
- Java：  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/controller/${entityName}Controller.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/service/I${entityName}Service.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/${entityName}ServiceImpl.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/service/[1-n]Service.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/service/impl/[1-n]ServiceImpl.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/mapper/${entityName}Mapper.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/${entityName}Mapper.xml`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/mapper/[1-n]Mapper.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/mapper/xml/[1-n]Mapper.xml`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/entity/${entityName}.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/entity/[1-n]Entity.javai`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vo/${entityName}Page.javai`
- Vue2：  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue/${entityName}List.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Form.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/${entityName}Modal.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue/modules/[1-n]Form.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue/V${currentDate}_1__menu_insert_${entityName}.sql`
- Vue3：  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}List.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Form.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/${entityName}Modal.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/components/[1-n]Form.vuei`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__api.tsi`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/${entityName}__data.tsi`  
  `tab/onetomany/java/${bussiPackage}/${entityPackage}/vue3/V${currentDate}_1__menu_insert_${entityName}.sql`

#### 6.3.8 `common`（公共片段）
- 初始化：  
  `common/init/initValue.ftl`  
  `common/init/initValueSub.ftl`  
  `common/init/native/vue3NativeInitValue.ftl`  
  `common/init/native/vue3NativeMainInitValue.ftl`  
  `common/init/native/vue3NativeSubInitValue.ftl`
- 表单片段：  
  `common/form/vue3popup.ftl`  
  `common/form/vue3Jvxepopup.ftl`  
  `common/form/native/vue3NativeForm.ftl`  
  `common/form/native/vue3NativeSearch.ftl`  
  `common/form/native/vue3NativeComponents.ftl`  
  `common/form/native/vue3NativeImport.ftl`
- 校验规则：  
  `common/validatorRulesTemplate/core.ftl`  
  `common/validatorRulesTemplate/main.ftl`  
  `common/validatorRulesTemplate/sub.ftl`  
  `common/validatorRulesTemplate/sub-vue3.ftl`  
  `common/validatorRulesTemplate/native/vue3CoreNative.ftl`  
  `common/validatorRulesTemplate/native/vue3MainNative.ftl`
- 其它：  
  `common/utils.ftl`  
  `common/blob.ftl`  
  `common/sql/menu_insert.ftl`

## 7. 字段→模板映射要点
- 主键：`db_is_key=1` → `isKey=Y`
- 显示：`is_show_form/list/query` → 表单/列表/查询区域，`queryMode`（single/group），`queryShowType` 控件
- 字典：`dict_field/table/text` 保留，用于生成字典注解或联表
- 校验：`field_valid_type`、`field_must_input`
- 默认值：`db_default_val`
- 外键：`mainTable/mainField` 写入 SubTableVo.foreignKeys/foreignMainKeys
- 树：head 的 `is_tree`、`tree_parent_id_field/tree_id_field/tree_fieldname` 进入 TableVo.extendParams

## 8. 输出结构（service 分层示例）
```
<projectPath>/
  src/main/java/${packagePath}/controller/${entityName}Controller.java
  src/main/java/${packagePath}/service/I${entityName}Service.java
  src/main/java/${packagePath}/service/impl/${entityName}ServiceImpl.java
  src/main/java/${packagePath}/mapper/${entityName}Mapper.java
  src/main/resources/mapper/${entityName}Mapper.xml
  src/main/java/${packagePath}/entity/${entityName}.java
  src/main/resources/${entityName}-menu.sql (部分模板生成)
front/
  src/views/${modulePath}/${EntityName}List.vue 及 modal 组件
```

## 9. 校验与安全
- 必须先同步数据库：`is_db_synch=Y`，否则前端拦截/后端也拒绝。
- 下载/预览受 Redis pathKey 和路径前缀校验保护，防目录穿越。
- firewall 模式下禁止自定义 projectPath。

## 10. 排错顺序
1) `onl_cgform_field.db_is_persist=1`、`is_db_synch=Y`
2) 生成器入参（jspMode/路径/包名/实体名/子表列表）
3) 服务层映射（ColumnVo 是否含目标字段）
4) 模板占位符（确认所在模板路径是否被 stylePath 过滤）

---

本说明已融合反编译结果与模板源码，可直接对照 `jeecg-decomp/` 与 `code-template-online/` 进行进一步审计。***

---

## 11. 使用流程 & 生成链路（Mermaid）

### 11.1 用户操作流程（前端视角）
```mermaid
flowchart TD
  A[进入 Online表单开发页] --> B[点击 新增表单]
  B --> C[配置表头/字段/控件/字典]
  C --> D[保存]
  D --> E[同步数据库 doDbSynch]
  E --> F[功能测试/预览]
  E --> G[代码生成弹窗 CodeGenerator]
  G --> H[提交 codeGenerate]
  H --> I[下载 ZIP downGenerateCode]
  I --> J[拷贝前端代码 + 后端代码]
  J --> K[菜单配置/角色授权]
  K --> L[上线使用]
```

### 11.2 后端生成链路（请求到文件）
```mermaid
flowchart LR
  Req[POST /online/cgform/api/codeGenerate] --> Ctl[OnlCgformApiController]
  Ctl -->|防火墙校验·写Redis pathKey| Svc[OnlCgformHeadService]
  Svc -->|读 head/field/button/增强| VO[TableVo·ColumnVo·SubTableVo]
  VO --> Enum[CgformEnum 选模板目录]
  Enum --> Gen[CodeGenerateOne / OneToMany]
  Gen -->|FreeMarker 渲染| Files["写入 projectPath\n(src/main/java 和 webapp)"]
  Files --> Redis[Redis pathKey->projectPath<br/>TTL 1800s]
  Redis --> DL[POST /downGenerateCode<br/>打包下载]
```

### 11.3 代码生成输出结构（简版）
```mermaid
flowchart TB
  root[projectPath] --> java[src/main/java/<packagePath>]
  java --> ctrl[controller/<entityName>Controller.java]
  java --> svc[service & service/impl]
  java --> mapper[mapper/<entityName>Mapper.java]
  java --> entity[entity/<entityName>.java]
  root --> xml[src/main/resources/mapper/<entityName>Mapper.xml]
  root --> menu[src/main/resources/<entityName>-menu.sql]
  root --> front[front/src/views/<modulePath>/<EntityName>List.vue 等]
```
