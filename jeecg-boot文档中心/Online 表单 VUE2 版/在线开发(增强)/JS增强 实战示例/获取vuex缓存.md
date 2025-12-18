# Online表单JS增强—获取vuex缓存

直接操作`$store`即可

## 示例：

![](images/eee76f1204411fc3ea22440af8873e10_811x283.png)

> `$store.getters.username` 是 `$store.getters.userInfo.username` 的语法糖

```
beforeAdd(){
  console.log('username 1: ', that.$store.getters.userInfo.username)
  console.log('username 2: ', that.$store.getters.username)
}
```

输出结果：

![](images/1e980de720c21d460bf3cc8d72748d77_211x61.png)

