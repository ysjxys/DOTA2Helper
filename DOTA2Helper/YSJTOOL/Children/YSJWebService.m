//
//  YSJWebService.m
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJWebService.h"
#import "AFNetworking.h"
@interface YSJWebService()

@end
@implementation YSJWebService

+ (void)requestTarget:(id)target withUrl:(NSString *)urlStr isPost:(BOOL)isPost parameters:(NSDictionary *)params complete:(CompleteHandle)completeHandle fail:(FailHandle)failHandle{
    MBProgressHUD *hud;
    if (!target) {
        return;
    }else{
        hud = [[MBProgressHUD alloc]initWithView:[(UIViewController *)target view]];
        [[(UIViewController *)target view] addSubview:hud];
        [hud show:YES];
    }
    
    Reachability *reachabiltiy = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (!reachabiltiy.isReachable) {
        [hud removeFromSuperview];
        [self showHudWithTarget:target title:@"网络连接不可用"];
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    //输入拼装后的url
    [self printUrlInfo:params withUrl:urlStr];
    
    if (isPost) {
        [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            //获取到目前的数据请求的进度
            NSLog(@"%lld", uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            completeHandle(responseObject);
            [hud removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hud removeFromSuperview];
            [self showHudWithTarget:target title:@"服务器繁忙"];
            if (failHandle) {
                failHandle(task,error);
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else{
        [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            //获取到目前的数据请求的进度
            NSLog(@"%lld", downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            completeHandle(responseObject);
            [hud removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hud removeFromSuperview];
            [self showHudWithTarget:target title:@"服务器繁忙"];
            if (failHandle) {
                failHandle(task,error);
            }else{
                NSLog(@"%@",error);
            }
        }];
    }
}

/**
 *  显示拼装后的url字符串
 */
+ (void)printUrlInfo:(NSDictionary *)params withUrl:(NSString *)url{
    if ([params isNotEmpty]) {
        NSMutableString *str = [NSMutableString string];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [str appendFormat:@"&%@=%@", key, obj];
        }];
        NSString *subStr = [str substringFromIndex:1];
        NSLog(@"URL--------------           %@?%@          --------------", url,subStr);
    }else{
        NSLog(@"URL--------------           %@          --------------", url);
    }
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


@end
