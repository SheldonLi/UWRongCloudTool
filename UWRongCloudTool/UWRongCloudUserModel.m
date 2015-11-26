//
//  UWRongCloudUserModel.m
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import "UWRongCloudUserModel.h"

@implementation UWRongCloudUserModel

- (NSString *)description {
    return [NSString stringWithFormat:@"userId:%@  nickName:%@  avatarFile:%@ ", _userId, _nickName,
            _avatarFile];
}

@end
