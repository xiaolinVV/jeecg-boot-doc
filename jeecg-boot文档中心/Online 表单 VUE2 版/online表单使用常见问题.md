#### 1.`sqlserver`中字段类型配置成`text`类型，就不能设置成查询条件，走查询会报类型不匹配的错：
`nested exception is
com.microsoft.sqlserver.jdbc.SQLServerException: The data types ntext and nvarchar are incompatible in the equal to operator.
`
![](images/5a42c20337611c2d3580ac50f79f37f9_1024x322.png)