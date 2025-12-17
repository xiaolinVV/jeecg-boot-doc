Maven私服设置
===

>[warning] JEECG存在自定义JAR包，放在自己的Maven私服上面，所以有的时候会遇到下载失败情况。


 一般遇到下载失败的情况，是因为用户设置了本地镜像，导致无法从JEECG私服下载资源
 参考下面的方式进行镜像排除配置即可。


- 找到 maven老家 conf/settings.xml，
在<mirrors>标签内增加下面方式的阿里云maven镜像（删除自己的镜像配置）， 最终结果见下面：
```
<mirrors>
       <mirror>
            <id>nexus-aliyun</id>
            <mirrorOf>*,!jeecg,!jeecg-snapshots,!getui-nexus</mirrorOf>
            <name>Nexus aliyun</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public</url>
        </mirror> 
 </mirrors>
```
- 此配置重点在这句话`<mirrorOf>*,!jeecg,!jeecg-snapshots</mirrorOf>`
如果不加这句话，默认所有的依赖都会去阿里云仓库下载，加上后jeecg的依赖包就可以从jeecg私服下载了。




