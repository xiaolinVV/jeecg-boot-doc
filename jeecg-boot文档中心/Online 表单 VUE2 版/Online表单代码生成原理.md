# Online 表单代码生成原理（元数据→模板→代码）

> 关心的只有链路：表单元数据如何存、怎么喂给模板、模板如何落地。

## 1. 元数据：前端配置项 ↔ 数据库存储
前端在线表单配置界面写入两类核心表：

- `onl_cgform_head`（表头/主信息）
  - `table_name`：物理/生成表名。
  - `table_type`：0单表、1主表、2附表、3一对多。
  - `relation_type`：一对多/一对一。
  - `sub_table_str`：子表名列表，用逗号分隔。
  - 树形参数：`is_tree`、`tree_parent_id_field`、`tree_id_field`、`tree_fieldname`。
  - 模板/主题：`form_template`、`form_template_mobile`、`theme_template`、`form_category`。
  - 同步标记：`is_db_synch`，代码生成前必须为 `Y`。
  - 其它：分页、滚动条、复制版本、扩展 JSON（`ext_config_json`）。

- `onl_cgform_field`（字段维度）
  - 数据库形态：`db_field_name`、`db_type`、`db_length`、`db_point_length`、`db_is_key`、`db_is_null`、`db_default_val`、`db_is_persist`。
  - 表单控件：`field_show_type`（text/date/sel_search/popup/image/file/checkbox/radio/tree/...），`field_length`，`field_href`。
  - 校验/必填：`field_valid_type`、`field_must_input`。
  - 默认值：`field_default_value`（支持常量、#{var}、{{JS}}、${规则}）。
  - 字典：`dict_field`、`dict_table`、`dict_text`。
  - 查询配置：`is_query`、`query_mode`、`query_show_type`、`query_dict_*`、`query_valid_type`、`query_must_input`、`query_def_val`、`sort_flag`。
  - 关联：`main_table`、`main_field`（子表外键约定 *_ID）。
  - 扩展：`field_extend_json`、`converter`（自定义值转换器）。

辅助表：
- `onl_cgform_button`：自定义按钮（样式 button/link、类型 js/action、排序、权限）。
- `onl_cgform_enhance_js/sql/java`：增强脚本与触发点。
- `onl_cgform_index`：自定义索引，生成/同步时一并处理。

## 2. 前端生成器表单（CodeGenerator）采集了什么
组件位置：`@jeecg/antd-online-mini` 的 `CodeGenerator` 弹窗。

收集字段：
- `projectPath`：代码输出目录（localStorage `jeecg_onl_project_path` 记忆）。
- `jspMode`：页面风格（普通/jvxe/tree/erp/tab/innerTable 等）。
- `jformType`：1单表/2附表/3一对多（从 head.table_type）。
- `tableName_tmp`、`entityName`、`entityPackage`、`ftlDescription`。
- `packageStyle`：service 或 project（分层方式）。
- `codeTypes`：controller/service/dao/mapper/entity/vue（默认全选）。
- 子表信息 `subList[*]`：表名、实体名、功能说明（来自 head.sub_table_str + 子表 head）。

数据来源：`GET /online/cgform/head/tableInfo?code={id}`（后端拼装 head + sub + 默认 projectPath + 可用 jspMode 列表）。

提交：`POST /online/cgform/api/codeGenerate` 携带以上参数及当前表 id（code）。

下载：`POST /online/cgform/api/downGenerateCode`（参数 `fileList`、`pathKey`），得到 zip。

## 3. 代码生成后端流水线（推断自接口与字段）
1) **输入校验**
   - 检查 `is_db_synch=Y`；未同步直接拒绝。
   - 校验表名/包名/实体名合法性。
2) **装载元数据**
   - 读取 `onl_cgform_head`（主表）及其 `onl_cgform_field`；若一对多，按 `sub_table_str` 拉子表 head/field。
   - 读取按钮、增强、索引等附加配置。
3) **模板选择**
   - 分层方式 `packageStyle`：决定包结构（如 `com.xxx.modules.demo.controller` / `service` / `mapper` / `entity`）。
   - 页面风格 `jspMode`：决定前端模板（普通列表、JVXE 表格、树、ERP、TAB、内嵌等）。
   - 代码类型 `codeTypes`：决定生成哪些文件（controller/service/dao/mapper.xml/entity/vue）。
4) **模板渲染**
   - 模板存放在 jar 资源（未开源），使用占位符读取元数据（表名、字段、字典、关联、校验、查询、增强标记等）。
   - 生成实体：字段类型映射由 `db_type/db_length/db_point_length` 决定；主键策略来自 `id_type/id_sequence`。
   - 生成 Mapper XML：根据字段列表、查询配置 `is_query/query_mode/query_show_type` 拼 where 条件；排序标记 `sort_flag`。
   - 生成 Controller/Service：按分层样式插入基础 CRUD、分页；若开启流程/增强，插入钩子调用。
   - 生成前端 Vue：根据 `field_show_type` 渲染表单控件、校验、字典、查询区、列宽；一对多生成子表 tabs 或内嵌表；树模板用 `tree_*` 字段配置。
5) **输出与回传**
   - 将生成文件写入 `projectPath` 对应目录；记录 `pathKey` 与文件列表。
   - 返回文件列表供前端展示；下载接口压缩返回。

## 4. 生成逻辑的映射关系（重点字段）
- 字段类型 → 实体属性/DB 字段/校验
  - `db_type` + 长度 → Java 类型、MyBatis 列类型、前端输入控件精度限制。
  - `field_valid_type` / `field_must_input` → 前端 Ant Form rules，后端 Bean Validation（若模板包含）。
  - `dict_*` → 前端字典组件；同时生成 `@Dict` 或查询 join（取决于模板实现）。
