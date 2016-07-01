//
//  Hero.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hero : NSObject

@property (nonatomic, copy) NSString *localizedName;
@property (nonatomic, copy) NSString *heroId;
@property (nonatomic, copy) NSString *name;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)heroWithDic:(NSDictionary *)dic;

@end
