//
//  Dota2HelperCommonTools.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dota2HelperCommonTools : NSObject

+ (Dota2HelperCommonTools *)shareTools;

- (void)setHerosDic:(NSDictionary *)herosDic;
- (void)setItemsDic:(NSDictionary *)itemsDic;
- (void)setLovePlayerArr:(NSArray *)loveArr;

- (NSDictionary *)herosDic;
- (NSDictionary *)itemsDic;
- (NSArray *)lovePlayerArr;
@end
