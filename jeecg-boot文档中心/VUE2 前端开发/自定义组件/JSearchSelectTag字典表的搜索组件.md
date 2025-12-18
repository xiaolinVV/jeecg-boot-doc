JSearchSelectTag 字典表的搜索组件
===

下拉搜索组件,支持异步加载,异步加载用于大数据量的字典表

 1.参数配置 

| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| placeholder      |string   | | placeholder |
| disabled      |Boolean   | | 是否禁用 |
| dict      |string   | | 表名,显示字段名,存储字段名拼接而成的字符串,如果提供了dictOptions参数 则此参数可不填|
| dictOptions      |Array   | | 多选项,如果dict参数未提供,可以设置此参数加载多选项 |
| async      |Boolean   | | 是否支持异步加载,设置成true,则通过输入的内容加载远程数据,否则在本地过滤数据,默认false|
| popContainer|string| | 父节点对应的CSS 选择器,内部使用`document.querySelector`选择父节点，如设置`.pnode`,则找到有class为pnode的节点然后渲染下拉框 |
| pageSize|number| | 当async设置为true时有效，表示异步查询时，每次获取数据的数量，默认10|



 2.使用示例

![](images/dc8150e71588bf3f77da7c6046eb2f25_385x330.png)
----
```vue
<template>
  <a-form>
    <a-form-item label="下拉搜索" style="width: 300px">
      <j-search-select-tag
        placeholder="请做出你的选择"
        v-model="selectValue"
        :dictOptions="dictOptions">
      </j-search-select-tag>
      {{ selectValue }}
    </a-form-item>

    <a-form-item label="异步加载" style="width: 300px">
      <j-search-select-tag
        placeholder="请做出你的选择"
        v-model="asyncSelectValue"
        dict="sys_depart,depart_name,id"
        :async="true">
      </j-search-select-tag>
      {{ asyncSelectValue }}
    </a-form-item>
  </a-form >
</template>

<script>
  import JSearchSelectTag from '@/components/dict/JSearchSelectTag'
  export default {
    components: {JSearchSelectTag},
    data() {
      return {
        selectValue:"",
        asyncSelectValue:"",
        dictOptions:[{
          text:"选项一",
          value:"1"
        },{
          text:"选项二",
          value:"2"
        },{
          text:"选项三",
          value:"3"
        }]
      }
    }
  }
</script>
```

