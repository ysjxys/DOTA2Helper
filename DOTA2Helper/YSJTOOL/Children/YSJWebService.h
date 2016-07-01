//
//  YSJWebService.h
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <Reachability.h>
#import <MBProgressHUD.h>
#import "NSObject+YSJ.h"

typedef void (^CompleteHandle)(id response);
typedef void (^FailHandle)(NSURLSessionTask *operation, NSError *error);

@interface YSJWebService : NSObject


+ (void)requestTarget:(id)target withUrl:(NSString *)urlStr isPost:(BOOL)isPost parameters:(NSDictionary *)params complete:(CompleteHandle)completeHandle fail:(FailHandle)failHandle;

@end
