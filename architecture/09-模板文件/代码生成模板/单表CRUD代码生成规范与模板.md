# 单表CRUD代码生成规范与模板

## 概述

本文档定义了基于现有开发规范的AI代码生成标准化指导体系，实现从数据表设计到完整功能部署的一键式自动化流程。通过标准化的AI提示词模板和生成规范，确保生成代码的一致性、规范性和可维护性。

**核心目标：**
- 基于现有规范，创建标准化的AI代码生成指导体系
- 实现从数据表设计到完整功能部署的自动化流程
- 确保生成结果的一致性和规范性
- 提升开发效率，减少重复工作

**技术栈：**
- 后端：Spring Boot + MyBatis Plus + Jeecg-boot
- 前端：Vue 2 + Ant Design Vue
- 数据库：MySQL 8.0+
- 架构：传统三层架构（Controller + Service + Mapper）

## 第一部分：数据表结构设计规范

### 1.1 AI提示词模板

```
请根据以下需求生成标准的MySQL数据表结构：

**需求描述：**
{用户提供的业务需求描述}

**原型图支持：**
- 支持直接上传或粘贴原型图片进行表结构设计
- AI会根据原型图中的表单字段、表格列、查询条件等自动识别需要的数据库字段
- 根据原型图中的控件类型（输入框、下拉框、日期选择器等）自动推断合适的数据库字段类型
- 通过原型图的页面流程和交互设计，分析业务逻辑并设计相应的字段结构
- 自动识别原型图中的下拉选择、单选按钮、复选框等，生成对应的字典配置

**原型图分析要素：**
1. **表单字段**：分析表单中的输入项，生成对应的数据库字段
2. **表格列**：分析列表页面的表格列，确定需要展示的字段
3. **查询条件**：分析搜索区域的查询条件，设计索引字段
4. **选择控件**：识别下拉框、单选框等，生成字典字段
5. **数据验证**：根据原型图中的必填标识、格式要求等设计字段约束
6. **关联关系**：分析页面间的数据关联，设计外键字段

**生成要求：**
1. 严格按照数据库表结构设计规范执行
2. 表名使用 {模块名}_{实体名} 格式，如 cms_article
3. 必须包含标准字段：id, del_flag, create_by, create_time, update_by, update_time
4. 字段类型严格按照规范选择：
   - 主键：varchar(32)
   - 字符串：VARCHAR(n)，长文本用TEXT
   - 数字：整数用INT/BIGINT，小数/金额用DECIMAL(m,n)
   - 时间：DATETIME，日期用DATE
   - 布尔值：tinyint(1)
   - 枚举：varchar类型，注释说明枚举值和字典编码
5. 为查询、排序、分组字段创建索引
6. 使用utf8mb4字符集，InnoDB引擎
7. 每个字段必须有清晰的中文注释

**输出格式：**
- 完整的CREATE TABLE语句
- 如有枚举字段，同时生成对应的字典配置SQL
- 如使用原型图，请说明从原型图中识别到的关键信息
```

### 1.2 标准表结构模板

```sql
CREATE TABLE `{module_name}_{entity_name}` (
  -- === 标准字段 ===
  `id` varchar(32) NOT NULL COMMENT '主键ID',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT (now()) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` varchar(1) DEFAULT '0' COMMENT '删除状态 0=未删除 1=已删除',
  
  -- === 业务字段（根据需求智能生成）===
  `name` varchar(100) NOT NULL COMMENT '名称',
  `status` varchar(1) DEFAULT '1' COMMENT '状态：0=禁用；1=启用。字典：sys_status',
  `sort_order` int DEFAULT '0' COMMENT '排序号',
  `description` text COMMENT '描述',
  
  -- === 主键和索引 ===
  PRIMARY KEY (`id`),
  INDEX `idx_del_flag` (`del_flag`) COMMENT '逻辑删除标记索引',
  INDEX `idx_status` (`status`) COMMENT '状态索引',
  INDEX `idx_sort_order` (`sort_order`) COMMENT '排序索引',
  UNIQUE KEY `uk_{table_name}_name` (`name`) COMMENT '名称唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='{表描述}';
```

## 第二部分：字典数据设计规范

### 2.1 AI提示词模板

```
请为以下枚举字段生成标准的字典配置SQL：

**字段信息：**
- 字段名：{field_name}
- 字典编码：{dict_code}
- 字典名称：{dict_name}
- 枚举值：{enum_values}

**生成要求：**
1. 使用UUID生成字典ID和字典项ID
2. 严格按照字典注解使用规范的SQL模板
3. 字典编码使用下划线分隔的小写字母
4. 字典项按业务逻辑排序
5. 所有字典项默认启用（status=1）

**输出格式：**
- 完整的字典配置SQL语句
- 包含字典主表和字典项表的INSERT语句
```

### 2.2 标准字典SQL模板

```sql
-- 字典配置 SQL：{dict_name}
-- 字典编码：{dict_code}

-- 生成字典主表ID
SET @dict_id = REPLACE(UUID(), '-', '');

-- 添加字典类型
INSERT INTO `sys_dict` (
    `id`, `dict_code`, `dict_name`, `description`, `del_flag`, 
    `create_by`, `create_time`, `update_by`, `update_time`
) VALUES (
    @dict_id, '{dict_code}', '{dict_name}', '{dict_description}', '0',
    'admin', NOW(), 'admin', NOW()
);

-- 添加字典项
{dict_items_sql}
```

### 2.3 字典SQL完整示例

#### 2.3.1 用户状态字典示例

```sql
-- 字典配置 SQL：用户状态
-- 字典编码：user_status

-- 生成字典主表ID
SET @dict_id = REPLACE(UUID(), '-', '');

-- 添加字典类型
INSERT INTO `sys_dict` (
    `id`, `dict_code`, `dict_name`, `description`, `del_flag`, 
    `create_by`, `create_time`, `update_by`, `update_time`
) VALUES (
    @dict_id, 'user_status', '用户状态', '用户状态字典', '0',
    'admin', NOW(), 'admin', NOW()
);

-- 生成字典项ID
SET @item_id_1 = REPLACE(UUID(), '-', '');
SET @item_id_2 = REPLACE(UUID(), '-', '');

-- 添加字典项
INSERT INTO `sys_dict_item` (
    `id`, `dict_id`, `item_text`, `item_value`, `item_color`, 
    `description`, `sort_order`, `status`, `create_by`, 
    `create_time`, `update_by`, `update_time`
) VALUES (
    @item_id_1, @dict_id, '正常', '1', '#00FF00',
    '用户正常状态', 1, 1, 'admin', NOW(), 'admin', NOW()
), (
    @item_id_2, @dict_id, '禁用', '0', '#FF0000',
    '用户禁用状态', 2, 1, 'admin', NOW(), 'admin', NOW()
);
```

#### 2.3.2 订单状态字典示例

```sql
-- 字典配置 SQL：订单状态
-- 字典编码：order_status

-- 生成字典主表ID
SET @dict_id = REPLACE(UUID(), '-', '');

-- 添加字典类型
INSERT INTO `sys_dict` (
    `id`, `dict_code`, `dict_name`, `description`, `del_flag`, 
    `create_by`, `create_time`, `update_by`, `update_time`
) VALUES (
    @dict_id, 'order_status', '订单状态', '订单状态字典', '0',
    'admin', NOW(), 'admin', NOW()
);

