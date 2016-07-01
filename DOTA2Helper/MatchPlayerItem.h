//
//  MatchPlayerItem.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTableViewCellBasicItem.h"
@class AccountItem;

@interface MatchPlayerItem : NSObject

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, strong) NSNumber *playerSlot;
@property (nonatomic, copy) NSString *heroId;
@property (nonatomic, strong) NSNumber *kills;
@property (nonatomic, strong) NSNumber *deaths;
@property (nonatomic, strong) NSNumber *assists;
@property (nonatomic, strong) NSNumber *lastHits;
@property (nonatomic, strong) NSNumber *denies;
@property (nonatomic, strong) NSNumber *gpm;
@property (nonatomic, strong) NSNumber *xpm;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *towerDamage;
@property (nonatomic, strong) NSNumber *heroDamage;
@property (nonatomic, strong) NSNumber *heroHealing;
@property (nonatomic, copy) NSArray *itemsArr;
@property (nonatomic, assign) BOOL isRadiant;
@property (nonatomic, strong) AccountItem *accountItem;

- (instancetype)initWitdDic:(NSDictionary *)dic;
+ (instancetype)playerItemWithDic:(NSDictionary *)dic;

@end
