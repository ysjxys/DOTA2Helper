//
//  MatchDetailViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/12.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "MatchDetailViewController.h"
#import "YSJNavigationController.h"
#import "UIImage+YSJ.h"
#import "YSJTableViewCellGroup.h"
#import "YSJWebService.h"
#import "MatchSummary.h"
#import "NSObject+YSJ.h"
#import "MatchPlayerItem.h"
#import "PlayerDetailTableViewCell.h"
#import "NSDate+YSJ.h"
#import "AccountItem.h"
#import "TeamHeaderView.h"
#import "AccountViewController.h"
#import "UIBarButtonItem+YSJ.h"
#import "UMSocial.h"

@interface MatchDetailViewController()<UITableViewDelegate,UITableViewDataSource,PlayerDetailTableViewCellDelegate,UMSocialUIDelegate>

@property (nonatomic, copy) NSString *matchId;

@property (weak, nonatomic) IBOutlet UILabel *overTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overTimeContLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeContLabel;
@property (weak, nonatomic) IBOutlet UILabel *fbTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fbTimeContLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchModeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchModeContLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) MatchSummary *matchSummary;
@property (nonatomic, assign) BOOL isOpenCell;
@property (nonatomic, strong) NSIndexPath *currentClickIndexPath;
@end

@implementation MatchDetailViewController

- (instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use detailWithMatchID: instead" userInfo:nil];
}

- (instancetype)initWithMatchId:(NSString *)matchId{
    self = [super init];
    self.matchId = matchId;
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

+ (instancetype)detailWithMatchID:(NSString *)matchId{
    return [[self alloc]initWithMatchId:matchId];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.titleView = nil;
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",Key(@"theMatchId"),self.matchId];
    self.tableView.hidden = YES;
    [self initViews];
    [self initData];
    
}

- (void)loadPlayerData{
    NSMutableString *idStrs = [NSMutableString string];
    YSJTableViewCellGroup *groupR = self.dataArr[0];
    for (MatchPlayerItem *item in groupR.itemArr) {
        if ([item.accountId longLongValue] != Steam32BitAnonymousID) {
            long long steamId64Bit = [item.accountId longLongValue]+Steam64BitCalculateConstant;
            [idStrs appendString:[NSString stringWithFormat:@"%lld|",steamId64Bit]];
        }
    }
    YSJTableViewCellGroup *groupD = self.dataArr[1];
    for (MatchPlayerItem *item in groupD.itemArr) {
        if ([item.accountId longLongValue] != Steam32BitAnonymousID) {
            long long steamId64Bit = [item.accountId longLongValue]+Steam64BitCalculateConstant;
            [idStrs appendString:[NSString stringWithFormat:@"%lld|",steamId64Bit]];
        }
    }
    NSDictionary *param = @{@"key":SteamAPIKey,@"steamids":idStrs};
    
    [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/" isPost:NO parameters:param complete:^(id response) {
        NSArray *arr = response[@"response"][@"players"];
        for (NSDictionary *dic in arr) {
            AccountItem *accountItem = [AccountItem itemWithDic:dic];
            BOOL isMatched = NO;
            for (YSJTableViewCellGroup *group in self.dataArr) {
                if (isMatched) {
                    break;
                }
                for (MatchPlayerItem *item in group.itemArr) {
                    if ([item.accountId longLongValue] + Steam64BitCalculateConstant == [accountItem.steamId64bit longLongValue]) {
                        item.accountItem = accountItem;
                        isMatched = YES;
                        break;
                    }
                }
            }
        }
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    } fail:nil];
}

