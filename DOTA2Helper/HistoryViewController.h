//
//  HistoryViewController.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
#import "LeftViewController.h"
@class AccountItem;

@interface HistoryViewController : YSJViewController
<LeftViewControllerDelegate>

- (instancetype)init;
- (instancetype)initWithAccountItem:(AccountItem *)accountItem;
@end
