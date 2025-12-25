# Jeecg-boot意图驱动的自动化代码生成方案

> 目标：跳过 Jeecg-boot Online 表单配置 UI，保留 FreeMarker 模板生成逻辑，让 AI 直接从 DDL/业务描述生成标准代码。

---

## 1. 模板语义提取

### 1.1 模板目录结构

模板根路径：`jeecg-module-system/jeecg-system-biz/src/main/resources/jeecg/code-template-online/`

| jspMode | 结构类型 | stylePath | 输出 |
|---------|---------|-----------|------|
| `one` | 单表 | `default/one` | Controller/Service/Mapper/Entity/Vue |
| `tree` | 树表 | `default/tree` | 同上 + 树查询逻辑 |
| `many` | 一对多(经典) | `default/onetomany` | 主表 + 子表全套 |
| `jvxe` | 一对多(JVXE) | `jvxe/onetomany` | JVXE 子表编辑 |
| `erp` | 一对多(ERP) | `erp/onetomany` | 子表列表 + 弹窗 |
| `innerTable` | 一对多(内嵌) | `inner-table/onetomany` | 子表内嵌组件 |
| `tab` | 一对多(Tab) | `tab/onetomany` | 子表 Tab 切换 |

### 1.2 核心配置对象模型

FreeMarker 模板依赖两个核心数据结构：

#### TableVo（表级配置）
```java
class TableVo {
    String tableName;           // 物理表名
    String entityName;          // 实体类名（大驼峰）
    String entityPackage;       // 包路径（如 demo）
    String ftlDescription;      // 功能描述
    int fieldRowNum;            // 表单列数（1/2/3/4）
    Map<String, Object> extendParams; // 扩展参数
        // - scroll: 是否横向滚动
        // - pidField: 树表父ID字段
        // - idField: 树表主键字段
        // - textField: 树表显示字段
}
```

#### ColumnVo（字段级配置）
```java
class ColumnVo {
    // === 数据库属性 ===
    String fieldDbName;         // 物理字段名（下划线）
    String fieldName;           // Java属性名（小驼峰）
    String fieldDbType;         // DB类型：string/int/double/BigDecimal/Datetime/Date/Blob
    int dbLength;               // 字段长度
    int dbPointLength;          // 小数位数
    String dbDefaultVal;        // 数据库默认值
    boolean isKey;              // 是否主键
    boolean nullable;           // 是否允许空（N=必填）
    
    // === 表单属性 ===
    String classType;           // 控件类型（核心！）
    String filedComment;        // 字段中文名
    String isShow;              // 表单是否显示（Y/N）
    String isShowList;          // 列表是否显示
    String isQuery;             // 是否查询条件
    String queryMode;           // 查询模式：single/group
    String readonly;            // 是否只读
    String defaultVal;          // 表单默认值
    int uploadnum;              // 上传数量限制
    
    // === 字典配置 ===
    String dictField;           // 字典Code
    String dictTable;           // 字典表名
    String dictText;            // 字典显示字段
    
    // === 校验配置 ===
    String fieldValidType;      // 校验规则编码
    String fieldMustInput;      // 是否必填（1=是）
    
    // === 外键配置（一对多） ===
    String mainTable;           // 外键主表名
    String mainField;           // 外键主键字段
    
    // === 扩展参数 ===
    Map<String, Object> extendParams;
        // - popupMulti: popup是否多选
        // - multi: 部门/用户选择是否多选
        // - store: 存储字段
        // - text: 显示字段
}
```

### 1.3 控件类型清单（classType）

| 控件类型 | Vue组件 | 适用场景 |
|---------|--------|---------|
| `text`/默认 | `<a-input />` | 普通文本 |
| `date` | `<j-date />` | 日期选择 |
| `datetime` | `<j-date :show-time="true" />` | 日期时间 |
| `time` | `<j-time />` | 时间选择 |
| `textarea` | `<a-textarea />` | 多行文本 |
| `password` | `<a-input-password />` | 密码输入 |
| `list` | `<j-dict-select-tag type="list" />` | 下拉选择 |
| `radio` | `<j-dict-select-tag type="radio" />` | 单选框 |
| `checkbox` | `<j-multi-select-tag type="checkbox" />` | 复选框 |
| `list_multi` | `<j-multi-select-tag type="list_multi" />` | 多选下拉 |
| `sel_search` | `<j-search-select-tag />` | 搜索下拉 |
| `sel_user` | `<j-select-user-by-dep />` | 用户选择 |
| `sel_depart` | `<j-select-depart />` | 部门选择 |
| `sel_tree` | `<j-tree-select />` | 树形下拉 |
| `cat_tree` | `<j-category-select />` | 分类字典树 |
| `popup` | `<j-popup />` | 弹窗选择 |
| `switch` | `<j-switch />` | 开关 |
| `file` | `<j-upload />` | 文件上传 |
| `image` | `<j-image-upload />` | 图片上传 |
| `umeditor` | `<j-editor />` | 富文本 |
| `markdown` | `<j-markdown-editor />` | Markdown |
| `pca` | `<j-area-linkage />` | 省市区 |