- (void)initData{
    NSDictionary *param = @{@"key":SteamAPIKey,@"language":SteamParamLanguage,@"match_id":self.matchId};
    [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/v1" isPost:NO parameters:param complete:^(id response) {
        NSArray *tempArr = response[@"result"][@"players"];
        if (!tempArr || tempArr.count < 1) {
            return;
        }
        NSMutableArray *playsArrR = [NSMutableArray array];
        NSMutableArray *playsArrD = [NSMutableArray array];
        int radiantKillCount = 0;
        int direKillCount = 0;
        int radiantDamage = 0;
        int direDamage = 0;
        int radiantExpCount = 0;
        int direExpCount = 0;
        int radiantGoldCount = 0;
        int direGoldCount = 0;
        int radiantDeathCount = 0;
        int direDeathCount = 0;
        for (int i = 0; i < tempArr.count; i++) {
            MatchPlayerItem *item = [MatchPlayerItem playerItemWithDic:tempArr[i]];
            if (i < 5) {
                item.isRadiant = YES;
                [playsArrR addObject:item];
                radiantKillCount = radiantKillCount + [item.kills intValue];
                radiantDamage = radiantDamage + [item.heroDamage intValue];
                radiantExpCount = radiantExpCount + [item.xpm intValue];
                radiantGoldCount = radiantGoldCount + [item.gpm intValue];
                radiantDeathCount = radiantDeathCount +[item.deaths intValue];
            }else{
                item.isRadiant = NO;
                [playsArrD addObject:item];
                direKillCount = direKillCount + [item.kills intValue];
                direDamage = direDamage +[item.heroDamage intValue];
                direExpCount = direExpCount + [item.xpm intValue];
                direGoldCount = direGoldCount + [item.gpm intValue];
                direDeathCount = direDeathCount + [item.deaths intValue];
            }
        }
        
        if ([response[@"result"] isNotEmpty]) {
            self.matchSummary = [MatchSummary summaryWithDic:response[@"result"]];
        }
        self.matchSummary.radiantKillCount = radiantKillCount;
        self.matchSummary.radiantHeroDamage = radiantDamage;
        self.matchSummary.direKillCount = direKillCount;
        self.matchSummary.direHeroDamage = direDamage;
        self.matchSummary.radiantExpCount = radiantExpCount;
        self.matchSummary.direExpCount = direExpCount;
        self.matchSummary.radiantGoldCount = radiantGoldCount;
        self.matchSummary.direGoldCount = direGoldCount;
        self.matchSummary.radiantDeathCount = radiantDeathCount;
        self.matchSummary.direDeathCount = direDeathCount;
        
        YSJTableViewCellGroup *groupR = self.dataArr[0];
        groupR.itemArr = [playsArrR copy];
        YSJTableViewCellGroup *groupD = self.dataArr[1];
        groupD.itemArr = [playsArrD copy];
        
        double second = [[NSDate date] compareTimeToAnotherDate:[NSDate dateWithTimeIntervalSince1970:[self.matchSummary.startTime doubleValue]]];
        if (second/(60*60*24*365) > 1) {
            if (second/(60*60*24*365) > 2) {
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*365), Key(@"yearsAgo")];
            }else{
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*365), Key(@"yearAgo")];
            }
        }else if (second/(60*60*24*30) > 1){
            if (second/(60*60*24*30) > 2) {
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*30), Key(@"monthsAgo")];
            }else{
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24*30), Key(@"monthAgo")];
            }
        }else if (second/(60*60*24) > 1){
            if (second/(60*60*24) > 2) {
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24), Key(@"daysAgo")];
            }else{
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60*24), Key(@"dayAgo")];
            }
        }else if (second/(60*60) > 1){
            if (second/(60*60) > 2) {
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60), Key(@"hoursAgo")];
            }else{
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60*60), Key(@"hourAgo")];
            }
        }else{
            if (second/(60) > 2) {
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60), Key(@"minutesAgo")];
            }else{
                self.overTimeContLabel.text = [NSString stringWithFormat:@"%.0lf%@", second/(60), Key(@"minuteAgo")];
            }
        }
        int fbSecond = [self.matchSummary.fbTime intValue]%60;
        NSString *fbSecondStr =  fbSecond < 10?[NSString stringWithFormat:@"0%d",fbSecond]:[NSString stringWithFormat:@"%d",fbSecond];
        self.fbTimeContLabel.text = [NSString stringWithFormat:@"%d:%@",[self.matchSummary.fbTime intValue]/60,fbSecondStr];
        
        self.lastTimeContLabel.text = [NSString stringWithFormat:@"%d%@",[self.matchSummary.matchDuration intValue]/60,Key(@"minutes")];
        
        self.matchModeContLabel.text = self.matchSummary.gameMode;
        [self loadPlayerData];
    } fail:nil];
}

