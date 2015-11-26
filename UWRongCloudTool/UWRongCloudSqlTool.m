//
//  UWRongCloudSqlTool.m
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import "UWRongCloudSqlTool.h"
#import "UWRongCloudUserModel.h"
#import "UWDBManager.h"

@implementation UWRongCloudSqlTool

/**
 *  插入一条用户信息
 *
 *  @param userModel 用户信息model
 *
 *  @return 成功或失败
 */
+ (BOOL)insertUserInfoWithUserInfoModel:(UWRongCloudUserModel *)userModel {
    FMDatabase *database = [UWDBManager getDatabase];
    if (![database open]) {
        return NO;
    }

    NSString *selectSql = [NSString
        stringWithFormat:@"select * from t_rcuser where userId = %d", [userModel.userId intValue]];

    FMResultSet *result = [database executeQuery:selectSql];

    if ([result next]) {
        NSString *updateSql = [NSString
            stringWithFormat:
                @"update t_rcuser set nickName = '%@',avatarFile = '%@' where userId = %d",
                userModel.nickName, userModel.avatarFile, [userModel.userId intValue]];

        BOOL updateResult = [database executeUpdate:updateSql];

        return updateResult;
    } else {
        NSString *sql = [NSString
            stringWithFormat:
                @"insert into t_rcuser (userId,nickName,avatarFile) values (%d,'%@','%@')",
                [userModel.userId intValue], userModel.nickName, userModel.avatarFile];

        BOOL result = [database executeUpdate:sql];

        if (result) {
            NSLog(@"用户数据插入成功");
        }

        return result;
    }
}

/**
 *  通过用户id获得一条用户信息
 *
 *  @param userId 用户id
 *
 *  @return 用户信息model
 */
+ (UWRongCloudUserModel *)getUserInfoWithUserId:(NSString *)userId {
    FMDatabase *database = [UWDBManager getDatabase];
    NSString *sql =
        [NSString stringWithFormat:@"select * from t_rcuser where userId = %d", [userId intValue]];

    FMResultSet *result = [database executeQuery:sql];

    UWRongCloudUserModel *userInfoModel = [[UWRongCloudUserModel alloc] init];

    while ([result next]) {
        userInfoModel.userId = [result stringForColumn:@"userId"];
        userInfoModel.nickName = [result stringForColumn:@"nickName"];
        userInfoModel.avatarFile = [result stringForColumn:@"avatarFile"];
    }
    return userInfoModel;
}

+ (BOOL)deleteAllUserInfo {
    FMDatabase *database = [UWDBManager getDatabase];

    NSString *sql = [NSString stringWithFormat:@"delete from t_rcuser"];

    BOOL isSucess = [database executeUpdate:sql];

    return isSucess;
}

@end
