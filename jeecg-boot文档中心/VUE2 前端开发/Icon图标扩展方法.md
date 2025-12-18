# Icon图标扩展方法
===
这里介绍的是系统与阿里矢量图标库的结合
[TOC]
## 图标准备
登录icon，并将图标下载至本地。如果还没有项目可在我的项目中新建项目并上传图标
![](images/3f5e9e98d6ba8051aabbd34735ce8ede_1381x374.png)
新建项目
![](images/9eeadadfd89020ccf13691574d92b51e_624x630.png)
FontClass/  Symbol 前缀可修改 也可为默认的icon  引用时一致即可
Font Family  可修改
## 整合项目
在src/components（其他目录也可以）下新建文件夹 iconfont，使用Fontclass模式时，需引入iconfont.css
将下载图标解压后，复制文件到iconfont下（demo可不复制）
![](images/1e64dd3d5aba6c800a93fb294677c9f3_224x271.png)
在iconfont文件下创建文件common.less，将如下代码复制到common.less文件中
~~~
/* 引入 icon class 文件 */
@import  "./iconfont.css";

/* 设置使用字体的优先级 anticon 高 */
:global(.anticon) {  /* :global() 是为了覆盖全局class .anticon 的样式 */
  &:before {
    font-family: "anticon", "anticon-jeecg" !important;
    /* 默认样式是这样
        font-family: "anticon" !important;
    */
  }
}
~~~
将common.less在全局文件中引入，这里是在src/App.vue中引入
~~~
// Fontclass模式
import '@/components/iconfont/common.less'
// 使用 symbol模式 支持多色
import '@/components/iconfont/iconfont.js'
~~~

## 在所需文件处，引 入图标
~~~
font-class模式 ： 

<i class="anticon-jeecg actionglasses1" style="font-size: 65px;"/>
anticon-jeecg 与icon项目的Font Family 对应
actionglasses1为icon项目的前缀和图片名称
~~~
![](images/47cb348f352d5921d1917a2ecf467ac5_73x68.png)
~~~
symbol 方式：

 <svg class="icon" aria-hidden="true">
  <use xlink:href="#actionglasses1"></use>
</svg>
//可修改图标样式  加入通用 CSS 代码（引入一次就行）
.icon {
  width: 4em;
  height: 4em;
  vertical-align: -0.15em;
  fill: currentColor;
  overflow: hidden;
}
~~~
![](images/fc3d70d7fab0c027c1a9b0eaa61ed0e4_84x53.png)

## 菜单中使用自定义图标
### 1.菜单表中的icon字段,保存自定义图标时，手动添加'cus_'前缀
![](images/dd21b6ee1e752bdac912e7269a0ec2f4_173x60.png)
### 2.菜单index.js中处理显示自定义图标
src/components/menu/index.js
![](images/bebd21dc17ecb058f44805ed5968c59a_724x381.png)
