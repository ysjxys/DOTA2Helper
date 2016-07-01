//
//  Item.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *localizedName;
@property (nonatomic, assign) BOOL isRecipe;
@property (nonatomic, strong) NSNumber *cost;
@property (nonatomic, assign) BOOL isInSecretShop;
@property (nonatomic, assign) BOOL isInSideShop;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)itemWithDic:(NSDictionary *)dic;

@end
