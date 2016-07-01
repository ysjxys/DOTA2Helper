//
//  NSDate+ysjDate.h
//  ysjLib
//
//  Created by ysj on 15/12/4.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YSJ)

/**
 *  输入formatterStr，返回对应格式转化后的NSString
 */
- (NSString *)dateToStringWithFormatterStr:(NSString *)formatterStr;

/**
 *  返回默认formatter的对应NSString
 *  默认formatter为@"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)dateToStringWithDefaultFormatterStr;

/**
 *  返回自现在开始dayNum天后的日期
 */
+ (NSDate *)dateSinceNowWithDaysLater:(NSTimeInterval)dayNum;

/**
 *  返回自现在开始hourNum小时后的日期
 */
+ (NSDate *)dateSinceNowWithHoursLater:(NSTimeInterval)hourNum;

/**
 *  返回自现在开始minNum分钟后的日期
 */
+ (NSDate *)dateSinceNowWithMinutesLater:(NSTimeInterval)minNum;

/**
 *  返回自现在开始secNum秒后的日期
 */
+ (NSDate *)dateSinceNowWithSecondsLater:(NSTimeInterval)secNum;

/**
 *  返回从referenceDate开始dayNum天后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithDaysLater:(NSTimeInterval)dayNum;

/**
 *  返回从referenceDate开始hourNum小时后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithHoursLater:(NSTimeInterval)hourNum;

/**
 *  返回从referenceDate开始minNum分钟后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithMinutesLater:(NSTimeInterval)minNum;

/**
 *  返回从referenceDate开始secNum秒后的日期
 */
+ (NSDate *)dateSinceDate:(NSDate *)date WithSecondsLater:(NSTimeInterval)secNum;


/**
 *  比较两个时间的时间差，差值以秒数返回；
 *  比较过程为self-date，若self时间较早，返回的为负数
 */
- (NSTimeInterval)compareTimeToAnotherDate:(NSDate *)date;

@end
