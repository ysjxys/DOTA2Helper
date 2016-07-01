//
//  YSJNavigationController.h
//  ysjLib
//
//  Created by ysj on 16/5/17.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSJNavigationController : UINavigationController
/**
 *  设置背景图
 */
- (void)setBackGroundImage:(UIImage *)image;

/**
 *  设置标题颜色与字体
 */
- (void)setNavigationTitleColor:(UIColor *)color font:(UIFont *)font;

@end
