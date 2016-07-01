//
//  Hero.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "Hero.h"
#import "NSObject+YSJ.h"

@implementation Hero

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if ([dic[@"id"] isNotEmpty]) {
            self.heroId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        }
        if ([dic[@"localized_name"] isNotEmpty]) {
            self.localizedName = dic[@"localized_name"];
        }
        if ([dic[@"name"] isNotEmpty]) {
            self.name = dic[@"name"];
        }
    }
    return self;
}

+ (instancetype)heroWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end
