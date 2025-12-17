# JImageUpload 帮助文档

## 效果展示

![](images/5f45fe53b8a1589e32a932d81614369c_378x143.png)
支持上传一张图片或多张图片
![](images/ab88b40f3ad4d0df4cfac8d8f19b4098_335x165.png)
![](images/d4853440d374e86adb5e098396dc722f_519x147.png)
## 引用方式

``` js
import JImageUpload from '@/components/jeecg/JImageUpload'
```

``` html
<j-image-upload text="上传" v-model="fileList" ></j-image-upload>
```

## 参数文档
| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| text      |String| | 按钮显示文字，默认为“上传”|
| disabled      |Boolean   | | 是否禁用 |
| bizPath |String | | 图片上传业务 默认为temp |
| value(v-model)    |String/Array | | 文件路径，String类型多个文件请用半角逗号隔开|
| isMultiple |Boolean| | 是否可上传多张图片，默认为false,仅支持一张 |
## 示例
~~~
<template>
  <a-modal
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    <j-image-upload text="头像" v-model="fileList" ></j-image-upload>
  </a-modal>
</template>

<script>
  import JImageUpload from '@/components/jeecg/JImageUpload'
  export default {
    components: { JImageUpload },
    data () {
      return {
        ...
        fileList:[],
      }
    },
    methods: {
      handleOk () {
        ....
        formData.img = this.fileList;
        ....
      }
    } 
</script>
~~~