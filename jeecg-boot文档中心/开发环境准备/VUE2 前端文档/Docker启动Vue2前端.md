# docker快速启动vue2 UI

## 启动vue2前端ant-design-vue-jeecg

### 1. 修改前端项目的后台域名
  .env.production
~~~
NODE_ENV=production
VUE_APP_API_BASE_URL=http://localhost:8080/jeecg-boot
VUE_APP_CAS_BASE_URL=http://localhost:8888/cas
VUE_APP_ONLINE_BASE_URL=http://fileview.jeecg.com/onlinePreview
~~~
   
### 2. 进入ant-design-vue-jeecg根目录，执行编译命令
~~~
yarn install
yarn run build
~~~

###  3. 构建镜像
~~~
docker build -t jeecgboot-ui2 .
~~~

###  4. 启动镜像
    docker run --name jeecgboot-ui-vue2 -p 80:80 -d jeecgboot-ui2
  
###  5. 访问前台项目
   http://localhost:80
