//
//  YSJTableViewCellBasicItem.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTableViewCellBasicItem.h"
@interface YSJTableViewCellBasicItem()

@end

@implementation YSJTableViewCellBasicItem

+ (instancetype)itemWithTitle:(NSString *)title desc:(NSString *)desc rightViewType:(RightViewType)rightViewType{
    YSJTableViewCellBasicItem *basicItem = [[YSJTableViewCellBasicItem alloc]init];
    basicItem.title = title;
    basicItem.desc = desc;
    basicItem.rightViewType = rightViewType;
    return basicItem;
}

@end
