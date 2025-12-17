Popup控件
===

Popup控件
_popup选择框的使用依赖于Online报表_
（1）创建一个Online报表来提供弹出数据列表的数据集
![](images/cf06e3aafc5bec0ca26a82f1af89c3de_1898x532.png)
（2）选择控件类型为popup弹出框
![](images/9c63162bfb3be095cf488e649eb9326f_1735x429.png)
（3）字典Table、字典Code、字典Text项填写对应的Online报表信息
```
字典Table : 填写Online报表编码
字典Code:  填写Online报表中的字段名（多个逗号隔开）
字典Text:   填写表单中字段名 （多个逗号隔开）
如下设置：
把报表user_msg查出的字段 realname,username 选择后分别写入表单中popupok和popback
```
![](images/08ac5e15d3c448e8dd9d14ad63878d01_1643x423.png)
（4）展示效果
![](images/9059dfa8d0f57b6c2b947010c4c34a9d_1726x210.png)
点击输入框弹出报表列表
![](images/2283e723c746fc4bcd2e0c381d3f7810_1141x827.png)
选择后数据带入表单
![](images/f076e5d10c5dbc1a878f0afdcaed58f7_1660x183.png)



