##  postgresql脚本
未提供脚本的数据库，可以参考 [文档](https://my.oschina.net/jeecg/blog/4905722) 自己转库。

## postgresql数据库兼容问题
> 问题：将mysql数据转到postgres，原tinyint类型会转成int2类型，这时实体属性是布尔类型 ，会导致插入数据失败。

**处理方案：**  添加postgres数据转化规则(登录postgres 切换到自己的数据库，执行以下代码即可)：
```
create or replace function bool_to_int(boolean) returns int2 as $$        
  select CAST($1::int as int2);
$$ language sql strict;
create cast (bool as int2) with function bool_to_int(boolean) as implicit; 
```
![](images/42103a015b3219ebaaf7d2d1772dca05_784x200.png)