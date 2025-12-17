
# JCheckbox 使用文档
  
###### 说明: antd-vue checkbox组件处理的是数组，用起来不是很方便，特二次封装，使用时只需处理字符串即可
## 参数配置
| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| options      |array   |✔| checkbox需要配置的项，是个数组，数组中每个对象包含两个属性:label(用于显示)和value(用于存储) |

使用示例
----
```vue
<template>
  <a-form :form="form">
    <a-form-item label="v-model式用法">
      <j-checkbox v-model="sport" :options="sportOptions"></j-checkbox><span>{{ sport }}</span>
    </a-form-item>

    <a-form-item label="v-decorator式用法">
      <j-checkbox v-decorator="['sport']" :options="sportOptions"></j-checkbox><span>{{ getFormFieldValue('sport') }}</span>
    </a-form-item>
  </a-form>
</template>

<script>
  import JCheckbox from '@/components/jeecg/JCheckbox'
  export default {
    components: {JCheckbox},
    data() {
      return {
        form: this.$form.createForm(this),
        sport:'',
        sportOptions:[
          {
            label:"足球",
            value:"1"
          },{
            label:"篮球",
            value:"2"
          },{
            label:"乒乓球",
            value:"3"
          }]
      }
    },
    methods: {
     getFormFieldValue(field){
       return this.form.getFieldValue(field)
     }
    }
  }
</script>
```