-- 生成字典项ID
SET @item_id_1 = REPLACE(UUID(), '-', '');
SET @item_id_2 = REPLACE(UUID(), '-', '');
SET @item_id_3 = REPLACE(UUID(), '-', '');
SET @item_id_4 = REPLACE(UUID(), '-', '');

-- 添加字典项
INSERT INTO `sys_dict_item` (
    `id`, `dict_id`, `item_text`, `item_value`, `item_color`, 
    `description`, `sort_order`, `status`, `create_by`, 
    `create_time`, `update_by`, `update_time`
) VALUES (
    @item_id_1, @dict_id, '待付款', '1', '#FFA500',
    '订单待付款状态', 1, 1, 'admin', NOW(), 'admin', NOW()
), (
    @item_id_2, @dict_id, '已付款', '2', '#00FF00',
    '订单已付款状态', 2, 1, 'admin', NOW(), 'admin', NOW()
), (
    @item_id_3, @dict_id, '已发货', '3', '#0000FF',
    '订单已发货状态', 3, 1, 'admin', NOW(), 'admin', NOW()
), (
    @item_id_4, @dict_id, '已完成', '4', '#008000',
    '订单已完成状态', 4, 1, 'admin', NOW(), 'admin', NOW()
);
```

## 第三部分：后端代码生成规范

### 3.1 代码存放位置

**后端代码目录结构：**
```
jeecg-module-system/jeecg-system-biz/src/main/java/org/jeecg/modules/{moduleNameCamelCase}/
├── controller/                    # 控制器层
│   └── {ModuleName}Controller.java
├── entity/                        # 实体类层
│   └── {ModuleName}.java
├── mapper/                        # 数据访问层
│   ├── {ModuleName}Mapper.java
│   └── xml/
│       └── {ModuleName}Mapper.xml
└── service/                       # 服务层
    ├── I{ModuleName}Service.java
    └── impl/
        └── {ModuleName}ServiceImpl.java
```

**示例：**
- 模块名：LxPlayerAccount
- 包路径：`org.jeecg.modules.lxPlayerAccount`
- 实体类：`org.jeecg.modules.lxPlayerAccount.entity.LxPlayerAccount`
- 控制器：`org.jeecg.modules.lxPlayerAccount.controller.LxPlayerAccountController`

### 3.2 AI提示词模板

```
请根据以下数据表结构生成标准的Jeecg-boot后端代码：

**表结构：**
{table_sql}

**模块信息：**
- 模块名（驼峰）：{ModuleName}
- 模块名（小写）：{moduleNameLowerCase}
- 表名：{table_name}
- 功能描述：{module_description}

**生成要求：**
1. 严格按照后端管理系统API规范执行
2. 生成完整的四层架构代码：Entity、Mapper、Service、Controller
3. 实体类必须包含所有标准注解：@Dict、@Excel、@JsonFormat等
4. Controller必须包含标准CRUD接口：list、add、edit、delete、deleteBatch、queryById、exportXls、importExcel
5. 所有接口使用Result包装返回结果
6. 权限注解格式：{moduleNameLowerCase}:{table_name}:操作
7. 包路径：org.jeecg.modules.{moduleNameCamelCase}

**输出顺序：**
1. Entity实体类
2. Mapper接口和XML
3. Service接口和实现类
4. Controller控制器
```

### 3.2 后端代码完整模板

#### 3.2.1 Entity实体类模板

```java
package org.jeecg.modules.{moduleNameCamelCase}.entity;

import java.io.Serializable;
import java.util.Date;
import java.math.BigDecimal;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableLogic;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import org.jeecgframework.poi.excel.annotation.Excel;
import org.jeecg.common.aspect.annotation.Dict;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * @Description: {module_description}
 * @Author: jeecg-boot
 * @Date: {current_date}
 * @Version: V1.0
 */
@Data
@TableName("{table_name}")
@Accessors(chain = true)
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="{table_name}对象", description="{module_description}")
public class {ModuleName} implements Serializable {
    private static final long serialVersionUID = 1L;

    /**主键ID*/
    @TableId(type = IdType.ASSIGN_ID)
    @ApiModelProperty(value = "主键ID")
    private String id;
    
    /**业务字段示例 - 根据实际表结构生成*/
    @Excel(name = "名称", width = 15)
    @ApiModelProperty(value = "名称")
    private String name;
    
    /**字典字段示例*/
    @Excel(name = "状态", width = 15, dicCode = "sys_status")
    @Dict(dicCode = "sys_status")
    @ApiModelProperty(value = "状态：0=禁用；1=启用")
    private String status;
    
    /**数字字段示例*/
    @Excel(name = "排序号", width = 15)
    @ApiModelProperty(value = "排序号")
    private Integer sortOrder;
    
    /**金额字段示例*/
    @Excel(name = "金额", width = 15)
    @ApiModelProperty(value = "金额")
    private BigDecimal amount;
    
    /**日期字段示例*/
    @Excel(name = "生效日期", width = 20, format = "yyyy-MM-dd")
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern="yyyy-MM-dd")
    @ApiModelProperty(value = "生效日期")
    private Date effectiveDate;
    
    /**长文本字段示例*/
    @Excel(name = "描述", width = 30)
    @ApiModelProperty(value = "描述")
    private String description;
    
    /**删除标志*/
    @Excel(name = "删除状态", width = 15)
    @ApiModelProperty(value = "删除状态 0=未删除 1=已删除")
    @TableLogic
    private String delFlag;
    
    /**创建人*/
    @ApiModelProperty(value = "创建人")
    private String createBy;
    
    /**创建时间*/
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    /**更新人*/
    @ApiModelProperty(value = "更新人")
    private String updateBy;
    
    /**更新时间*/
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
```

#### 3.2.2 Mapper接口模板

```java
package org.jeecg.modules.{moduleNameCamelCase}.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import com.github.yulichang.base.MPJBaseMapper;

/**
 * @Description: {module_description}
 * @Author: jeecg-boot
 * @Date: {current_date}
 * @Version: V1.0
 */
public interface {ModuleName}Mapper extends MPJBaseMapper<{ModuleName}> {
    
    // 自定义查询方法（如需要）
    List<{ModuleName}> selectCustomList(@Param("param") String param);
}
```

#### 3.2.3 Mapper XML模板

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="org.jeecg.modules.{moduleNameCamelCase}.mapper.{ModuleName}Mapper">

    <!-- 自定义查询语句（如需要） -->
    <select id="selectCustomList" resultType="org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName}">
        SELECT * FROM {table_name} 
        WHERE del_flag = '0'
        <if test="param != null and param != ''">
            AND field_name LIKE CONCAT('%', #{param}, '%')
        </if>
    </select>

</mapper>
```

#### 3.2.4 Service接口模板

```java
package org.jeecg.modules.{moduleNameCamelCase}.service;

import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import com.github.yulichang.base.MPJBaseService;

/**
 * @Description: {module_description}
 * @Author: jeecg-boot
 * @Date: {current_date}
 * @Version: V1.0
 */
public interface I{ModuleName}Service extends MPJBaseService<{ModuleName}> {
    
    // 自定义业务方法（如需要）
    void customBusinessMethod(String param);
}
```

#### 3.2.5 Service实现类模板

