//
//  MatchPlayerItem.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "MatchPlayerItem.h"
#import "NSObject+YSJ.h"

@implementation MatchPlayerItem

- (instancetype)initWitdDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if ([dic[@"account_id"] isNotEmpty]) {
            self.accountId = [NSString stringWithFormat:@"%@",dic[@"account_id"]];
        }
        if ([dic[@"player_slot"] isNotEmpty]) {
            self.playerSlot = dic[@"player_slot"];
        }
        if ([dic[@"hero_id"] isNotEmpty]) {
            self.heroId = [NSString stringWithFormat:@"%@",dic[@"hero_id"]];
        }
        if ([dic[@"kills"] isNotEmpty]) {
            self.kills = dic[@"kills"];
        }
        if ([dic[@"deaths"] isNotEmpty]) {
            self.deaths = dic[@"deaths"];
        }
        if ([dic[@"assists"] isNotEmpty]) {
            self.assists = dic[@"assists"];
        }
        if ([dic[@"last_hits"] isNotEmpty]) {
            self.lastHits = dic[@"last_hits"];
        }
        if ([dic[@"denies"] isNotEmpty]) {
            self.denies = dic[@"denies"];
        }
        if ([dic[@"gold_per_min"] isNotEmpty]) {
            self.gpm = dic[@"gold_per_min"];
        }
        if ([dic[@"xp_per_min"] isNotEmpty]) {
            self.xpm = dic[@"xp_per_min"];
        }
        if ([dic[@"level"] isNotEmpty]) {
            self.level = dic[@"level"];
        }
        if ([dic[@"tower_damage"] isNotEmpty]) {
            self.towerDamage = dic[@"tower_damage"];
        }
        if ([dic[@"hero_damage"] isNotEmpty]) {
            self.heroDamage = dic[@"hero_damage"];
        }
        if ([dic[@"hero_healing"] isNotEmpty]) {
            self.heroHealing = dic[@"hero_healing"];
        }
        self.itemsArr = @[[NSString stringWithFormat:@"%@",dic[@"item_0"]],
                          [NSString stringWithFormat:@"%@",dic[@"item_1"]],
                          [NSString stringWithFormat:@"%@",dic[@"item_2"]],
                          [NSString stringWithFormat:@"%@",dic[@"item_3"]],
                          [NSString stringWithFormat:@"%@",dic[@"item_4"]],
                          [NSString stringWithFormat:@"%@",dic[@"item_5"]]];
    }
    return self;
}

+ (instancetype)playerItemWithDic:(NSDictionary *)dic{
    return [[self alloc]initWitdDic:dic];
}
@end
