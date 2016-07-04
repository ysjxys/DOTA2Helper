//
//  MatchSummary.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchSummary : NSObject

@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, assign) BOOL radiantWin;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *matchDuration;
@property (nonatomic, copy) NSString *macthSeqNum;
@property (nonatomic, strong) NSNumber *fbTime;
@property (nonatomic, copy) NSString *gameMode;
@property (nonatomic, strong) NSNumber *radiantScore;
@property (nonatomic, strong) NSNumber *direScore;
@property (nonatomic, assign) int radiantKillCount;
@property (nonatomic, assign) int direKillCount;
@property (nonatomic, assign) int radiantHeroDamage;
@property (nonatomic, assign) int direHeroDamage;
@property (nonatomic, assign) int radiantExpCount;
@property (nonatomic, assign) int direExpCount;
@property (nonatomic, assign) int radiantGoldCount;
@property (nonatomic, assign) int direGoldCount;
@property (nonatomic, assign) int radiantDeathCount;
@property (nonatomic, assign) int direDeathCount;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)summaryWithDic:(NSDictionary *)dic;


@end
