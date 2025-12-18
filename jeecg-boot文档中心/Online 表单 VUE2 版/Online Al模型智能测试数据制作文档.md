> 本章介绍AI模型如何制作

[TOC]
## 制作步骤
### 1、制作表格数据
#### 1.1 效果展示
![](images/c984f87bbe161ac989d181c80ad296f3_1911x980.png)
#### 1.2 新建一个online表单，名称为`商家信息`
>除了自动生成的字段，其中还包含`bu_name`、`bu_desc`、`bu_address`,点击确定即可

![](images/21093e052ce0b6121f440ce5fc4461aa_1899x365.png)
![](images/724aee34625a22b5c7f2877df31bcf80_1903x653.png)
#### 1.3 制作表格数据库
>前台页面新增一个文件夹`demo`，并创建js文件，名称为`one.business.js`，文件存放地址`src/views/modules/aitest/data`

![](images/7b218f9703847f1b8f8a22d4c2460f65_565x707.png)

>在`one.business.js`文件中配置表信息`ai_business(商家信息)`
```
/**
 * 配置表信息
 */
const table = {
  //表名
  tableName: 'ai_business',
  //表描述
  tableTxt: '单表-商家信息',
  //表类型 1单表 2主表 3子表
  tableType: 1,
  formTemplate: '1',
  themeTemplate: "normal",
  //是否有横向滚动条 0否 1是 
  scroll: 1,
  //当前表版本号
  tableVersion: 1,
  //显示复选框 Y是 N否
  isCheckbox: 'Y',
  isDbSynch: 'Y',
  //是否分页 Y是 N否
  isPage: 'Y',
  //是否树 Y是 N否
  isTree: 'N',
  idType: 'UUID',
  queryMode: 'single',
  formCategory:'temp',
  //仅在附表中有效,0一对多、1一对一，在单表、主表中删掉
  relationType: 0
}
```

>在Online在线表单页面中键盘按F12打开浏览器控制台页面，点击表描述为`商家信息`的编辑

![](images/cc04b95d872cbd6134bf8c77519af6d7_1526x109.png)

>发现控制台有内容输出,复制json串

![](images/855220ce808c37898791831741783069_1920x864.png)

>配置`ai_business(商家信息)`字段->将json串放到`one.business.js`文件中

![](images/508178cc8a3fb5abbebb41f5e152d40a_1900x287.png)

>在`one.business.js`文件末尾，将配置的数据导出
```
/**
 * 数据导出
 * table 表信息
 * fields 表字段
 * 命名规则:表名_config
 */
const ai_business_config = {
  table: table,
  fields: fields
}
export default ai_business_config
```
![](images/d79ff85457d5b25abc666e2998ed1afd_1642x455.png)
> 在`config.js`文件中新增表名和描述，文件地址：`src/views/modules/aitest/data/config.js`

![](images/f0411151f384ac93b291fc70655c94e9_1897x807.png)
>在方法末尾添加`title`和`name`

![](images/f7e10b0c221153e78b9dcb8a602aa28a_887x133.png)
```
{
  title: '单表-商家信息', name:'ai_business'
}
```
>`onlinetest.base.js`引入配置类，文件地址：`src/views/modules/aitest/onlinetest.base.js`

![](images/5496c86acd56cf38c1f5129e690240ee_1618x669.png)


>[danger] 注意：如果json中存在自动生成的字段（id，create_by，create_time，update_by，update_time，sys_org_code）需要去掉包含字段花括号里面的所有内容

![](images/3558b79adab9611173b7ad9dd908da55_1871x343.png)
### 2、自定义按钮
自定义按钮页面配置详见:[自定义按钮](http://doc.jeecg.com/2516895)
#### 2.1 效果展示
![](images/1b473a2e73ba3015de872a2f41716acb_1911x980.png)
#### 2.2 创建一个名称为`js增强button`的自定义按钮
>在`data.common.js`文件`customButtons`方法中新增自定义按钮，文件地址：`src/views/modules/aitest/data/data.common.js`
```
{
    //按钮编码
    buttonCode: 'one',
    //按钮名称
    buttonName: 'btn增强',
    //按钮样式 link/button/form
    buttonStyle: 'button',
    //按钮位置1侧面 2底部 仅在form模式下有效
    optPosition: '2',
    //按钮类型 action/js
    optType: 'js',
    //排序
    orderNum: 1,
    //按钮状态 0 无效 1 有效
    buttonStatus: '1'
}
```

![](images/778badd1b9fad2284216a0fa14068372_1545x689.png)
### 3、js增强
js增强页面配置详见:[js增强](http://doc.jeecg.com/2044103)
>js增强分为两种,分别为`list`列表和`form`表单
#### 3.1 效果展示
![](images/cd7f6f760b0ab1245001c936417c3b67_1911x980.png)
#### 3.2 js增强`list`列表风格
>在`data.common.js`文件`customListEnhanceJavascript`新增自定义按钮，文件地址：`src/views/modules/aitest/data/data.common.js`

```
one(){
  console.log('当前选中行的id',that.table.selectedRowKeys);
}
```
![](images/f275266d239cf54f2000ede9b7cb429a_1588x630.png)
#### 3.3 js增强`form`表单风格
>在`one.business.js`文件中中新增`from`增强，并将其引入到`ai_business_config`里面，`ai_business_config`固定对象为`enhanceFormJs`
```
//表单js增强
const enhanceFormJs = `
one(){
  console.log("我是表单js增强")
}`
```
![](images/558361cb4b82d1106e20d6a5207c94a7_1881x840.png)

### 4、SQL增强
SQL页面配置详见：[SQL增强](http://doc.jeecg.com/2044111)
#### 4.1 效果展示
![](images/043d885f437874fd1e1eb4a9553cf4b8_1911x980.png)
#### 4.2 新增编辑时修改`商品名称`
>在`one.business.js`文件中中新增`from`增强，并将其引入到`ai_business_config`里面，`ai_business_config`固定对象为`enhanceSql`

```
const enhanceSql = "update ai_business set name = '我是sql增强' where id = '#{id}'"
```
![](images/3c9cbba3583b8f776e07d294db655be2_1856x599.png)
### 5、java增强
#### 5.1 效果展示
![](images/561859fbb09ea0c2b1aad4e2913c6f42_1911x980.png)
#### 5.2 配置java增强
java增强页面配置详见：[java增强](http://doc.jeecg.com/2516887)
>在`data.common.js`文件`customJavaEnhance`中新增`java增强`，文件地址：`src/views/modules/aitest/data/data.common.js`

```
{
  //按钮编码:新增add、编辑edit、导入import、导出export、查询query、删除delete
  buttonCode: 'add',
  //事件状态 开始start、结束end，仅在新增、编辑、删除时有效
  event: 'start',
  //类型 spring-key/class/http
  cgJavaType: 'spring',
  //内容
  cgJavaValue: 'cgformEnhanceJavaDemo',
  //是否生效 0否、1是
  activeStatus: '1'
}
```
![](images/d4dbeda762ec40594e9b31df3fbd5747_1775x601.png)

## 其他规则
1、列表的js增强是全局的
2、表单的js增强是根据表名配置的（在各种的js里面定义）
3、注意一对多更改表名，会导致js增强不好使，还会导致编辑页面赋不上值