- (void)initViews{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Share"] edgeInsets:UIEdgeInsetsZero bounds:CGRectMake(0, 0, 24, 24) higlightedImage:[UIImage imageNamed:@"Share"] target:self action:@selector(shareBtnClicked)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.overTimeTitleLabel.text = Key(@"matchStartTimeTitle");
    self.lastTimeTitleLabel.text = Key(@"matchLastTimeTitle");
    self.fbTimeTitleLabel.text = Key(@"firstBloodTimeTitle");
    self.matchModeTitleLabel.text = Key(@"matchModeTitle");
}

//@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
- (void)shareBtnClicked{
    [UMSocialData defaultData].extConfig.title = @"战绩助手";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://api.maxjia.com/api/match/detail/shared/?match_id=%@&from=singlemessage&isappinstalled=1",self.matchId];
//    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMSocialAPPKey
                                      shareText:@"我在Dota2中取得了辉煌的战绩，快来瞅瞅呀~"
                                     shareImage:[UIImage imageNamed:@"Icon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina]
                                       delegate:self];
}

#pragma mark - PlayerDetailTableViewCellDelegate
- (void)playerHeadSelected:(AccountItem *)accountItem{
    AccountViewController *accountVC = [[AccountViewController alloc]initWithAccountItem:accountItem shouldShowMatches:YES];
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark - tableView Delegate& Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == self.currentClickIndexPath) {
        if (self.isOpenCell == YES) {
            self.currentClickIndexPath = indexPath;
            return 95.0f;
        }
        return 50.0f;
    }else{
        return 50.0f;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YSJTableViewCellGroup *group = self.dataArr[section];
    return group.itemArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BOOL isRadiant = section == 0?YES:NO;
    TeamHeaderView *headerView = [TeamHeaderView viewWithMatchSummary:self.matchSummary isRadiant:isRadiant];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSJTableViewCellGroup *group = self.dataArr[indexPath.section];
    MatchPlayerItem *item = group.itemArr[indexPath.row];
    PlayerDetailTableViewCell *cell = [PlayerDetailTableViewCell cellWithTableView:tableView playerItem:item matchSummary:self.matchSummary];
    cell.delegate = self;
    BOOL isRadiant = indexPath.section == 0?YES:NO;
    [cell setNameColorIsRadiant:isRadiant];
    
    if (indexPath == self.currentClickIndexPath) {
        if (self.isOpenCell == YES) {
            [cell changeBottomViewToShow];
            NSArray *cellsArr = [tableView visibleCells];
            for (PlayerDetailTableViewCell *otherCell in cellsArr) {
                [otherCell changeBottomViewToHide];
            }
        }else{
            [cell changeBottomViewToHide];
        }
    }else{
        [cell changeBottomViewToHide];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == self.currentClickIndexPath) {
        self.isOpenCell = !self.isOpenCell;
    }else{
        self.isOpenCell = YES;
    }
    self.currentClickIndexPath = indexPath;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        YSJTableViewCellGroup *groupR = [[YSJTableViewCellGroup alloc]init];
        YSJTableViewCellGroup *groupD = [[YSJTableViewCellGroup alloc]init];
        _dataArr = _dataArr = [NSMutableArray arrayWithObjects:groupR,groupD, nil];;
    }
    return _dataArr;
}

@end
