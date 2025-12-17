# JVXETable 文档

[2020-09-14 | v2.3.0 版本]

[TOC=2,2]

>[info] [vxe-table 官方文档](https://xuliangzhan_admin.gitee.io/vxe-table/#/table/base/basic)
> `JVXETable`基于`vxe-table`组件开发，使用方式与`JEditableTable`类似，但也不完全一样

## 参数配置

### 基础参数配置

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | array |  | **【必填】** 表格列的配置描述，详见【columns 参数配置】 |
| dataSource | array |  | **【必填】** 表格数据 |
| size | string | 'medium' | 表格尺寸，可选值有：'medium'、 'small'、 'mini'、 'tiny' |
| loading | boolean | false | 是否正在加载 |
| height | number, string | 'auto' | 表格的固定高度，string只能填'auto'，代表自适应高度 |
| maxHeight | number | null | 设定最大高度(px)，默认null不限定最大高度 |
| disabled | boolean | false | 是否禁用全部组件 |
| bordered | boolean | false | 是否显示单元格竖向边框线 |
| toolbar | boolean | false | 是否显示工具栏 |
| toolbarConfig | object | {slot: \['prefix', 'suffix'\], btn: \['add', 'remove', 'clearSelection'\]} | 工具栏配置 |
| rowNumber | boolean | false | 是否显示行号 |
| rowSelection | boolean | false | 是否可选择行 |
| rowSelectionType | string | 'checkbox' | 选择行类型， 可选值：'checkbox'、 'radio' |
| rowExpand | boolean | false | 是否可展开行 |
| expandConfig | object | {} | 展开行配置 |
| pagination | object | {} | 分页器参数，设置了即可显示分页器，详见（[APagination分页](https://antdv.com/components/pagination-cn/#API)） |
| clickRowShowSubForm | boolean | false | 点击行时是否显示子表单 |
| clickRowShowMainForm | boolean | false | 点击行时是否显示主表单 |
| clickSelectRow | boolean | false | 是否点击选中行，优先级最低 |
| reloadEffect | boolean | false | 是否开启 reload 数据效果 |
| editRules | object | {} | 校验规则 |
| asyncRemove | boolean | false | 是否异步删除行，如果你要实现异步删除，那么需要把这个选项开启；在remove事件里调用confirmRemove方法才会真正删除（除非删除的全是新增的行） |
| authPre| string |  | 配置按钮/列权限，通常规则是[前缀:列/按钮编码] 如`jvxeauth:add` ,如果需要在该table上作权限控制，就需要配置此属性为权限编码的前缀 ，此例中为`jvxeauth` |
| alwaysEdit | boolean | false | 是否一直显示输入框，如果为false则只有点击的时候才出现输入框。注：该参数不能动态修改；如果行、列字段多的情况下，会根据机器性能造成不同程度的卡顿，谨慎使用 2.4.4+|
| linkageConfig | array| [] | `2.4.7+` 多级联动配置，详见[【多级联动配置】](多级联动配置.md) |

>[info] [更多配置详见VXETable文档](https://vxetable.cn/v2/#/table/api?filterName=columns)

### columns 参数配置

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| title | string | **【必填】** 表格列头显示的标题 |
| key | string | **【必填】** 列数据在数据项中对应的`key`，必须是**唯一**的 |
| type | string | **【必填】** 表单的类型，可以通过`JVXETypes`赋值（详见：[【组件配置文档】](组件配置文档.md)） |
| fixed | string | left（固定左侧）, right（固定右侧） |
| width | string | 列的宽度,`px`、`%` |
| minWidth |  | 最小列宽度， `px`、`%`；会自动将剩余空间按比例分配 |
| align | string | 列对齐方式 left（左对齐）, center（居中对齐）, right（右对齐） |
| placeholder | string | 表单预期值的提示信息，可以使用`${...}`变量替换文本（详见【常见问题_${...} 变量如何使用】） |
| defaultValue | string | 默认值，在新增一行时生效 |
| props | object | 设置添加给表单元素的自定义属性，例如:`props:{title: 'show title'}` |
| disabled | boolean | 是否禁用当前列，默认false |
| validateRules | array | 表单验证规则，配置方式见【validateRules 配置规则】 |
| formatter | Function({cellValue, row, column}) | 格式化显示内容，将处理后的值返回即可。注：仅影响展示的值，不会修改实际的值，也就是说，在获取和点击编辑时不会受影响 |

### validateRules 配置规则

`validateRules`需要的是一个数组，数组里每项都是一个规则，规则是object类型，规则的各个参数如下

* `required`是否必填，可选值为`true`or`false`
* `unique`唯一校验，不可重复，可选值为`true`or`false`
* `pattern`正则表达式验证，只有成功匹配该正则的值才能成功通过验证
* `handler`自定义函数校验，使用方法请见【使用示例\_五】)
* `message`当验证未通过时显示的提示文本，可以使用`${...}`变量替换文本（详见【常见问题_${...} 变量如何使用】）
* 配置示例请看【使用示例\_二】

## 事件

### added

* `触发时机`：点击`新增`按钮、调用`addRows`方法时会触发
* `携带参数`：
    * `row`：添加完成后的行

>[info] 如果调用`addRows`方法添加多行，则每添加一行都会触发一次该事件

### save

* `触发时机`：只有点击`保存`按钮时才会触发

### remove

* `触发时机`：只有点击`删除`按钮时才会触发
* `携带参数`：
    * `deleteRows`：即将被删除的行的ID
    * `confirmRemove`：确认删除方法

>[info] 如果`asyncRemove`参数设为true，则会传递`confirmRemove`方法，否者不会，且只有调用了该方法后才会真正删除（除非删除的全是新增的行）
> 如果`asyncRemove`参数设为false，就会直接删除行，而不用调用`confirmRemove`。

### selectRowChange

* `触发时机`：当行被选中或取消选中时触发
* `携带参数`：
    * `type`：选中类型
        * `radio`：单选
        * `checkbox`：多选
    * `action`：选中操作
        * `selected`：选中
        * `unselected`：取消选中
        * `selected-all`：全选
    * `row`：当前操作的行（全选时没有该参数）
    * `selectedRows`：所有被选中的行
    * `selectedRowIds`：所有被选中的行的ID
    * `$event`：原生事件

### pageChange

* `触发时机`：当分页参数被改变时触发
* `携带参数`：
    * `current`：当前页码
    * `pageSize`：当前页大小

### valueChange

* `触发时机`：当数据发生改变的时候触发的事件
* `携带参数`：
    * `type`：组件类型（JVXETypes中定义的类型）
    * `value`：新值
    * `oldValue`：旧值
    * `row`：当前行
    * `col`：当前列
    * `column`：当前列配置
    * `rowIndex`：当前行下标
    * `columnIndex`：当前列下标
    * `cellTarget`：当前组件实例
    * `isSetValues`：为`true`则代表是通过`setValues`方法触发的事件

>[info] **特别注意：** 如果是通过`setValues`方法触发的事件，将不会传递`row`、`rowIndex`、`columnIndex`、`cellTarget`这几个参数的。

## 方法

### addRows

* `说明`：添加一行或多行临时数据，会填充默认值，总是会激活添加的最后一行的编辑模式
* `参数`：
    * `rows`：\[object | array\] 要添加的行
* `返回值`：Promise<row,rows>

### pushRows

* `说明`：添加一行或多行临时数据，不会填充默认值，传什么就添加进去什么
* `参数`：
    * `rows`：\[object | array\] 要添加的行
    * `options`：object 选项参数
        * `index`：默认-1，插入位置，-1为最后一行
        * `setActive`：默认false，是否激活添加的最后一行的编辑模式
* `返回值`：Promise<row,rows>

### loadData

* `说明`：加载数据，和`dataSource`不同的是，由于该方法不直接绑定到页面上，所以可以防止vue监听大数据，提高性能。当然如果数据量少的话就模棱两可了。
* `参数`：
    * `dataSource`：array
* `返回值`：Promise

### loadNewData

* `说明`：加载新数据，和`loadData`不同的是，用该方法加载的数据都是相当于点新增按钮新增的数据，适用于不是数据库里查出来的没有id的临时数据。
* `参数`：
    * `dataSource`：array
* `返回值`：Promise

### resetScrollTop

* `说明`：重置滚动条Top位置
* `参数`：
    * `top`：number 新top位置，留空则滚动到上次记录的位置，用于解决切换tab选项卡时导致白屏以及自动将滚动条滚动到顶部的问题
* `返回值`：无

### validateTable

* `说明`：校验table，失败返回errMap，成功返回null
* `参数`：无
* `返回值`：Promise

### setValues

* `说明`： 设置某行某列的值
* `参数`：
    * `values`：array
* `返回值`：void

### getAll

* `说明`：获取所有的数据，包括`tableData`、`deleteData`
* `参数`：无
* `返回值`：{ tableData, deleteData }

### getTableData

* `说明`： 获取表格数据
* `参数`：
    * `options`：object 选项参数
        * `rowIds`：string\[\] 行ID，传了就只返回传递的行
* `返回值`：row\[\]

### getNewData

* `说明`：仅获取新增的临时数据
* `参数`：无
* `返回值`：row\[\]

### getIfRowById

* `说明`：根据ID获取行，新增的临时行也能查出来
* `参数`：id
* `返回值`：{row, isNew}
    * `row`：获取到的行
    * `isNew`：当前行是否是新增的临时行

### getNewRowById

* `说明`：通过临时ID获取新增的临时行
* `参数`：id
* `返回值`：row

### getDeleteData

* `说明`：仅获取被删除的数据（新增又被删除的数据不会被获取到）
* `参数`：无
* `返回值`：row\[\]

### clearSelection

* `说明`：清空选择
* `参数`：无
* `返回值`：void

### removeRows

* `说明`：删除一行或多行数据
* `参数`：
    * `rows`：\[object | array\]
* `返回值`：void

### removeRowsById

* `说明`：根据id删除一行或多行
* `参数`：
    * `rowId`：\[string | array\]
* `返回值`：void

>[info] [更多方法见VXETable文档](https://vxetable.cn/v2/#/grid/api?filterName=methods)

## 内置插槽

| 插槽名 | 说明 |
| --- | --- |
| toolbarPrefix | 在操作按钮的**前面**插入插槽，和自带的按钮共处于一行，受`toolbar`和`toolbarConfig`属性的影响 |
| toolbarSuffix | 在操作按钮的**后面**插入插槽，和自带的按钮共处于一行，受`toolbar`和`toolbarConfig`属性的影响 |
| toolbarAfter | 在工具条的**下面**插入插槽，不受`toolbar`和`toolbarConfig`属性的影响 |
| subForm | 点击展开子表的内容 |
| mainForm | 弹出主表的内容 |

## vxeUtils.js 使用说明

引用路径：`@/components/jeecg/JVxeTable/utils/vxeUtils.js`

### export 的常量

* `VALIDATE_FAILED`
在判断表单验证是否通过时使用，如果 reject 的值 === VALIDATE\_NO\_PASSED 则代表表单验证未通过，你可以做相应的其他处理，反之则可能是发生了报错，可以使用`console.error`输出

### 封装的方法

#### validateTables

* `说明`：一次性验证多个JVxeTable实例
当你的页面中存在多个JVxeTable实例的时候，如果要获取每个实例的值、判断表单验证是否通过，就会让代码变得极其冗余、繁琐，于是我们就将该操作封装成了一个函数供你调用，它可以同时获取并验证多个JVxeTable实例的值，只有当所有实例的表单验证都通过后才会返回值，否则将会告诉你具体哪个实例没有通过验证。具体使用方法请看下面的示例
* `参数`：
    - `cases`：array，传入一个数组，数组中的每项都是一个JVxeTable的实例
    - `autoJumpTab` boolean，默认true，校验失败后，是否自动跳转tab选项
    仅限于在ATab组件下使用的情况，如果没有就可以无视该参数
* `返回值`：Promise<tablesData[]> 返回表格数据数组，与传入的顺序一一对应
*   `示例：`
``` js
import { validateTables, VALIDATE_FAILED } from '@/components/jeecg/JVxeTable/utils/vxeUtils.js'
// 封装cases
let cases = []
cases.push(this.$refs.editableTable1)
cases.push(this.$refs.editableTable2)
cases.push(this.$refs.editableTable3)
cases.push(this.$refs.editableTable4)
cases.push(this.$refs.editableTable5)
// 同时验证并获取多个实例的值
validateTables(cases).then(tablesData => {
    // tablesData 是一个数组，每项都对应传入cases的下标，包含values和deleteIds
    console.log('所有实例的值：', tablesData)
}).catch((e = {}) => {
    // 判断表单验证是否未通过
    if (e.error === VALIDATE_FAILED) {
        console.log('未通过验证的实例下标:', e.index)
    } else {
        console.error('发生异常:', e)
    }
})
```

#### validateFormAndTables

* `说明`：同时验证AFrom实例和多个JVxeTable实例
和`validateTables`功能相同，只不过该方法进一步验证了AForm实例。
* `参数`：
    - `form`：AForm实例
    - `cases`：array，传入一个数组，数组中的每项都是一个JVxeTable的实例
    - `autoJumpTab` boolean，默认true，校验失败后，是否自动跳转tab选项
* `返回值`：Promise<dataMap> dataMap.formValue=主表数据，dataMap.tablesValue=子表数据

### vxePackageToSuperQuery

* `说明`：vxe columns 封装成高级查询可识别的选项
* `参数`：
    - `columns`：array，columns
    - `handler`：function、单独处理方法
* `返回值`：array，高级查询所需要的`fieldList`

### getRefPromise

* `说明`：获取指定的 $refs 对象
有时候可能会遇到组件未挂载到页面中的情况，导致无法获取 $refs 中的某个对象
这个方法可以等待挂载完成之后再返回 $refs 的对象，避免报错
* `参数`：
    - `vm`：vue实例
    - `name`：string，ref的名称
* `返回值`：Promise，获取到的ref实例
