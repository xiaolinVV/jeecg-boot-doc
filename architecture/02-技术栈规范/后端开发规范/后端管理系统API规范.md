# 后端管理系统API设计规范

## 概述

本文档定义了jeecg-boot项目中后端管理系统（Jeecg-boot架构）的API设计和代码组织规范。基于传统的Jeecg-boot架构方式，所有后端管理系统的前后端基础增删改查代码，包括前端页面都可以直接用代码生成器生成，结构都是标准模板生成的，比较统一。

**适用范围：**
- 后端管理系统API接口
- 管理员端操作接口  
- 系统配置与维护接口

**技术栈：**
- 后端：Spring Boot + MyBatis Plus + Jeecg-boot
- 前端：Vue 2 + Ant Design Vue
- 架构：传统三层架构（Controller + Service + Mapper）

前缀说明：管理后台接口不限制固定前缀；仅需避免使用 /front、/after、/before、/back（分别保留给 C 端与商家端）。建议按模块路径组织，保持一致性即可。

## 1. 后端代码结构规范

### 1.1 标准目录结构

基于 `jeecg-module-system/jeecg-system-biz/src/main/java/org/jeecg/modules/platformAgreementVersions` 标准模板：

```
/org/jeecg/modules/{moduleNameCamelCase}/
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

### 1.2 实体类（Entity）规范

#### 1.2.1 基本结构

```java
package org.jeecg.modules.{moduleNameCamelCase}.entity;

import java.io.Serializable;
import java.util.Date;
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
 * @Description: 模块描述
 * @Author: jeecg-boot
 * @Date: 生成日期
 * @Version: V1.0
 */
@Data
@TableName("table_name")
@Accessors(chain = true)
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="table_name对象", description="表描述")
public class ModuleName implements Serializable {
    private static final long serialVersionUID = 1L;

    /**主键ID*/
    @TableId(type = IdType.ASSIGN_ID)
    @ApiModelProperty(value = "主键ID")
    private String id;
    
    /**业务字段*/
    @Excel(name = "字段描述", width = 15)
    @ApiModelProperty(value = "字段描述")
    private String fieldName;
    
    /**字典字段*/
    @Excel(name = "字典字段", width = 15, dicCode = "dict_code")
    @Dict(dicCode = "dict_code")
    @ApiModelProperty(value = "字典字段描述")
    private String dictField;
    
