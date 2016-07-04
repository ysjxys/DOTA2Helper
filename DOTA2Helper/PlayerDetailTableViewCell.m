//
//  PlayerDetailTableViewCell.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "PlayerDetailTableViewCell.h"
#import "MatchPlayerItem.h"
#import "UIImageView+WebCache.h"
#import "Dota2HelperCommonTools.h"
#import "Hero.h"
#import "MatchSummary.h"
#import "Item.h"
#import "UIView+YSJ.h"
#import "AccountItem.h"

@interface PlayerDetailTableViewCell ()
@property (nonatomic, strong) MatchPlayerItem *playerItem;
@property (nonatomic, strong) MatchSummary *matchSummary;

@property (weak, nonatomic) IBOutlet UIImageView *heroImgView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *battleRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *kdaDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *damageLabel;
@property (weak, nonatomic) IBOutlet UILabel *kdaRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView0;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView3;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView4;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView5;
@property (weak, nonatomic) IBOutlet UIView *playerHeadBackView;
@property (weak, nonatomic) IBOutlet UIImageView *playerHeadImgView;
@property (weak, nonatomic) IBOutlet UIButton *playerHeadBtn;
@property (weak, nonatomic) IBOutlet UILabel *heroDamageLabel;
@property (weak, nonatomic) IBOutlet UILabel *xpmLabel;
@property (weak, nonatomic) IBOutlet UILabel *towerDamageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastHitLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpmLabel;
@property (weak, nonatomic) IBOutlet UILabel *heroHealingLabel;
@property (weak, nonatomic) IBOutlet UILabel *heroLevelLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightZeroConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightNormalConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
@implementation PlayerDetailTableViewCell

- (void)changeBottomViewToHide{
//    self.bottomHeightNormalConstraint.priority = UILayoutPriorityDefaultLow;
//    self.bottomHeightZeroConstraint.priority = UILayoutPriorityDefaultHigh;
    self.bottomView.hidden = YES;
}

- (void)changeBottomViewToShow{
//    self.bottomHeightZeroConstraint.priority = UILayoutPriorityDefaultLow;
//    self.bottomHeightNormalConstraint.priority = UILayoutPriorityDefaultHigh;
    self.bottomView.hidden = NO;
}

- (void)setNameColorIsRadiant:(BOOL)isRadiant{
    self.playerNameLabel.textColor = isRadiant?RGBA(61, 144, 40, 1):RGBA(156, 55, 39, 1);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView playerItem:(MatchPlayerItem *)playerItem matchSummary:(MatchSummary *)matchSummary{
    static NSString *identifier = @"PlayerDetailTableViewCell";
    PlayerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initView];
    }
    cell.matchSummary = matchSummary;
    cell.playerItem = playerItem;
    [cell changeBottomViewToHide];
    return cell;
}

- (void)initView{
    self.playerHeadBackView.clipsToBounds = YES;
    self.playerHeadBackView.layer.cornerRadius = self.playerHeadBackView.width/2;
    self.playerHeadBackView.layer.borderWidth = 0;
    
    self.playerHeadImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.playerHeadImgView.image = [UIImage imageNamed:@"emptyHead.jpg"];
    
    [self.playerHeadBtn addTarget:self action:@selector(headBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)headBtnClicked{
    if (!self.playerItem.accountItem) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(playerHeadSelected:)]) {
        [self.delegate playerHeadSelected:self.playerItem.accountItem];
    }
}

- (void)setPlayerItem:(MatchPlayerItem *)playerItem{
    _playerItem = playerItem;
    //英雄头像
    Hero *hero = [[[Dota2HelperCommonTools shareTools] herosDic] objectForKey:playerItem.heroId];
    NSURL *url = [NSURL URLWithString:HeroImgUrlStr(hero.name)];
    [self.heroImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder image"]];
    //英雄等级
    self.heroLevelLabel.text = [playerItem.level stringValue];
    //用户名称
    self.playerNameLabel.text = playerItem.accountItem?playerItem.accountItem.personName:Key(@"anonymousPlayer");
    //kda率
    self.kdaRateLabel.text = [NSString stringWithFormat:@"KDA:%.1f",([playerItem.kills floatValue]+[playerItem.assists floatValue])/[playerItem.deaths floatValue]];
    //用户头像
    NSString *headImgUrl = self.playerItem.accountItem.iconImgUrl;
    [self.playerHeadImgView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"emptyHead.jpg"]];
    
    if (playerItem.isRadiant) {
        //参战率
        self.battleRateLabel.text = [NSString stringWithFormat:@"%@:%.1f%%",Key(@"battleRateTitle"), 100*([playerItem.kills floatValue]+[playerItem.assists floatValue])/self.matchSummary.direDeathCount];
        //英雄伤害百分比
        self.damageLabel.text = [NSString stringWithFormat:@"%@:%.1f%%",Key(@"damageRateTitle"), 100*[playerItem.heroDamage floatValue]/_matchSummary.radiantHeroDamage];
    }else{
        //参战率
        self.battleRateLabel.text = [NSString stringWithFormat:@"%@:%.1f%%",Key(@"battleRateTitle"), 100*([playerItem.kills floatValue]+[playerItem.assists floatValue])/self.matchSummary.radiantDeathCount];
        //英雄伤害百分比
        self.damageLabel.text = [NSString stringWithFormat:@"%@:%.1f%%",Key(@"damageRateTitle"), 100*[playerItem.heroDamage floatValue]/_matchSummary.direHeroDamage];
    }
    
    //kda数据
    self.kdaDataLabel.text = [NSString stringWithFormat:@"%@/%@/%@",playerItem.kills,playerItem.deaths,playerItem.assists];
    //装备数据
    NSArray *itemIconViewArr = @[self.itemImgView0, self.itemImgView1, self.itemImgView2, self.itemImgView3, self.itemImgView4, self.itemImgView5];
    for (int i = 0; i < itemIconViewArr.count; i++) {
        UIImageView *imgView = itemIconViewArr[i];
        Item *item = [[[Dota2HelperCommonTools shareTools] itemsDic] objectForKey:playerItem.itemsArr[i]];
//        NSString *key = [item.name stringByReplacingOccurrencesOfString:@"item_" withString:@""];
        [imgView sd_setImageWithURL:[NSURL URLWithString:ItemImgUrlStr(item.name)]];
    }
    //英雄伤害具体数值
    self.heroDamageLabel.text = [NSString stringWithFormat:@"%@:%@", Key(@"heroDamageNumberTtle"),playerItem.heroDamage];
    //XPM
    self.xpmLabel.text = [NSString stringWithFormat:@"%@:%@", Key(@"xpm"),playerItem.xpm];
    //GPM
    self.gpmLabel.text = [NSString stringWithFormat:@"%@:%@", Key(@"gpm"),playerItem.gpm];
    //英雄治疗
    self.heroHealingLabel.text = [NSString stringWithFormat:@"%@:%@", Key(@"heroHealing"), playerItem.heroHealing];
    //建筑伤害
    self.towerDamageLabel.text = [NSString stringWithFormat:@"%@:%@", Key(@"towerDamage"), playerItem.towerDamage];
    self.lastHitLabel.text = [NSString stringWithFormat:@"%@:%@ %@:%@", Key(@"lastHit"), playerItem.lastHits, Key(@"denies"), playerItem.denies];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
