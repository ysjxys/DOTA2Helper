//
//  FMDBHelper.m
//  ysjLib
//
//  Created by ysj on 16/5/24.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "FMDBHelper.h"

#define HelpLog(...) NSLog(__VA_ARGS__)

static NSString *dbHomePath;

@implementation FMDBHelper

+ (void)dataBaseWithName:(NSString *)dbName{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [library[0] stringByAppendingPathComponent:dbName];
    dbHomePath = dbPath;
    HelpLog(@"%@", dbHomePath);
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dataBase open]) {
        HelpLog(@"无法获取数据库");
        return;
    }
    [dataBase close];
}

+ (void)createTable:(NSString *)tableName withKeyTypeDic:(NSDictionary *)keyTypeDic{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
        int count = 0;
        for (NSString *key in keyTypeDic) {
            count++;
            [sql appendString:key];
            [sql appendString:@" "];
            [sql appendString:[keyTypeDic valueForKey:key]];
            if (count != [keyTypeDic count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@")"];
        HelpLog(@"%@",sql);
        [db executeUpdate:sql];
    }];
}

+ (void)insertKeyValues:(NSDictionary *)keyValueDic intoTable:(NSString *)tableName{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *keys = [keyValueDic allKeys];
        NSArray *values = [keyValueDic allValues];
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (", tableName]];
        NSInteger count = 0;
        for (NSString *key in keys) {
            [sql appendString:key];
            count ++;
            if (count < [keys count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@") VALUES ("];
        for (int i = 0; i < [values count]; i++) {
            [sql appendString:@"?"];
            if (i < [values count] - 1) {
                [sql appendString:@","];
            }
        }
        [sql appendString:@")"];
        HelpLog(@"%@", sql);
        [db executeUpdate:sql withArgumentsInArray:values];
    }];
}

+ (void)updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValueDic{
    [self updateTable:tableName setKeyValues:keyValueDic whereCondition:keyValueDic];
}


+ (void)updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValueDic whereCondition:(NSDictionary *)conditionDic{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET ",tableName]];
        
        [sql appendString:[self assembleMainCommonStr:@", %@ = ? " zeroSpecialStr:@"%@ = ? " kvDic:conditionDic]];
        [sql appendString:[self assembleMainCommonStr:@"AND %@ = ? " zeroSpecialStr:@"WHERE %@ = ? " kvDic:conditionDic]];
        HelpLog(@"%@",sql);
        if (![self executeUpdateConditionSQL:sql keyValues:keyValueDic condition:conditionDic]) {
            *rollback = YES;
        }
    }];
}

+ (void)deleteTable:(NSString *)tableName whereCondition:(NSDictionary *)conditionDic{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *dataBase, BOOL *rollback) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"DELETE FROM %@ ",tableName]];
        [sql appendString:[self assembleMainCommonStr:@"AND %@ = ? " zeroSpecialStr:@"WHERE %@ = ? " kvDic:conditionDic]];
        HelpLog(@"%@",sql);
        if (![self executeUpdateConditionSQL:sql keyValues:nil condition:conditionDic]) {
            *rollback = YES;
        }
    }];
}

+ (void)deleteTable:(NSString *)tableName{
    [self deleteTable:tableName whereCondition:nil];
}

+ (void)dropTable:(NSString *)tableName{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
        [db executeUpdate:sql];
    }];
}

+ (NSArray *)selectDataFromTable:(NSString *)tableName condition:(NSDictionary *)conditionDic selectConditionMode:(SelectConditionMode)selectConditionMode{
    NSMutableString *sql = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"SELECT * FROM %@ ",tableName]];
    NSString *commonStr;
    NSString *zeroSpecialStr;
    switch (selectConditionMode) {
        case SelectConditionEqualAnd:
            commonStr = @"AND %@ = ? ";
            zeroSpecialStr = @"WHERE %@ = ? ";
            break;
        case SelectConditionEqualOr:
            commonStr = @"OR %@ = ? ";
            zeroSpecialStr = @"WHERE %@ = ? ";
            break;
        case SelectConditionLikeAnd:
            commonStr = @"AND %@ LIKE ? ";
            zeroSpecialStr = @"WHERE %@ LIKE ? ";
            break;
        case SelectConditionLikeOr:
            commonStr = @"OR %@ LIKE ? ";
            zeroSpecialStr = @"WHERE %@ LIKE ? ";
            break;
        case SelectConditionNone:
            commonStr = @"";
            zeroSpecialStr = @"";
            break;
        default:
            break;
    }
    [sql appendString:[self assembleMainCommonStr:commonStr zeroSpecialStr:zeroSpecialStr kvDic:conditionDic]];
    HelpLog(@"%@",sql);
    NSMutableArray *resultArr = [NSMutableArray array];
    FMResultSet *resultSet = [self executeQueryConditionSQL:sql condition:conditionDic];
    while ([resultSet next]) {
        [resultArr addObject:[resultSet resultDictionary]];
    }
    return resultArr;
}

+ (NSArray *)selectDataFromTable:(NSString *)tableName{
    return [self selectDataFromTable:tableName condition:nil selectConditionMode:SelectConditionNone];
}

#pragma tool method
+ (NSMutableString *)assembleMainCommonStr:(NSString *)commonStr zeroSpecialStr:(NSString *)specialStr kvDic:(NSDictionary *)kvDic{
    NSMutableString *resultStr = [@"" mutableCopy];
    if (!kvDic) {
        return resultStr;
    }
    if ([specialStr isEqualToString:@""] || [commonStr isEqualToString:@""]) {
        return resultStr;
    }
    NSArray *keys = kvDic.allKeys;
    for (int i = 0; i < keys.count; i++) {
        if (i == 0) {
            [resultStr appendFormat:specialStr,keys[i]];
        }else{
            [resultStr appendFormat:commonStr,keys[i]];
        }
    }
    HelpLog(@"%@",resultStr);
    return resultStr;
}

+ (void)addArgumentArr:(NSMutableArray *)argumentArr FromDic:(NSDictionary *)dic{
    if (!argumentArr) {
        return;
    }
    if (!dic) {
        return;
    }
    NSArray *dicKeys = dic.allKeys;
    for (int i = 0; i < dicKeys.count; i++) {
        [argumentArr addObject:[dic objectForKey:dicKeys[i]]];
    }
}

+ (FMResultSet *)executeQueryConditionSQL:(NSString *)sql condition:(NSDictionary *)condition{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    __block FMResultSet *resultSet;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSError *error;
        NSMutableArray *argumentArr = [NSMutableArray array];
        [self addArgumentArr:argumentArr FromDic:condition];
        resultSet = [db executeQuery:sql withArgumentsInArray:argumentArr];
        if (!resultSet) {
            HelpLog(@"%@",error);
        }
    }];
    return resultSet;
}

+ (BOOL)executeUpdateConditionSQL:(NSString *)sql keyValues:(NSDictionary *)keyValues condition:(NSDictionary *)condition{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    __block BOOL result;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSError *error;
        NSMutableArray *argumentArr = [NSMutableArray array];
        [self addArgumentArr:argumentArr FromDic:keyValues];
        [self addArgumentArr:argumentArr FromDic:condition];
        result = [db executeUpdate:sql values:argumentArr error:&error];
        if (error) {
            HelpLog(@"%@",error);
        }
    }];
    return result;
}

@end
