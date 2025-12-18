门户首页根据角色授权
===
### 1.在门户设置中，添加门户
门户类型：选择企业门户或流程门户
是否默认：用于未授权时，默认展示的门户；
在同一类型的门户中，默认门户只能有一个，其他设为默认后，会把原有默认门户改为否
路由页面：企业门户(eoa/cmsoa/EoaCmsEnterprisePortal)
                 流程门户（modules/eoa/cmsbpm/EoaCmsProcessPortal）
门户网站模块设置：根据模板样式选择模块需显示的功能
![](images/e71284a080f437e9df3aa789226436d1_788x860.png)
### 2.授权
在列表中为添加门户授权角色，每个角色只会授权一种门户类型，
若有重复授权，则以最新为准，删除原来已授权门户
![](images/0b56223418cff8778902f37963877172_910x492.png)

### 3.扩展功能组件
1.新扩展功能组件将页面路径加入到constant.js中
src/utils/portal/constant.js
如下图：
![](images/e70e5bf084115beb263c12a3da876062_962x513.png)
2.添加模块坐标，将模板样式对应坐标，添加到EoaPortalSiteConfig.js （2021.01.06以后）
src/views/modules/eoa/cms/modules/EoaPortalSiteConfig.js
如下图：
![](images/5f04666e865ae1a9531f602d4802f093_635x681.png)
