#  unipush推送功能

[TOC]



### 一、配置推送
打开项目的manifest.json文件
![](images/56356b9e1330b4e8c88cb2cc3e5fceed_326x611.png)
在App SDK配置模块勾选unipush推送
![](images/9a0e68edd6495e59b27a336286ea7c87_1466x776.png)
在APP模块权限配置中勾选push推送
![](images/b47bf5c701c309a924e831726f836188_1139x540.png)
进入配置页面
![](images/3e18373838a4f315ef09919d654e6ee8_714x121.png)

在配置时请先确认实名认证
![](images/0a6b6d7ef26e96d794d660521fe1c373_640x216.png)
### 二、配置信息
#### 1、获取android签名
（1）https://ask.dcloud.net.cn/article/35777
（2）win10签名需要写入文件，需要管理员权限
![](images/ba5d2ee545629ecbff17a83bb5f63760_450x242.png)

![](images/fc255c9451efb8268652793019b72132_897x219.png)

生成一个名字为test的签名
![](images/4a7176899e97439e60264437922664c1_1010x522.png)

出现这种情况直接复制系统给的命令执行即可  
注意这里需要管理员权限
![](images/7f3e0ed7a5989869af0a78ddae868aef_955x203.png)
完成后会生成两个个keystore文件，其中old后缀是一个备份文件
![](images/3ecfaf44d8ebf6287a2f9dbe1c66f76a_791x58.png)
可以使用以下命令查看：
keytool -list -v -keystore test.keystore  
Enter keystore password: //输入密码，回车
会输出以下格式信息：
![](images/37b1225cb91b6aee00fb9f4a1efd4503_1005x492.png)
其中**SHA1**和**SHA256**是所需要的
#### 2、配置推送信息
1.其中包名需要记住,找到需要配置的应用，将之前生成的SHA1配置到应用签名上

![](images/b6a0a14618e266d2b9cefda02da75d75_1505x594.png)

### 三、打包执行
![](images/359ff438a8a88e0179b62cae5bea5b83_827x329.png)

包名和别名在前面需要一致
![](images/3be4056e4716468779f1c41e558a1e22_841x651.png)

等待打包完成

![](images/113e14f9c14b1e258ba4ca42ba363ae7_847x788.png)
完成后更改打包基座
![](images/f335cceb4c963e751244ab565194d525_961x394.png)
运行到设备
![](images/0002c93cb7c3f3e393e17cd904cb6966_852x459.png)

### 三、测试推送
在官网中发送一个推送
![](images/9284b372709822f8e68aa492d2b2ed97_953x488.png)
注意需要打开通知权限
![](images/d07e5fe3a69049a085caa10e8f62bf7a_335x688.png)

![](images/5ca1fa5e5b35988da2e28bfcc73c01b3_318x666.png)


### 四、配置离线厂商推送
#### 1、注册手机厂商账号（华为）
华为开发者平台账号注册：(建议直接使用华为账号，否则可能无法使用推送)
1.直接到[https://developer.huawei.com/](https://developer.huawei.com/)华为开发者联盟去注册账号，跟着提示一步步走即可

2.账号注册完后到管理中心----》我的应用 ----》新建    去新建项目。
![](images/25faf663100999778fd7cacb377e4b22_1879x657.png)

3.新建完成后，点击开发进入如下页面
![](images/7084c4443ae643e039c10a0047932d2c_1668x669.png)
 4.填写包名，**这个包名很重要，需要和unipush的包名保持一致**。

5.项目创建完成后需要生成指纹证书文件，将之前生成的SHA256填入如图标记部分
![](images/ba8aa2a52084c7553a7e086d383c918f_990x700.png)

自此华为所需信息都已经获取完成。
6.项目信息完成后，开通推送服务
![](images/f3b044de7375953fc1077e8ca7492971_993x756.png)
点击“立即开通”
![](images/1401a8838fc745d72685a9b05355ae06_960x526.png)
web推送代理打开
![](images/247f1455e32c7ccebee32b2ac2fff559_984x501.png)
#### 2、注册手机厂商账号（小米）
1.到小米开发这平台注册账号：需要小米账号,非小米账号就会没有权限
![](images/3d44f6a311ddc6366e77bba8b41faa1c_963x206.png)
2.账号注册完成，就可去到推送运营平台。点击创建应用，创建自己的推送项目，注意报名要与unipush保持一致。
![](images/dfe13cf0452c41d1ea16d091d1ea33ad_1866x492.png)
3.点击应用信息就可以拿到，推送需要的应用信息
![](images/6e7909307fa237cd39f32c728361603a_967x494.png)
#### 3、 unipush接入厂商：
1.找到之前配置的unipush
![](images/0d63752e76721c33e027ad9312247de4_1477x498.png)
2.配置厂商通道：点击厂商推送设置将各个厂商的应用信息填入对应项中，保存。