    /**日期字段*/
    @Excel(name = "日期字段", width = 20, format = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    @ApiModelProperty(value = "日期字段描述")
    private Date dateField;
    
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

#### 1.2.2 注解使用规范

- **@TableName**: 指定数据库表名
- **@TableId**: 主键字段，统一使用 `IdType.ASSIGN_ID`
- **@TableLogic**: 逻辑删除字段
- **@Excel**: 导出Excel配置
- **@Dict**: 字典翻译配置
- **@JsonFormat/@DateTimeFormat**: 日期格式化

### 1.3 Mapper层规范

#### 1.3.1 Mapper接口

```java
package org.jeecg.modules.{moduleNameCamelCase}.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import com.github.yulichang.base.MPJBaseMapper;

/**
 * @Description: 模块描述
 * @Author: jeecg-boot
 * @Date: 生成日期
 * @Version: V1.0
 */
public interface {ModuleName}Mapper extends MPJBaseMapper<{ModuleName}> {
    
    // 自定义查询方法（如需要）
    List<{ModuleName}> selectCustomList(@Param("param") String param);
}
```

#### 1.3.2 XML映射文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="org.jeecg.modules.{moduleNameCamelCase}.mapper.{ModuleName}Mapper">

    <!-- 自定义查询语句（如需要） -->
    <select id="selectCustomList" resultType="org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName}">
        SELECT * FROM table_name 
        WHERE del_flag = '0'
        <if test="param != null and param != ''">
            AND field_name LIKE CONCAT('%', #{param}, '%')
        </if>
    </select>

</mapper>
```

### 1.4 Service层规范

#### 1.4.1 Service接口

```java
package org.jeecg.modules.{moduleNameCamelCase}.service;

import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import com.github.yulichang.base.MPJBaseService;

/**
 * @Description: 模块描述
 * @Author: jeecg-boot
 * @Date: 生成日期
 * @Version: V1.0
 */
public interface I{ModuleName}Service extends MPJBaseService<{ModuleName}> {
    
    // 自定义业务方法（如需要）
    void customBusinessMethod(String param);
}
```

#### 1.4.2 Service实现类

```java
package org.jeecg.modules.{moduleNameCamelCase}.service.impl;

import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import org.jeecg.modules.{moduleNameCamelCase}.mapper.{ModuleName}Mapper;
import org.jeecg.modules.{moduleNameCamelCase}.service.I{ModuleName}Service;
import org.springframework.stereotype.Service;
import com.github.yulichang.base.MPJBaseServiceImpl;

/**
 * @Description: 模块描述
 * @Author: jeecg-boot
 * @Date: 生成日期
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

### 1.5 Controller层规范

#### 1.5.1 基本结构

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
 * @Description: 模块描述
 * @Author: jeecg-boot
 * @Date: 生成日期
 * @Version: V1.0
 */
@Api(tags="模块描述")
@RestController
@RequestMapping("/{moduleNameLowerCase}/{moduleNameLowerCase}")
@Slf4j
public class {ModuleName}Controller extends JeecgController<{ModuleName}, I{ModuleName}Service> {
    @Autowired
    private I{ModuleName}Service {moduleNameCamelCase}Service;
}
```

#### 1.5.2 标准CRUD接口

```java
/**
 * 分页列表查询
 */
@ApiOperation(value="模块-分页列表查询", notes="模块-分页列表查询")
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
@AutoLog(value = "模块-添加")
@ApiOperation(value="模块-添加", notes="模块-添加")
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:add")
@PostMapping(value = "/add")
public Result<String> add(@RequestBody {ModuleName} {moduleNameCamelCase}) {
    {moduleNameCamelCase}Service.save({moduleNameCamelCase});
    return Result.OK("添加成功！");
}

/**
 * 编辑
 */
@AutoLog(value = "模块-编辑")
@ApiOperation(value="模块-编辑", notes="模块-编辑")
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:edit")
@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
public Result<String> edit(@RequestBody {ModuleName} {moduleNameCamelCase}) {
    {moduleNameCamelCase}Service.updateById({moduleNameCamelCase});
    return Result.OK("编辑成功!");
}

/**
 * 通过id删除
 */
@AutoLog(value = "模块-通过id删除")
@ApiOperation(value="模块-通过id删除", notes="模块-通过id删除")
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:delete")
@DeleteMapping(value = "/delete")
public Result<String> delete(@RequestParam(name="id",required=true) String id) {
    {moduleNameCamelCase}Service.removeById(id);
    return Result.OK("删除成功!");
}

/**
 * 批量删除
 */
@AutoLog(value = "模块-批量删除")
@ApiOperation(value="模块-批量删除", notes="模块-批量删除")
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:deleteBatch")
@DeleteMapping(value = "/deleteBatch")
public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
    this.{moduleNameCamelCase}Service.removeByIds(Arrays.asList(ids.split(",")));
    return Result.OK("批量删除成功!");
}

/**
 * 通过id查询
 */
@ApiOperation(value="模块-通过id查询", notes="模块-通过id查询")
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
    return super.exportXls(request, {moduleNameCamelCase}, {ModuleName}.class, "模块数据");
}

/**
 * 通过excel导入数据
 */
@RequestMapping(value = "/importExcel", method = RequestMethod.POST)
public Result<?> importExcel(HttpServletRequest request, HttpServletResponse response) {
    return super.importExcel(request, response, {ModuleName}.class);
}
```

#### 1.5.3 响应格式规范

**强制使用 Result 类：**
```java
// ✅ 正确
@GetMapping("/info")
public Result<ModuleInfo> getInfo() {
    ModuleInfo info = service.getInfo();
    return Result.OK(info);
}

// ❌ 错误 - 禁止直接返回数据对象
@GetMapping("/info")  
public ModuleInfo getInfo() {
    return service.getInfo();
}
```

## 2. 前端代码结构规范

### 2.1 标准目录结构

基于 `src/views/platformAgreementVersions` 标准模板：

```
/src/views/{moduleNameKebabCase}/
├── {ModuleName}List.vue              # 主列表页面
├── {ModuleName}_menu_insert.sql      # 菜单插入SQL
└── modules/                          # 子组件目录
    ├── {ModuleName}Modal.vue         # 弹窗组件
    ├── {ModuleName}Modal.Style#Drawer.vue  # 抽屉弹窗
    └── {ModuleName}Form.vue          # 表单组件
```

### 2.2 列表页面规范

#### 2.2.1 基本结构 (List.vue)

```vue
<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <!-- 查询条件 -->
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="字段名">
              <a-input placeholder="请输入" v-model="queryParam.fieldName"></a-input>
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
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <a-button type="primary" icon="download" @click="handleExportXls('数据导出')">导出</a-button>
      
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel">
            <a-icon type="delete"/>删除
          </a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
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
        @change="handleTableChange">

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>
          <a-divider type="vertical" />
          <a @click="handleDetail(record)">详情</a>
          <a-divider type="vertical" />
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
            <a style="color: #ff4d4f;">删除</a>
          </a-popconfirm>
        </span>

