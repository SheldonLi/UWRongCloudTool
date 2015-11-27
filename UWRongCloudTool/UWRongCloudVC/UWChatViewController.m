//
//  UWChatViewController.m
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import "UWChatViewController.h"

@interface UWChatViewController ()

@end

@implementation UWChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

@end
