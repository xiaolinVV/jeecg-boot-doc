JMarkdwnEditor使用文档
markdown编辑器

### 示例： v-model用法

```
<j-markdown-editor v-model="testFieldName"></j-markdown-editor>
```


### 示例：v-decorator用法 
> 注意：使用v-decorator需要给其赋值id属性，属性值和v-decorator保持一致
```html
<j-markdown-editor v-decorator="['testFieldName',{initialValue:''}]" id="testFieldName"></j-markdown-editor>
```

备注:
使用前需要在script内引入
```vue
<script>
  import JMarkdownEditor from '@/components/jeecg/JMarkdownEditor/index'
  export default {
    name: "demo",
    components: {
      JMarkdownEditor 
    }
    //...
  }
</script>
```
