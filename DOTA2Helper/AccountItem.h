//
//  AccountItem.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTableViewCellBasicItem.h"

@interface AccountItem : YSJTableViewCellBasicItem

@property (nonatomic, copy) NSString *steamId32bit;
@property (nonatomic, copy) NSString *steamId64bit;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, strong) NSNumber *createdTime;
@property (nonatomic, strong) NSNumber *lastLoginTime;
@property (nonatomic, copy) NSString *iconImgUrl;
@property (nonatomic, copy) NSString *profileUrl;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)itemWithDic:(NSDictionary *)dic;
@end
