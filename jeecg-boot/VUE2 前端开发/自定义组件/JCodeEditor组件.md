
# JCodeEditor 使用文档
  
###### 说明: 一个简易版的代码编辑器，支持语法高亮
## 参数配置
| 参数           | 类型   | 必填 |说明|
|--------------|---------|----|---------|
| language      |string   | | 表示当前编写代码的类型 javascript/html/css/sql |
| placeholder      |string   | | placeholder |
| lineNumbers      |Boolean   | | 是否显示行号 |
| fullScreen      |Boolean   | | 是否显示全屏按钮 |
| zIndex      |string   | | 全屏以后的z-index |

使用示例
----
```vue
<template>
  <div>
    <j-code-editor
      language="javascript"
      v-model="editorValue"
      :fullScreen="true"
      style="min-height: 100px"/>
    {{ editorValue }}
  </div>
</template>

<script>
  import JCodeEditor from '@/components/jeecg/JCodeEditor'
  export default {
    components: {JCodeEditor},
    data() {
      return {
        form: this.$form.createForm(this),
        editorValue:'',
      }
    }
  }
</script>
```