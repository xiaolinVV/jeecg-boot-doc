Form 表单开发特殊性
===

v-decorator 属性
针对特殊控件： select、radio、checkbox
```
<a-radio-group buttonStyle="solid" v-decorator="[ 'status', {'initialValue':0}]">
    <a-radio-button :value="0">正常</a-radio-button>
    <a-radio-button :value="-1">停止</a-radio-button>
</a-radio-group>
```

注意： 此处的默认值只能通过{'initialValue':0} 这样的设置，不能通过属性。


表单编辑赋值操作：
```
this.$nextTick(() => {
    this.form.setFieldsValue(pick(this.model,'description','status'));
});
```

