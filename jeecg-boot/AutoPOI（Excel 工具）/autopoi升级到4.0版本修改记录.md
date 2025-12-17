

**1.样式相关**
 ###### 图案颜色和样式设置：
 ```
 其他颜色修改类似
HSSFColor.WHITE.index  =》  IndexedColors.WHITE.index;
HSSFColor.SKY_BLUE.index =》 IndexedColors.SKY_BLUE.index;
图案样式：
CellStyle.SOLID_FOREGROUND =》 FillPatternType.SOLID_FOREGROUND
```
###### 对齐设置：
```
CellStyle.ALIGN_CENTER (垂直居中) ==》 HorizontalAlignment.CENTER
CellStyle.VERTICAL_CENTER(左右居中) ==》  VerticalAlignment.CENTER
CellStyle.ALIGN_RIGHT =》 HorizontalAlignment.RIGHT
类似的偏左以及偏右 替换成对应的LEFT  或者 RIGHT 
```
###### 边框线设定：
```
原有的单线最细边框设置
cellStyle.setBorderTop((short) 1 ) =》修改后cellStyle.setBorderTop(BorderStyle.THIN);//上边框
(short) 1  =》 BorderStyle.THIN
至于其他边框粗细，参考BorderStyle 里面的相关介绍
```
###### 粗细设置：
```
font.getBoldweight() =》font.getBold()
font.setBoldweight(Font.BOLDWEIGHT_BOLD);  =》 font.setBold(true);
```

**2.数据类型**
```
 Cell.CELL_TYPE_STRING     =》       CellType.STRING
 Cell.CELL_TYPE_NUMERIC    =》       CellType.NUMERIC
 Cell.CELL_TYPE_BOOLEAN    =》       CellType.BOOLEAN
 Cell.CELL_TYPE_FORMULA    =》       CellType.FORMULA
 Cell.CELL_TYPE_NUMERIC    =》       CellType.NUMERIC
```
如有小伙伴也遇到了相同的问题，并修改了其他相关的地方，可以联系小弟一起学习探讨