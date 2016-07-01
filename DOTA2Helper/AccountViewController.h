//
//  AccountViewController.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/20.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
@class AccountItem;
@interface AccountViewController : YSJViewController


- (instancetype)initWithAccountItem:(AccountItem *)accountItem shouldShowMatches:(BOOL)shouldShowMatches;
- (instancetype)init;
@end
