//
//  Dota2HelperCommonTools.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "Dota2HelperCommonTools.h"
@interface Dota2HelperCommonTools()
@property (nonatomic, copy) NSDictionary *heroDic;
@property (nonatomic, copy) NSDictionary *itemDic;
@end


@implementation Dota2HelperCommonTools


+ (Dota2HelperCommonTools *)shareTools{
    static Dota2HelperCommonTools *commonTools = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        commonTools = [[self alloc] init];
    });
    return commonTools;
}
- (void)setHerosDic:(NSDictionary *)herosDic{
    _heroDic = [herosDic copy];
}

- (void)setItemsDic:(NSDictionary *)itemsDic{
    _itemDic = [itemsDic copy];
}

- (void)setLovePlayerArr:(NSArray *)loveArr{
    NSString *lovePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"love.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:lovePath]) {
        [fileManager createFileAtPath:lovePath contents:nil attributes:nil];
    }
    [loveArr writeToFile:lovePath atomically:YES];
}

- (NSDictionary *)herosDic{
    return _heroDic;
}
- (NSDictionary *)itemsDic{
    return _itemDic;
}

- (NSArray *)lovePlayerArr{
    NSString *lovePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"love.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:lovePath]) {
        [fileManager createFileAtPath:lovePath contents:nil attributes:nil];
    }
    NSArray *loveArr = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:lovePath isDirectory:NO]];
    return loveArr;
}

@end
