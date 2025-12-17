# JEllipsis 字符串超长截取省略号显示
  
###### 说明: 遇到超长文本展示，通过此标签可以截取省略号显示，鼠标放置会提示全文本
## 参数配置
| 参数  | 类型     | 必填 |    说明      |
|--------|---------|----|----------------|
| value  |string   | 必填   |  字符串文本|
| length | number  | 非必填 |  默认25    |
使用示例
----
1.组件带有v-model的使用方法
```vue
<j-ellipsis :value="text"/>


# Modal弹框实现最大化功能  

1.定义modal的宽度：
```vue
  <a-modal
    :width="modalWidth"
    
    
    />
```
2.自定义modal的title,居右显示切换图标
```vue
  <template slot="title">
    <div style="width: 100%;">
      <span>{{ title }}</span>
      <span style="display:inline-block;width:calc(100% - 51px);padding-right:10px;text-align: right">
        <a-button @click="toggleScreen" icon="appstore" style="height:20px;width:20px;border:0px"></a-button>
      </span>
    </div>
  </template>
```
3.定义toggleScreen事件,用于切换modal宽度
```vue
  toggleScreen(){
      if(this.modaltoggleFlag){
        this.modalWidth = window.innerWidth;
      }else{
        this.modalWidth = 800;
      }
      this.modaltoggleFlag = !this.modaltoggleFlag;
    },
```
4.data中声明上述用到的属性
```vue
    data () {
      return {
        modalWidth:800,
        modaltoggleFlag:true,
```