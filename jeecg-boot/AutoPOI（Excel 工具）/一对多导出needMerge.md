### 一对多导出needMerge注解的使用
1）注意事项：需要一对多的时候才可以正确导出纵向合并单元格（如一个教师对应多个学生）
2）一对多，一表中需要导出的字段都需要添加上needMerge
3）后台代码实现示例
教师实体类
```
/**needMerge需要写在@Excel里面,并且是一对多的情况下，否则合并失败*/
/**教师名称*/
@Excel(name = "教师名称", width = 15,needMerge = true)
@ApiModelProperty(value = "教师名称")
private String name;

@ExcelCollection(name="学生")
@ApiModelProperty(value = "学生")
private List<Student> studentList;
```
![](images/ec1a117f51e85995d7b98b76fc033182_797x589.png)
学生实体类
```

/**主键*/
@TableId(type = IdType.ID_WORKER_STR)
@ApiModelProperty(value = "主键")
private String id;
/**所属部门*/
@ApiModelProperty(value = "所属部门")
private String sysOrgCode;
/**姓名*/
@Excel(name = "姓名", width = 15)
@ApiModelProperty(value = "姓名")
private String name;
/**年龄*/
@Excel(name = "年龄", width = 15)
@ApiModelProperty(value = "年龄")
private String age;
/**性別*/
@Excel(name = "性別", width = 15)
@ApiModelProperty(value = "性別")
private String sex;
/**教师id*/
@ApiModelProperty(value = "教师id")
private String teacherId;
```
controller控制类
![](images/91ebe4408875b21d6eca4acba5b48b11_1520x582.png)
![](images/a9101a20a5714096e4ff6b83a446796e_1689x607.png)
导出excel截图
![](images/78aa127bcb95a03f0fe588f709d7ce21_696x348.png)
