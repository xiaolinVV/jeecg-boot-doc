redis 如何使用？
===

jeecg-boot集成了redis

用法分三种：


  1. 通过Jeecg自封装工具类
```
   //封装了redis操作各种方法
   @Autowired
   private RedisUtil redisUtil;
```

 2.通过注解
参考链接： https://www.cnblogs.com/fashflying/p/6908028.html
```
   //key的定义参考官方文档
  @Cacheable(cacheNames="jeecgDemo", key="#id")

  示例：
/**
	 * 缓存注解测试： redis
	 */
	@Cacheable(cacheNames="jeecgDemo", key="#id")
	public JeecgDemo getByIdCacheable(String id) {
		JeecgDemo t = jeecgDemoMapper.selectById(id);
		System.err.println(t);
		return t;
	}
```
  
 3.通过原生工具service
```
  @Autowired
  private RedisTemplate<String, Object> redisTemplate;
  @Autowired
  private StringRedisTemplate stringRedisTemplate;
```
  


其他技巧：
@CacheEvict用来标注在需要清除缓存元素的方法或类上的
参考链接： https://www.cnblogs.com/fashflying/p/6908028.html
```
@CacheEvict(value="dictCache", allEntries=true)
public Result<SysDict> delete(@RequestParam(name="id",required=true) String id) {
```


