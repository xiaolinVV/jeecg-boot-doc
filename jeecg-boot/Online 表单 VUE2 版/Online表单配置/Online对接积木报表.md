# Online对接积木报表
[TOC]

## 配置积木报表

1、打开积木报表的设计页面，在数据集管理里添加一个API数据集
![](images/04b3d8312be6b5a11f39e7bf8616cddb_220x197.png)

2、Online表单数据的 API地址固定为以下的格式
```
 {{ domainURL }}/online/cgform/api/data/{tableName}/queryById?id=${id}&token=${token}&mock=true
```

参数替换说明：

- [1]. 其中 {tableName} 需要替换成Online的表名，
- [2]. 域名前缀变量`{{ domainURL }}`，固定不要改。如果需要对接外网可以替换真实地址，比如 [http://localhost:8080/jeecg-boot](http://localhost:8080/jeecg-boot)
- [3]. `?id=${id}&token=${token}&mock=true`这一段固定参数，不要改。

![](images/a1b8cac798bf1b91818c30c61e34dcfd_1442x647.png)

3、点击API解按钮，生成Online表单里的字段

>[info]  提醒：这里需要先填写参数ID和Token的默认值，再点击API解析，才能成功生成字段

![](images/268063d64eac251a49eb8d22f761e935_1599x604.png)

如何获取id和token的值？
* id是某条数据的id。获取方式见下图（可以直接查询表数据）
![](images/e456534193b2bf9535fe693c6df782d8_145x190.png)
![](images/663027e07826644ae3f66a2d72e45b8f_731x200.png)

* token是项目的token，实际使用时会替换成有效的token，这里API解析成功后就没多大用了。



4、点击确定按钮保存，可以直接将字段拖拽到要显示的位置上
![](images/a32447aad6ee7ffe709f0127d711f6a3_1088x466.png)

## 配置Online表单
1、点击积木报表上的预览按钮，把打开的链接复制一下（不需要复制 ? 后面的参数）
![](images/dd01c22a1736e03d0e228dc78e3aa840_730x50.png)

2、在Online报表配置页面，点击扩展配置，点击启用打印，并且把刚刚复制的链接粘贴上保存即可。  
如果是当前项目前缀可以改成变量`{{ window._CONFIG['domianURL'] }}`

![](images/80edf69b94b311d9fa9d342e5ba72c35_1173x446.png)
![](images/ec15fe3573b2bffc1df98b0b827802d6_1009x355.png)

3、在功能测试页面可以点击打印
![](images/bbad0caaa063e1008cccd77e0b88b7b4_417x317.png)
也可以在编辑或者详情页面点击图标打印
![](images/0a3d38e517d469c1fb254909d3592f18_845x452.png)
