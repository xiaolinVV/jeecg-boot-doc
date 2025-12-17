# Vue2+jeecg-boot后台管理系统前后端开发完整规范

## 📋 概述

本文档是jeecg-boot后台管理系统的前后端开发完整规范，整合了网络请求最佳实践、API设计规范、代码结构标准等核心内容，为开发团队提供统一的开发指导。

**适用范围：**
- 后台管理系统前端开发（jeecg-boot-web）
- 后台管理系统后端API开发（jeecg-boot-backend）
- 前后端协作开发流程
- 代码审查和质量控制
`
**技术栈版本信息：**
- **后端**: Spring Boot + MyBatis Plus + jeecg-boot 3.4.3
- **前端**: Vue 2.6.10 + Ant Design Vue + Axios 0.18.0
- **架构**: 传统三层架构（Controller + Service + Mapper）
- **请求签名**: MD5签名机制
- **超时设置**: 180秒

## 🏗️ 核心架构

### 1. 项目结构层次
```
jeecg-boot/
├── jeecg-boot-backend/                    # 后端项目
│   └── jeecg-module-system/
│       └── jeecg-system-biz/
│           └── src/main/java/org/jeecg/modules/
│               └── {moduleNameCamelCase}/
│                   ├── controller/
│                   ├── entity/
│                   ├── mapper/
│                   └── service/
└── jeecg-boot-web/               # 前端项目
    └── src/
        ├── api/                     # API封装
        ├── views/                   # 页面组件
        ├── utils/                   # 工具函数
        └── mixins/                  # 混入组件
```

### 2. 请求封装层次结构
```
src/
├── utils/
│   ├── request.js          # axios实例配置、拦截器
│   └── axios.js            # VueAxios插件封装
├── api/
│   ├── manage.js           # 基础API方法封装
│   └── api.js              # 具体业务API定义
└── utils/encryption/
    └── signMd5Utils.js     # 签名工具
```

## 🔧 后端开发规范

### 1. 标准目录结构

基于jeecg-boot标准模板：

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

### 2. 实体类（Entity）规范

#### 2.1 基本结构模板

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

#### 2.2 注解使用规范

- **@TableName**: 指定数据库表名
- **@TableId**: 主键字段，统一使用 `IdType.ASSIGN_ID`
- **@TableLogic**: 逻辑删除字段
- **@Excel**: 导出Excel配置
- **@Dict**: 字典翻译配置
- **@JsonFormat/@DateTimeFormat**: 日期格式化

### 3. Controller层规范

#### 3.1 基本结构模板

```java
package org.jeecg.modules.{moduleNameCamelCase}.controller;

import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.{moduleNameCamelCase}.entity.{ModuleName};
import org.jeecg.modules.{moduleNameCamelCase}.service.I{ModuleName}Service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;

import org.jeecg.common.system.base.controller.JeecgController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
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

#### 3.2 响应格式规范

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

### 4. 数据库设计规范

#### 4.1 基础字段

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

#### 4.2 命名规范

- **表名**: 使用下划线分隔的小写字母
- **字段名**: 使用下划线分隔的小写字母
- **索引名**: `idx_` + 字段名
- **唯一索引**: `uk_` + 字段名

## 🎨 前端开发规范

### 1. API方法封装

#### 1.1 标准HTTP方法

**文件位置**: `src/api/manage.js`

```javascript
import { getAction, postAction, putAction, deleteAction } from '@/api/manage'

// GET请求 - 查询数据
getAction('/sys/user/list', { pageNo: 1, pageSize: 10 })
  .then(res => {
    if (res.success) {
      console.log(res.result)
    }
  })

// POST请求 - 新增数据（JSON格式）
postAction('/sys/user/add', {
  username: 'admin',
  realname: '管理员'
}).then(res => {
  if (res.success) {
    this.$message.success('添加成功')
  }
})

// PUT请求 - 更新数据（JSON格式）
putAction('/sys/user/edit', {
  id: '123',
  username: 'admin'
}).then(res => {
  if (res.success) {
    this.$message.success('更新成功')
  }
})

// DELETE请求 - 删除数据
deleteAction('/sys/user/delete', { id: '123' })
  .then(res => {
    if (res.success) {
      this.$message.success('删除成功')
    }
  })
```

#### 1.2 表单参数方法

