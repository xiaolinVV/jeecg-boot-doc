JTreeSelect树形下拉框 (异步加载)
===

1.参数配置

| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| placeholder      |string   | | placeholder |
| disabled      |Boolean   | | 是否禁用 |
| dict          |string   | | 表名,显示字段,存储字段 拼接的字符串 |
| pidField      |string   | | 指定父级节点的字段 默认pid|
| pidValue      |string   | | 指定父级节点的id值 不指定则默认为 0 不可以为空，若为空请自行修改数据库 |
| condition     |string(json字符串)   | | 支持自定义查询条件，进行过滤数据，请按此标准示例赋值：condition='{"create_by":"admin"}' |
| hasChildField | string   | | 指定是否含有子节点的字段（默认不传），控制是否显示展开箭头（1=有，0=没有） |


2.使用示例
![](images/cb18a94f7dc0fd4d1a6269a530b52dfc_819x433.png)
```
<template>
  <a-form :form="form">
    <a-form-item>
      <j-tree-select
        style="width: 300px"
        v-model="treeValue"
        dict="sys_depart,depart_name,id"
        pid-field="parent_id">
      </j-tree-select>
      {{ treeValue }}
    </a-form-item>

    <a-form-item>
      <j-tree-select
        style="width: 300px"
        v-decorator="['demoTree']"
        dict="sys_depart,depart_name,id"
        pid-field="parent_id">
      </j-tree-select>
      {{ getTreeFieldValue() }}
    </a-form-item>
  </a-form>
</template>

<script>
  import JTreeSelect from '@/components/jeecg/JTreeSelect'
  export default {
    components: { JTreeSelect },
    data() {
      return {
        form: this.$form.createForm(this),
        treeValue:'',
      }
    },
    methods:{
      getTreeFieldValue(){
        return this.form.getFieldValue("demoTree")
      }
    }
  }
</script>
```


