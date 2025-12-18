# Vue2前端项目快速启动

项目下载和运行
----

- 拉取项目代码
```bash
git clone https://gitee.com/jeecg/ant-design-vue-jeecg
cd  ant-design-vue-jeecg
```

1. 安装node.js
   如果您电脑未安装[Node.js](https://nodejs.org/en/)，请安装它。
 **验证**
~~~
# 出现相应npm版本即可
npm -v
# 出现相应node版本即可
node -v
~~~

2. 安装yarn
~~~
# 全局安装yarn
npm i -g yarn
# 验证
yarn -v # 出现对应版本号即代表安装成功
~~~


3. 切换到ant-design-vue-jeecg文件夹下


```
# 下载依赖
yarn install

# 启动
yarn run serve

# 编译项目
yarn run build

# Lints and fixes files
yarn run lint
```

4. 接口地址配置
.env.development
~~~
NODE_ENV=development
VUE_APP_API_BASE_URL=http://localhost:8080/jeecg-boot
~~~
