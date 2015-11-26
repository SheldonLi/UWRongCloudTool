//
//  UWRongCloudSqlTool.h
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UWRongCloudUserModel;

@interface UWRongCloudSqlTool : NSObject

/**
 *  插入一条用户信息
 *
 *  @param userModel 用户信息model
 *
 *  @return 成功或失败
 */
+ (BOOL)insertUserInfoWithUserInfoModel:(UWRongCloudUserModel *)userModel;

/**
 *  通过用户id获得一条用户信息
 *
 *  @param userId 用户id
 *
 *  @return 用户信息model
 */
+ (UWRongCloudUserModel *)getUserInfoWithUserId:(NSString *)userId;

/**
 *  删除所有用户信息
 *
 *  @return bool
 */
+ (BOOL)deleteAllUserInfo;

@end
