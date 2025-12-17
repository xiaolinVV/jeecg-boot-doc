# GUI代码生成器
>[info] 目前Vue3只支持GUI模式代码生成。


[TOC]


## 第一步：代码生成器的配置
### 1. 配置数据库
 配置文件：`jeecg-boot-module-system\src\main\resources\jeecg\jeecg_database.properties`
![](images/d27817eccbb32235fa8de63e72235095_1222x360.png)

### 2. 配置生成代码路径
 配置文件：`jeecg-boot-module-system\src\main\resources\jeecg\jeecg_config.properties`
![](images/7223e9b7a67f0ecd2c54e502744a37f6_969x349.png)

## 第二步：GUI代码生成使用
### 1. 单表代码生成

 找到类 `jeecg-boot-module-system\src\main\java\org\jeecg\JeecgOneGUI.java` 右键执行弹出GUI代码生成界面，按照提示输入参数。

>[warning] 注意：代码生成会同时生成vue2和vue3的页面，手工选择所需版本的代码

![](images/89d6ea40a958ba1274c458ede6879ca1_454x392.png)

### 2. 一对多代码生成

 找到类  `jeecg-boot\jeecg-boot-module-system\src\main\java\org\jeecg\JeecgOneToMainUtil.java`
 修改代码参数配置，右键执行生成代码

### 3. vue3模板目录
> 需要哪个vue版本的页面，复制哪个目录下的代码到前端项目即可

![](images/8402fc1edebaa8d7b13d53842079b5a8_416x348.png)