```javascript
import { postApplicationAction } from '@/api/manage'

// 表单参数提交（Content-Type: application/x-www-form-urlencoded）
// 适用于后端使用@RequestParam注解的接口
postApplicationAction('/sys/user/audit', {
  id: '123',
  status: 'approved',
  reason: '审核通过'
}).then(res => {
  if (res.success) {
    this.$message.success('审核成功')
  } else {
    this.$message.error(res.message)
  }
})
```

### 2. API调用方法选择指南

#### 2.1 核心API方法对比

| 方法名 | Content-Type | 参数位置 | 适用后端注解 | 使用场景 |
|--------|-------------|----------|-------------|----------|
| `getAction` | - | `params` | `@RequestParam` | GET请求，URL参数 |
| `deleteAction` | - | `params` | `@RequestParam` | DELETE请求，URL参数 |
| `postAction` | `application/json` | `data` | `@RequestBody` | POST请求，JSON数据 |
| `putAction` | `application/json` | `data` | `@RequestBody` | PUT请求，JSON数据 |
| `httpAction` | `application/json` | `data` | `@RequestBody` | 自定义方法，JSON数据 |
| `postApplicationAction` | `application/x-www-form-urlencoded` | `params` | `@RequestParam` | POST请求，表单数据 |

#### 2.2 根据后端注解选择前端方法

**@RequestBody注解 → 使用JSON方法**
```javascript
// 后端
@PostMapping("/add")
public Result<?> add(@RequestBody User user) {
    // ...
}

// 前端
import { postAction } from '@/api/manage'
postAction('/sys/user/add', {
  username: 'admin',
  realname: '管理员'
})
```

**@RequestParam注解 → 使用表单方法**
```javascript
// 后端
@PostMapping("/audit")
public Result<?> audit(
    @RequestParam("id") String id,
    @RequestParam("status") String status) {
    // ...
}

// 前端
import { postApplicationAction } from '@/api/manage'
postApplicationAction('/sys/user/audit', {
  id: '123',
  status: 'approved'
})
```

### 3. 前端代码结构规范

#### 3.1 标准目录结构

基于jeecg-boot标准模板：

```
/src/views/{moduleNameKebabCase}/
├── {ModuleName}List.vue              # 主列表页面
├── {ModuleName}_menu_insert.sql      # 菜单插入SQL
└── modules/                          # 子组件目录
    ├── {ModuleName}Modal.vue         # 弹窗组件
    ├── {ModuleName}Modal.Style#Drawer.vue  # 抽屉弹窗
    └── {ModuleName}Form.vue          # 表单组件
```

#### 3.2 列表页面规范（List.vue）

```vue
<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
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
  methods: {}
}
</script>
```

#### 3.3 JeecgListMixin 使用规范

**必须配置的数据：**
- `url` 对象：包含所有API接口地址
- `columns` 数组：表格列定义
- `queryParam` 对象：查询参数

**可重写的方法：**
- `loadData()`: 自定义数据加载逻辑
- `handleAdd()`: 自定义新增逻辑
- `handleEdit(record)`: 自定义编辑逻辑
- `handleDelete(id)`: 自定义删除逻辑

### 4. 错误处理最佳实践

#### 4.1 统一错误处理模式

```javascript
export default {
  methods: {
    async handleApiCall() {
      try {
        const res = await getAction('/api/data', this.params)

        if (res.success) {
          // 成功处理
          this.dataSource = res.result
          return res.result
        } else {
          // 业务错误处理
          this.$message.warning(res.message || '操作失败')
          return null
        }
      } catch (error) {
        // 网络错误处理
        console.error('API调用失败:', error)
        this.$message.error('网络错误，请稍后重试')
        return null
      }
    }
  }
}
```

#### 4.2 常见API调用错误

**错误1：Required request parameter not present**
```javascript
// 原因：使用httpAction调用@RequestParam接口
// 错误写法
httpAction('/sys/task/audit', params, 'post')

// 正确写法
postApplicationAction('/sys/task/audit', params)
```

**错误2：JSON parse error**
```javascript
// 原因：使用postApplicationAction调用@RequestBody接口
// 错误写法
postApplicationAction('/sys/user/add', userObject)

// 正确写法
postAction('/sys/user/add', userObject)
```

**错误3：参数名不匹配**
```javascript
// 后端
@RequestParam("userId") String userId

// 前端参数必须使用userId
{ userId: '123' }  // 正确
{ id: '123' }      // 错误
```

### 5. 权限控制规范

#### 5.1 后端权限注解

```java
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:add")    // 新增权限
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:edit")   // 编辑权限
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:delete") // 删除权限
@RequiresPermissions("{moduleNameLowerCase}:{table_name}:query")  // 查询权限
```

