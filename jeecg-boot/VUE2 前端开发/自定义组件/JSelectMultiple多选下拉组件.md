
# JSelectMultiple 多选下拉组件
online用 实际开发请使用components/dict/JMultiSelectTag

# JSlider 滑块验证码

使用示例
----
```vue
<template>
  <div style="width: 300px">
    <j-slider @onSuccess="sliderSuccess"></j-slider>
  </div>
</template>

<script>
  import JSlider from '@/components/jeecg/JSlider'
  export default {
    components: {JSlider},
    data() {
      return {
        form: this.$form.createForm(this),
        editorValue:'',
      }
    },
    methods:{
      sliderSuccess(){
        console.log("验证完成")
      }
    }
  }
</script>
```
