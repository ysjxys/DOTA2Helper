//
//  YSJNavigationController.m
//  ysjLib
//
//  Created by ysj on 16/5/17.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJNavigationController.h"

@implementation YSJNavigationController

/**
 *  设置背景图
 */
- (void)setBackGroundImage:(UIImage *)image{
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

/**
 *  设置标题颜色与字体
 */
- (void)setNavigationTitleColor:(UIColor *)color font:(UIFont *)font{
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color,                NSFontAttributeName:font};
//    [UIFont boldSystemFontOfSize:font]
}
@end