#### 5.2 前端权限控制

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

### 6. 请求拦截器配置

#### 6.1 请求前拦截器

```javascript
// 自动添加认证Token
service.interceptors.request.use(config => {
  const token = Vue.ls.get(ACCESS_TOKEN)
  if (token) {
    config.headers['X-Access-Token'] = token
  }

  // 多租户支持
  let tenantid = Vue.ls.get(TENANT_ID) || 0
  config.headers['tenant-id'] = tenantid

  // GET请求添加时间戳防缓存
  if (config.method === 'get') {
    config.params = {
      _t: Date.parse(new Date()) / 1000,
      ...config.params
    }
  }

  return config
})
```

#### 6.2 响应拦截器

```javascript
// 统一响应处理
service.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response) {
      switch (error.response.status) {
        case 403:
          Vue.prototype.$notification.error({
            message: '系统提示',
            description: '拒绝访问'
          })
          break
        case 500:
          if (error.response.data.message.includes("Token失效")) {
            // Token失效处理
            Vue.prototype.$modal.error({
              title: '登录已过期',
              content: '很抱歉，登录已过期，请重新登录',
              onOk: () => {
                store.dispatch('Logout').then(() => {
                  window.location.reload()
                })
              }
            })
          }
          break
      }
    }
    return Promise.reject(error)
  }
)
```

### 7. 性能优化建议

#### 7.1 请求防抖

```javascript
import { debounce } from 'lodash'

export default {
  methods: {
    // 搜索防抖
    handleSearch: debounce(function(keyword) {
      this.queryParam.keyword = keyword
      this.loadData()
    }, 300)
  }
}
```

#### 7.2 请求缓存机制

```javascript
// 避免重复请求
const requestCache = new Map()

async function cachedApiCall(url, params) {
  const key = `${url}_${JSON.stringify(params)}`
  if (requestCache.has(key)) {
    return requestCache.get(key)
  }

  const promise = postApplicationAction(url, params)
  requestCache.set(key, promise)
  return promise
}
```

#### 7.3 错误重试机制

```javascript
async function apiCallWithRetry(apiCall, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await apiCall()
    } catch (error) {
      if (i === maxRetries - 1) throw error
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)))
    }
  }
}
```

## 🚀 前后端协作规范

### 1. 代码生成器使用

#### 1.1 生成步骤

1. **创建数据库表**（遵循数据库设计规范）
2. **使用Jeecg代码生成器**生成基础代码
3. **配置菜单权限**（执行生成的SQL文件）
4. **自定义业务逻辑**（在生成代码基础上扩展）

#### 1.2 生成后的调整

- 根据业务需求调整表格列显示
- 添加自定义查询条件
- 实现特殊业务逻辑
- 完善表单验证规则

### 2. 签名机制

#### 2.1 自动签名

所有POST、GET、PUT请求都会自动添加MD5签名：

```javascript
// 签名自动添加到请求头
let signHeader = {
  "X-Sign": sign,
  "X-TIMESTAMP": timestamp
}
```

#### 2.2 签名算法

```javascript
// 签名生成过程
1. 合并URL参数和请求体参数
2. 参数按key升序排序
3. JSON.stringify(sortedParams) + signatureSecret
4. MD5加密并转大写
```

### 3. 文件操作规范

#### 3.1 文件上传

```javascript
import { uploadAction } from '@/api/manage'

// 文件上传
const formData = new FormData()
formData.append('file', file)

uploadAction('/sys/common/upload', formData)
  .then(res => {
    if (res.success) {
      this.form.avatar = res.result.url
      this.$message.success('上传成功')
    }
  })
```

#### 3.2 文件下载

```javascript
import { downloadFile } from '@/api/manage'

// Excel导出下载
downloadFile('/sys/user/exportXls', this.queryParam, 'user_list.xlsx')
  .then(() => {
    this.$message.success('导出成功')
  })
```

#### 3.3 获取文件访问URL

```javascript
import { getFileAccessHttpUrl } from '@/api/manage'

// 获取文件完整访问路径
const imageUrl = getFileAccessHttpUrl(this.record.avatar)
```

### 4. 字典数据处理

#### 4.1 字典数据获取机制

