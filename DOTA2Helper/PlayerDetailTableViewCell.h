//
//  PlayerDetailTableViewCell.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MatchPlayerItem;
@class MatchSummary;
@class AccountItem;

@protocol PlayerDetailTableViewCellDelegate <NSObject>

- (void)playerHeadSelected:(AccountItem *)accountItem;

@end

@interface PlayerDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PlayerDetailTableViewCellDelegate> delegate;


+ (instancetype)cellWithTableView:(UITableView *)tableView playerItem:(MatchPlayerItem *)playerItem matchSummary:(MatchSummary *)matchSummary;

- (void)changeBottomViewToHide;
- (void)changeBottomViewToShow;
- (void)setNameColorIsRadiant:(BOOL)isRadiant;

@end