```java
package org.jeecg.modules.{moduleNameCamelCase}.service.impl;

import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import org.jeecg.modules.{moduleNameCamelCase}.mapper.{ModuleName}Mapper;
import org.jeecg.modules.{moduleNameCamelCase}.service.I{ModuleName}Service;
import org.springframework.stereotype.Service;
import com.github.yulichang.base.MPJBaseServiceImpl;

/**
 * @Description: {module_description}
 * @Author: jeecg-boot
 * @Date: {current_date}
 * @Version: V1.0
 */
@Service
public class {ModuleName}ServiceImpl extends MPJBaseServiceImpl<{ModuleName}Mapper, {ModuleName}> implements I{ModuleName}Service {

    @Override
    public void customBusinessMethod(String param) {
        // 自定义业务逻辑实现
    }
}
```

#### 3.2.6 Controller控制器模板

```java
package org.jeecg.modules.{moduleNameCamelCase}.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.common.util.oConvertUtils;
import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import org.jeecg.modules.{moduleNameCamelCase}.service.I{ModuleName}Service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;

import org.jeecgframework.poi.excel.ExcelImportUtil;
import org.jeecgframework.poi.excel.def.NormalExcelConstants;
import org.jeecgframework.poi.excel.entity.ExportParams;
import org.jeecgframework.poi.excel.entity.ImportParams;
import org.jeecgframework.poi.excel.view.JeecgEntityExcelView;
import org.jeecg.common.system.base.controller.JeecgController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import com.alibaba.fastjson.JSON;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.jeecg.common.aspect.annotation.AutoLog;
import org.apache.shiro.authz.annotation.RequiresPermissions;

/**
 * @Description: {module_description}
 * @Author: jeecg-boot
 * @Date: {current_date}
 * @Version: V1.0
 */
@Api(tags="{module_description}")
@RestController
@RequestMapping("/{moduleNameLowerCase}/{moduleNameLowerCase}")
@Slf4j
public class {ModuleName}Controller extends JeecgController<{ModuleName}, I{ModuleName}Service> {
    @Autowired
    private I{ModuleName}Service {moduleNameCamelCase}Service;

    /**
     * 分页列表查询
     */
    @ApiOperation(value="{module_description}-分页列表查询", notes="{module_description}-分页列表查询")
    @GetMapping(value = "/list")
    public Result<IPage<{ModuleName}>> queryPageList({ModuleName} {moduleNameCamelCase},
                                   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
                                   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
                                   HttpServletRequest req) {
        QueryWrapper<{ModuleName}> queryWrapper = QueryGenerator.initQueryWrapper({moduleNameCamelCase}, req.getParameterMap());
        Page<{ModuleName}> page = new Page<{ModuleName}>(pageNo, pageSize);
        IPage<{ModuleName}> pageList = {moduleNameCamelCase}Service.page(page, queryWrapper);
        return Result.OK(pageList);
    }

    /**
     * 添加
     */
    @AutoLog(value = "{module_description}-添加")
    @ApiOperation(value="{module_description}-添加", notes="{module_description}-添加")
    @RequiresPermissions("{moduleNameLowerCase}:{table_name}:add")
    @PostMapping(value = "/add")
    public Result<String> add(@RequestBody {ModuleName} {moduleNameCamelCase}) {
        {moduleNameCamelCase}Service.save({moduleNameCamelCase});
        return Result.OK("添加成功！");
    }

    /**
     * 编辑
     */
    @AutoLog(value = "{module_description}-编辑")
    @ApiOperation(value="{module_description}-编辑", notes="{module_description}-编辑")
    @RequiresPermissions("{moduleNameLowerCase}:{table_name}:edit")
    @RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
    public Result<String> edit(@RequestBody {ModuleName} {moduleNameCamelCase}) {
        {moduleNameCamelCase}Service.updateById({moduleNameCamelCase});
        return Result.OK("编辑成功!");
    }

    /**
     * 通过id删除
     */
    @AutoLog(value = "{module_description}-通过id删除")
    @ApiOperation(value="{module_description}-通过id删除", notes="{module_description}-通过id删除")
    @RequiresPermissions("{moduleNameLowerCase}:{table_name}:delete")
    @DeleteMapping(value = "/delete")
    public Result<String> delete(@RequestParam(name="id",required=true) String id) {
        {moduleNameCamelCase}Service.removeById(id);
        return Result.OK("删除成功!");
    }

    /**
     * 批量删除
     */
    @AutoLog(value = "{module_description}-批量删除")
    @ApiOperation(value="{module_description}-批量删除", notes="{module_description}-批量删除")
    @RequiresPermissions("{moduleNameLowerCase}:{table_name}:deleteBatch")
    @DeleteMapping(value = "/deleteBatch")
    public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
        this.{moduleNameCamelCase}Service.removeByIds(Arrays.asList(ids.split(",")));
        return Result.OK("批量删除成功!");
    }

    /**
     * 通过id查询
     */
    @ApiOperation(value="{module_description}-通过id查询", notes="{module_description}-通过id查询")
    @GetMapping(value = "/queryById")
    public Result<{ModuleName}> queryById(@RequestParam(name="id",required=true) String id) {
        {ModuleName} {moduleNameCamelCase} = {moduleNameCamelCase}Service.getById(id);
        if({moduleNameCamelCase}==null) {
            return Result.error("未找到对应数据");
        }
        return Result.OK({moduleNameCamelCase});
    }

    /**
     * 导出excel
     */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, {ModuleName} {moduleNameCamelCase}) {
        return super.exportXls(request, {moduleNameCamelCase}, {ModuleName}.class, "{module_description}数据");
    }

    /**
     * 通过excel导入数据
     */
    @RequestMapping(value = "/importExcel", method = RequestMethod.POST)
    public Result<?> importExcel(HttpServletRequest request, HttpServletResponse response) {
        return super.importExcel(request, response, {ModuleName}.class);
    }
}
```

## 第四部分：前端代码生成规范

### 4.1 代码存放位置

**前端代码目录结构：**
```
src/views/{moduleNameKebabCase}/
├── {ModuleName}List.vue              # 主列表页面
├── {ModuleName}_menu_insert.sql      # 菜单插入SQL
└── modules/                          # 子组件目录
    ├── {ModuleName}Modal.vue         # 弹窗组件
    ├── {ModuleName}Form.vue          # 表单组件
    └── Import{ModuleName}Modal.vue   # 导入弹窗组件
```

**示例：**
- 模块名：LxPlayerAccount
- 目录：`src/views/lx/lxPlayerAccount/`
- 文件：`LxPlayerAccountList.vue`、`modules/LxPlayerAccountModal.vue`

### 4.2 AI提示词模板

```
请根据以下后端实体类生成标准的Vue前端代码：

**实体类信息：**
{entity_class}

**模块信息：**
- 模块名（PascalCase）：{ModuleName}
- 模块名（kebab-case）：{module-name-kebab-case}
- 模块名（小写）：{moduleNameLowerCase}
- 功能描述：{module_description}

**生成要求：**
1. 严格按照前端代码结构规范执行
2. 生成完整的前端页面：List.vue、Modal.vue、Form.vue
3. 使用JeecgListMixin实现标准CRUD功能
4. 表格列配置要包含所有业务字段
5. 表单组件要包含所有字段的输入控件
6. 字典字段使用j-dict-select-tag组件
7. 日期字段使用a-date-picker组件
8. 权限控制使用v-has指令
9. 代码放置在 src/views/{moduleNameKebabCase}/ 目录下

**输出顺序：**
1. 列表页面（List.vue）
2. 弹窗组件（Modal.vue）
3. 表单组件（Form.vue）
4. 菜单配置SQL
```

