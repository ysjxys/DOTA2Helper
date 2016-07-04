//
//  MatchSummary.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "MatchSummary.h"
#import "NSObject+YSJ.h"

@implementation MatchSummary

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if ([dic[@"match_id"] isNotEmpty]) {
            self.matchId = [NSString stringWithFormat:@"%@",dic[@"match_id"]];
        }
        if ([dic[@"radiant_win"] isNotEmpty]) {
            self.radiantWin = [dic[@"radiant_win"] intValue] == 0?NO:YES;
        }
        if ([dic[@"start_time"] isNotEmpty]) {
            self.startTime = dic[@"start_time"];
        }
        if ([dic[@"duration"] isNotEmpty]) {
            self.matchDuration = dic[@"duration"];
        }
        if ([dic[@"match_seq_num"] isNotEmpty]) {
            self.macthSeqNum = [NSString stringWithFormat:@"%@",dic[@"match_seq_num"]];
        }
        if ([dic[@"first_blood_time"] isNotEmpty]) {
            self.fbTime = dic[@"first_blood_time"];
        }
        if ([dic[@"game_mode"] isNotEmpty]) {
            int matchMode = [dic[@"game_mode"] intValue];
            if (matchMode == 1) {
                self.gameMode = @"全阵营选择";
            }else if (matchMode == 2){
                self.gameMode = @"队长模式";
            }else if (matchMode == 3){
                self.gameMode = @"随机征召";
            }else if (matchMode == 4){
                self.gameMode = @"个别征召";
            }else if (matchMode == 22){
                self.gameMode = @"天梯匹配";
            }else{
                self.gameMode = [NSString stringWithFormat:@"%d",matchMode];
            }
        }
        if ([dic[@"radiant_score"] isNotEmpty]) {
            self.radiantScore = dic[@"radiant_score"];
        }
        if ([dic[@"dire_score"] isNotEmpty]) {
            self.direScore = dic[@"dire_score"];
        }
    }
    return self;
}

+ (instancetype)summaryWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
@end
