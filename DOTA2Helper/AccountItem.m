//
//  AccountItem.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "AccountItem.h"
#import "NSObject+YSJ.h"
#import "NSNumber+YSJ.h"

@implementation AccountItem

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if ([dic[@"steamid"] isNotEmpty]) {
            self.steamId64bit = dic[@"steamid"];
            self.steamId32bit = [NSString stringWithFormat:@"%lld",[self.steamId64bit longLongValue] - Steam64BitCalculateConstant];
        }
        if ([dic[@"personaname"] isNotEmpty]) {
            self.personName = dic[@"personaname"];
            self.title = self.personName;
        }
        if ([dic[@"timecreated"] isNotEmpty]) {
            self.createdTime = dic[@"timecreated"];
        }
        if ([dic[@"lastlogoff"] isNotEmpty]) {
            self.lastLoginTime = dic[@"lastlogoff"];
            self.desc = [self.lastLoginTime since1970NumStrWithFormatter:@"yyyy-MM-dd HH:mm"];
        }
        if ([dic[@"avatarfull"] isNotEmpty]) {
            self.iconImgUrl = dic[@"avatarfull"];
            self.leftImgUrlStr = self.iconImgUrl;
        }
        if ([dic[@"profileurl"] isNotEmpty]) {
            self.profileUrl = dic[@"profileurl"];
        }
        self.rightViewType = rightViewTypeArrow;
    }
    return self;
}

+ (instancetype)itemWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end
