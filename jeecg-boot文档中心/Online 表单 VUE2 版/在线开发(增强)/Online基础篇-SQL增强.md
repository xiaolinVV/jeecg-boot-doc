online 基础篇-SQL增强
===

1.功能简述
通过增强SQL，可以关联修改业务数据
>[info] SQL增强是在线开发概念，不支持代码生成器生成。


2.操作截图  
![](images/5b0761e54d15fcc9877299dad1297ec0_1830x465.png)
![](images/bde3b0aa8f5df4d7cd8ccbb45cc8e265_903x614.png)

> 注意：
> 1.这里选择的按钮一定要是按钮类型是action的,因为js类型的是走的js增强，而按钮样式未作限制
> 2.这边我将按钮点击后触发的sql定义为,修改demo表的性别字段为1
> 3.#{id}是一种规范,id可以是任何当前表中的字段名
> 4.如果数据库定义的字段是数值类型的，这边是不需要加单引号('')的
> 5.sqlServer数据库插入修改sql遇到中文乱码时，需在sql前加N
       例1：insert into test_one2 (id,username,sex) values('1',N'大王巡山','1') 
       例2：update test_one2 set name=N'张三' where id=N'#{id}'
       

3.效果演示  
操作前  
![](images/fac86a2c28ccc70573607813512f7db3_1577x379.png)
操作后  
![](images/433a174710dc8adbaa26c2a4e750c802_1584x186.png)
4.sql增强中可以定义系统变量(如下)  

| 变量名称| 变量释义| 
| --------   | -----  | ----  |
| #{sys_user_code}| 登陆用户的账号名| 
| #{sys_org_code}| 登陆用户所属机构编码| 
| #{sys_date}| 系统日期"yyyy-MM-dd"| 
| #{sys_time}| 系统时间"yyyy-MM-dd HH:mm"| 
| #{sys_user_name}| 登录用户真实姓名| 
示例SQL： update demo set content= '#{sys_user_name}' where id = '#{id}' (设置个人简介的内容为当前用户真实姓名)

#### 注意：
上述增强sql中取表单的值（如`#{id}`）和取系统变量的值(如`#{sys_user_code}`)用的都是#{},如果两者的参数名相同，以表单的值为准，若表单中未取到,会从系统变量中取值


