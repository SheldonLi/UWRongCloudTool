//
//  UWHttpTool.h
//  uworks-library
//
//  Created by SheldonLee on 15/10/30.
//  Copyright © 2015年 U-Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UWHttpTool : NSObject

typedef void (^successBlock)(id operation, id responseObject);
typedef void (^failureBlock)(id operation, NSError *error);

/**
 *  get请求
 *
 *  @param url     请求地址
 *  @param params  求情参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params  success:(successBlock)success failure:(failureBlock)failure;

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params  求情参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;




@end
