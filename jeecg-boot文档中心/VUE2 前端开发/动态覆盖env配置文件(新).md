全局配置文件
===
前台全局配置文件
配置内容：后台域名、图片服务器域名配置
文件位置：public/static/config.js
好处： 前端build完也可以直接修改config.js配置内容
config.js配置内容如下
~~~
/**
 * 常量配置
 */
window._CONFIG = {
  //接口父路径
  VUE_APP_API_BASE_URL: '',
  //单点登录地址
  VUE_APP_CAS_BASE_URL: '',
  //文件预览路径
  VUE_APP_ONLINE_BASE_URL: ''
}
~~~
**注：当值不为空时会覆盖env文件配置**


