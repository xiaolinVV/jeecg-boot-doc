# Online 表单开发 前端→后端→数据库 全链路解析（VUE2）

> 角色口吻：Linus；只讲技术，不兜圈子。

## 0. 站位图（一句话概览）
菜单 `Online表单开发` → 前端路由组件 `OnlCgformHeadList`（打包在 `@jeecg/antd-online-mini`） → 调用一组 `/online/cgform` 与 `/online/cgform/api` 接口 → 后端私有 jar `org.jeecgframework.boot:hibernate-re:3.6.1-RC` 的控制器与服务 → 读写在线模型表 `onl_*` 并按配置生成/同步真实业务表与代码。

## 1. 前端链路
- 菜单绑定：`sys_permission_v2.component = modules/online/cgform/OnlCgformHeadList`（见 `jeecg-boot/db/jeecgboot-mysql-5.7.sql`）。
- 路由解析：`ant-design-vue-jeecg/src/utils/util.js` 在生成路由时检测到上述组件名，改为 `onlineCommons.OnlCgformHeadList`，来源包 `@jeecg/antd-online-mini/dist/OnlineForm.umd.min.js`。
- 列表页主要职责：
  - 列表数据：`GET /online/cgform/head/list`
  - 删除/移除：`/online/cgform/head/delete`、`/deleteBatch`、`/removeRecord`
  - 同步数据库：`/online/cgform/api/doDbSynch/{id}/{mode}`（mode=normal/force）
  - 扩展功能：JS/SQL/JAVA增强、自定义按钮、权限、复制表等均通过同一组件的弹窗子组件调用对应接口。
- 运行态自动表单（进入“功能测试”）：
  - 核心接口前缀 `/online/cgform/api`
  - 列定义：`getColumns/{code}`
  - 数据：`getData/{code}`；导入 `importXls/{code}`；导出 `exportXls/{code}`
  - 动作：`doButton`（自定义按钮执行），`startMutilProcess`（BPM），`form/{code}/{id}` CRUD。
  - 前端把接口返回的 columns、dict、button、EnhanceJS 注入 Ant Table & Form；EnhanceJS 通过 `eval` 执行（安全风险）。
- 代码生成入口：
  - 列表页按钮 `goGenerateCode()` → 校验已同步数据库、主表选择。
  - 弹窗组件 `CodeGenerator`（同包）：先 `GET /online/cgform/head/tableInfo?code={id}` 拉元数据与默认目录；提交 `POST /online/cgform/api/codeGenerate`；再 `POST /online/cgform/api/downGenerateCode` 下载 zip。

## 2. 后端接口与实现（基于反编译 jar 及接口命名推断）
- 主要控制器：`org.jeecg.modules.online.cgform.c.*`（jar `hibernate-re-3.6.1-RC`），入口 `@RequestMapping("/online/cgform/api")`。
- 关键服务：
  - `IOnlCgformHeadService`：表头与元数据维护；同步数据库。
  - `IOnlCgformFieldService`：字段元数据。
  - `IOnlCgformSqlService` / `IOnlAuthPageService`：SQL、权限增强。
  - `IOnlCgformButtonService`：自定义按钮。
  - 代码生成：服务内部根据 head/field/sub 表配置，渲染模板（后端持有代码模板集），落地到指定 project_path，再返回文件列表+pathKey。
- 同步数据库流程（推断）：
  1) 读取 `onl_cgform_head/onl_cgform_field` 配置。
  2) 根据 `table_type` 与 `relation_type` 生成/更新物理表，mode=force 时重建。
  3) 更新 `is_db_synch` 标志。
- 代码生成流程：
  1) 校验 `is_db_synch=Y`。
  2) 读取模板：分“业务分层(service)”与“代码分层(project)”两种包结构；支持风格 `jspMode`（普通/jvxe/tree/tab/erp 等）。
  3) 主子表元数据（含字典、控件、JS/SQL/JAVA 增强引用）灌入模板。
  4) 结果写入后端文件系统；记录 pathKey，便于打包下载。

## 3. 数据库模型（核心表）
- `onl_cgform_head`：主表定义，含表名、类型(0单表/1主表/2附表/3一对多)、版本、说明、分页、树配置、模板、主题、复制标记等。
- `onl_cgform_field`：字段清单，含控件类型、字典、校验、查询方式、显示/隐藏、排序等。
- `onl_cgform_button`：自定义按钮，`button_style`=button/link，`button_type`=js/action。
- `onl_cgform_enhance_{js,sql,java}`：增强脚本与触发点。
- `onl_cgform_index`：自定义索引，`is_db_synch` 标识同步状态。
- 业务物理表：同步数据库后生成真实业务表（表名即 head.table_name），字段来自 `onl_cgform_field`；主子表通过外键命名约定 `_ID` 关联。

## 4. 时序视角（单表示例）
1) 用户在前端新建表单 → 提交 `onl_cgform_head` + `onl_cgform_field` 元数据。
2) 点击“同步数据库” → `/online/cgform/api/doDbSynch/{id}/{mode}` → 生成/更新物理表，`is_db_synch=Y`。
3) 点击“代码生成” → `/head/tableInfo` 拉元数据 → `/api/codeGenerate` 生成代码 → `/api/downGenerateCode` 下载 zip。
4) 菜单配置指向生成的前端页面路径，后端代码放入目标模块，重启即可。

## 5. 一对多 / 特殊模板
- 一对多：`table_type=3`，`relation_type=0/1`（多/一）；`sub_table_str` 保存子表清单；字段约定子表外键以 `_ID` 结尾且与主表主键同名。
- 树：`is_tree=Y`，`tree_parent_id_field/tree_id_field/tree_fieldname` 确定树结构字段；前端自动走树形列表组件。
- 主题模板：`theme_template` 可选 `erp/tab/innerTable` 等，路由跳转不同自动列表组件。

## 6. 关键校验与约束
- 代码生成前必须 `is_db_synch=Y`（前端已做校验；后端也会拒绝）。
- 物理表名、字段名来自元数据，未同步时生成代码可能与实际表不符。
- 增强脚本：
  - JS：前端 `eval` 执行，风险高；建议受控来源和审计。
  - SQL/JAVA：后端执行，需注意注入与事务隔离。
- 下载路径：前端用 `localStorage jeecg_onl_project_path` 记住生成目录，默认从后端接口返回路径。

## 7. 风险/改进建议
- 闭源 jar + 闭源前端包：无法内联调试，升级需联动验证；建议官方开放接口文档/签名。
- 前端 `eval` 增强脚本：建议后端白名单+签名校验，或移至 sandbox。
- 同步/生成无 schema diff 预览：force 模式会删表，风险大；应增加差异预览和备份。
- 接口无版本前缀：未来升级易破坏用户空间，建议加版本路由或能力探测。

## 8. 快速排错指引
- 列表空白/字段错乱：查 `/online/cgform/api/getColumns/{code}` 返回是否正常；核对 `onl_cgform_field` 字段 `is_db_synch`。
- 同步失败：检查表名重复、索引冲突、字段长度变更；必要时用 `force`，但先备份。
- 生成失败：确认 `projectPath` 可写、`is_db_synch=Y`、模板风格合法；查看接口返回日志列表。

## 9. 结语
这条链路的本质：元数据驱动 + 模板渲染。把元数据搞干净，其他都是流水线。不要在“增强”里堆屎山，更不要破坏用户空间。***
