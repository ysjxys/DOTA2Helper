//
//  NSNumber+YSJ.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "NSNumber+YSJ.h"

@implementation NSNumber (YSJ)

/**
 *  输入formatterStr，返回转化自1970零时起的秒数日期
 */
- (NSString *)since1970NumStrWithFormatter:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = formatterStr;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self longValue]];
    return [formatter stringFromDate:date];
}

/**
 *  返回转化自1970零时起的秒数日期
 *  默认formatter为@"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)since1970NumStrWithDefaultFormatterStr{
    return [self since1970NumStrWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

@end
