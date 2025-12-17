vue路由带参总结
===

#### 1. params  
```<router-link :to="{name:'test', params: {id:1}}">  ```  
配置路由格式要求: path: "/test/:id"  
js参数获取：this.$route.params.id

------
#### 2.query
```<router-link :to="{name:'test', query: {id:1}}"> ```  
配置路由:无要求  
js参数获取：this.$route.query.id

------

#### 备注：  
router-link是html写法，JS中语法如下：  
```this.$router.push({name:'test',query: {id:'1'}})```  
```this.$router.push({name:'test',params: {id:'1'}}) ```





 


