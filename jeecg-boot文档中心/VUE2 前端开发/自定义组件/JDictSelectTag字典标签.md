# JDictSelectTag字典标签

> 针对字典的使用，目前提供了一个标签实现下拉和radio组件。
> JDictSelectTag 标签： 用于表单的标签使用，比如通过性别字典编码：sex，可以直接渲染出下拉组件。
> JDictSelectUtil.js函数： 用于列表数据展示，针对列表字段字典值替换成字典文本，进行展示（可以作废了，建议@Dict注解进行翻译）
> @Dict用法
> 字典翻译注解@Dict，用于列表字段字典翻译（比如字段sex存的值是1，会自动生成一个翻译字段 sex_dictText 值是‘男’）。详细文档：http://jeecg-boot.mydoc.io/?t=345678



## JDictSelectTag 字典标签用法
----

### 示例： v-model用法

```
<j-dict-select-tag v-model="queryParam.sex" placeholder="请输入用户性别" dictCode="sex"/>
```


### 示例：v-decorator用法 
> 注意得加参数 :triggerChange="true"，不然赋值不成功
```html
<j-dict-select-tag  v-decorator="['sex', {}]" :triggerChange="true" placeholder="请输入用户性别"
                  dictCode="sex"/>
```

### 表字典类型
> 从数据库表获取字典数据，dictCode格式说明: 表名,文本字段,取值字段
```html
<j-dict-select-tag v-model="queryParam.username" placeholder="请选择用户名称" 
                   dictCode="sys_user,realname,id"/>
```
### 表字典类型条件
> 当从数据库表获取字典数据的时候支持写查询条件进行过滤数据
> 下面dictCode = "sys_user,realname,id,sex = '2'"表示从sys_user表中查询数据且只查询sex='2'的数据
```html
<j-dict-select-tag v-model="queryParam.username" placeholder="请选择用户名称" dictCode="sys_user,realname,id,sex = '2'"/>  
```


## 参数说明




## DictSelectUtil.js 列表字典函数用法
----


### 第一步： 引入依赖方法
       
```
import {initDictOptions, filterDictText} from '@/components/dict/JDictSelectUtil'
```

### 第二步： 在created()初始化方法执行字典配置方法
    
```
 this.initDictConfig();
```
### 第三步： 实现initDictConfig方法，加载列表所需要的字典(列表上有多个字典项，就执行多次initDictOptions方法)
      
```
//sexDictOptions 自行定义
      initDictConfig() {
        //初始化字典 - 性别
        initDictOptions('sex').then((res) => {
          if (res.success) {
            this.sexDictOptions = res.result;
          }
        });
      },
```
### 第四步：实现字段的customRender方法
    
 ```
customRender: (text, record, index) => {
       //字典值替换通用方法
       return filterDictText(this.sexDictOptions, text);
```


