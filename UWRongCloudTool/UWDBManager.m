//
//  UWDBManager.m
//  uworks-library
//
//  Created by SheldonLee on 15/10/10.
//  Copyright © 2015年 U-Works. All rights reserved.
//

#import "UWDBManager.h"

#define DOCUMENT_PATH \
    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

static UWDBManager *_sharedDBmanager = nil;

@interface UWDBManager () {
    NSString *_fileName;
}

@end

@implementation UWDBManager

NSString *_dbPath;
FMDatabase *_dataBase;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *fileName = [NSString stringWithFormat:@"RongCloud.sqlite"];
        _dbPath = [DOCUMENT_PATH stringByAppendingPathComponent:fileName];
        _dataBase = [FMDatabase databaseWithPath:_dbPath];
        if (![_dataBase open]) {
            return;
        }
        
        NSString *sqlCreateTable =
        [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 't_rcuser' (userId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, portrait TEXT);"];
        BOOL result = [_dataBase executeUpdate:sqlCreateTable];
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    });


}

+ (BOOL)initDB {
    FMDatabase *dataBase = [[FMDatabase alloc] initWithPath:_dbPath];

    if ([dataBase open]) {
        return YES;
    } else {
        return NO;
    }
}

+ (FMDatabase *)getDatabase {
    //    return [self creatDatabaseWithPath:_dbPath];
    if (![_dataBase goodConnection]) {
        if ([self initDB]) {
            return _dataBase;
        } else {
            return nil;
        }
    } else {
        return _dataBase;
    }
}

#pragma mark - Query
- (NSArray *)resultArrayForDataBase:(FMDatabase *)dataBase executeQuery:(NSString *)query {
    NSMutableArray *resultArray = [NSMutableArray array];
    FMResultSet *resultSet;
    if ([dataBase open]) {
        resultSet = [dataBase executeQuery:query];
        // column包括主键
        int columnNum = resultSet.columnCount;
        while (resultSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:columnNum];
            for (int i = 0; i < columnNum; i++) {
                
                NSString *columnName = [resultSet columnNameForIndex:i];
                id columnValue = [resultSet objectForColumnIndex:i];
                [dict setObject:columnValue forKey:columnName];
            }
            if (dict) {
                [resultArray addObject:dict];
            }
        }
    }
    [dataBase close];
    return (NSArray *)resultArray;
}

/// 关闭连接
- (void)close {
    [_dataBase close];
    _sharedDBmanager = nil;
}

- (void)dealloc {
    [self close];
}

@end
