# JS增强—列表API

[TOC]

> JS增强api围绕着that关键词
> JS增强定义的方法内可使用 `that`关键字，该关键字指向当前页面的vue实例，那就意味着可以用`that`调用任何当前页面的实例方法/属性


## 列表API

|   功能描述 |  语法   |参数|
| --- | --- | --- |
|   获取选中行  |  that.table.selectionRows   |
|   选中行的KEY |  that.table.selectedRowKeys   |
|   获取所有数据  |  that.table.dataSource   |
|   加载数据  |  that.loadData()  |
|  获取查询对象  | that.queryParam或是that.getQueryParams()   |
|  获取当前行  | hello(row){console.log('选择',row)}   |
| 时间格式化 | that.simpleDateFormat(millisecond, format) | millisecond:毫秒数，<br>format:yyyy-MM-dd hh:mm:ss 根据需求自定义格式|
|lodash|that.lodash.methodName|具体使用什么工具方法参考[lodash官方文档](https://lodash.com)|
|ajax请求方法| getAction | 具体见下面的例子 |

//Ajax示例
~~~
getAction('/test/jeecgDemo/getNote',{school:value}).then(res=>{
                let otherValues = {'note':res}
                that.triggleChangeValues(otherValues,id,targrt)
            })
~~~

```
//示例：调用simpleDateFormat格式化时间
created(){
  console.log(that.simpleDateFormat(new Date().getTime(),'yyyy-MM-dd'));
}
```

> 详见 src/views/modules/online/cgform/auto/OnlCgformAutoList.vue 
> 所有属性/方法均在此页面定义
> JS增强嵌入点，代码定位搜索：
> 列表：this.cgButtonJsHandler('created')
> 表单：EnhanceJS[
> src/components/online/autoform/OnlineForm.vue



## 列表事件

事件方法 | 功能描述 | 
---|---|
beforeAdd | 在新增之前调用,后续扩展after方法 | 
beforeEdit | 在编辑之前调用,该方法可以携带一个参数row，表示当前记录，后续扩展after方法 | 
beforeDelete | 在删除之前调用,该方法可以携带一个参数row，表示当前记录,后续扩展after方法 | 
created | 在对应页面vue钩子函数created中调用 | 

~~~
org.jeecg.modules.online.cgform.util.EnhanceJsUtil#enhanceJsButtonCode

"beforeSubmit,beforeAdd,beforeEdit,afterAdd,afterEdit,beforeDelete,afterDelete,mounted,created,show,loaded";
~~~




