//
//  NSString+YSJ.m
//  ysjLib
//
//  Created by ysj on 15/12/4.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import "NSString+YSJ.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YSJ)

/**
 *  输入formatterStr，返回对应格式转化后的NSDate
 */
- (NSDate *)stringToDateWithFormatterStr:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = formatterStr;
    return [formatter dateFromString:self];
}

/**
 *  返回默认formatter的对应NSDate
 *  默认formatter为@"yyyy-MM-dd HH:mm:ss"
 */
- (NSDate *)stringToDateWithDefaultFormatterStr{
    return [self stringToDateWithFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 *  返回某段文本的所占size大小，font为文本字体，maxSize为可容许的最大大小
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  MD5加密
 */
- (NSString *)md5HexDigest{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

/**
 *  去特殊字符
 */
- (NSString *)trimStr:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"  " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    return str;
}

/**
 *  解码base64加密的字符串并返回
 */
- (NSString *)base64Decoded:(NSString *)base64Str{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 *  解码base64加密的字符串并将json转换为dictionary返回
 */
- (NSDictionary *)base64DecodeAndTransform:(NSString *)base64String{
    NSString *str = [self base64Decoded:base64String];
    str = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    str = [str stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
    str = [str stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
    str = [str stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    str = [str stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}
@end
