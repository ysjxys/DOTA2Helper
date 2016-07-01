//
//  UIBarButtonItem+YSJ.h
//  ysjLib
//
//  Created by ysj on 16/5/16.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YSJ)

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton，frame为image的frame
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets higlightedImage:(UIImage *)higlightedImage target:(id)target action:(SEL)action;

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets bounds:(CGRect)frame higlightedImage:(UIImage *)higlightedImage target:(id)target action:(SEL)action;

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton 根据title设置button标题
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title color:(UIColor *)color bounds:(CGRect)bound  target:(id)target action:(SEL)action;


@end
