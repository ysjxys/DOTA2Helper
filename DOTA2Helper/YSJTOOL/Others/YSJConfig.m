//
//  YSJConfig.m
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJConfig.h"
@interface YSJConfig()

@end
static NSDictionary *infoPlistDic;
@implementation YSJConfig

+ (NSString *)getWebAPI{
    return (NSString *)[self getValue:BUNDLE_KEY_WEBAPI];
}

+ (NSString *)getWebIMG{
    return (NSString *)[self getValue:BUNDLE_KEY_WEBIMG];
}


+ (NSObject *)getValue:(NSString *)key{
    if(infoPlistDic == nil){
        NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoPlistDic = [[NSDictionary alloc] initWithContentsOfFile:File];
    }
    return [infoPlistDic objectForKey:key];
}
@end