- 关系/子表
  - 主表 `sub_table_str` + 子表外键约定 `_ID` → 生成一对多代码，子表 mapper/service/controller 同时输出。
- 查询区
  - `is_query`、`query_mode`、`query_show_type`、`query_dict_*` → 生成列表查询表单 & Mapper where 条件。
- 增强
  - `onl_cgform_enhance_js`：前端 `eval` 执行；模板可能仅保留入口占位。
  - `onl_cgform_enhance_sql/java`：后端在 CRUD 钩子里调用（模板含钩子占位）。
- 索引
  - `onl_cgform_index` 在同步数据库与生成建表脚本时使用，保证索引一致。

## 5. 典型执行顺序（生成一次代码）
1) 前端勾选代码生成 → 校验同步 → 弹窗填目录/包名/实体名等。
2) `/head/tableInfo` 拉元数据，前端展示默认值（实体名 = 驼峰表名首字母大写）。
3) `/api/codeGenerate`：
   - 后端载入 head/field/sub/button/增强/索引。
   - 选模板，填充上下文，输出文件到 projectPath。
   - 返回生成文件列表 + pathKey。
4) `/api/downGenerateCode` 打包下载 zip。

## 6. 关注点与风险
- 模板闭源：升级 jar 时需验证模板占位符与字段一致性。
- `eval` JS 增强：生成的前端代码可能继续 `eval`，审计与隔离要做好。
- 同步 vs 生成：未同步会导致实体/mapper 与真实表不一致；务必先同步再生成。
- 物理路径写入：`projectPath` 可写性决定是否成功；容器环境需授权挂载。

## 7. 结论
代码生成的核心是“把 `onl_cgform_head/field` 的元数据喂给模板”。理解表字段与配置就等于拿到了生成结果的控制权；其它只是模板细节。***

---

## 附：模板占位符与输出结构（基于公开版模板的可验证推断）
> 后端模板在私有 jar 中，无法直接展开；以下占位符和结构来自 Jeecg 公开代码生成模板的通用写法，足以对照生成结果进行排查。

### 常见占位符（FreeMarker 风格）
- `${packageName}`：代码基础包，与生成器表单的 `entityPackage`、`packageStyle` 共同决定。
- `${entityName}` / `${entityName?uncap_first}`：实体类名/实例名。
- `${tableName}`：物理表名（`table_name`）。
- `${tableTxt}`：功能说明（`table_txt`）。
- `${primaryKey.fieldName}` / `${primaryKey.propertyName}`：主键列/属性。
- 字段循环：`<#list fieldList as field>`  
  - `${field.fieldName}`：数据库列名  
  - `${field.propertyName}`：Java 属性名（下划线转驼峰）  
  - `${field.dbType}`、`${field.length}`、`${field.pointLength}`：类型与精度  
  - `${field.dictField}` / `${field.dictTable}` / `${field.dictText}`：字典配置  
  - `${field.showType}`：表单控件类型  
  - `${field.isQuery}`、`${field.queryMode}`：查询区配置

### 典型文件结构（代码分层 `service` 风格举例）
```
<projectPath>/
  src/main/java/${packagePath}/
    controller/${entityName}Controller.java
    service/${entityName}Service.java
    service/impl/${entityName}ServiceImpl.java
    mapper/${entityName}Mapper.java
    entity/${entityName}.java
  src/main/resources/mapper/${entityName}Mapper.xml
  src/main/resources/${entityName}-menu.sql         （部分版本会生成菜单 SQL）
front/
  src/views/${modulePath}/${EntityName}List.vue     （Vue 列表 + 表单）
```
> `packagePath` 是 `entityPackage` 的点转斜杠；`modulePath` 通常取包名的最后一级或表名驼峰。

### 字段到模板的常见映射示例
- 实体属性：
```java
@TableName("${tableName}")
public class ${entityName} implements Serializable {
  /** ${field.dbFieldTxt} */
  @TableId(type = IdType.${idType})
  private ${field.javaType} ${field.propertyName};
}
```
- Mapper XML where 片段（含查询配置）：
```xml
<if test="${field.propertyName} != null and ${field.propertyName} != ''">
  <#if field.queryMode == "single">
    and ${field.fieldName} = #{${field.propertyName}}
  <#elseif field.queryMode == "group">
    and ${field.fieldName} between #{${field.propertyName}Begin} and #{${field.propertyName}End}
  </#if>
</if>
```
- 前端列/表单渲染（Vue）：
```js
columns: [
  { title: '${field.dbFieldTxt}', dataIndex: '${field.propertyName}', align: 'center', sorter: ${field.sortFlag=='1'} }
]
formItems: [
  { label: '${field.dbFieldTxt}', field: '${field.propertyName}', component: '${field.showType}', dictCode: '${field.dictField},${field.dictText},${field.dictTable}' }
]
```

### 校验生成结果的办法
1. 生成代码后，检查实体/Mapper/Vue 是否包含上述占位符展开的实际值。
2. 若某字段缺失，回查对应 `onl_cgform_field` 的 `is_db_synch`、`db_is_persist`、`is_show_form/list/query` 是否为 0。
3. 一对多：确认主表生成了子表 tabs/内嵌组件，子表 mapper/service 同步生成；外键列以 `_ID` 命名并写入 XML join/on 条件。

> 由于模板闭源，若需要逐文件对照，可先把生成目录置空，再生成一次，通过 `find`/`diff` 观察新增内容，结合上面的占位符映射即可定位问题。***
