# 如何处理Long类型精度丢失问题?

>[info] 当实体类中的字段为`Long`类型，且值超过前端`js`显示的长度范围时会导致前端回显错误。



### 方法1 使用@JsonSerialize注解的时候把Long自动转为String
```
@JsonSerialize(using = ToStringSerializer.class)
private Long id;

```

### 方法2 使用@JsonFormat注解的时候把Long自动转为String
```
@JsonFormat(shape = JsonFormat.Shape.STRING)
private Long id;

```

### 方法3 全局配置org.jeecg.config.WebMvcConfiguration中添加如下代码
```
   builder.serializerByType(Long.class, ToStringSerializer.instance);
   builder.serializerByType(Long.TYPE, ToStringSerializer.instance);
```
具体配置如下
```
@Bean
public Jackson2ObjectMapperBuilderCustomizer jackson2ObjectMapperBuilderCustomizer() {
    return builder -> {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        //返回时间数据序列化
        builder.serializerByType(LocalDateTime.class, new LocalDateTimeSerializer(formatter));
        //接收时间数据反序列化
        builder.deserializerByType(LocalDateTime.class, new LocalDateTimeDeserializer(formatter));
        //序列化Long
        builder.serializerByType(Long.class, ToStringSerializer.instance);
        builder.serializerByType(Long.TYPE, ToStringSerializer.instance);
    };
}
```