//
//  UWRongCloudUserModel.h
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UWRongCloudUserModel : NSObject

/** 主键 */
@property (nonatomic, copy) NSString *userId;

/** 昵称 */
@property (nonatomic, copy) NSString *nickName;

/** 头像 */
@property (nonatomic, copy) NSString *avatarFile;

@end
