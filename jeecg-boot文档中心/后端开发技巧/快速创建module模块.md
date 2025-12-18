快速创建module模块？
===
[TOC]

## 方式一：使用archetype初始化项目
*   此文档支持 JeecgBoot 2.4.2+ 版本
*   务必按照本文档`包名规则 org.jeecg.modules.* `进行初始化，自定义路径 请了解jeecgboot `mybatis`的包扫描规则，不然bean扫描不到！
*   根据如下文档通过mvn 命令生成初始化demo项目, IDEA 可以直接图形化使用
```
// 注意： windows下可直接复制执行， Linux/Macos下  ^ 修改成  \

mvn archetype:generate ^
   -DgroupId=org.jeecg.modules.demo ^
   -DartifactId=jeecg-module-demo ^
   -Dversion=2.4.6 ^
   -DarchetypeGroupId=org.jeecgframework.archetype ^
   -DarchetypeArtifactId=jeecg-boot-gen ^
   -DarchetypeVersion=2.0
```
说明：    `-DarchetypeVersion=2.0`版本号固定不需要修改，`2.4.6`根据自己项目的版本号进行调整。

生成的POM结构
![](images/f8744fa90d70716a1b71ccb2d2dbecd7_817x431.png)

## 方式二： IDEA快速创建module模块

![](images/c5cba445c2e1916a599f7039a0f920ce_1905x934.gif)

 简单说明
```
  jeecg-boot-module-system作为启动项目，所以其他模块不要引用system。
  jeecg-boot-base-core作为基础Core，所以新建模块一定要引用。
```

重点：如果业务模块需要调用system里面的业务方法怎么办呢？
* 单体模式，可以引入jeecg-system-local-api
~~~
<!-- jeecg system api -->
<dependency>
   <groupId>org.jeecgframework.boot</groupId>
   <artifactId>jeecg-system-local-api</artifactId>
</dependency>
~~~
* 微服务模式，直接引入jeecg-boot-starter-cloud即可
~~~
<dependency>
    <groupId>org.jeecgframework.boot</groupId>
    <artifactId>jeecg-boot-starter-cloud</artifactId>
</dependency>
~~~

*****


**历史文档备份**

```
平台在common里面预留了接口 org.jeecg.common.system.api.ISysBaseAPI，
需要调用system的方法在这里面重新声明
在system有个实现类 org.jeecg.modules.system.service.impl.SysBaseApiImpl，实现具体业务。
```