### 1.4 校验规则编码

| 编码 | 含义 | 正则/逻辑 |
|-----|------|----------|
| `*` | 必填 | `required: true` |
| `only` | 唯一 | 远程校验 |
| `n6-16` | 6-16位数字 | `/^\d{6,16}$/` |
| `*6-16` | 6-16位任意 | `/^.{6,16}$/` |
| `e` | 邮箱 | 邮箱正则 |
| `m` | 手机 | `/^1[3456789]\d{9}$/` |
| `url` | 网址 | URL正则 |
| `n` | 数字 | `/^-?\d+\.?\d*$/` |
| `z` | 整数 | `/^-?\d+$/` |
| `money` | 金额 | 金额正则 |

---

## 2. 元数据映射机制

### 2.1 DDL → 配置对象的自动推导

AI 需要从 DDL 自动推导出 `TableVo` 和 `ColumnVo[]`，核心映射规则：

#### 2.1.1 表级推导

```
DDL: CREATE TABLE `order_main` (...)
     ↓
TableVo:
  tableName = "order_main"
  entityName = "OrderMain"          // 下划线转大驼峰
  entityPackage = "order"           // 取表名前缀或由AI推断
  ftlDescription = "订单主表"        // 从COMMENT或AI推断
  fieldRowNum = 2                   // 默认2列，可配置
```

#### 2.1.2 字段级推导（核心智能映射）

```yaml
# 数据库类型 → Java类型
VARCHAR/CHAR      → String
INT/TINYINT       → Integer
BIGINT            → Long
DECIMAL/NUMERIC   → BigDecimal
DOUBLE/FLOAT      → Double
DATE              → Date (fieldDbType=Date)
DATETIME/TIMESTAMP→ Date (fieldDbType=Datetime)
TEXT/LONGTEXT     → String (fieldDbType=Text)
BLOB              → byte[] (fieldDbType=Blob)

# 字段名 → 控件类型（语义推断）
*_status/*_state  → list + 字典
*_type/*_category → list + 字典
*_time/*_date     → date/datetime
create_time       → datetime + 隐藏
update_time       → datetime + 隐藏
create_by         → text + 隐藏
update_by         → text + 隐藏
*_id (外键)       → popup/sel_search
sex/gender        → radio + sex字典
phone/mobile      → text + 手机校验(m)
email             → text + 邮箱校验(e)
*_url/*_link      → text + URL校验
*_file/*_attach   → file
*_img/*_image/*_pic → image
*_content/*_desc  → textarea/umeditor
*_remark/*_note   → textarea
*_money/*_amount/*_price → number + money校验
is_*              → switch
sort/*_order      → number
```

### 2.2 业务描述增强

AI 可从自然语言描述中提取更精确的配置：

```
用户输入："status字段用下拉框，选项有：待审核、已通过、已拒绝"
     ↓
ColumnVo:
  classType = "list"
  dictField = "order_status"  // AI生成字典编码
  // 同时生成字典SQL
```

### 2.3 智能推断规则表

| 字段特征 | 推断结果 |
|---------|---------|
| 字段名含 `status/state/type` | `classType=list` + 需要字典 |
| 字段名含 `time/date` | `classType=date/datetime` |
| 字段名含 `by` 且为系统字段 | `isShow=N` |
| 字段名含 `id` 且非主键 | 可能是外键，`classType=popup` |
| 字段类型 `TEXT` | `classType=textarea/umeditor` |
| 字段名含 `file/attach` | `classType=file` |
| 字段名含 `img/image/pic/photo` | `classType=image` |
| 字段名以 `is_` 开头 | `classType=switch` |
| 字段类型 `DECIMAL` + 名含 `money/amount` | `fieldValidType=money` |
| `NOT NULL` 约束 | `nullable=N` |
| 有 `DEFAULT` 值 | `dbDefaultVal=xxx` |
| 有 `COMMENT` | `filedComment=xxx` |

---

## 3. 模拟生成引擎

### 3.1 生成流程

