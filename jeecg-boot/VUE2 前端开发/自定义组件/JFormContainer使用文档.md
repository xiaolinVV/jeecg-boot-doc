# JFormContainer 使用文档
  
###### 说明: 暂用于表单禁用

使用示例
----
```vue
<!-- 在form下直接写这个组件，设置disabled为true就能将此form中的控件禁用 -->
  <a-form layout="inline" :form="form" >
    <j-form-container disabled>
      <!-- 表单内容省略..... -->
    </j-form-container>
  </a-form>
```