### 4.3 列表页面模板（List.vue）

```vue
<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <!-- 查符串查询字段 -->
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="名称">
              <a-input placeholder="请输入名称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          
          <!-- 字典查询字段 -->
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="状态">
              <j-dict-select-tag placeholder="请选择状态" v-model="queryParam.status" dictCode="sys_status"/>
            </a-form-item>
          </a-col>
          
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus" v-has="'{moduleNameLowerCase}:{table_name}:add'">新增</a-button>
      <a-button type="primary" icon="download" @click="handleExportXls('{module_description}数据')" v-has="'{moduleNameLowerCase}:{table_name}:exportXls'">导出</a-button>
      <j-upload-button type="primary" icon="import" text="导入" v-has="'{moduleNameLowerCase}:{table_name}:importExcel'" :url="url.importExcelUrl" @success="handleImportExcel"></j-upload-button>
      
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel" v-has="'{moduleNameLowerCase}:{table_name}:deleteBatch'">
            <a-icon type="delete"/>删除
          </a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px">
          批量操作 <a-icon type="down" />
        </a-button>
      </a-dropdown>
    </div>

    <!-- 表格区域 -->
    <div>
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
        </template>
        <template slot="fileSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无文件</span>
          <a-button
            v-else
            :ghost="true"
            type="primary"
            icon="download"
            size="small"
            @click="downloadFile(text)">
            下载
          </a-button>
        </template>

        <template slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)" v-has="'{moduleNameLowerCase}:{table_name}:edit'">编辑</a>
          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="handleDetail(record)" v-has="'{moduleNameLowerCase}:{table_name}:detail'">详情</a>
              </a-menu-item>
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)" v-has="'{moduleNameLowerCase}:{table_name}:delete'">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </template>

      </a-table>
    </div>

    <!-- 弹窗组件 -->
    <{module-name-kebab-case}-modal ref="modalForm" @ok="modalFormOk"></{module-name-kebab-case}-modal>
  </a-card>
</template>

<script>
  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import {ModuleName}Modal from './modules/{ModuleName}Modal'

  export default {
    name: '{ModuleName}List',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      {ModuleName}Modal
    },
    data () {
      return {
        description: '{module_description}管理页面',
        // 表头
        columns: [
          {
            title: '#',
            dataIndex: '',
            key:'rowIndex',
            width:60,
            align:"center",
            customRender:function (t,r,index) {
              return parseInt(index)+1;
            }
          },
          {
            title:'名称',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status_dictText'
          },
          {
            title: '创建时间',
            align:"center",
            dataIndex: 'createTime',
            sorter: true
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:147,
            scopedSlots: { customRender: 'action' }
          }
        ],
        url: {
          list: "/{moduleNameLowerCase}/{moduleNameLowerCase}/list",
          delete: "/{moduleNameLowerCase}/{moduleNameLowerCase}/delete",
          deleteBatch: "/{moduleNameLowerCase}/{moduleNameLowerCase}/deleteBatch",
          exportXlsUrl: "/{moduleNameLowerCase}/{moduleNameLowerCase}/exportXls",
          importExcelUrl: "/{moduleNameLowerCase}/{moduleNameLowerCase}/importExcel",
        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
      this.getSuperFieldList();
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'string',value:'name',text:'名称',dictCode:''})
        fieldList.push({type:'string',value:'status',text:'状态',dictCode:'sys_status'})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>
```

### 4.4 弹窗组件模板（Modal.vue）

```vue
<template>
  <j-modal
    :title="title"
    :width="800"
    :visible="visible"
    :confirmLoading="confirmLoading"
    switchFullscreen
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    
    <{module-name-kebab-case}-form ref="realForm" @ok="submitCallback" :disabled="disableSubmit"></{module-name-kebab-case}-form>
  </j-modal>
</template>

<script>
  import {ModuleName}Form from './{ModuleName}Form'

  export default {
    name: '{ModuleName}Modal',
    components: {
      {ModuleName}Form
    },
    data () {
      return {
        title:"",
        width:800,
        visible: false,
        model: {},
        confirmLoading: false,
        disableSubmit: false
      }
    },
    methods: {
      add () {
        this.edit({});
      },
      edit (record) {
        this.title = record.id ? '{module_description}编辑' : '{module_description}添加';
        this.visible = true;
        this.$nextTick(() => {
          this.$refs.realForm.edit(record);
        })
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {
        this.$refs.realForm.submitForm();
      },
      submitCallback(){
        this.$emit('ok');
        this.visible = false;
      },
      handleCancel () {
        this.close()
      }
    }
  }
</script>
```

### 4.5 表单组件模板（Form.vue）

```vue
<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入名称"></a-input>
            </a-form-model-item>
          </a-col>
          
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-dict-select-tag type="list" v-model="model.status" dictCode="sys_status" placeholder="请选择状态"/>
            </a-form-model-item>
          </a-col>
          
          <a-col :span="24">
            <a-form-model-item label="排序" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sortOrder">
              <a-input-number v-model="model.sortOrder" placeholder="请输入排序号" style="width: 100%"/>
            </a-form-model-item>
          </a-col>
          
          <a-col :span="24">
            <a-form-model-item label="描述" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="description">
              <a-textarea v-model="model.description" rows="4" placeholder="请输入描述"/>
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>
  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: '{ModuleName}Form',
    components: {
    },
    props: {
      //表单禁用
      disabled: {
        type: Boolean,
        default: false,
        required: false
      }
    },
    data () {
      return {
        model:{},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        validatorRules: {
          name: [
            { required: true, message: '请输入名称!'},
            {validator: this.validateName}
          ],
          status: [
            { required: true, message: '请选择状态!'},
          ],
        },
        url: {
          add: "/{moduleNameLowerCase}/{moduleNameLowerCase}/add",
          edit: "/{moduleNameLowerCase}/{moduleNameLowerCase}/edit",
          queryById: "/{moduleNameLowerCase}/{moduleNameLowerCase}/queryById"
        }
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
    },
    methods: {
      add () {
        this.edit({});
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.visible = true;
      },
      submitForm () {
        const that = this;
        // 触发表单验证
        this.$refs.form.validate(valid => {
          if (valid) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.id){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
              method = 'put';
            }
            httpAction(httpurl,this.model,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
            })
          }
        })
      },
      validateName(rule, value, callback) {
        var pattern = /^[a-zA-Z0-9\u4e00-\u9fa5]+$/;
        if(!value || value.length==0){
          callback();
        } else if(!pattern.test(value)){
          callback(new Error('名称只能包含字母、数字和中文!'));
        } else {
          validateDuplicateValue('{table_name}', 'name', value, this.model.id, callback);
        }
      }
    }
  }
</script>
```

### 4.6 字典组件使用规范

#### 4.6.1 j-dict-select-tag组件使用方式

```vue
<!-- 下拉选择框 -->
<j-dict-select-tag 
  v-model="model.status" 
  dictCode="sys_status" 
  placeholder="请选择状态"/>

<!-- 单选框组 -->
<j-dict-select-tag 
  type="radio" 
  v-model="model.status" 
  dictCode="sys_status"/>

<!-- 复选框组 -->
<j-dict-select-tag 
  type="checkbox" 
  v-model="model.status" 
  dictCode="sys_status"/>

<!-- 列表形式 -->
<j-dict-select-tag 
  type="list" 
  v-model="model.status" 
  dictCode="sys_status"/>
```

