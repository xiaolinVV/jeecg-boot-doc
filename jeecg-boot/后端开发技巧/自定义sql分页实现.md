自定义sql分页实现
===

### （1）mapper 接口以及 xml
```
/**
 * @Description: 系统通告表
 * @Author: jeecg-boot
 * @Date:  2019-01-02
 * @Version: V1.0
 */
public interface SysAnnouncementMapper extends BaseMapper<SysAnnouncement> {

	
	List<SysAnnouncement> querySysCementListByUserId(Page<SysAnnouncement> page, String userId,String msgCategory);

}
```
这里要注意的是，这个 Page page 是必须要有的，否则 Mybatis-Plus 无法为你实现分页。

```
<resultMap id="SysAnnouncement" type="org.jeecg.modules.system.entity.SysAnnouncement" >
		<result column="id" property="id" jdbcType="VARCHAR"/>
		<result column="titile" property="titile" jdbcType="VARCHAR"/>
		<result column="msg_content" property="msgContent" jdbcType="VARCHAR"/>
		<result column="start_time" property="startTime" jdbcType="TIMESTAMP"/>
		<result column="end_time" property="endTime" jdbcType="TIMESTAMP"/>
		<result column="sender" property="sender" jdbcType="VARCHAR"/>
		<result column="priority" property="priority" jdbcType="VARCHAR"/>
		<result column="msg_category" property="msgCategory" jdbcType="VARCHAR"/>
		<result column="msg_type" property="msgType" jdbcType="VARCHAR"/>
		<result column="send_status" property="sendStatus" jdbcType="VARCHAR"/>
		<result column="send_time" property="sendTime" jdbcType="VARCHAR"/>
		<result column="cancel_time" property="cancelTime" jdbcType="VARCHAR"/>
		<result column="del_flag" property="delFlag" jdbcType="VARCHAR"/>
		<result column="create_by" property="createBy" jdbcType="VARCHAR"/>
		<result column="create_time" property="createTime" jdbcType="TIMESTAMP"/>
		<result column="update_by" property="updateBy" jdbcType="VARCHAR"/>
		<result column="update_time" property="updateTime" jdbcType="TIMESTAMP"/>
		<result column="user_ids" property="userIds" jdbcType="VARCHAR"/>
	</resultMap>
	
	
	<select id="querySysCementListByUserId" parameterType="String"  resultMap="SysAnnouncement">
	   select sa.* from sys_announcement sa,sys_announcement_send sas 
	   where sa.id = sas.annt_id 
	   and sa.send_status = '1'
	   and sa.del_flag = '0'
	   and sas.user_id = #{userId}
	   and sa.msg_category = #{msgCategory}
	   and sas.read_flag = '0'
	</select>
```

### （3） service 实现

```
@Override
	public Page<SysAnnouncement> querySysCementPageByUserId(Page<SysAnnouncement> page, String userId,String msgCategory) {
		 return page.setRecords(sysAnnouncementMapper.querySysCementListByUserId(page, userId, msgCategory));
	}
```

### （4） controller 实现

```
@RequestMapping(value = "/list", method = RequestMethod.GET)
	public Result<Page<SysAnnouncement>> queryPageList(SysAnnouncement sysAnnouncement,
									  @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
									  @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
									  HttpServletRequest req) {
		Result<Page<SysAnnouncement>> result = new Result<Page<SysAnnouncement>>();
		Page<SysAnnouncement> pageList = new Page<SysAnnouncement>(pageNo,pageSize);
		pageList = sysAnnouncementService.querySysCementPageByUserId(pageList,"","1");//通知公告消息
		log.info("查询当前页："+pageList.getCurrent());
		log.info("查询当前页数量："+pageList.getSize());
		log.info("查询结果数量："+pageList.getRecords().size());
		log.info("数据总数："+pageList.getTotal());
		result.setSuccess(true);
		result.setResult(pageList);
		return result;
	}
```

