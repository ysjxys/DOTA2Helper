//
//  YSJConfig.h
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUNDLE_KEY_WEBAPI @"Web API"
#define BUNDLE_KEY_WEBIMG @"Web IMG"

@interface YSJConfig : NSObject

+ (NSString *)getWebAPI;

+ (NSString *)getWebIMG;


@end
