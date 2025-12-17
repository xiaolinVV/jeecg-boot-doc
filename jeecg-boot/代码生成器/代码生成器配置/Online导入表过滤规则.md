为了系统安全，防止有些前缀的表导入进行破坏，jeecg平台针对以下前缀表做了过滤，所以在导入表单的时候，会看不到这些表。

~~~
"act_",
"ext_act_",
"design_",
"onl_",
"sys_",
"qrtz_"
~~~

最新版本2.3+ 开始支持自定义导入过滤前缀配置
jeecg-boot-module-system\src\main\resources\jeecg\jeecg_config.properties
![](images/d39850a7e0565b379c4a66f2f28e695b_957x384.png)