#### 4.6.2 常用字典组件属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| dictCode | String | - | 字典编码（必填） |
| type | String | select | 组件类型：select/radio/checkbox/list |
| placeholder | String | 请选择 | 占位符文本 |
| disabled | Boolean | false | 是否禁用 |
| allowClear | Boolean | true | 是否显示清除按钮 |

## 第五部分：系统集成规范

### 5.1 菜单配置SQL生成模板

#### 5.1.1 菜单配置SQL生成规范（基于任务发布模块最佳实践）

**核心原则：** 基于任务发布模块的成功经验，建立标准化的菜单配置流程，确保一致性和可复用性。

**1. ID生成规范：**
- **主键ID生成：** 使用 `REPLACE(UUID(), '-', '')` 动态生成32位无横线UUID
- **变量引用：** 使用MySQL变量存储主要菜单ID，便于后续引用
- **示例：**
  ```sql
  SET @main_menu_id = REPLACE(UUID(), '-', '');
  SET @sub_menu_id = REPLACE(UUID(), '-', '');
  ```
- **优势：**
  - 避免ID冲突
  - 提高脚本可移植性
  - 支持多环境部署
  - 无需手动维护ID序号

**2. 菜单层级结构规范：**
- **三级结构：** 模块主菜单 → 功能子菜单 → 操作按钮
- **任务模块示例：**
  ```
  任务管理 (2024122401)
  ├── 任务发布管理 (2024122402)
  │   ├── 添加 (2024122402001)
  │   ├── 编辑 (2024122402002)
  │   ├── 删除 (2024122402003)
  │   └── ...
  └── 任务接受记录 (2024122403)
      ├── 查看详情 (2024122403001)
      ├── 审核 (2024122403002)
      └── ...
  ```

**3. component参数规范：**
- **模块主菜单：** `layouts/RouteView` (路由视图容器)
- **功能子菜单：** `{模块名}/{页面名}`
- **示例：** `task/TaskPublishList`
- **注意事项：**
  - 不包含`.vue`文件后缀
  - 不包含前缀`/`
  - 路径分隔符使用`/`

**4. url参数规范：**
- **模块主菜单：** `/{模块名}`
- **功能子菜单：** `/{模块名}/{页面名}`
- **示例：** `/task`, `/task/TaskPublishList`
- **要求：** 确保路径在系统中唯一，避免冲突

**5. 权限编码规范（perms字段）：**
- **格式：** `{模块名}:{操作类型}`
- **标准操作：** add, edit, delete, deleteBatch, exportXls, importExcel
- **业务操作：** updateStatus, audit, batchAudit, detail
- **示例：** `taskPublish:add`, `taskAcceptanceRecord:audit`

**6. 权限授权SQL规范：**
- **动态角色查询：** 使用 `(SELECT id FROM sys_role WHERE role_code = 'admin')` 获取admin角色ID
- **UUID生成：** 使用 `REPLACE(UUID(), '-', '')` 生成32位无横线UUID作为主键
- **可移植性：** 确保SQL脚本在不同环境下都能正确执行
- **标准格式：** `INSERT INTO sys_role_permission (id, role_id, permission_id, ...) VALUES (REPLACE(UUID(), '-', ''), @admin_role_id, @menu_id, ...)`

**7. 前端字典字段显示规范：**
- **字典字段命名规范：**
  - 显示字段：使用`原字段名 + _dictText`后缀
  - 示例：状态字段`status`对应显示字段`status_dictText`
- **实现要求：**
  - 后端：配合使用相应的字典注解
  - 前端：在列表模板中明确使用fieldName_dictText字段进行显示
  - 文档：在模板说明中明确标注此规范的使用方法

#### 5.1.2 标准菜单配置SQL模板（基于任务模块成功实践）

**模板说明：** 基于任务发布模块的成功经验，提供标准化的菜单配置SQL模板，确保一致性和可维护性。

```sql
-- {module_description}管理模块菜单配置SQL
-- 使用动态UUID生成，提高脚本可移植性
-- 模块：{ModuleName}
-- 生成时间：{current_date}

-- =====================================================
-- 1. 设置变量存储菜单ID
-- =====================================================
SET @main_menu_id = REPLACE(UUID(), '-', '');
SET @sub_menu_id = REPLACE(UUID(), '-', '');

-- =====================================================
-- 2. 模块主菜单（路由容器）
-- =====================================================
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    @main_menu_id, NULL, '{module_description}',
    '/{moduleNameKebabCase}', 'layouts/RouteView', NULL, NULL,
    0, NULL, '1', {sort_no}.00, 0, '{icon_name}', 1, 0, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- =====================================================
-- 3. 功能子菜单
-- =====================================================
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    @sub_menu_id, @main_menu_id, '{module_description}管理',
    '/{moduleNameKebabCase}/{ModuleName}List',
    '{moduleNameKebabCase}/{ModuleName}List', NULL, NULL,
    1, NULL, '1', 1.00, 0, 'form', 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- =====================================================
-- 4. 标准CRUD按钮权限
-- =====================================================

-- 添加
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '添加', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:add', '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- 编辑
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '编辑', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:edit', '1', 2.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- 删除
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '删除', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:delete', '1', 3.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- 批量删除
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '批量删除', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:deleteBatch', '1', 4.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- 导出excel
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '导出excel', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:exportXls', '1', 5.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- 导入excel
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '导入excel', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:importExcel', '1', 6.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- =====================================================
-- 5. 业务特定按钮权限（根据需要添加）
-- =====================================================
-- 示例：状态更新按钮（如任务模块的上下架功能）
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect,
    menu_type, perms, perms_type, sort_no, always_show, icon,
    is_route, is_leaf, keep_alive, hidden, hide_tab, description,
    status, del_flag, rule_flag, create_by, create_time, update_by,
    update_time, internal_or_external
) VALUES (
    REPLACE(UUID(), '-', ''), @sub_menu_id, '状态更新', NULL, NULL, NULL, NULL,
    2, '{moduleNameLowerCase}:updateStatus', '1', 7.00, 0, NULL, 1, 1, 0, 0, 0, NULL,
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);
```

#### 5.1.3 菜单配置SQL完整示例

