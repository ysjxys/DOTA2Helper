//
//  CommonTableViewCell.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/22.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "YSJTableViewCellBasicItem.h"
#import "UIImageView+WebCache.h"
#import "UIView+YSJ.h"

#define RightImgViewSuitableWidth 72;
#define LeftImgViewWidth 40;


@interface CommonTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelShowConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelHideConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *leftImgBackView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@property (nonatomic, strong) YSJTableViewCellBasicItem *item;

@end
@implementation CommonTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView item:(YSJTableViewCellBasicItem *)item{
    static NSString *identifier = @"CommonTableViewCell";
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
        cell.leftImgView.clipsToBounds = YES;
        cell.leftImgView.layer.cornerRadius = cell.leftImgView.width/2;
        cell.leftImgView.layer.borderWidth = 0;
        cell.leftImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.rightImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    cell.item = item;
    return cell;
}

- (void)setItem:(YSJTableViewCellBasicItem *)item{
    _item = item;
    //显示标题
    self.titleLabel.text = item.title;
    //若存在描述文字，显示之 并修改约束条件，反之则修改约束条件隐藏
    if (item.desc) {
        self.descLabel.text = item.desc;
        self.descLabelShowConstraint.priority = UILayoutPriorityDefaultHigh;
        self.descLabelHideConstraint.priority = UILayoutPriorityDefaultLow;
    }else{
        self.descLabel.text = @"";
        self.descLabelShowConstraint.priority = UILayoutPriorityDefaultLow;
        self.descLabelHideConstraint.priority = UILayoutPriorityDefaultHigh;
    }
    //显示或隐藏左侧图片
    if (!item.leftImg && !item.leftImgUrlStr) {
        self.leftViewWidthConstraint.constant = 0;
    }else{
        self.leftViewWidthConstraint.constant = LeftImgViewWidth;
        if (item.leftImgUrlStr) {
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:item.leftImgUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder image"]];
        }else{
            self.leftImgView.image = item.leftImg;
        }
    }
    
    //根据不同类型，显示右侧view
    switch (item.rightViewType) {
        case rightViewTypeNone:
            self.rightViewWidthConstraint.constant = 0;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
            
        case rightViewTypeArrow:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.rightViewWidthConstraint.constant = 0;
            break;
            
        case rightViewTypeImgview:
            self.rightLabel.text = @"";
            self.accessoryType = UITableViewCellAccessoryNone;
            if (!item.rightImgUrlStr && !item.rightImg) {
                self.rightViewWidthConstraint.constant = 0;
            }else{
                self.rightViewWidthConstraint.constant = RightImgViewSuitableWidth;
                if (item.rightImgUrlStr) {
                    [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:item.rightImgUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder image"]];
                }else{
                    self.rightImgView.image = item.rightImg;
                }
            }
            break;
            
        case rightViewTypeCustomer:
            self.rightLabel.text = @"";
            self.accessoryType = UITableViewCellAccessoryNone;
            if (!item.customerView) {
                self.rightViewWidthConstraint.constant = 0;
            }else{
                self.rightViewWidthConstraint.constant = 20.0f +RightImgViewSuitableWidth;
                [self.rightView addSubview:item.customerView];
            }
            break;
        
        case rightViewTypeLabel:
            self.accessoryType = UITableViewCellAccessoryNone;
            if (!item.rightDesc) {
                self.rightViewWidthConstraint.constant = 0;
            }else{
                self.rightViewWidthConstraint.constant = 20.0f +RightImgViewSuitableWidth;
                self.rightLabel.text = item.rightDesc;
            }
        break;
            
        default:
            break;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
