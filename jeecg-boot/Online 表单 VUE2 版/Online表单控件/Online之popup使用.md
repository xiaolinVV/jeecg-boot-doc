Online之popup使用
===

- 1 . 功能说明：online-demo表单在简介字段上配置popup关联online报表,popup选择完成后,将姓名、性别赋值到表单上
- 2 . 配置online报表（如图2-1）
![](images/2da7d0603fca115d96c80aab1364720e_1900x855.png)
- 3 . 配置online表单-demo表的简介字段的页面属性为popup弹出框
![](images/a1987ce0701e15eaec89480c13e071aa_1837x841.png)
- 4 . 配置online表单-demo表的简介字段的> 校验字段，如下图
![](images/f202fd2213e0c533bae4793619eda5de_1869x480.png)
#### 注意：校验字段定义规则
> 1.字典table定义成online报表的编码如图2-1
> 2.字典code定义成online报表的结果字段，需要使用哪些字段的值就拼接哪些字段，字段之间用逗号分隔
> 3.字典text定义成online表单的字段，需要设置哪些字段的值就拼接哪些字段，字段之间用逗号分隔，这和online报表的字段一一对应，所以字段顺序很重要
> 4 . 上述字典text配置online表单的字段，第一个字段一定是当前字段，那么对应的字典code的第一个字段的取值即为当前字段的值
- 5 . 测试表单  
![](images/f7cd39dde4e3e7159a74f4dcdf5e52a4_875x728.png)