```sql
-- 菜单配置 SQL：平台协议版本内容表管理
-- 模块：PlatformAgreementVersions
-- 注意：该页面对应的前台目录为views/platformAgreementVersions文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值

-- 主菜单配置
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect, 
    menu_type, perms, perms_type, sort_no, always_show, icon, 
    is_route, is_leaf, keep_alive, hidden, hide_tab, description, 
    status, del_flag, rule_flag, create_by, create_time, update_by, 
    update_time, internal_or_external
) VALUES (
    '2025052904195420270', NULL, '平台协议版本内容表', 
    '/platformAgreementVersions/platformAgreementVersionsList', 
    'platformAgreementVersions/PlatformAgreementVersionsList', NULL, NULL, 
    0, NULL, '1', 0.00, 0, NULL, 1, 0, 0, 0, 0, NULL, 
    '1', 0, 0, 'admin', '2025-05-29 16:19:27', NULL, NULL, 0
);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '2025052904195420271', '2025052904195420270', '添加平台协议版本内容表', NULL, NULL, 
    0, NULL, NULL, 2, 'platformAgreementVersions:platform_agreement_versions:add', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-05-29 16:19:27', NULL, NULL, 
    0, 0, '1', 0
);

-- 编辑
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '2025052904195420272', '2025052904195420270', '编辑平台协议版本内容表', NULL, NULL, 
    0, NULL, NULL, 2, 'platformAgreementVersions:platform_agreement_versions:edit', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-05-29 16:19:27', NULL, NULL, 
    0, 0, '1', 0
);

-- 删除
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '2025052904195420273', '2025052904195420270', '删除平台协议版本内容表', NULL, NULL, 
    0, NULL, NULL, 2, 'platformAgreementVersions:platform_agreement_versions:delete', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-05-29 16:19:27', NULL, NULL, 
    0, 0, '1', 0
);

-- 批量删除
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '2025052904195420274', '2025052904195420270', '批量删除平台协议版本内容表', NULL, NULL, 
    0, NULL, NULL, 2, 'platformAgreementVersions:platform_agreement_versions:deleteBatch', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-05-29 16:19:27', NULL, NULL, 
    0, 0, '1', 0
);

-- 导出excel
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '2025052904195420275', '2025052904195420270', '导出excel_平台协议版本内容表', NULL, NULL, 
    0, NULL, NULL, 2, 'platformAgreementVersions:platform_agreement_versions:exportXls', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-05-29 16:19:27', NULL, NULL, 
    0, 0, '1', 0
);

-- 导入excel
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '2025052904195420276', '2025052904195420270', '导入excel_平台协议版本内容表', NULL, NULL, 
    0, NULL, NULL, 2, 'platformAgreementVersions:platform_agreement_versions:importExcel', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-05-29 16:19:27', NULL, NULL, 
    0, 0, '1', 0
);
```

#### 5.1.4 代码部署和SQL执行流程规范

**1. 自动部署要求：**
- 前端代码：自动放置到`src/views/`对应目录
- 后端代码：自动放置到对应的controller、service、mapper目录
- 无需用户手动复制粘贴操作

**2. SQL脚本管理规范：**
- 整合要求：将菜单配置SQL、权限授权SQL等所有相关SQL整合为单一初始化脚本
- 存放位置：放置在项目的SQL脚本目录下（如`db`）
- 执行方式：在工作流中涉及SQL执行时，直接调用MySQL MCP工具自动执行初始化

**3. ID生成规范：**
- 使用时间戳+随机数生成唯一ID
- 格式：YYYYMMDDHHMISS + 5位随机数
- 示例：`2025052904195420270`

#### 5.1.5 admin角色权限授权SQL模板

```sql
-- admin角色权限授权SQL
-- 使用动态查询避免硬编码角色ID，提高脚本可移植性

-- 获取admin角色ID
SET @admin_role_id = (SELECT id FROM sys_role WHERE role_code = 'admin');

-- 为admin角色授权主菜单
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
VALUES (REPLACE(UUID(), '-', ''), @admin_role_id, '{module_main_menu_id}', NULL, NOW(), '127.0.0.1');

-- 为admin角色授权子菜单
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
VALUES (REPLACE(UUID(), '-', ''), @admin_role_id, '{sub_menu_id}', NULL, NOW(), '127.0.0.1');

-- 为admin角色授权所有按钮权限（使用子查询动态获取）
INSERT INTO sys_role_permission(id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT
    REPLACE(UUID(), '-', ''),
    @admin_role_id,
    sp.id,
    NULL,
    NOW(),
    '127.0.0.1'
FROM sys_permission sp
WHERE sp.parent_id = @sub_menu_id
AND sp.menu_type = 2;
```

#### 5.1.6 任务发布模块成功案例分析

**案例背景：** 任务发布模块是jeecg-boot项目中首个完整实现的复杂业务模块，其菜单配置实践为后续模块开发提供了宝贵经验。

**成功要素分析：**

1. **清晰的层级结构**
   ```
   任务管理 (主菜单容器)
   ├── 任务发布管理 (功能页面)
   │   ├── 标准CRUD操作 (添加、编辑、删除、批量删除、导出、导入)
   │   └── 业务特定操作 (上下架)
   └── 任务接受记录 (功能页面)
       ├── 查看详情、删除、导出
       └── 业务特定操作 (审核、批量审核)
   ```

2. **规范的ID生成策略**
   - 主菜单：2024122401
   - 子菜单：2024122402, 2024122403
   - 按钮权限：2024122402001, 2024122402002...
   - 优势：时间可追溯、便于维护、避免冲突

3. **完整的权限覆盖**
   - 菜单权限：控制页面访问
   - 按钮权限：控制操作功能
   - 角色授权：admin角色完整授权

4. **业务适配性**
   - 标准CRUD：满足基础数据管理需求
   - 业务扩展：上下架、审核等特定业务操作
   - 灵活配置：支持后续功能扩展

**经验总结：**

✅ **成功实践**
- 三级菜单结构清晰易懂
- ID生成规则简单有效
- 权限配置完整无遗漏
- 业务功能覆盖全面

⚠️ **待优化点**
- admin角色ID硬编码问题
- 缺少动态权限查询机制
- 菜单图标配置需要标准化

**复用指导：**
1. 直接复制任务模块的菜单结构模式
2. 调整模块名称和业务特定操作
3. 保持ID生成规则的一致性
4. 确保权限配置的完整性

#### 5.1.7 完整的菜单配置和权限授权SQL整合模板