```
┌─────────────────────────────────────────────────────────────────┐
│                      AI 代码生成流程                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────┐    ┌─────────────┐    ┌─────────────┐             │
│  │  DDL    │───▶│  元数据推导  │───▶│  TableVo    │             │
│  │  输入   │    │  (AI智能)   │    │  ColumnVo[] │             │
│  └─────────┘    └─────────────┘    └──────┬──────┘             │
│                                           │                     │
│  ┌─────────┐                              ▼                     │
│  │ 业务描述 │──────────────────▶  ┌─────────────┐               │
│  │ (可选)  │                     │  配置增强   │               │
│  └─────────┘                     │  (字典/校验) │               │
│                                  └──────┬──────┘               │
│                                         │                       │
│                                         ▼                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                   模板选择                               │   │
│  │  jspMode: one/tree/many/jvxe/erp/innerTable/tab        │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                     │
│                           ▼                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                FreeMarker 渲染                           │   │
│  │  读取 code-template-online/{stylePath}/ 下模板          │   │
│  │  注入 tableVo + columns + subTables 上下文              │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                     │
│                           ▼                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                   输出文件                               │   │
│  │  - Entity.java        - Controller.java                 │   │
│  │  - Service.java       - ServiceImpl.java                │   │
│  │  - Mapper.java        - Mapper.xml                      │   │
│  │  - List.vue           - Form.vue                        │   │
│  │  - Modal.vue          - menu.sql                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 AI 模拟 FreeMarker 渲染

AI 有两种实现路径：

#### 方案A：直接调用 FreeMarker（推荐）

```java
// 1. 构建配置对象
TableVo tableVo = buildTableVoFromDDL(ddl);
List<ColumnVo> columns = buildColumnsFromDDL(ddl);

// 2. 准备模板上下文
Map<String, Object> context = new HashMap<>();
context.put("tableVo", tableVo);
context.put("tableName", tableVo.getTableName());
context.put("entityName", tableVo.getEntityName());
context.put("entityPackage", tableVo.getEntityPackage());
context.put("bussiPackage", "org.jeecg.modules");
context.put("columns", columns);
context.put("originalColumns", columns);
context.put("primaryKeyField", "id");

// 3. 调用 FreeMarker
Configuration cfg = new Configuration(Configuration.VERSION_2_3_31);
cfg.setDirectoryForTemplateLoading(new File("code-template-online"));
Template template = cfg.getTemplate("default/one/java/.../entity/${entityName}.javai");
StringWriter out = new StringWriter();
template.process(context, out);
```

#### 方案B：AI 直接生成（学习模板风格）

AI 学习 FreeMarker 模板的输出模式，直接生成代码：

```
输入：TableVo + ColumnVo[]
输出：按模板风格生成的代码

关键点：
1. 注解位置、顺序必须与模板一致
2. 命名规范必须一致（驼峰转换）
3. 权限编码格式必须一致
4. Vue组件引用必须一致
```

### 3.3 模板上下文变量清单

| 变量名 | 类型 | 说明 |
|-------|------|------|
| `tableVo` | TableVo | 表配置对象 |
| `tableName` | String | 物理表名 |
| `entityName` | String | 实体类名 |
| `entityPackage` | String | 包路径 |
| `bussiPackage` | String | 业务包前缀 |
| `columns` | List | 字段列表（过滤后） |
| `originalColumns` | List | 原始字段列表 |
| `primaryKeyField` | String | 主键字段名 |
| `subTables` | List | 子表列表（一对多） |

---

## 4. 风格对齐与可控性

### 4.1 代码风格对齐清单

#### Entity 层
- [x] `@Data` + `@TableName` + `@Accessors(chain=true)` + `@EqualsAndHashCode`
- [x] `@ApiModel` + `@ApiModelProperty`
- [x] 主键：`@TableId(type = IdType.ASSIGN_ID)`
- [x] 日期：`@JsonFormat` + `@DateTimeFormat`
- [x] 字典：`@Dict(dicCode=xxx)` 或 `@Dict(dictTable,dicText,dicCode)`
- [x] Excel：`@Excel(name=xxx, width=15)`

#### Controller 层
- [x] `@Api(tags=xxx)` + `@RestController` + `@RequestMapping`
- [x] 继承 `JeecgController<Entity, Service>`
- [x] 权限注解：`@RequiresPermissions("package:table:action")`
- [x] 日志注解：`@AutoLog(value=xxx)`
- [x] Swagger：`@ApiOperation`

#### Vue 层
- [x] 组件命名：`${EntityName}List.vue` / `${EntityName}Form.vue` / `${EntityName}Modal.vue`
- [x] API路径：`/${entityPackage}/${entityName?uncap_first}/xxx`
- [x] 表单校验：`validatorRules` 对象
- [x] 字典组件：`<j-dict-select-tag dictCode="xxx" />`

### 4.2 权限编码规范

```
格式：${entityPackage}:${tableName}:${action}

示例：
- demo:test_demo:add
- demo:test_demo:edit
- demo:test_demo:delete
- demo:test_demo:deleteBatch
- demo:test_demo:exportXls
- demo:test_demo:importExcel
```

### 4.3 API 路径规范

```
格式：/${entityPackage}/${entityName?uncap_first}/${action}

