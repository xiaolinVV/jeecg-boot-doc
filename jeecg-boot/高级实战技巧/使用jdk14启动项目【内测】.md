- 1.修改父pom文件，设置java版本
![](images/7defd588abcb52a4e41aca87ee1469bc_894x345.png)
- 2.修改core的pom，shiro排除，文件地址：jeecg-boot-base/jeecg-boot-base-core/pom.xml
![](images/2d7aa58f0d246a1eff27a9a556764f71_799x316.png)
    ~~~
    <exclusion>
       <groupId>com.puppycrawl.tools</groupId>
       <artifactId>checkstyle</artifactId>
    </exclusion>
    ~~~


- 3.修改platform下各个模块的pom，删除plugins，主要是混淆插件会导致启动失败
- 4.添加启动参数
![](images/003993322fff51ed1000d8380da6fb9e_944x187.png)·
`--add-opens java.base/jdk.internal.loader=ALL-UNNAMED`
说明：
```
Judging from the stack trace this is caused by Groovy so either your are using an old Groovy version that doesn't support JDK 9 or running code that imports `jdk.internal.loader` without declaring proper Java module access.

I'd start by checking that you have recent Groovy dependencies but a quick workaround would be to run the JVM with:
```
