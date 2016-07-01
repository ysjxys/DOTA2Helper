//
//  YSJAlertView.h
//  ysjLib
//
//  Created by ysj on 16/5/16.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectOption)(NSInteger);

@interface YSJAlertView : UIAlertView

@property (nonatomic, copy) SelectOption selectOption;

@end