示例：
- GET  /demo/testDemo/list
- POST /demo/testDemo/add
- PUT  /demo/testDemo/edit
- DELETE /demo/testDemo/delete
- GET  /demo/testDemo/queryById
- GET  /demo/testDemo/exportXls
- POST /demo/testDemo/importExcel
```

---

## 5. 落地路径与技术组件

### 5.1 核心技术组件

| 组件 | 职责 | 技术选型 |
|-----|------|---------|
| **DDL 解析器** | 解析 SQL DDL 提取表结构 | JSqlParser / Druid SQL Parser |
| **元数据推导引擎** | DDL → TableVo/ColumnVo | AI 规则引擎 + 语义推断 |
| **配置增强器** | 业务描述 → 字典/校验配置 | LLM 自然语言理解 |
| **模板渲染器** | FreeMarker 模板渲染 | FreeMarker 2.3.x |
| **代码输出器** | 文件写入 + 目录结构 | Java IO / NIO |

### 5.2 实现步骤

#### Phase 1：基础能力（MVP）

1. **DDL 解析**
   - 输入：CREATE TABLE DDL
   - 输出：表名、字段列表、类型、约束、注释

2. **基础映射**
   - DB类型 → Java类型
   - 字段名 → 驼峰命名
   - 表名 → 实体名/包名

3. **单表生成**
   - 使用 `default/one` 模板
   - 生成 Entity/Controller/Service/Mapper/Vue

#### Phase 2：智能推断

1. **控件类型推断**
   - 基于字段名语义
   - 基于数据类型
   - 基于业务描述

2. **字典自动生成**
   - 识别枚举类字段
   - 生成字典 SQL
   - 关联字典配置

3. **校验规则推断**
   - 基于字段名（phone→m, email→e）
   - 基于约束（NOT NULL→*）

#### Phase 3：高级功能

1. **一对多支持**
   - 主子表关系识别
   - 外键字段推断
   - 多种风格模板

2. **树表支持**
   - 树结构字段识别（pid/parent_id）
   - 树表模板生成

3. **业务增强**
   - 自然语言配置
   - 自定义模板扩展

### 5.3 AI Prompt 设计

```markdown
# 角色
你是 Jeecg-boot 代码生成专家，精通 FreeMarker 模板和 Jeecg 代码规范。

# 输入
1. DDL 语句
2. 业务描述（可选）
3. 生成模式（one/tree/many/jvxe/erp/innerTable/tab）

# 任务
1. 解析 DDL，提取表结构
2. 推导 TableVo 和 ColumnVo[] 配置
3. 智能推断控件类型、字典、校验规则
4. 按 Jeecg 模板风格生成代码

# 输出要求
- 代码风格必须与 Jeecg 官方生成器完全一致
- 注解位置、命名规范、权限编码必须对齐
- 生成完整的 Entity/Controller/Service/Mapper/Vue 文件

# 参考模板
[附上关键模板片段]
```

### 5.4 配置文件格式（可选）

支持 YAML 配置文件作为中间格式：

```yaml
table:
  name: order_main
  entity: OrderMain
  package: order
  description: 订单主表
  mode: one  # one/tree/many
  fieldRowNum: 2

columns:
  - name: id
    type: string
    key: true
    show: false
    
  - name: order_no
    type: string
    comment: 订单编号
    show: true
    query: true
    valid: only
    
  - name: status
    type: int
    comment: 订单状态
    control: list
    dict: order_status
    
  - name: create_time
    type: datetime
    comment: 创建时间
    show: false

dictionaries:
  - code: order_status
    items:
      - value: 0
        text: 待支付
      - value: 1
        text: 已支付
      - value: 2
        text: 已取消
```

---

## 6. 总结

### 6.1 方案优势

1. **跳过 UI 配置**：AI 直接从 DDL/业务描述生成配置，无需手工点选
2. **保留模板逻辑**：复用 Jeecg 官方 FreeMarker 模板，确保代码风格一致
3. **智能推断**：基于字段语义自动推断控件类型、字典、校验规则
4. **可控性强**：支持 YAML 配置文件作为中间格式，便于人工调整

### 6.2 关键成功因素

1. **元数据映射准确性**：DDL → 配置对象的映射规则必须完备
2. **模板理解深度**：AI 必须深入理解 FreeMarker 模板的变量依赖
3. **风格对齐严格性**：生成代码必须与官方生成器输出完全一致

### 6.3 后续演进

1. **模板扩展**：支持自定义模板，适配不同项目风格
2. **增量生成**：支持在已有代码基础上增量修改
3. **双向同步**：代码修改后反向更新配置
