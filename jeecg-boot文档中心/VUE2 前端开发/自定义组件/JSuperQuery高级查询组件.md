# JSuperQuery 高级查询 使用文档

[TOC]

## 参数配置
| 参数           | 类型      | 必填 | 说明                   |
|--------------|---------|----|----------------------|
| fieldList      | array   |✔| 需要查询的列集合示例如下，type类型有:date/datetime/string/int/number      |
| callback   | array   |  | 回调函数名称(非必须)默认handleSuperQuery                |

fieldList结构示例：
```vue
  const superQueryFieldList=[{
    type:"date",
    value:"birthday",
    text:"生日"
  },{
    type:"string",
    value:"name",
    text:"用户名"
  },{
    type:"int",
    value:"age",
    dbType: "int",
    text:"年龄"
  }]
```
页面代码概述:  
----
1.import之后再components之内声明
```vue
import JSuperQuery from '@/components/jeecg/JSuperQuery.vue';
  export default {
    name: "JeecgDemoList",
    components: {
      JSuperQuery
    },

```
2.页面引用
```vue
  <!-- 高级查询区域 -->
  <j-super-query :fieldList="fieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>
```
3.list页面data中需要定义三个属性：
```vue
  fieldList:superQueryFieldList,
  superQueryFlag:false,
  superQueryParams:""
```
4.list页面声明回调事件handleSuperQuery(与组件的callback对应即可)
```vue
//高级查询方法
handleSuperQuery(arg) {
  if(!arg){
    this.superQueryParams=''
    this.superQueryFlag = false
  }else{
    this.superQueryFlag = true
    this.superQueryParams=JSON.stringify(arg)
  }
  this.loadData()
},
```
5.改造list页面方法
```vue
  // 获取查询条件
  getQueryParams() {
    let sqp = {}
    if(this.superQueryParams){
      sqp['superQueryParams']=encodeURI(this.superQueryParams)
    }
    var param = Object.assign(sqp, this.queryParam, this.isorter);
    param.field = this.getQueryField();
    param.pageNo = this.ipagination.current;
    param.pageSize = this.ipagination.pageSize;
    return filterObj(param);
  },
```

## 附录：
### 下拉字典配置——自定义
```
{ type: 'select', value: 'isDbSynch', text: '同步状态', options: [
    {label: "已同步",value: "Y"},
    {label: "未同步",value: "N"}
  ]},

```

### 下拉字典配置——通过字典表
```
{ type: 'select', value: 'formCategory', text: '表单分类', dictCode: 'ol_form_biz_type' },

```

### dbType 支持的类型
不区分大小写
> int、bigDecimal、short、long、float、double、boolean