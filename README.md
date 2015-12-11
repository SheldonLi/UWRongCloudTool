#融云快速接入工具[![Build Status](https://travis-ci.org/SheldonLi/UWRongCloudTool.svg?branch=master)](https://travis-ci.org/SheldonLi/UWRongCloudTool)



[融云官方: iOS SDK 2.0 开发指南](http://www.rongcloud.cn/docs/ios.html)

>融云不维护和管理用户的基本信息（用户Id、昵称、头像）的获取、缓存、变更和同步，也不管理好友关系。


###本框架主要处理用户数据的储存与查询 

- UWRongCloudVC文件夹下有继承融云列表、融云会话的控制器 

- UWRongCloudTool文件夹存放管理用户数据工具类 

其中**UWRongCloudTool类**:提供封装融云业务的API,实现了多个融云的代理方法。


```
/** 连接融云(不设置登录用户的数据) */
-(void)connectWithToken:(NSString *)token;

/** 连接融云(带用户模型) */
-(void)connectWithToken:(NSString *)token userModel:(UWRongCloudUserModel *)userModel;

/** 连接融云（带用户模型，成功失败回调处理） */
-(void)connectWithToken:(NSString *)token userModel:(UWRongCloudUserModel *)userModel success:(void (^)(NSString *userId))success error:(void (^)(RCConnectErrorCode status))error tokenIncorrect:(void (^)())tokenIncorrect;

/** 断开连接 */
-(void)rongCloudLogOut;

/** 创建新的聊天控制器 */
-(void)addPrivateConversationVieController:(UWRongCloudUserModel *)userModel completion:(void (^)(RCConversationViewController *conversationVC)) completion;

/** 更新登录用户的融云信息 */
-(void)updateUserInfo:(UWRongCloudUserModel *)userModel; 
```



一些tips:	

1.推送：app进程被杀死后，融云无法推送消息，因此需要完整的推送功能的话还需重新加上苹果原生或极光等推送服务。
2.继承RCConversationListViewController的好友列表，若未登录融云，会出现BAD_EXC_ACCESS的崩溃，此崩溃出现在列表控制器的viewWillAppear方法，注释[super viewWillAppear]即可。
