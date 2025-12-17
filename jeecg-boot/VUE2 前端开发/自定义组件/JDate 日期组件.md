
# JDate 日期组件 使用文档
  
###### 说明: antd-vue日期组件需要用moment中转一下，用起来不是很方便，特二次封装，使用时只需要传字符串即可
## 参数配置
| 参数           | 类型      | 必填 |说明|
|--------------|---------|----|---------|
| placeholder      |string   | | placeholder      |
| readOnly   | boolean   | | true/false 默认false                 |
| value      | string | | 绑定v-model或是v-decorator后不需要设置    |
| showTime | boolean | | 是否展示时间true/false 默认false  |
| dateFormat    | string | |日期格式 默认'YYYY-MM-DD' 若showTime设置为true则需要将其设置成对应的时间格式(如:YYYY-MM-DD HH:mm:ss)               |
## 事件
| 事件名           | 说明      | 回调参数|
|--------------|---------|----------|
| change |日期值改变回调   | 日期的值 |

使用示例
----
1.组件带有v-model的使用方法
```vue
    <j-date v-model="dateStr"></j-date>
```

2.组件带有v-decorator的使用方法  

  ```vue
    <j-date v-decorator="['dateStr',{}]"></j-date>
  ```

3.其他使用
添加style
```vue
<j-date v-model="dateStr" style="width:100%"></j-date>
```
添加placeholder
```vue
<j-date v-model="dateStr" placeholder="请输入dateStr"></j-date>
```
添加readOnly
```vue
<j-date v-model="dateStr" :read-only="true"></j-date>
```

备注:
script内需引入jdate
```vue
<script>
  import JDate from '@/components/jeecg/JDate'
  export default {
    name: "demo",
    components: {
      JDate
    }
    //...
  }
</script>
```