      </a-table>
    </div>

    <!-- 弹窗组件 -->
    <module-name-modal ref="modalForm" @ok="modalFormOk"></module-name-modal>
  </a-card>
</template>

<script>
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import ModuleNameModal from './modules/ModuleNameModal'

export default {
  name: 'ModuleNameList',
  mixins: [JeecgListMixin],
  components: {
    ModuleNameModal
  },
  data () {
    return {
      description: '模块管理',
      // 表头
      columns: [
        {
          title: '序号',
          dataIndex: '',
          key:'rowIndex',
          width:60,
          align:"center",
          customRender:function (t,r,index) {
            return parseInt(index)+1;
          }
        },
        {
          title:'字段名',
          align:"center",
          dataIndex: 'fieldName'
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
        list: "/moduleNameLowerCase/moduleNameLowerCase/list",
        delete: "/moduleNameLowerCase/moduleNameLowerCase/delete",
        deleteBatch: "/moduleNameLowerCase/moduleNameLowerCase/deleteBatch",
        exportXlsUrl: "/moduleNameLowerCase/moduleNameLowerCase/exportXls",
        importExcelUrl: "/moduleNameLowerCase/moduleNameLowerCase/importExcel",
      },
      dictOptions:{},
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  methods: {}
}
</script>
```

#### 2.2.2 JeecgListMixin 使用规范

**必须配置的数据：**
- `url` 对象：包含所有API接口地址
- `columns` 数组：表格列定义
- `queryParam` 对象：查询参数

**可重写的方法：**
- `loadData()`: 自定义数据加载逻辑
- `handleAdd()`: 自定义新增逻辑
- `handleEdit(record)`: 自定义编辑逻辑
- `handleDelete(id)`: 自定义删除逻辑

### 2.3 弹窗组件规范

#### 2.3.1 弹窗组件 (Modal.vue)

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
    
    <module-name-form ref="realForm" @ok="submitCallback" :disabled="disableSubmit"></module-name-form>
    
  </j-modal>
</template>

<script>
import ModuleNameForm from './ModuleNameForm'

export default {
  name: 'ModuleNameModal',
  components: {
    ModuleNameForm
  },
  data () {
    return {
      title:"",
      width:800,
      visible: false,
      confirmLoading: false,
      disableSubmit: false
    }
  },
  methods: {
    add () {
      this.visible=true;
      this.title="新增";
      this.disableSubmit = false;
    },
    edit (record) {
      this.visible=true;
      this.title="编辑";
      this.disableSubmit = false;
      this.$nextTick(() => {
        this.$refs.realForm.edit(record);
      });
    },
    close () {
      this.$emit('close');
      this.visible = false;
      this.$refs.realForm.close();
    },
    handleOk () {
      this.$refs.realForm.submitForm();
    },
    handleCancel () {
      this.close()
    },
    submitCallback(){
      this.$emit('ok');
      this.close();
    }
  }
}
</script>
```

#### 2.3.2 表单组件 (Form.vue)

```vue
<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="字段名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="fieldName">
              <a-input v-model="model.fieldName" placeholder="请输入字段名"></a-input>
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
  name: 'ModuleNameForm',
  components: {},
  props: {
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
        fieldName: [
          { required: true, message: '请输入字段名!'},
        ],
      },
      url: {
        add: "/moduleNameLowerCase/moduleNameLowerCase/add",
        edit: "/moduleNameLowerCase/moduleNameLowerCase/edit",
        queryById: "/moduleNameLowerCase/moduleNameLowerCase/queryById"
      }
    }
  },
  computed: {
    formDisabled(){
      return this.disabled;
    },
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
  }
}
</script>
```

## 3. 权限控制规范

### 3.1 权限注解

```java
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:add")    // 新增权限
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:edit")   // 编辑权限
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:delete") // 删除权限
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:query")  // 查询权限
```

### 3.2 前端权限控制

```vue
<!-- 按钮权限控制 -->
<a-button v-has="'moduleNameLowerCase:table_name:add'" @click="handleAdd" type="primary">新增</a-button>
<a-button v-has="'moduleNameLowerCase:table_name:delete'" @click="batchDel" type="danger">批量删除</a-button>

<!-- 表格操作权限 -->
<span slot="action" slot-scope="text, record">
  <a v-has="'moduleNameLowerCase:table_name:edit'" @click="handleEdit(record)">编辑</a>
  <a v-has="'moduleNameLowerCase:table_name:delete'" @click="handleDelete(record.id)">删除</a>
</span>
```

## 4. 数据库设计规范

### 4.1 基础字段

所有表必须包含以下基础字段：

```sql
CREATE TABLE `table_name` (
  `id` varchar(32) NOT NULL COMMENT '主键ID',
  
  -- 业务字段
  `business_field` varchar(100) NOT NULL COMMENT '业务字段描述',
  
  -- 系统字段
  `del_flag` varchar(1) DEFAULT '0' COMMENT '删除状态 0=未删除 1=已删除',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT (now()) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  
  PRIMARY KEY (`id`),
  INDEX `idx_del_flag` (`del_flag`) COMMENT '逻辑删除标记索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表描述';
```

### 4.2 命名规范

- **表名**: 使用下划线分隔的小写字母
- **字段名**: 使用下划线分隔的小写字母
- **索引名**: `idx_` + 字段名
- **唯一索引**: `uk_` + 字段名

## 5. 代码生成器使用

### 5.1 生成步骤

1. **创建数据库表**（遵循数据库设计规范）
2. **使用Jeecg代码生成器**生成基础代码
3. **配置菜单权限**（执行生成的SQL文件）
4. **自定义业务逻辑**（在生成代码基础上扩展）

### 5.2 生成后的调整

- 根据业务需求调整表格列显示
- 添加自定义查询条件
- 实现特殊业务逻辑
- 完善表单验证规则

## 6. 最佳实践

### 6.1 Controller层

- 使用 `@AutoLog` 记录操作日志
- 使用 `@RequiresPermissions` 控制权限
- 统一使用 `Result` 包装返回结果
- 参数校验使用 `@Valid` 注解

### 6.2 Service层

- 复杂业务逻辑放在Service层实现
- 使用 `@Transactional` 控制事务
- 避免在Controller中写业务逻辑

### 6.3 前端页面

- 使用 `JeecgListMixin` 减少重复代码
- 组件拆分要合理，提高复用性
- 统一使用 `this.$message` 显示提示信息
- 表单验证要完善

### 6.4 性能优化

- 合理使用索引
- 避免N+1查询问题
- 大数据量查询要分页
- 合理使用缓存 
