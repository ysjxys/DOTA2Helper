//
//  MatchItem.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "MatchItem.h"
#import "NSObject+YSJ.h"
#import "AccountItem.h"
#import "NSDate+YSJ.h"
#import "Dota2HelperCommonTools.h"
#import "Hero.h"

@implementation MatchItem

+ (instancetype)itemWithDic:(NSDictionary *)dic AccountItem:(AccountItem *)accountItem{
    return [[self alloc]initWithDic:dic AccountItem:accountItem];
}

- (instancetype)initWithDic:(NSDictionary *)dic AccountItem:(AccountItem *)accountItem{
    if (self = [super init]) {
        if ([dic[@"match_id"] isNotEmpty]) {
            self.matchId = [NSString stringWithFormat:@"%@",dic[@"match_id"]];
        }
        if ([dic[@"start_time"] isNotEmpty]) {
            self.startTime = dic[@"start_time"];
            self.desc = [self timeAgoStr:[self.startTime doubleValue]];
        }
        /*
         lobby_type:
         -1 - Invalid               无效的
         0 - Public matchmaking     全阵营选择
         1 - Practise
         2 - Tournament             锦标赛
         3 - Tutorial
         4 - Co-op with bots.       机器人练习赛
         5 - Team match             队长模式
         6 - Solo Queue
         7 - Ranked Matchmaking     天梯匹配
         8 - 1v1 Solo Mid           中路1v1
         */
        if ([dic[@"lobby_type"] isNotEmpty]) {
            self.lobbyType = dic[@"lobby_type"];
        }
        if ([dic[@"players"] isNotEmpty]) {
            self.players = dic[@"players"];
        }
        if (accountItem) {
            self.title = accountItem.title;
            self.leftImgUrlStr = accountItem.leftImgUrlStr;
            self.playerId = accountItem.steamId32bit;
            
            for (NSDictionary *playerDic in self.players) {
                if ([[NSString stringWithFormat:@"%@",[playerDic objectForKey:@"account_id"]] isEqualToString:self.playerId]) {
                    self.heroId = [NSString stringWithFormat:@"%@",[playerDic objectForKey:@"hero_id"]];
                    break;
                }
            }
            Hero *hero = [[[Dota2HelperCommonTools shareTools] herosDic] objectForKey:self.heroId];
            self.rightImgUrlStr = HeroImgUrlStr(hero.name);
            self.rightViewType = rightViewTypeImgview;
        }
    }
    return self;
}

- (NSString *)timeAgoStr:(double)time{
    double second = [[NSDate date] compareTimeToAnotherDate:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *ageStr;
    if (second/(60*60*24*365) > 1) {
        if (second/(60*60*24*365) > 2) {
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*365), Key(@"yearsAgo")];
        }else{
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*365), Key(@"yearAgo")];
        }
    }else if (second/(60*60*24*30) > 1){
        if (second/(60*60*24*30) > 2) {
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*30), Key(@"monthsAgo")];
        }else{
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*30), Key(@"monthAgo")];
        }
    }else if (second/(60*60*24) > 1){
        if (second/(60*60*24) > 2) {
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24), Key(@"daysAgo")];
        }else{
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24), Key(@"dayAgo")];
        }
    }else if (second/(60*60) > 1){
        if (second/(60*60) > 2) {
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60), Key(@"hoursAgo")];
        }else{
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60*60), Key(@"hourAgo")];
        }
    }else{
        if (second/(60) > 2) {
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60), Key(@"minutesAgo")];
        }else{
            ageStr = [NSString stringWithFormat:@"%.0lf%@", second/(60), Key(@"minuteAgo")];
        }
    }
    return ageStr;
}

@end
