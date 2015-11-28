//
//  UWHttpTool.m
//  uworks-library
//
//  Created by SheldonLee on 15/10/30.
//  Copyright © 2015年 U-Works. All rights reserved.
//

#import "UWHttpTool.h"
#import <AFNetworking.h>

//#define BaseURL @"http://localhost:8081"
//#define BaseURL @"http://192.168.10.150:8081"
#define BaseURL @"http://10.0.2.73:8081"

@implementation UWHttpTool

+ (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(successBlock)success
           failure:(failureBlock)failure {
    AFHTTPRequestOperationManager *manager =
        [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:url
        parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"1111111------");
            if (success) {
                success(responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"222222-------");
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(successBlock)success
            failure:(failureBlock)failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager =
        [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:url
        parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

@end
