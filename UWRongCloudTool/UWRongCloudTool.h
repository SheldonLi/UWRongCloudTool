//
//  UWRongCloudTool.h
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
@class UWRongCloudUserModel;

@interface UWRongCloudTool : NSObject

+ (UWRongCloudTool *)sharedTool;

- (void)connectWithToken:(NSString *)token;

- (void)connectWithToken:(NSString *)token userModel:(id)userModel;

- (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))success
                   error:(void (^)(RCConnectErrorCode status))error
          tokenIncorrect:(void (^)())tokenIncorrect;

/**
 *  断开连接
 */
- (void)rongCloudLogOut;

- (void)addPrivateConversationVieController:(UWRongCloudUserModel *)userModel
                                 completion:(void (^)(RCConversationViewController *conversationVC))
                                                completion;

@end
