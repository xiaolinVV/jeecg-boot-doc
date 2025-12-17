
# JAsyncTreeList异步树列表组件使用说明

## 引入组件

```js
import JTreeTable from '@/components/jeecg/JTreeTable'
export default {
  components: { JTreeTable }
}
```

## 所需参数

| 参数        | 类型   | 必填   | 说明                                                         |
|-------------|--------|--------|--------------------------------------------------------------|
| rowKey      | String | 非必填 | 表格行 key 的取值，默认为"id"                                |
| columns     | Array  | 必填   | 表格列的配置描述，具体见Antd官方文档                         |
| url         | String | 必填   | 数据查询url                                                  |
| childrenUrl | String | 非必填 | 查询子级时的url，若不填则使用url参数查询子级                 |
| queryKey    | String | 非必填 | 根据某个字段查询，如果传递 id 就根据 id 查询，默认为parentId |
| queryParams | Object | 非必填 | 查询参数，当查询参数改变的时候会自动重新查询，默认为{}       |
| topValue    | String | 非必填 | 查询顶级时的值，如果顶级为0，则传0，默认为null               |
| tableProps  | Object | 非必填 | 自定义给内部table绑定的props                                 |

## 代码示例

```html
<template>
  <a-card :bordered="false">
    <j-tree-table :url="url" :columns="columns" :tableProps="tableProps"/>
  </a-card>
</template>

<script>
  import JTreeTable from '@/components/jeecg/JTreeTable'

  export default {
    name: 'AsyncTreeTable',
    components: { JTreeTable },
    data() {
      return {
        url: '/api/asynTreeList',
        columns: [
          { title: '菜单名称', dataIndex: 'name' },
          { title: '组件', dataIndex: 'component' },
          { title: '排序', dataIndex: 'orderNum' }
        ],
        selectedRowKeys: []
      }
    },
     computed: {
       tableProps() {
         let _this = this
         return {
           // 列表项是否可选择
           // 配置项见：https://vue.ant.design/components/table-cn/#rowSelection
           rowSelection: {
             selectedRowKeys: _this.selectedRowKeys,
             onChange: (selectedRowKeys) => _this.selectedRowKeys = selectedRowKeys
           }
         }
       }
     }
  }
</script>
```

