//
//  NSObject+YSJ.m
//  ysjLib
//
//  Created by ysj on 16/2/2.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "NSObject+YSJ.h"

@implementation NSObject (YSJ)

- (BOOL)isNotNull{
    if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null]){
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmpty{
    if([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]
       ){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSArray *)self count]>0){
            return YES;
        }
        return NO;
    }
    if([self isKindOfClass:[NSSet class]] || [self isKindOfClass:[NSMutableSet class]]
       ){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSSet *)self count]>0){
            return YES;
        }
        return NO;
    }
    if([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]
       ){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSDictionary *)self count]>0){
            return YES;
        }
        return NO;
    }
    if([self isKindOfClass:[NSString class]]){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(length)] && [(NSString *)self length]>0 && ![(NSString *)self isEqualToString:@" "]){
            return YES;
        }
        return NO;
    }
    
    if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null]){
        return YES;
    }
    
    return NO;
}

@end
