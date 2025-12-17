Online基础篇-JS增强(表单渲染)
===

1.功能简述
通过定义form的增强JS，实现表单动态效果。例如：设置默认值

2.API
|  方法   |   描述  |
| --- | --- |
|  ~~show~~  |   页面加载时执行, 2.1之后推荐使用`loaded`  |


演示
需求：给表单字段设置默认值
实现： 通过表单的JS增强，定义show方法
代码：
```
show(){
   console.log('form',that)
   //this.form.setFieldsValue({"name":"name值"})  
  that.$nextTick(() => {
           //age是对应表的字段名
            that.form.setFieldsValue({"age":"age值"})
          });
}
```

注意： 如何需要兼容IE浏览器，不要用 **箭头函数** 改为
```
show(){
   console.log('form',that)
   //this.form.setFieldsValue({"name":"name值"})  
  that.$nextTick(function(){
           //age是对应表的字段名
            that.form.setFieldsValue({"age":"age值"})
          });
}
```

![](images/95b189625b7fa32ce53789341ac5179b_1671x842.png)
效果： 点击功能测试，点击添加，发现年龄设置默认值成功
![](images/65ff17fce5ebc84dc709552d17de1701_1633x759.png)