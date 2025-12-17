

**依赖修改**
```
 <dependency>
    <groupId>io.minio</groupId>
    <artifactId>minio</artifactId>
    <version>8.0.3</version>
</dependency>
```
**类添加如下import内容**

```
import io.minio.*;
```
**主要问题如下：**

1.MinioClient的构造函数方式变为从builder里获取
```
修改前：MinioClient minioClient = new MinioClient(minioUrl, minioName,minioPass);
```
```
修改后： MinioClient.builder().endpoint(minioUrl)
							 .credentials(minioName, minioPass)
							 .build();
```

2.检查桶的存在
```
修改前：boolean isExist = minioClient.bucketExists(bucketName);
```
```
修改后：boolean isExist = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build()
```
3.创建桶的方式
```
修改前：minioClient.makeBucket(newBucket);
```
```
修改后：minioClient.makeBucket(MakeBucketArgs.builder().bucket(newBucket).build());
```
4.文件上传方式

```
修改前：minioClient.putObject(newBucket,objectName, stream,stream.available(),"application/octet-stream");
```
```
修改后：PutObjectArgs objectArgs = PutObjectArgs.builder().object(objectName)
                    .bucket(newBucket)
                    .contentType("application/octet-stream")
                    .stream(stream,stream.available(),-1).build();
       minioClient.putObject(objectArgs);
```

5.获取文件流
```
修改前：inputStream =minioClient.getObject(bucketName, objectName);
```
```
修改后：  GetObjectArgs objectArgs = GetObjectArgs.builder().object(objectName)
                    .bucket(bucketName).build();
       inputStream = minioClient.getObject(objectArgs);
```

6.删除文件
```
修改前：minioClient.removeObject(bucketName, objectName);
```
```
修改后：  RemoveObjectArgs objectArgs = RemoveObjectArgs.builder().object(objectName)
                    .bucket(bucketName).build();
       minioClient.removeObject(objectArgs);
```
如有小伙伴也遇到了相同的问题，并修改了其他相关的地方，可以联系小弟一起学习探讨