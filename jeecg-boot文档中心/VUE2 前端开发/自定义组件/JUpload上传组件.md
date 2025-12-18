# JUpload 帮助文档

## 效果展示

![](images/d2b3e3c41b4dc0abcbf2634788dc51c1_102x53.png)
![](images/1dd205d51f6e95fb15954227231bf8ee_358x98.png)

## 引用方式

``` js
import JUpload from '@/components/jeecg/JUpload'
```

``` html
<j-upload v-model="fileList" text="上传"></j-upload>
```

## 参数文档
| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| text      |String| | 按钮显示文字，默认为“点击上传”|
| fileType      |String  | |  定义文件类型，可选值：all、image。默认为all，如果传image，则只能上传图片 |
| bizPath |String | | 用于控制文件上传的业务路径 默认为temp |
| value(v-model)    |String/Array | | 文件路径，String类型多个文件请用半角逗号隔开|
| disabled |Boolean| | 是否禁用，默认false |
| number|int| | 上传文件数量，默认不限制 |
| returnUrl |Boolean| | 是否返回文件url，true:仅返回文件url，多个url则逗号隔开，false:返回json类型{fileName:"1.doc",filePath:"/temp/1.doc",fileSize:200}   默认true |
| multiple |Boolean| | 是否可以多选，默认true `v_3.4.5` |
## 示例
~~~
<template>
  <a-modal
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    <j-upload v-model="fileList" text="上传"></j-upload>
  </a-modal>
</template>

<script>
  import JUpload from  '@/components/jeecg/JUpload'
  export default {
    components: { JUpload },
    data () {
      return {
        ...
        fileList:[],
        ...
      }
    },
    methods: {
      handleOk () {   
        ...
        formData.file = this.fileList;
        ...
      },
    }
  }
</script>
~~~