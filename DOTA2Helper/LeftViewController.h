//
//  LeftViewController.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
@protocol LeftViewControllerDelegate <NSObject>
- (void)userInputSteamID32Bit:(NSString *)SteamID32Bit;
@end

@interface LeftViewController : YSJViewController

@property (nonatomic, weak) id<LeftViewControllerDelegate> delegate;

@end
