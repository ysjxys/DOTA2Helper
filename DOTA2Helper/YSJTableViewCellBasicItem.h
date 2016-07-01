//
//  YSJTableViewCellBasicItem.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RightViewType) {
    rightViewTypeNone = 0,
    rightViewTypeCustomer,
    rightViewTypeImgview,
    rightViewTypeArrow,
    rightViewTypeLabel,
};

typedef void (^SelectedOption)();

@interface YSJTableViewCellBasicItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *rightDesc;
@property (nonatomic, copy) SelectedOption selectedOption;
@property (nonatomic, copy) NSString *leftImgUrlStr;
@property (nonatomic, copy) NSString *rightImgUrlStr;
@property (nonatomic, assign) RightViewType rightViewType;

@property (nonatomic, strong) UIView *customerView;
@property (nonatomic, strong) UIImage *leftImg;
@property (nonatomic, strong) UIImage *rightImg;


+ (instancetype)itemWithTitle:(NSString *)title desc:(NSString *)desc rightViewType:(RightViewType)rightViewType;

@end
