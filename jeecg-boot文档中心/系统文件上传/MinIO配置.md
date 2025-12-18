# MinIO文件上传配置
jeecg-boot 提供文件及图片上传至MinIO。

[TOC]
## MinIO安装部署
官方文档：[https://docs.min.io/docs/minio-quickstart-guide.html](https://docs.min.io/docs/minio-quickstart-guide.html)
## 配置MinIO存储桶访问策略
* 设置 * ReadOnly 则所有用户通过文件路径即可访问，私有桶则不必设置访问策略
![](images/4943c6afb74957fcf9f342b16f34c987_615x232.png)
## yml文件配置
在yml文件中设置MinIO的配置
![](images/4ef8004893434adab21585058821561e_347x137.png)
参数说明
| 名称 | 说明
|---|-----|
|  minio_url | MinIO访问路径（ip 或 域名）  |
|  minio_name | 账号 |
|  minio_pass | 密码 |
|  bucketName | MinIO桶名字  如果为未创建新桶，则上传文件时先创建桶 |
