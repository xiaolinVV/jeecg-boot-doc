# JCron 帮助文档

## 效果展示

![](images/51b6225eaa61bd320ceef364212bd866_613x54.png)
![](images/128f947e6976e697635782da107fb52d_615x432.png)

## 引用方式

``` js
import JCron from "@/components/jeecg/JCron";
```

``` html
<j-cron />
```

## 设置默认值

### v-model 方式

![](images/85ba4d09761e4e8fad47f86e9f8b6d42_381x50.png)
![](images/88e87a89d6c629b9b36b254543c630c6_417x89.png)

### a-form 表单方式

![](images/b1fa5830b02e9c21ce3fff0f806fe816_896x76.png)

``` html
<j-cron v-decorator="['cronExpression', { initialValue: '* * * * * ? *' }]"/>
```