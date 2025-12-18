快速插入菜单升级SQL
> 需要手工替换下面三个参数

|   参数  |  描述   |
| --- | --- |
|   菜单名字  |  测试树列表   |
|   菜单请求URL  |  /hr/JeecgTreeDemoList   |
|   菜单组件路径  |  /hr/JeecgTreeDemoList   |


```
 INSERT INTO `sys_permission`(`id`, `parent_id`, `name`, `url`, `component`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_route`, `is_leaf`, `keep_alive`, `hidden`, `description`, `status`, `del_flag`, `rule_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `internal_or_external`) VALUES ('121008911426059sc94', '2a470fc0c3954d9dbb61de6d80846549', '测试树列表', '/hr/JeecgTreeDemoList', 'erp/hr/JeecgTreeDemoList', NULL, NULL, 1, NULL, '1', 111.00, 0, NULL, 1, 1, 1, 0, NULL, '1', 0, 1, 'admin', '2019-12-26 14:45:02', 'admin', '2020-01-06 14:24:14', 0);
```




