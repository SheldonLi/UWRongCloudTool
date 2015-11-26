##融云快速接入工具


[融云官方: iOS SDK 2.0 开发指南](http://www.rongcloud.cn/docs/ios.html)

>融云不维护和管理用户的基本信息（用户Id、昵称、头像）的获取、缓存、变更和同步。


###本框架主要处理用户数据的储存与查询
- **UWRongCloudSqlTool**用于储存与查询用户数据
- **UWRongCloudTool**提供封装融云业务的API












一些tips:	

1.推送：app进程被杀死后，融云无法推送消息，因此需要完整的推送功能的话还需重新加上苹果原生或极光等推送服务。
