> 本章介绍ai开头的online表单测试数据主要测试的功能点

[TOC]

## 表单控件

表单控件分为单表`ai_control_single`，主表`ai_control_main`，一对多`ai_control_sub`,一对一`ai_control_sub_one`

### 1、单表

> 选择`表单控件@单表`，点击生成数据， 如果表名重复，需要修改

![](images/75d67d8c818f8590d4398a90cac75ae1_1920x908.png)

> 生成对应的自定义按钮、js增强、sql增强

![](images/56b111fee8cd70b4926225d6d96fbbeb_1647x282.png)

自定义按钮，点击生成测试数据
![](images/81b1fb8ffed80cb2a6346c143b9cf570_1914x925.png)
js增强from，点击生成测试数据
![](images/be8d30794f5df9ef83ca2ea14f76169a_1068x605.png)
js增强list，点击生成测试数据
![](images/cbbf4cdbd390a8cc420f95a590bd3301_1107x487.png)
SQL增强，点击生成测试数据
![](images/ea86bca7d5362b20b5b8b2bf7a655d51_1918x919.png)

> 主要测试内容

* 重点-> 控件是否全部生成，并且可以点击、新增和保存，字典、字典表和字典表带条件的下拉、单选、多选、下拉多选、下拉搜索是否可以生成
    ![](images/2913454fea8a74026e97ed2ab72ff726_998x812.png)
* 输入`单价和文本`，`多行文本`里面的内容是否发生改变
    ![](images/323002a2a4174c6531046561990f53f9_942x174.png)
    ![](images/a9ab177604b2ef2cf266dfeefe8499d2_980x173.png)
* 点击form增强，并点击确定，列表是否跟新
    ![](images/b0be924a1b0f9c4dd27baa426f050e0c_993x887.png)

> 列表

![](images/8b5c1386aeaffad7a2cb037a6f945528_1579x137.png)

* 点击js增强button，控制台是否有输出
    ![](images/1fd94291f3f068a59dbb52667115f20d_1920x784.png)
* 点击js增强link，控制台是否有输出
    ![](images/30fea0151a4e852ba57bcde207633bff_1920x908.png)
* 点击action增强button，`单价`是否更新为`2`
    ![](images/41c015f4e1e179b4cfcb5dd2af6378c4_1631x281.png)

### 2、多表

> 生成`表单控件@主表`，点击保存并同步数据库

![](images/64c399d38e22b94f9a115d614d58939c_1919x814.png)

> 生成`表单控件@一对多子表`，点击保存并同步数据库

![](images/4b32f436c522cf3f597fe4623324626d_1920x918.png)
如果主表表名修改，那么对应子表的外键也需要修改
![](images/36f933bf7104955fe4a275c2a5b51205_1919x915.png)

> 生成`表单控件@一对一子表`，点击保存并同步数据库

![](images/82a5a883e85325699a3f927067068ce9_1920x936.png)

> 为主表生成对应的自定义按钮，js增强，sql增强

![](images/c3ee8f6f62f31401955303a5e94e41bb_1654x483.png)

> 主要测试内容

* 重点-> 控件是否全部生成，并且可以点击、新增和保存，字典、字典表和字典表带条件的下拉、单选、多选、下拉多选、下拉搜索是否可以生成
    主表
    ![](images/fb3994f5c704b0b80f2ece9ca5fd5c14_1388x685.png)
    子表`一对一`、`一对多`
    ![](images/7f7c0631d48c489007cc2627ed073d99_1391x496.png)
* js增强主表，在`自定义正则`输入后，`多行文本`是否有值
    ![](images/1c7620f15ff7f64c49cc818b88182dee_1368x77.png)
    ![](images/e0052f61231a6e26e688ab5465da898b_1222x168.png)
* js增强子表一对一,在`正则`输入内容后，`文本`是否有值
    ![](images/6ddcc29684637a91768b5b57e5f17e45_1341x486.png)
    ![](images/5154090e2207fada92a40f1193512030_1068x80.png)
* js增强子表一对多,在`单价`输入后，`实付`是否是`购买数量*单价`
    \*![](images/86f6bb08f92e955f4d082c76ac33daaa_1394x298.png)
* 点击js增强button按钮，查看控制台是否有数据输出
    ![](images/f8f57f9ee67a9d7502a7075d57890650_1920x764.png)
* 点击js增强link按钮，查看控制台是否有数据输出
    ![](images/90cc7f58349a4ce6488c9921b49ccb2c_1920x868.png)
* 点击action增强button，`单价`是否修改成2
    ![](images/6d32441e9faa0651d18d9bc84d9fad39_1597x345.png)
* 点击表单按钮，列表`文本框`是否修改
    ![](images/33abc95f86c8332c6f59787a20185980_1371x540.png)
    列表
    ![](images/04396c17545689c595b782ba11053302_1364x321.png)

## 表单默认值

表单默认值分为单表`ai_defval_single`，主表`ai_defval_main`，一对多`ai_defval_sub`,一对一`ai_defval_subone`

### 1、单表

> 生成`表单默认值@单表`，点击保存并同步数据库

![](images/5da7db2f684c7643b11b87f11a6d2852_1914x905.png)

> 主要测试内容：各个组件的默认值、系统变量、编码规则、js表达式是否生成正确

![](images/ee8e12034738e35120ebbd722995d95a_1012x826.png)

### 2、多表

> 生成`表单默认值@主表`，点击保存并同步数据库

![](images/0cf67787a92483e2399cae4927490f97_1917x906.png)

