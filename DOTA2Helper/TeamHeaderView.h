//
//  TeamHeaderView.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/16.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MatchSummary;

@interface TeamHeaderView : UIView

+ (instancetype)viewWithMatchSummary:(MatchSummary *)matchSummary isRadiant:(BOOL)isRadiant;

@end
