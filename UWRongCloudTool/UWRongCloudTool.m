//
//  UWRongCloudTool.m
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import "UWRongCloudTool.h"
#import "UWRongCloudUserModel.h"
#import "UWRongCloudSqlTool.h"
#import "UWChatViewController.h"
#import "UWRongCloudUserModel.h"

#define RONGCLOUD_IM_APPKEY @"p5tvi9dst1yk4"

@interface UWRongCloudTool ()<RCIMUserInfoDataSource, RCIMReceiveMessageDelegate,
                              RCIMConnectionStatusDelegate> {
}
@end

@implementation UWRongCloudTool

+ (UWRongCloudTool *)sharedTool {
    static dispatch_once_t once;
    static UWRongCloudTool *rongCloudTool = nil;
    dispatch_once(&once, ^{
        rongCloudTool = [[UWRongCloudTool alloc] init];
    });
    return rongCloudTool;
}

#pragma mark - 登录融云API
- (void)connectWithToken:(NSString *)token {
    [self connectWithToken:token userModel:nil success:nil error:nil tokenIncorrect:nil];
}

- (void)connectWithToken:(NSString *)token userModel:(UWRongCloudUserModel *)userModel {
    [self connectWithToken:token userModel:userModel success:nil error:nil tokenIncorrect:nil];
}

- (void)connectWithToken:(NSString *)token
               userModel:(UWRongCloudUserModel *)userModel
                 success:(void (^)(NSString *))success
                   error:(void (^)(RCConnectErrorCode))error
          tokenIncorrect:(void (^)())tokenIncorrect {
    RCIM *rcim = [RCIM sharedRCIM];
    if (rcim.connectionStatusDelegate) {
        return;
    }
    [rcim initWithAppKey:RONGCLOUD_IM_APPKEY];

    //    注册自定义消息
    //    [rcim registerMessageType:BizCardMessageContent.class];

    [rcim connectWithToken:token
        success:^(NSString *userId) {
            //  设置返回用户信息代理
            [rcim setUserInfoDataSource:self];
            //  设置接收消息代理
            [rcim setReceiveMessageDelegate:self];
            //  设置网络连接状态
            [rcim setConnectionStatusDelegate:self];
            //  设置消息包含用户信息
            rcim.enableMessageAttachUserInfo = YES;
            //  设置列表头像样式
            rcim.globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
            //  设置消息头像样式
            rcim.globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
            //  设置融云自身用户的信息
            if (userModel) {
                rcim.currentUserInfo = [[RCUserInfo alloc] initWithUserId:userModel.userId name:userModel.name portrait:userModel.portrait];
            }
            if (success) {
                success(userId);
            }
        }
        error:^(RCConnectErrorCode status) {
            if (error) {
                error(status);
            }
        }
        tokenIncorrect:^() {
            if (tokenIncorrect) {
                tokenIncorrect();
            }
        }];
}

/**
 *  断开连接
 */
- (void)rongCloudLogOut {
    [[RCIM sharedRCIM] disconnect];
}


#pragma mark - RCIM代理方法
/**
 *  网络状态变化。(RCIMConnectionStatusDelegate)
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle:@"提示"
                      message:@"您的帐号在别的设备上登录，您被迫下线！"
                     delegate:nil
            cancelButtonTitle:@"知道了"
            otherButtonTitles:nil, nil];
        [alert show];

        [self rongCloudLogOut];
        // TODO: 回登陆界面
    }
}

/**
 *  接收消息到消息后执行 (RCIMReceiveMessageDelegate)
 *
 *  @param message 接收到的消息
 *  @param left    剩余消息数
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {

    UWRongCloudUserModel *userModel = [[UWRongCloudUserModel alloc] init];
    userModel.userId = message.content.senderUserInfo.userId;
    userModel.name = message.content.senderUserInfo.name;
    userModel.portrait = message.content.senderUserInfo.portraitUri;
    if (!userModel.userId) {
        return;
    }
    BOOL isSuccess = [UWRongCloudSqlTool insertUserInfoWithUserInfoModel:userModel];
    if (isSuccess) {
        NSLog(@"保存用户信息成功");
    }
}

/**
 *  接收消息到消息后执行 (RCIMReceiveMessageDelegate)
 *
 *  @param message 接收到的消息
 *  @param left    剩余消息数
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {

    UWRongCloudUserModel *userModel = [UWRongCloudSqlTool getUserInfoWithUserId:userId];

    RCUserInfo *rcUser = [[RCUserInfo alloc] init];
    rcUser.userId = userId;
    rcUser.name = userModel.name;
    rcUser.portraitUri = userModel.portrait;
    return completion(rcUser);
}

#pragma mark - 业务API

- (void)addPrivateConversationVieController:(UWRongCloudUserModel *)userModel
                                 completion:(void (^)(RCConversationViewController *conversationVC))
                                                completion {
    BOOL isSuccess = [UWRongCloudSqlTool insertUserInfoWithUserInfoModel:userModel];
    if (isSuccess) {
        NSLog(@"保存数据成功");
    }

    UWChatViewController *conversationVC = [[UWChatViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = userModel.userId;
    conversationVC.userName = userModel.name;
    conversationVC.title = userModel.portrait;

    if (completion) {
        completion(conversationVC);
    }
}

@end
