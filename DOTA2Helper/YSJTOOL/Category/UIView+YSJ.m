//
//  UIView+YSJ.m
//  ysjLib
//
//  Created by ysj on 15/12/4.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import "UIView+YSJ.h"

@implementation UIView (YSJ)
/**
 *  返回x坐标
 */
- (CGFloat)left{
    return self.frame.origin.x;
}

/**
 *  设置x坐标
 */
- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

/**
 *  返回y坐标
 */
- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

/**
 *  设置y坐标
 */
- (void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

/**
 *  返回顶部坐标
 */
- (CGFloat)top{
    return self.frame.origin.y;
}

/**
 *  设置顶部坐标
 */
- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

/**
 *  返回底部坐标
 */
- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

/**
 *  设置底部部坐标
 */
- (void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

/**
 *  返回中心点x坐标
 */
- (CGFloat)centerX{
    return self.center.x;
}

/**
 *  设置中心点x坐标
 */
- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

/**
 *  返回中心点y坐标
 */
- (CGFloat)centerY{
    return self.center.y;
}

/**
 *  设置中心点y坐标
 */
- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

/**
 *  返回宽度值
 */
- (CGFloat)width{
    return self.frame.size.width;
}

/**
 *  设置宽度值
 */
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/**
 *  返回高度值
 */
- (CGFloat)height{
    return self.frame.size.height;
}

/**
 *  设置高度值
 */
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/**
 *  返回原点值
 */
- (CGPoint)origin{
    return self.frame.origin;
}

/**
 *  设置原点值
 */
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/**
 *  返回原点值
 */
- (CGSize)size{
    return self.frame.size;
}

/**
 *  设置原点值
 */
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end
