//
//  CommonTableViewCell.h
//  DOTA2Helper
//
//  Created by ysj on 16/6/22.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSJTableViewCellBasicItem;

@interface CommonTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView item:(YSJTableViewCellBasicItem *)item;

@end
