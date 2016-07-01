//
//  NSDate+ysjDate.m
//  ysjLib
//
//  Created by ysj on 15/12/4.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import "NSDate+YSJ.h"
#define ONEMINUTESECONDS 60
#define ONEHOURMINUTES 60
#define ONEDAYHOURS 24


@implementation NSDate (YSJ)

/**
 *  输入formatterStr，返回对应格式转化后的NSString
 */
- (NSString *)dateToStringWithFormatterStr:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = formatterStr;
    return [formatter stringFromDate:self];
}

/**
 *  返回默认formatter的对应NSString
 *  默认formatter为@"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)dateToStringWithDefaultFormatterStr{
    return [self dateToStringWithFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 *  返回自现在开始dayNum天后的日期
 */
+ (NSDate *)dateSinceNowWithDaysLater:(NSTimeInterval)dayNum{
    return [self dateWithTimeIntervalSinceNow:dayNum*ONEMINUTESECONDS*ONEHOURMINUTES*ONEDAYHOURS];
}

/**
 *  返回自现在开始hourNum小时后的日期
 */
+ (NSDate *)dateSinceNowWithHoursLater:(NSTimeInterval)hourNum{
    return [self dateWithTimeIntervalSinceNow:hourNum*ONEMINUTESECONDS*ONEHOURMINUTES];
}

/**
 *  返回自现在开始minNum分钟后的日期
 */
+ (NSDate *)dateSinceNowWithMinutesLater:(NSTimeInterval)minNum{
    return [self dateWithTimeIntervalSinceNow:minNum*ONEMINUTESECONDS];
}

/**
 *  返回自现在开始secNum秒后的日期
 */
+ (NSDate *)dateSinceNowWithSecondsLater:(NSTimeInterval)secNum{
    return [self dateWithTimeIntervalSinceNow:secNum];
}

/**
 *  返回从referenceDate开始dayNum天后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithDaysLater:(NSTimeInterval)dayNum{
    return [self dateWithTimeInterval:dayNum*ONEMINUTESECONDS*ONEHOURMINUTES*ONEDAYHOURS sinceDate:date];
}

/**
 *  返回从referenceDate开始hourNum小时后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithHoursLater:(NSTimeInterval)hourNum{
    return [self dateWithTimeInterval:hourNum*ONEMINUTESECONDS*ONEHOURMINUTES sinceDate:date];
}

/**
 *  返回从referenceDate开始minNum分钟后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithMinutesLater:(NSTimeInterval)minNum{
    return [self dateWithTimeInterval:minNum*ONEMINUTESECONDS sinceDate:date];
}

/**
 *  返回从referenceDate开始secNum秒后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithSecondsLater:(NSTimeInterval)secNum{
    return [self dateWithTimeInterval:secNum sinceDate:date];
}

/**
 *  比较两个时间的时间差，差值以秒数返回；
 *  比较过程为self-date，若self时间较早，返回的为负数
 */
- (NSTimeInterval)compareTimeToAnotherDate:(NSDate *)date{
    return self.timeIntervalSince1970 - date.timeIntervalSince1970;
}
@end
