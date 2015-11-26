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

- (void)connectWithToken:(NSString *)token {
    [self connectWithToken:token success:nil error:nil tokenIncorrect:nil];
}

- (void)connectWithToken:(NSString *)token userModel:(id)userModel {
    // TODO: 怎么设置通用的用户model
}

- (void)connectWithToken:(NSString *)token
                        success:(void (^)(NSString *userId))success
                          error:(void (^)(RCConnectErrorCode status))error
                 tokenIncorrect:(void (^)())tokenIncorrect {
    RCIM *rcim = [RCIM sharedRCIM];
    NSLog(@"%@", rcim.currentUserInfo);
    if (rcim.connectionStatusDelegate) {
        return;
    }
    [rcim initWithAppKey:RONGCLOUD_IM_APPKEY];

    //    注册自定义消息
    //    [rcim registerMessageType:BizCardMessageContent.class];

    [rcim connectWithToken:token
        success:^(NSString *userId) {
            NSLog(@"连接融云成功");
            //  设置返回用户信息代理
            [rcim setUserInfoDataSource:self];
            //  设置接收消息代理
            [rcim setReceiveMessageDelegate:self];
            //  设置网络连接状态
            [rcim setConnectionStatusDelegate:self];
            //  设置消息包含用户信息
            rcim.enableMessageAttachUserInfo = YES;

            rcim.globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
            rcim.globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;

            //                       AKChatUserModel *userModel = [[AKChatUserModel alloc] init];
            //                       userModel.userId = userId;
            //                       userModel.nickName = [StoreData storeObjectForKey:KEY_NAME];
            //                       userModel.avatarFile = [StoreData
            //                       storeObjectForKey:KEY_AVATAR];
            //                       BOOL isSuccess = [DCRongCloudSqlTool
            //                       insertUserInfoWithUserInfoModel:userModel];
            //                       if (isSuccess) {
            //                           NSLog(@"储存用户自己信息成功");
            //                       }
            //
            //                       rcim.currentUserInfo = [[RCUserInfo alloc]
            //                       initWithUserId:userModel.userId
            //                                                                            name:userModel.nickName
            //                                                                        portrait:userModel.avatarFile];

        }
        error:^(RCConnectErrorCode status) {
            NSLog(@"连接融云失败");
        }
        tokenIncorrect:^() {
            NSLog(@"token无效");
        }];
}

/**
 *  断开连接
 */
- (void)rongCloudLogOut {
    [[RCIM sharedRCIM] disconnect];
}

/**
 *  网络状态变化。
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
 *  接收消息到消息后执行
 *
 *  @param message 接收到的消息
 *  @param left    剩余消息数
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    //    UIApplication *application = [UIApplication sharedApplication];
    //    [application setApplicationIconBadgeNumber:left];

    NSLog(@"%@", message);
    // 自定义消息
    if ([message.objectName isEqualToString:@"Robin:BizCardMessage"]) {
        [[RCIMClient sharedRCIMClient] deleteMessages:@[ @(message.messageId) ]];

    } else {
        UWRongCloudUserModel *userModel = [[UWRongCloudUserModel alloc] init];
        userModel.userId = message.content.senderUserInfo.userId;
        userModel.nickName = message.content.senderUserInfo.name;
        userModel.avatarFile = message.content.senderUserInfo.portraitUri;
        if (!userModel.userId) {
            return;
        }
        BOOL isSuccess = [UWRongCloudSqlTool insertUserInfoWithUserInfoModel:userModel];
        if (isSuccess) {
            NSLog(@"保存用户信息成功");
        }
    }
}

#pragma mark - setUserInfoDataSource delegate
/*
 * 此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"__%s,__%@", __func__, userId);

    UWRongCloudUserModel *userModel = [UWRongCloudSqlTool getUserInfoWithUserId:userId];

    RCUserInfo *rcUser = [[RCUserInfo alloc] init];
    rcUser.userId = userId;
    //???: 姓名，头像为空怎么处理
    rcUser.name = userModel.nickName;
    rcUser.portraitUri = userModel.avatarFile;
    return completion(rcUser);
}

#pragma mark - customFunction

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
    conversationVC.userName = userModel.nickName;
    conversationVC.title = userModel.nickName;

    if (completion) {
        completion(conversationVC);
    }
}

@end
