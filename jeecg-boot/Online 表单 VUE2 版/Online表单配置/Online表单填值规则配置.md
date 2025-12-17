# Online表单填值规则配置

## 如何使用
> Online填值规则配置，需要通过${}包含着填值规则编码，例如：${order_num_rule}
> 下面有的截图是老图，请以${}用法为准。

在 `页面属性` 中，倒数第二列就是`填值规则`的输入框。
![](images/62bf7e42781b338f0f44cc04253d5f2e_1232x497.png)
输入框里填写的是填值规则的`规则Code`
如果你不希望生成的数据被修改，可以勾选`是否只读`
![](images/e9e41a6f1b95c6b55d054dcb81cd6c09_48x176.png)

## 如何定义填值规则

在 系统管理-->填值规则 菜单中进行添加，详细添加方法请参考 [填值规则（编码生成）](http://doc.jeecg.com/2044051) 文档

## 如何在某个值变化的时候更新填值规则

要做到这一点，就需要通过 JS增强 来实现了，可参考[ online基础篇-JS增强(表单渲染) ](http://doc.jeecg.com/2044102)

![](images/0f82a9d5ea046c2fd530792194814a2e_1164x393.png)

如上图，我的`order_rule`字段设置了填值规则，我想实现当`name`字段变化时重新生成填值规则，JS增强该如何编写呢？

### 第一步
在Online表单开发页面，选中你要修改JS增强的那一条数据，并点击上方的JS增强按钮
![](images/9514139a0998df4dbe61b54a953c98fd_922x449.png)

### 第二步
#### 主表JS增强写法
![](images/51e53f8461dee2c46a90357fff7908d3_788x311.png)

``` js
 onlChange(){
   return {
    name() {
      that.executeMainFillRule()
    }
  }
 }
```
#### 子表JS增强写法

> **注意：子表的JS增强也写在主表里！**

![](images/65fa044fa9283b483a67a3764d36881d_788x573.png)

```
test_fill_rule_sub_onlChange(){
  return {
    name(that, event) {
      // 重新触发子表的填值规则（仅当前更改的行）
      that.executeSubFillRule('test_fill_rule_sub', event)
    }
  }
}
```