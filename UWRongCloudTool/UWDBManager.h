//
//  UWDBManager.h
//  uworks-library
//
//  Created by SheldonLee on 15/10/10.
//  Copyright © 2015年 U-Works. All rights reserved.
//
//  封装FMDB工具类


#import <Foundation/Foundation.h>
#import <FMDB.h>

@class FMDatabase;


@interface UWDBManager : NSObject

/**
 *  获取数据库
 */
+ (FMDatabase *)getDatabase;

/**
 *  关闭数据库
 */
- (void)close;

/**
 *  返回数据库查询结果
 *
 *  @param dataBase 数据库对象
 *  @param query    查询语句
 *
 *  @return 返回字典数组
 */
- (NSArray *)resultArrayForDataBase:(FMDatabase *)dataBase executeQuery:(NSString *)query;

@end
