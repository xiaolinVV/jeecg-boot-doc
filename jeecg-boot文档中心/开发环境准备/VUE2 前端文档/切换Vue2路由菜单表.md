
## JeecgBoot切换Vue2路由

**重要：**
>[danger]  如果你运行过vue3版，这个时候后台菜单表会做切换，如果你又需要用到vue2版前端允许，哪请手工切换下vue2菜单表。如果你没运行过vue3版，忽略此文档。



## 执行SQL脚本 
~~~
alter table sys_permission rename as sys_permission_v3;
alter table sys_permission_v2 rename as sys_permission;
~~~


