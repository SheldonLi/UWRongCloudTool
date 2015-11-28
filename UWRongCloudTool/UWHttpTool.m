//
//  UWHttpTool.m
//  uworks-library
//
//  Created by SheldonLee on 15/10/30.
//  Copyright © 2015年 U-Works. All rights reserved.
//

#import "UWHttpTool.h"
#import <AFNetworking.h>

#define KEY_HTTP_TOKEN_FIELD @"X-Access-Token"

//   网络静态参数设置
static NSTimeInterval const timeout = 30;
static NSString *const BaseURLString = @"http://10.0.2.73:8081";
// static NSString * const BaseURLString = @"http://localhost:8081";
// static NSString * const BaseURLString = @"http://192.168.10.150:8081";

@implementation UWHttpTool

+ (AFHTTPRequestOperationManager *)managerInit {
    //  初始化BaseUrl
    AFHTTPRequestOperationManager *manager =
        [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    //  JSON序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = timeout;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    //  请求头设置
    [manager.requestSerializer setValue:@"xxx" forHTTPHeaderField:KEY_HTTP_TOKEN_FIELD];
    //  cookies设置
    manager.requestSerializer.HTTPShouldHandleCookies = YES;

    return manager;
}

+ (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(successBlock)success
           failure:(failureBlock)failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [self managerInit];

    [manager GET:url
        parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (success) {
                success(operation, responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (failure) {
                failure(operation, error);
            }
        }];
}

+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(successBlock)success
            failure:(failureBlock)failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [self managerInit];

    [manager POST:url
        parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (success) {
                success(operation, responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (failure) {
                failure(operation, error);
            }
        }];
}

@end