```sql
-- {module_description}管理 - 完整菜单配置和权限授权SQL
-- 模块：{ModuleName}
-- 注意：该页面对应的前台目录为views/{moduleNameKebabCase}文件夹下

-- ==================== 菜单配置部分 ====================
-- 主菜单配置
INSERT INTO sys_permission(
    id, parent_id, name, url, component, component_name, redirect, 
    menu_type, perms, perms_type, sort_no, always_show, icon, 
    is_route, is_leaf, keep_alive, hidden, hide_tab, description, 
    status, del_flag, rule_flag, create_by, create_time, update_by, 
    update_time, internal_or_external
) VALUES (
    '{menu_id}', NULL, '{module_description}', 
    '/{moduleNameKebabCase}/{moduleNameKebabCase}List', 
    '{moduleNameKebabCase}/{ModuleName}List', NULL, NULL, 
    0, NULL, '1', 0.00, 0, NULL, 1, 0, 0, 0, 0, NULL, 
    '1', 0, 0, 'admin', NOW(), NULL, NULL, 0
);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '{add_btn_id}', '{menu_id}', '添加{module_description}', NULL, NULL, 
    0, NULL, NULL, 2, '{moduleNameLowerCase}:{table_name}:add', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', NOW(), NULL, NULL, 
    0, 0, '1', 0
);

-- 编辑
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '{edit_btn_id}', '{menu_id}', '编辑{module_description}', NULL, NULL, 
    0, NULL, NULL, 2, '{moduleNameLowerCase}:{table_name}:edit', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', NOW(), NULL, NULL, 
    0, 0, '1', 0
);

-- 删除
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '{delete_btn_id}', '{menu_id}', '删除{module_description}', NULL, NULL, 
    0, NULL, NULL, 2, '{moduleNameLowerCase}:{table_name}:delete', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', NOW(), NULL, NULL, 
    0, 0, '1', 0
);

-- 批量删除
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '{batch_delete_btn_id}', '{menu_id}', '批量删除{module_description}', NULL, NULL, 
    0, NULL, NULL, 2, '{moduleNameLowerCase}:{table_name}:deleteBatch', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', NOW(), NULL, NULL, 
    0, 0, '1', 0
);

-- 导出excel
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '{export_btn_id}', '{menu_id}', '导出excel_{module_description}', NULL, NULL, 
    0, NULL, NULL, 2, '{moduleNameLowerCase}:{table_name}:exportXls', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', NOW(), NULL, NULL, 
    0, 0, '1', 0
);

-- 导入excel
INSERT INTO sys_permission(
    id, parent_id, name, url, component, is_route, component_name, 
    redirect, menu_type, perms, perms_type, sort_no, always_show, 
    icon, is_leaf, keep_alive, hidden, hide_tab, description, 
    create_by, create_time, update_by, update_time, del_flag, 
    rule_flag, status, internal_or_external
) VALUES (
    '{import_btn_id}', '{menu_id}', '导入excel_{module_description}', NULL, NULL, 
    0, NULL, NULL, 2, '{moduleNameLowerCase}:{table_name}:importExcel', '1', 
    NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', NOW(), NULL, NULL, 
    0, 0, '1', 0
);

-- ==================== admin角色权限授权部分 ====================
-- 获取admin角色ID
SET @admin_role_id = (SELECT id FROM sys_role WHERE role_code = 'admin');

-- 为admin角色授权主菜单
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) 
VALUES ('{role_permission_menu_id}', @admin_role_id, '{menu_id}', NULL, NOW(), '127.0.0.1');

-- 为admin角色授权按钮权限
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) 
VALUES 
('{role_permission_add_id}', @admin_role_id, '{add_btn_id}', NULL, NOW(), '127.0.0.1'),
('{role_permission_edit_id}', @admin_role_id, '{edit_btn_id}', NULL, NOW(), '127.0.0.1'),
('{role_permission_delete_id}', @admin_role_id, '{delete_btn_id}', NULL, NOW(), '127.0.0.1'),
('{role_permission_batch_delete_id}', @admin_role_id, '{batch_delete_btn_id}', NULL, NOW(), '127.0.0.1'),
('{role_permission_export_id}', @admin_role_id, '{export_btn_id}', NULL, NOW(), '127.0.0.1'),
('{role_permission_import_id}', @admin_role_id, '{import_btn_id}', NULL, NOW(), '127.0.0.1');
```

## 第六部分：完整流程AI提示词模板

### 6.1 一键生成完整功能模块

```
请根据以下需求生成完整的单表CRUD功能模块：

**业务需求：**
{用户提供的详细业务需求描述}

**原型图支持：**
- 支持直接贴入原型图片或设计稿
- 支持Figma、Sketch、Axure等设计工具的截图
- 支持手绘草图或线框图
- AI将根据原型图自动识别页面布局、字段排列、交互逻辑等
- 原型图将作为前端页面生成的重要参考依据

**原型图使用说明：**
1. 直接将原型图片拖拽到对话框中
2. 或者提供原型图的在线链接
3. AI会自动分析原型图中的：
   - 页面布局结构
   - 表单字段排列
   - 按钮位置和样式
   - 表格列的显示顺序
   - 查询条件的布局
   - 弹窗和抽屉的设计

**模块信息：**
- 模块名称：{module_name}
- 功能描述：{module_description}
- 父级菜单ID：{parent_menu_id}（可选，默认为系统管理）

**代码存放位置：**
- 后端代码：jeecg-module-system/jeecg-system-biz/src/main/java/org/jeecg/modules/{moduleNameCamelCase}/
- 前端代码：src/views/{moduleNameKebabCase}/

**生成要求：**
请严格按照AI代码生成规范化指导文档执行，生成以下完整内容：

1. **数据表结构**
   - 根据需求分析业务字段
   - 生成标准的CREATE TABLE语句
   - 包含所有必要的索引
   - 严格按照数据库表结构设计规范

2. **字典数据配置**
   - 识别枚举字段
   - 生成字典配置SQL
   - 使用UUID生成字典ID

3. **后端代码**（存放在 jeecg-module-system/jeecg-system-biz/src/main/java/org/jeecg/modules/{moduleNameCamelCase}/）
   - Entity实体类（包含@Dict、@Excel、@JsonFormat等所有注解）
   - Mapper接口和XML（继承MPJBaseMapper）
   - Service接口和实现类（继承MPJBaseService）
   - Controller控制器（包含标准CRUD接口和权限注解）

4. **前端代码**（存放在 src/views/{moduleNameKebabCase}/）
   - 列表页面（List.vue，使用JeecgListMixin）
   - 弹窗组件（Modal.vue）
   - 表单组件（Form.vue，字典字段使用j-dict-select-tag）

5. **系统集成**
   - 菜单配置SQL
   - 权限按钮SQL
   - admin角色授权SQL

**输出格式：**
请按照以下顺序输出，每个部分用明确的标题分隔：

### 1. 数据表结构
### 2. 字典数据配置
### 3. 后端代码
#### 3.1 Entity实体类
#### 3.2 Mapper接口
#### 3.3 Mapper XML
#### 3.4 Service接口
#### 3.5 Service实现类
#### 3.6 Controller控制器
### 4. 前端代码
#### 4.1 列表页面（List.vue）
#### 4.2 弹窗组件（Modal.vue）
#### 4.3 表单组件（Form.vue）
### 5. 系统集成
#### 5.1 菜单配置SQL
#### 5.2 部署说明

**质量要求：**
- 代码必须符合现有规范
- 注释完整清晰
- 字段验证完善
- 权限控制到位
- 字典字段正确使用j-dict-select-tag组件
- 可直接运行使用
```

### 6.2 字段类型智能识别规则

```
**字段类型智能识别规则：**

根据字段名称和描述自动识别合适的数据类型：

1. **字符串类型**
   - 名称、标题、描述 → VARCHAR(100-500)
   - 内容、详情、备注 → TEXT
   - 编码、代码 → VARCHAR(50)
   - 链接、URL → VARCHAR(500)

2. **数字类型**
   - 金额、价格、费用 → DECIMAL(10,2)
   - 数量、库存 → INT
   - 排序、序号 → INT
   - 百分比、比率 → DECIMAL(5,2)

3. **时间类型**
   - 时间、日期 → DATETIME
   - 生日、日期 → DATE

4. **枚举类型**
   - 状态、类型、级别 → VARCHAR(1) + 字典
   - 性别 → VARCHAR(1) + 字典

5. **布尔类型**
   - 是否、启用、禁用 → TINYINT(1)

6. **特殊类型**
   - 手机号 → VARCHAR(11)
   - 邮箱 → VARCHAR(100)
   - 身份证 → VARCHAR(18)
```

## 第七部分：质量控制与最佳实践

### 7.1 代码质量检查清单

```
**生成代码质量检查清单：**

□ **数据表结构**
  □ 表名符合命名规范（模块名_实体名）
  □ 包含所有标准字段
  □ 字段类型选择合理
  □ 索引设计完善
  □ 注释完整清晰

□ **实体类**
  □ 包名路径正确
  □ 注解使用规范（@Dict、@Excel、@JsonFormat等）
  □ 字段类型与数据库一致
  □ 字典字段配置正确

□ **Mapper层**
  □ 继承MPJBaseMapper
  □ XML命名空间正确
  □ 自定义SQL语法正确

□ **Service层**
  □ 接口继承MPJBaseService
  □ 实现类注解完整
  □ 业务逻辑合理

□ **Controller层**
  □ 包含所有标准CRUD接口
  □ 权限注解配置正确
  □ 返回结果使用Result包装
  □ 参数校验完善

□ **前端页面**
  □ 使用JeecgListMixin
  □ 表格列配置完整
  □ 表单验证规则完善
  □ 权限控制到位

□ **系统集成**
  □ 菜单配置完整
  □ 权限按钮齐全
  □ admin角色授权
```

