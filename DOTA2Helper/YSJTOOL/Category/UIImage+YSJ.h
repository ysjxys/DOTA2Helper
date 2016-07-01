//
//  UIImage+YSJ.h
//  ysjLib
//
//  Created by ysj on 16/5/16.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YSJ)
/**
 *  根据颜色创建图片
 *
 *  @param color 需要图片的颜色
 *
 *  @return 相应颜色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  裁剪图片为圆形
 *
 *  @return 裁剪后的图片
 */
- (UIImage *)circleImage;
@end
