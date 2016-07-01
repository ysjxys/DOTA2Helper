//
//  FMDBHelper.h
//  ysjLib
//
//  Created by ysj on 16/5/24.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
typedef NS_ENUM(NSInteger, SelectConditionMode){
    SelectConditionEqualAnd = 0,
    SelectConditionEqualOr,
    SelectConditionLikeAnd,
    SelectConditionLikeOr,
    SelectConditionNone,
};
@interface FMDBHelper : NSObject


/**
 *  创建数据库
 *
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
+ (void)dataBaseWithName:(NSString *)dbName;



/**
 *  给指定数据库建表
 *
 *  @param db        指定数据库对象
 *  @param tableName 表的名称
 *  @param keyTypeDic   所含字段以及对应字段类型 字典
 */
+ (void)createTable:(NSString *)tableName withKeyTypeDic:(NSDictionary *)keyTypeDic;



/**
 *  给指定数据库的表添加值
 *
 *  @param db        数据库名称
 *  @param keyValueDic 字段及对应的值
 *  @param tableName 表名
 */
+ (void)insertKeyValues:(NSDictionary *)keyValueDic intoTable:(NSString *)tableName;



/**
 *  给指定数据库的表更新值
 *
 *  @param db        数据库名称
 *  @param keyValueDic 要更新字段及对应的值
 *  @param tableName 表名
 */
+ (void)updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValueDic;



/**
 *  条件更新
 *
 *  @param db        数据库名称
 *  @param tableName 表名称
 *  @param keyValueDic 要更新的字段及对应值
 *  @param conditionDic 条件
 */
+ (void)updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValueDic whereCondition:(NSDictionary *)conditionDic;

/**
 *  条件删除数据
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param conditionDic 删除条件
 */
+ (void)deleteTable:(NSString *)tableName whereCondition:(NSDictionary *)conditionDic;

/**
 *  删除表中所有数据
 *
 *  @param db        数据库
 *  @param tableName 表名
 */
+ (void)deleteTable:(NSString *)tableName;

/**
 *  删除表
 *
 *  @param tableName 表名
 */
+ (void)dropTable:(NSString *)tableName;

/**
 *  查询指定数据
 *
 *  @param tableName       表名
 *  @param conditionDic       约束条件
 *  @param selectConditionMode  展示模式
 *
 *  @return 指定结果数据数组
 */
+ (NSArray *)selectDataFromTable:(NSString *)tableName condition:(NSDictionary *)conditionDic selectConditionMode:(SelectConditionMode)selectConditionMode;

/**
 *  查询所有数据
 *
 *  @param tableName 表名
 *
 *  @return 全部数组
 */
+ (NSArray *)selectDataFromTable:(NSString *)tableName;

@end
