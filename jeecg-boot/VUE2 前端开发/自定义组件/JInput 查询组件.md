JInput 特殊查询组件（模糊查询）
===

主要特殊查询组件，支持模糊查询、大于等于查询、小于等于查询、不匹配查询。

1.参数配置

| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| placeholder      |string   | | placeholder |
| trim |boolean   | | 是否自动去空格 默认false|
| type    |string   | | 查询类型['like','ne','ge','le'] 分别是模糊，不等于，大于，小于，默认like,如果不想添加任何规则，请设置type="",即能走等于查询（默认like）|

2.使用示例
改造用户管理，账号支持模糊查询
2.1 组件导入
~~~
//省略其他代码
import JInput from '@/components/jeecg/JInput'

export default {
  name: "UserList",
  mixins: [JeecgListMixin],
  components: {
    SysUserAgentModal,
    UserModal,
    PasswordModal,
    JInput
  },
//省略其他代码
~~~
2.2 替换输入框
~~~
<a-col :md="6" :sm="12">
  <a-form-item label="账号">
    <!--<a-input placeholder="请输入账号查询" v-model="queryParam.username"></a-input>-->
    <j-input placeholder="请输入账号模糊查询" v-model="queryParam.username"></j-input>
  </a-form-item>
</a-col>
~~~
2.3  测试
![](images/88dab59d13750837da0dd32ef6c6aba0_1624x463.png)