> 生成`表单默认值@一对多子表`，点击保存并同步数据库

![](images/0ced3020b11624e6c95d31b65fb67f6e_1920x900.png)
如果主表表名修改，需要修改外键
![](images/43a951d8ca1147a8bb69175db77bfd22_1920x358.png)

> 生成`表单默认值@一对一子表`，点击保存并同步数据库

![](images/8d48f33b0328c3f7aac2bf49306ace3b_1920x909.png)

> 主要测试内容：主表、子表各个组件的默认值、系统变量、编码规则、js表达式是否生成正确

> 主表

![](images/cc0a114acbcc2fcc4126596a1aeefd25_1622x655.png)

> 一对多子表

![](images/4d7f11e482a555defc5533aa7060869d_1629x345.png)

> 一对一子表

![](images/9aa0245bcdc152423e47d988e3e01592_1627x487.png)

## 表单检验

表单检验分为单表`ai_rules_single`，主表`ai_rules_main`，一对多`ai_rules_sub`,一对一`ai_rules_sub_one`

### 1、单表

> 生成`表单检验@单表`，点击保存并同步数据库

![](images/7387d4c05cbe5fe59ba10c45e485d3c2_1920x856.png)

> 主要测试内容：验证规则里面的检验是否正确，自定一验证规则`中文`是否通过，不同组件必填是否有效

![](images/d8da8cea9abdb60d237c8d64e7afebfd_999x434.png)
![](images/d0e94c07c7235680fbd095e1f03e12f3_1001x408.png)

### 2、多表

> 生成`表单检验@主表`，点击保存并同步数据库

![](images/acc306d8e120f29c36d637aa89e67a36_1917x910.png)

> 生成`表单检验@一对多子表`，点击保存并同步数据库

![](images/70f4df9f62a712896afe96f13b13bf37_1920x916.png)
如果主表表名修改，需要修改外键
![](images/385fee2799dc2607d84244ea91bb149e_1449x236.png)

> 生成`表单检验@一对一子表`，点击保存并同步数据库

![](images/7a5825af2f5a5faceadc837dd7db2e41_1920x918.png)

> 主要测试内容：主表、子表验证规则里面的检验是否正确，自定一验证规则`中文`是否通过，不同组件必填是否有效

> 主表

![](images/9af34282a1544757d36a01fcf8f5dd48_1265x430.png)

> 一对多子表

![](images/efa8f0231ddf0043672127f10c4e7d16_1374x276.png)

> 一对一子表

![](images/7f15e0909905ab59c644be3cb49bb119_1357x559.png)

## 自定义查询

自定义查询分为单表`ai_query_custom_single`，主表`ai_query_custom_main`，一对多`ai_query_custom_sub`,一对一`ai_query_custom_sub_one`

### 1、单表

> 生成`自定义查询@单表`，点击保存并同步数据库

![](images/649382b48800fd1e670d552adde3071d_1920x906.png)

> 主要测试内容：列表页面查询是否全部生成（包含数字、时间范围），并且默认值是否存在，高级查询是否生成

![](images/65377794fa9dfdf1cbad311c655fcebf_1649x636.png)

### 2、多表

> 生成`自定义查询@主表`，点击保存并同步数据库

![](images/247eed2dda4dca39cac12632c4c10133_1916x917.png)

> 生成`自定义查询@一对多子表`，点击保存并同步数据库

![](images/b8cce60db4f0d5c96ca1de8c55957935_1920x926.png)
如果主表表名修改，需要修改外键
![](images/f74e1c5f9828fbe7090644f83397896f_1909x438.png)

> 生成`自定义查询@一对一子表`，点击保存并同步数据库

![](images/8be1ff5743116eaa228cd4b1d1bd2e17_1920x913.png)

> 主要测试内容：主表、子表列表页面查询是否全部生成（包含数字、时间范围），并且默认值是否存在，高级查询是否生成

>[danger] 注意：当风格是默认和tab时，需要勾选联合查询，erp分格不需要

![](images/72cfffc51580e254d6bb293a1bc5624b_1673x896.png)

## 默认查询

默认查询分为单表`ai_query_def_single`，主表`ai_query_def_main`，一对多`ai_query_def_sub`,一对一`ai_query_def_sub_one`

### 1、单表

> 生成`默认查询@单表`，点击保存并同步数据库

![](images/653a785cef2bf27f4441aa45873bb43b_1919x909.png)

> 主要测试内容：列表页面查询是否全部生成（包含数字、时间范围），高级查询是否生成

![](images/69db269f1ee371b3a60a9639a6bb21f9_1680x630.png)

### 2、多表

> 生成`默认查询@主表`，点击保存并同步数据库

![](images/0a3c3082b1033ff4a5621a73ff356221_1920x910.png)

> 生成`默认查询@一对多子表`，点击保存并同步数据库

![](images/884734d196ce910b6ce2785398328725_1920x907.png)
如果主表表名修改，需要修改外键
![](images/10a104b14c7fa0c4b7e45e7b1f3c0e1f_1919x579.png)

> 生成`默认查询@一对一子表`，点击保存并同步数据库

![](images/b76bce0cee8f9da40d81e34f9d861e5b_1920x915.png)

> 主要测试内容：主表、子表列表页面查询是否全部生成（包含数字、时间范围），高级查询是否生成

>[danger] 注意：当风格是默认和tab时，需要勾选联合查询，erp分格不需要

![](images/075183b44083e5f7af7a4be40fa90a03_1624x766.png)