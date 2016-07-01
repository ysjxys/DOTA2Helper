//
//  UIView+YSJ.h
//  ysjLib
//
//  Created by ysj on 15/12/4.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YSJ)

/**
 *  返回x坐标
 */
- (CGFloat)left;

/**
 *  设置x坐标
 */
- (void)setLeft:(CGFloat)left;

/**
 *  返回y坐标
 */
- (CGFloat)right;

/**
 *  设置y坐标
 */
- (void)setRight:(CGFloat)right;

/**
 *  返回顶部坐标
 */
- (CGFloat)top;

/**
 *  设置顶部坐标
 */
- (void)setTop:(CGFloat)top;

/**
 *  返回底部坐标
 */
- (CGFloat)bottom;

/**
 *  设置底部部坐标
 */
- (void)setBottom:(CGFloat)bottom;

/**
 *  返回中心点x坐标
 */
- (CGFloat)centerX;

/**
 *  设置中心点x坐标
 */
- (void)setCenterX:(CGFloat)centerX;

/**
 *  返回中心点y坐标
 */
- (CGFloat)centerY;

/**
 *  设置中心点y坐标
 */
- (void)setCenterY:(CGFloat)centerY;

/**
 *  返回宽度值
 */
- (CGFloat)width;

/**
 *  设置宽度值
 */
- (void)setWidth:(CGFloat)width;

/**
 *  返回高度值
 */
- (CGFloat)height;

/**
 *  设置高度值
 */
- (void)setHeight:(CGFloat)height;

/**
 *  返回原点值
 */
- (CGPoint)origin;

/**
 *  设置原点值
 */
- (void)setOrigin:(CGPoint)origin;

/**
 *  返回原点值
 */
- (CGSize)size;

/**
 *  设置原点值
 */
- (void)setSize:(CGSize)size;
@end
