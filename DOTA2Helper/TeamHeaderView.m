//
//  TeamHeaderView.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/16.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "TeamHeaderView.h"
#import "MatchSummary.h"
#import "UIView+YSJ.h"

@interface TeamHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *teamTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamDataLabel;

@property (nonatomic, strong) MatchSummary *matchSummary;
@property (nonatomic, assign) BOOL isRadiant;
@end

@implementation TeamHeaderView

+ (instancetype)viewWithMatchSummary:(MatchSummary *)matchSummary isRadiant:(BOOL)isRadiant{
    TeamHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TeamHeaderView" owner:nil options:nil] lastObject];
    view.isRadiant = isRadiant;
    view.matchSummary = matchSummary;
    view.backgroundColor = isRadiant?RGBA(61, 144, 40, 1):RGBA(156, 55, 39, 1);
    return view;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat height = self.height;
    CGFloat width = self.width;
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);//线条颜色
    CGContextMoveToPoint(context, 95, height);
    CGContextAddLineToPoint(context, 135, 2);
    CGContextAddLineToPoint(context, width, 2);
    CGContextAddLineToPoint(context, width, height);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
}

- (void)setMatchSummary:(MatchSummary *)matchSummary{
    _matchSummary = matchSummary;
    if (self.isRadiant) {
        self.teamTypeLabel.text = @"Radiant";
        self.teamNameLabel.text = Key(@"radiant");
        self.teamResultLabel.text = matchSummary.radiantWin?Key(@"win"):Key(@"fail");
        self.teamDataLabel.text = [NSString stringWithFormat:@"%@:%d  %@:%d  %@:%d", Key(@"kill"), matchSummary.radiantKillCount, Key(@"experience"), matchSummary.radiantExpCount, Key(@"gold"), matchSummary.radiantGoldCount];
    }else{
        self.teamTypeLabel.text = @"Dire";
        self.teamNameLabel.text = Key(@"dire");
        self.teamResultLabel.text = matchSummary.radiantWin?Key(@"fail"):Key(@"win");
        self.teamDataLabel.text = [NSString stringWithFormat:@"%@:%d  %@:%d  %@:%d", Key(@"kill"), matchSummary.direKillCount, Key(@"experience"), matchSummary.direExpCount, Key(@"gold"), matchSummary.direGoldCount];
    }
}

@end
