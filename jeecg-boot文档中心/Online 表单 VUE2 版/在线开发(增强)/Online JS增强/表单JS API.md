# JS增强—表单API

[TOC]

> JS增强api围绕着that关键词
> JS增强定义的方法内可使用 `that`关键字，该关键字指向当前页面的vue实例，那就意味着可以用`that`调用任何当前页面的实例方法/属性

## 表单API

| 功能描述 | 语法 | 参数 |
| --- | --- | --- |
| 获取某下拉组件的下拉选项 | that.getSelectOptions(field) | field：字段名称 |
| 设置某下拉组件的下拉选项 | that.changeOptions(field,options) | field：字段名称<br>option：新设置的下拉选项 每一项由value和label组成 |
| 改变表单的值 | that.triggleChangeValues(param) | param：表单值对象，格式{控件名:控件值} |
| 进入表单页面立即触发change事件，需要在js增强中定义show方法, 给immediateEnhance赋值true | that.immediateEnhance = true | 当为true则，进入表单页若有change事件立即触发，否则不会，默认false |
| 获取当前表单数据 | 见下 |  |
| 获取某个字段的值 | 见下 |  |
| 修改某个字段的值 | 见下 |  |
| 发起ajax请求 | getAction,postAction,deleteAction | 方法参数参考src/api/manage.js |
| 时间格式化 | that.simpleDateFormat(millisecond, format) | millisecond:毫秒数，<br>format:yyyy-MM-dd hh:mm:ss 根据需求自定义格式 |
| lodash | that.lodash.methodName | 具体使用什么工具方法参考[lodash官方文档](https://lodash.com) |
| 自定义按钮函数内需要关闭表单弹窗 | that.$emit("onSuccess",formdata) | formdata:表单数据，可以不传 |

## 表单事件

| 事件方法 | 描述 |
| --- | --- |
| ~~show~~ | 页面表单初始化时触发（不支持获取数据） |
| loaded | 表单数据加载完成后触发 （支持获取表单数据） |
| beforeSubmit | 表单数据提交之前 [详细文档](http://doc.jeecg.com/2061290) |

## API代码

### 初始化表单方法

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

### 修改字段值

> 字段采用online表单配置的字段英文名

```
that.triggleChangeValue("字段",“值”)
```

### 获取全部表单数据

```
let formData = that.form.getFieldsValue()
```

### 获取表单字段值

```
let sex = that.form.getFieldValue("sex")
```

### 字段值变更触发方法

> ruz\_date 是字段名字，所有的字段触发方法都统一写在方法onlChange里。
> onlChange()方法必须与前一段代码有`回车`或者`空格`，否则会报错。

```
onlChange(){
   return {
     
     ruz_date(){
        let value = event.value
        //alert('触发控件',value)
        
//根据入职日期，自动计算出入职年数
        if(value!=null && value!=""){
          let currDate = new Date(value.replace(/-/g, "\/")); 
          let d = new Date(); 
          let ru_year_num = d.getFullYear()-currDate.getFullYear()    
          let values = {'ru_year_num':ru_year_num + 1}
          that.triggleChangeValues(values)
        }
      }
     
    }
 }
```

### 修改表单字段下拉属性

```
that.changeOptions(field,options)
```

> 疑问：此方法能否涉及到 radio、select、搜索下拉等功能。

### 修改表下拉属性

## 示例

### 通过页面多个字段计算出某个字段的值

参考示例：

* [单表或主表](http://doc.jeecg.com/2044110)
* [从表改主表](http://doc.jeecg.com/2186818)

### 三级联动示例（ajax）

参考示例：[点击查看](http://doc.jeecg.com/2044120)

### 动态的控制字段组件的显示与隐藏

参考示例：[点击查看](http://doc.jeecg.com/2044107)

### 动态的控制字段组件是否禁用\[不支持\]

```
//示例：调用simpleDateFormat格式化时间
show(){
    console.log(that.simpleDateFormat(new Date().getTime(),'yyyy年MM月dd日 hh时mm分ss秒'));
}
```