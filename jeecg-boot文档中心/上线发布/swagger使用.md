*前言 :使用swagger需要模拟登录获取token，这是测试接口的前提。*


**1.启动system项目,访问路径**：[http://localhost:8080/jeecg-boot](http://localhost:8080/jeecg-boot)

**2.获取验证码，按图操作，输入参数key的值，此处输入123，点击发送，获取验证码图片**
![](images/ca316cee5b0524802babae49f4ea5264_1889x719.png)
![](images/fd5bfe91c3911e858399dbb731397697_771x193.png)

**3.登录,获取token**
![](images/4f6a7ce89c168ebb4af7d054f6b3d5f3_1903x774.png)

登录参数说明
|  参数   |  说明   |
| --- | --- |
|   captcha  |   验证码  |
|   checkKey  |   获取验证码是输入的key的值，此例中为123  |
|   password  |   登录密码  |
|   username  |   登录用户账号  |

**4.拿到token，按图操作，保存token信息到请求头**
![](images/686980327c25cfbafc0b1428ef240bc7_1896x343.png)

**5.测试接口-新增**
![](images/a0e020d5340298475a5829d53e947e02_1895x707.png)
**6.测试接口-查询 根据name查询，拿到该用户的id**
![](images/9afddb1508dc236f5c3e4b58ebcd30cd_1899x869.png)

![](images/58f5175fd9d26074a3d66d54fff6e5f8_1163x532.png)

**7.测试接口-修改 输入上述id和新的name,即可根据id修改name**
![](images/7ef18889557272abf2e720d8e176a081_1572x441.png)

**8.根据id查询，输入上述id**
![](images/4200a1b283cbce57560fc05e4803a56e_1500x612.png)

**9.根据id删除**
![](images/0c348bfd2d5304d723ceaf9ee340f7ac_1466x491.png)
再次查询，result为空
![](images/9732d6196a209ef55bf774777c07cd30_1315x408.png)



