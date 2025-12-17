
# JImportModal 使用文档
  
###### 说明: 用于列表页面导入excel功能

使用示例
----
```vue

<template>
  <!--  此处省略部分代码...... -->
  <a-button @click="handleImportXls" type="primary" icon="upload">导入</a-button>
  <!--  此处省略部分代码...... -->
  <j-import-modal ref="importModal" :url="getImportUrl()" @ok="importOk"></j-import-modal>
  <!--  此处省略部分代码...... -->
</template>

<script>
  import JCodeEditor from '@/components/jeecg/JCodeEditor'
  export default {
    components: {JCodeEditor},
    data() {
      return {
        //省略代码......
      }
    },
    methods:{
      //省略部分代码......
      handleImportXls(){
        this.$refs.importModal.show()
      },
      getImportUrl(){
         return '你自己处理上传业务的后台地址'
      },
      importOk(){
        this.loadData(1)
      }
    }
  }
</script>
```