//
//  YSJViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
#import "MBProgressHUD.h"
#import "YSJNavigationController.h"
#import "UIImage+YSJ.h"

@interface YSJViewController ()

@end

@implementation YSJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat distance = 7.0f;
    titleBtn.frame = CGRectMake(distance, distance, NavigationBarHeight-distance*2, NavigationBarHeight-distance*2);
    [titleBtn setImage:[UIImage imageNamed:@"dota2Icon"] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dota2Icon"] forState:UIControlStateSelected];
    [titleBtn setImage:[UIImage imageNamed:@"dota2Icon"] forState:UIControlStateHighlighted];
    [titleBtn addTarget:self action:@selector(titleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *titleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dota2Icon"]];
//    
//    titleImgView.frame = CGRectMake(distance, distance, NavigationBarHeight-distance*2, NavigationBarHeight-distance*2);
//    titleImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = titleBtn;
    
    
    YSJNavigationController *nav = (YSJNavigationController *)self.navigationController;
    
    //设置标题颜色与字体
    [nav setNavigationTitleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17]];
    
    //设置背景颜色
    [nav setBackGroundImage:[UIImage imageWithColor:RGBA(38, 46, 56, 1)]];
    
    //设置返回键 颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置返回键文字内容
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    //设置statusbar style
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)titleBtnClicked{
    YSJLog(@"xxxx");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  显示hud
 */
+ (void)showHudWithTarget:(id)target title:(NSString *)title{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:[(UIViewController *)target view]];
    HUD.labelText = title;
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"X"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [[(UIViewController *)target view] addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5f);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

- (void)showHudWithTitle:(NSString *)title{
    [YSJViewController showHudWithTarget:self title:title];
}

@end