#### 5.1.8 菜单配置常见问题与最佳实践

**基于任务模块开发经验总结**

**常见问题：**

1. **ID冲突问题**
   - **问题：** 多个模块使用相同的ID导致冲突
   - **解决方案：** 使用时间戳+模块序号的ID生成策略
   - **示例：** 2024122401 (2024年12月24日第01个模块)

2. **权限遗漏问题**
   - **问题：** 菜单创建了但忘记给admin角色授权
   - **解决方案：** 使用完整的SQL模板，确保权限配置完整
   - **检查清单：** 主菜单权限、子菜单权限、所有按钮权限

3. **路径配置错误**
   - **问题：** component路径与实际文件路径不匹配
   - **解决方案：** 严格按照`{模块名}/{页面名}`格式配置
   - **示例：** `task/TaskPublishList` 对应 `src/views/task/TaskPublishList.vue`

4. **权限编码不规范**
   - **问题：** perms字段命名不一致，影响前端权限控制
   - **解决方案：** 使用标准格式 `{模块名}:{操作}`
   - **示例：** `taskPublish:add`, `taskAcceptanceRecord:audit`

**最佳实践：**

1. **菜单结构设计**
   ```
   ✅ 推荐：三级结构
   模块主菜单 → 功能子菜单 → 操作按钮

   ❌ 避免：过深的嵌套层级
   模块 → 子模块 → 功能 → 子功能 → 操作
   ```

2. **ID生成策略**
   ```
   ✅ 推荐：时间戳+序号
   2024122401, 2024122402, 2024122402001

   ❌ 避免：随机UUID
   a1b2c3d4-e5f6-7890-abcd-ef1234567890
   ```

3. **权限配置完整性**
   ```
   ✅ 必须配置：
   - 主菜单权限
   - 子菜单权限
   - 所有按钮权限
   - admin角色授权

   ❌ 常见遗漏：
   - 忘记配置按钮权限
   - 忘记给admin角色授权
   ```

4. **业务扩展性**
   ```
   ✅ 预留扩展：
   - 标准CRUD操作
   - 业务特定操作
   - 状态管理操作

   ✅ 任务模块示例：
   - 标准：添加、编辑、删除、批量删除、导出、导入
   - 业务：上下架、审核、批量审核
   ```

**执行检查清单：**

□ **菜单结构**
  □ 主菜单使用 `layouts/RouteView`
  □ 子菜单路径正确配置
  □ 菜单层级不超过3级

□ **权限配置**
  □ 所有菜单都有对应权限
  □ 所有按钮都有权限控制
  □ admin角色已完整授权

□ **命名规范**
  □ ID使用时间戳+序号格式
  □ perms使用模块名:操作格式
  □ component路径与文件路径匹配

□ **业务完整性**
  □ 标准CRUD操作齐全
  □ 业务特定操作已配置
  □ 权限控制粒度合适

### 7.2 常见问题与解决方案

```
**常见问题与解决方案：**

1. **字典翻译不生效**
   - 检查@Dict注解参数是否正确
   - 确认字典数据是否已插入
   - 验证字典编码是否匹配

2. **权限控制失效**
   - 检查权限注解格式是否正确
   - 确认菜单和按钮权限是否已配置
   - 验证角色授权是否完成

3. **表单验证不生效**
   - 检查validatorRules配置
   - 确认表单字段绑定正确
   - 验证验证规则语法

4. **导入导出功能异常**
   - 检查@Excel注解配置
   - 确认文件上传路径配置
   - 验证Excel模板格式

5. **分页查询问题**
   - 检查QueryWrapper配置
   - 确认分页参数传递
   - 验证SQL语法正确性
```

## 第八部分：部署与测试指南

### 8.1 部署步骤

```
**标准部署步骤：**

1. **数据库初始化**
   ```sql
   -- 1. 执行表结构SQL
   CREATE TABLE `{table_name}` (...);
   
   -- 2. 执行字典配置SQL（如有枚举字段）
   INSERT INTO `sys_dict` (...);
   INSERT INTO `sys_dict_item` (...);
   
   -- 3. 执行菜单配置SQL
   INSERT INTO `sys_permission` (...);
   INSERT INTO `sys_role_permission` (...);
   ```

2. **后端代码部署**
   - 将生成的Java代码放入 `jeecg-module-system/jeecg-system-biz/src/main/java/org/jeecg/modules/{moduleNameCamelCase}/`
   - 确保包路径正确：`org.jeecg.modules.{moduleNameCamelCase}`
   - 重启后端服务
   - 验证接口可访问性：`GET /{moduleNameLowerCase}/{moduleNameLowerCase}/list`

3. **前端代码部署**
   - 将Vue组件放入 `src/views/{moduleNameKebabCase}/` 目录
   - 确保文件命名正确：`{ModuleName}List.vue`、`modules/{ModuleName}Modal.vue`等
   - 重启前端服务
   - 验证页面正常显示

4. **功能测试**
   - 测试菜单访问权限
   - 测试增删改查功能
   - 测试字典翻译功能
   - 测试权限控制（按钮权限）
   - 测试导入导出功能
   - 测试表单验证功能

5. **常见问题排查**
   - 如果菜单不显示：检查菜单SQL是否执行成功，角色是否授权
   - 如果接口404：检查后端代码包路径和Controller注解
   - 如果字典不翻译：检查@Dict注解和字典数据
   - 如果权限失效：检查权限注解和按钮权限配置
```

### 8.2 测试用例模板

```
**功能测试用例：**

1. **新增功能测试**
   - 正常数据新增
   - 必填字段验证
   - 重复数据验证
   - 字段长度验证

2. **查询功能测试**
   - 列表数据显示
   - 分页功能
   - 条件查询
   - 排序功能

3. **编辑功能测试**
   - 数据回显
   - 修改保存
   - 字段验证

4. **删除功能测试**
   - 单条删除
   - 批量删除
   - 删除确认

5. **权限测试**
   - 菜单访问权限
   - 按钮操作权限
   - 数据权限控制

6. **导入导出测试**
   - Excel导出功能
   - Excel导入功能
   - 模板下载
```

## 总结

本AI代码生成规范化指导文档提供了完整的标准化流程，通过规范的AI提示词模板和生成规范，可以实现从业务需求到完整功能模块的一键式自动化生成。

**核心优势：**
1. **标准化**：基于现有规范，确保生成代码的一致性
2. **自动化**：一键生成完整功能模块，大幅提升开发效率
3. **规范化**：严格遵循开发规范，保证代码质量
4. **可维护性**：生成的代码结构清晰，易于维护和扩展

**使用建议：**
1. 严格按照提示词模板执行
2. 生成后进行质量检查
3. 根据具体需求进行微调
4. 及时更新和完善规范文档

通过遵循本规范，可以实现高效、规范、可维护的代码生成，为项目开发提供强有力的支持。 