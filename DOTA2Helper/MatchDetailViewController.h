//
//  MatchDetailViewController.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"

@interface MatchDetailViewController : YSJViewController


- (instancetype)init;
- (instancetype)initWithMatchId:(NSString *)matchId;
+ (instancetype)detailWithMatchID:(NSString *)matchId;

@end
