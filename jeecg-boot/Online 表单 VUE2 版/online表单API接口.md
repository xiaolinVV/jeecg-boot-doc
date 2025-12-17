# Online表单数据操作—API接口

- 1.表单保存操作：请求(post)：
~~~
/online/cgform/api/form/{code}
~~~
请求参数：表单数据的json对象
这里的{code}是online配置表的ID，实际开发调用同3。

-  2.表单查询： 请求(get)：
~~~
/online/cgform/api/form/{code}/{id}
~~~
这里的{code}是online配置表的ID，{id}是这个表单对应数据的ID

-  3.修改 请求(put)：
~~~
/online/cgform/api/form/{code}
~~~
请求参数：表单数据的json对象

-  4.删除操作：请求(delete)：
~~~
/online/cgform/api/form/{code}/{id}
~~~
-  5.查询列表数据  请求(get)：
~~~
/online/cgform/api/getData/{code}

~~~
这里的{code}是online配置表的ID
如果是单条记录的删除则{id}即为表单对应数据的ID
如果是多条记录的删除，{id}是所有数据ID以逗号分隔拼接而成的字符串


