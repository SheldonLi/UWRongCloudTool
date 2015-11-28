//
//  UWConversationListViewController.m
//  UWRongCloudTool
//
//  Created by SheldonLee on 15/11/26.
//  Copyright © 2015年 Sheldon. All rights reserved.
//

#import "UWConversationListViewController.h"
#import "UWChatViewController.h"
#import "UWHttpTool.h"
#import "UWRongCloudTool.h"

@implementation UWConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDisplayConversationTypes:@[ @(ConversationType_PRIVATE) ]];
    [self setTableViewStatus];
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"聊天列表";
        self.displayConversationTypeArray = @[ @(ConversationType_PRIVATE) ];
        [self jsutLogin];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (![[UWRongCloudTool sharedTool] isConnecting]) {
        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"未连接上融云，请重试 "
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)jsutLogin {
    [UWHttpTool getWithURL:@"/user/imLisi"
        params:nil
        success:^(id operation, id responseObject) {
            NSLog(@"%@", responseObject);
            if (responseObject) {
                NSString *imToken = responseObject[@"imToken"];
                [[UWRongCloudTool sharedTool] connectWithToken:imToken];
            }
        }
        failure:^(id operation, NSError *error) {
            NSLog(@"%@", error);
        }];
}

//重载函数，onSelectedTableRow
//是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    UWChatViewController *conversationVC = [[UWChatViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName = model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

/**
 *  设置聊天列表样式
 */
- (void)setTableViewStatus {
    self.conversationListTableView.frame =
        CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.conversationListTableView.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
}

/**
 *  重写列表为空的视图
 */
- (void)showEmptyConversationView {
    UIView *blankView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blankView.backgroundColor = [UIColor whiteColor];

    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = @"没有聊天记录";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont systemFontOfSize:15];
    emptyLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    emptyLabel.center = self.view.center;

    [blankView addSubview:emptyLabel];
    self.emptyConversationView = blankView;
    [self.view addSubview:self.emptyConversationView];
}

@end
