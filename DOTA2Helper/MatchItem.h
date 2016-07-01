//
//  MatchItem.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTableViewCellBasicItem.h"
@class AccountItem;

@interface MatchItem : YSJTableViewCellBasicItem

@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, copy) NSString *lobbyType;
@property (nonatomic, copy) NSArray *players;
@property (nonatomic, copy) NSString *playerId;
@property (nonatomic, copy) NSString *heroId;

+ (instancetype)itemWithDic:(NSDictionary *)dic AccountItem:(AccountItem *)accountItem;
- (instancetype)initWithDic:(NSDictionary *)dic AccountItem:(AccountItem *)accountItem;


@end
