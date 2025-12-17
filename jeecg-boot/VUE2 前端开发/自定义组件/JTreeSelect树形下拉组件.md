
# JTreeSelect 树形下拉组件
异步加载的树形下拉组件

## 参数配置
| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| placeholder      |string   | | placeholder |
| dict      |string   | ✔| 表名,显示字段名,存储字段名拼接的字符串 |
| pidField      |string   | ✔| 父ID的字段名 |
| pidValue      |string   | | 根节点父ID的值 默认'0' 不可以设置为空,如果想使用此组件，而数据库根节点父ID为空，请修改之 |

使用示例
----
```vue
<template>
  <a-form>
    <a-form-item label="树形下拉测试" style="width: 300px">
      <j-tree-select
        v-model="departId"
        placeholder="请选择部门"
        dict="sys_depart,depart_name,id"
        pidField="parent_id">
      </j-tree-select>
      {{ departId }}
    </a-form-item>
  </a-form >
</template>

<script>
  import JTreeSelect from '@/components/jeecg/JTreeSelect'
  export default {
    components: {JTreeSelect},
    data() {
      return {
        departId:""
      }
    }
  }
</script>
```