```javascript
import { ajaxGetDictItems, getDictItemsFromCache } from '@/api/api'

// 字典数据获取（带缓存）
async function initDictOptions(dictCode) {
  if (!dictCode) {
    return '字典Code不能为空!'
  }

  // 优先从缓存中读取
  if (getDictItemsFromCache(dictCode)) {
    let res = {}
    res.result = getDictItemsFromCache(dictCode)
    res.success = true
    return res
  }

  // 缓存中没有，请求API
  let res = await ajaxGetDictItems(dictCode)
  return res
}
```

#### 4.2 字典组件网络请求

```javascript
// 在组件中使用字典
export default {
  data() {
    return {
      dictOptions: []
    }
  },

  created() {
    this.initDictConfig()
  },

  methods: {
    async initDictConfig() {
      // 初始化字典配置
      const res = await initDictOptions('user_status')
      if (res.success) {
        this.dictOptions = res.result
      }
    }
  }
}
```

## 📚 最佳实践总结

### 1. 开发规范建议

#### 1.1 代码审查检查点
- [ ] 确认后端使用的注解类型（@RequestParam vs @RequestBody）
- [ ] 选择对应的前端API方法
- [ ] 验证参数名称的一致性
- [ ] 检查错误处理的完整性
- [ ] 确保权限控制的正确性

#### 1.2 命名规范
```javascript
// API方法导入规范
import {
  getAction,           // GET请求
  postAction,          // POST JSON
  putAction,           // PUT JSON
  deleteAction,        // DELETE参数
  postApplicationAction // POST表单
} from '@/api/manage'
```

#### 1.3 注释规范
```javascript
// 审核任务 - 使用表单参数格式
postApplicationAction('/task/audit', {
  id: recordId,        // 必填：记录ID
  auditResult: true,   // 必填：审核结果
  auditReason: '',     // 可选：拒绝原因
  auditOpinion: ''     // 可选：审核意见
})
```

### 2. 关键要点

#### 2.1 后端开发要点
1. **遵循jeecg-boot标准结构**：使用标准的Entity、Mapper、Service、Controller结构
2. **统一使用Result包装返回结果**：确保前后端数据格式一致
3. **正确使用注解**：@RequestParam vs @RequestBody的选择要准确
4. **完善权限控制**：使用@RequiresPermissions注解控制接口权限

#### 2.2 前端开发要点
1. **明确后端注解类型**：@RequestParam vs @RequestBody
2. **选择正确的API方法**：postApplicationAction vs postAction
3. **保持参数名一致性**：前后端参数名必须完全匹配
4. **完善错误处理**：提供友好的用户提示

#### 2.3 协作开发要点
1. **使用JeecgListMixin简化列表页面开发**
2. **充分利用jeecg-boot的分页、批量操作、导出功能**
3. **正确处理字典数据的缓存和网络请求**
4. **使用正确的Content-Type处理不同类型的请求**
5. **实现完整的Token失效处理机制**
6. **遵循jeecg-boot的图片预览和文件处理规范**

### 3. 最佳实践原则

1. **遵循框架规范**：使用jeecg-boot推荐的方法和结构
2. **保持代码一致性**：同类型操作使用相同的调用方式
3. **注重用户体验**：提供清晰的错误提示和加载状态
4. **持续优化改进**：定期审查和优化API调用代码
5. **完善测试覆盖**：确保功能的稳定性和可靠性

### 4. 性能优化要求

1. **合理使用索引**：数据库查询性能优化
2. **避免N+1查询问题**：使用合适的查询策略
3. **大数据量查询要分页**：避免一次性加载过多数据
4. **合理使用缓存**：提升系统响应速度
5. **实现请求缓存和错误重试机制**：提升用户体验

## 📝 总结

本规范文档整合了jeecg-boot项目后台管理系统的前后端开发最佳实践，涵盖了从数据库设计到前端交互的完整开发流程。遵循这些规范可以确保：

- **代码质量的一致性**：统一的代码结构和命名规范
- **开发效率的提升**：标准化的开发流程和工具使用
- **系统的稳定性**：完善的错误处理和权限控制机制
- **用户体验的优化**：合理的性能优化和交互设计
- **团队协作的顺畅**：清晰的前后端协作规范

希望开发团队严格遵循本规范，持续改进和完善开发实践，为jeecg-boot项目的成功交付提供有力保障。

---

**文档维护记录：**
- 初始版本：基于jeecg-boot项目实践总结 
- v1.0：整合网络请求最佳实践规范
- v1.1：整合jeecg-boot框架API调用最佳实践
- v2.0：整合后端管理系统API规范，形成前后端完整开发规范
- 最后更新：2025年1月18日
- 维护者：AI开发助手
