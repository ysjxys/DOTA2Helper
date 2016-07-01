//
//  Item.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "Item.h"
#import "NSObject+YSJ.h"

@implementation Item

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if ([dic[@"id"] isNotEmpty]) {
            self.itemId = [NSString stringWithFormat:@"%@", dic[@"id"]];
        }
        if ([dic[@"name"] isNotEmpty]) {
            self.name = dic[@"name"];
        }
        if ([dic[@"localized_name"] isNotEmpty]) {
            self.localizedName = dic[@"localized_name"];
        }
        if ([dic[@"recipe"] isNotEmpty]) {
            self.isRecipe = [dic[@"recipe"] intValue] == 0 ?NO:YES;
        }
        if ([dic[@"cost"] isNotEmpty]) {
            self.cost = dic[@"cost"];
        }
        if ([dic[@"secret_shop"] isNotEmpty]) {
            self.isInSecretShop = [dic[@"secret_shop"] intValue] == 0?NO:YES;
        }
        if ([dic[@"side_shop"] isNotEmpty]) {
            self.isInSideShop = [dic[@"side_shop"] intValue] == 0?NO:YES;
        }
    }
    return self;
}

+ (instancetype)itemWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
@end
