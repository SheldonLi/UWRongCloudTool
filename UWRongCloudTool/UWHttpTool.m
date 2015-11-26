//
//  UWHttpTool.m
//  uworks-library
//
//  Created by SheldonLee on 15/10/30.
//  Copyright © 2015年 U-Works. All rights reserved.
//

#import "UWHttpTool.h"
#import <AFNetworking.h>

#define KEY_HTTP_TOKEN_FIELD      @"X-Access-Token"

#define BaseURL @"http://whojoin-appserver-dev.obaymax.com"

@implementation UWHttpTool

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            success(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (failure) {
            success(error);
        }
    }];
}


@end
