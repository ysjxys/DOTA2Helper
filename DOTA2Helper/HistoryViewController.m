//
//  HistoryViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "HistoryViewController.h"
#import "YSJWebService.h"
#import "UIView+YSJ.h"
#import "YSJTableViewCellGroup.h"
#import "YSJTableViewCellBasicItem.h"
#import "MatchItem.h"
#import "AccountItem.h"
#import "UIBarButtonItem+YSJ.h"
#import "YSJNavigationController.h"
#import "ViewDeck.h"
#import "LeftViewController.h"
#import "MJRefresh.h"
#import "NSDate+YSJ.h"
#import "Hero.h"
#import "Item.h"
#import "MatchDetailViewController.h"
#import "AppDelegate.h"
#import "Dota2HelperCommonTools.h"
#import "AccountViewController.h"
#import "CommonTableViewCell.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) IIViewDeckController *deckVC;
@property (nonatomic, strong) NSMutableDictionary *paramAccount;
@property (nonatomic, strong) NSMutableDictionary *paramMatch;
@property (nonatomic, copy) NSString *lastSteamId64Bit;

@property (nonatomic, assign) BOOL isMainAccount;
@property (nonatomic, strong) AccountItem *accountItem;
@end

@implementation HistoryViewController

- (instancetype)init{
    self = [super init];
    self.isMainAccount = YES;
    return self;
}

- (instancetype)initWithAccountItem:(AccountItem *)accountItem{
    self = [super init];
    self.isMainAccount = NO;
    self.accountItem = accountItem;
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkRightLoveItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initConstraint];
    [self initData];
    [self initParamData];
    [self loadAccountData];
}

- (void)initViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-TabBarHeight-StatusBarHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadAccountData];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        YSJTableViewCellGroup *groupMatch = self.dataArr[1];
        MatchItem *matchItem = [groupMatch.itemArr lastObject];
        if (!matchItem) {
            return;
        }
        [self.paramMatch setObject:matchItem.matchId forKey:SteamParamStartAtMatchId];
        [self loadMatchHistory];
    }];
    
    UIBarButtonItem *loveBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"play_heart_2"] edgeInsets:UIEdgeInsetsZero higlightedImage:[UIImage imageNamed:@"play_heart_selected"] target:self action:@selector(loveBtnClicked)];
    self.navigationItem.rightBarButtonItem = loveBarButtonItem;
    
    if (self.isMainAccount) {
        UIBarButtonItem *settingBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"more-tab"] edgeInsets:UIEdgeInsetsZero higlightedImage:[UIImage imageNamed:@"more-tab-selected"] target:self action:@selector(settingBarButtonItemClicked)];
        self.navigationItem.leftBarButtonItem = settingBarButtonItem;
        
        UIView *coverView = [[UIView alloc]initWithFrame:self.view.frame];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        self.coverView = coverView;
        [self.view addSubview:coverView];
        
        UITapGestureRecognizer *tapRegcognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingBarButtonItemClicked)];
        [coverView addGestureRecognizer:tapRegcognizer];
    }
}

- (void)initConstraint{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *tableViewLeading = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tableViewTailing = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tableViewHeight = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    tableViewLeading.active = YES;
    tableViewTailing.active = YES;
    tableViewTop.active = YES;
    tableViewHeight.active = YES;
}

- (void)initParamData{
    if (self.isMainAccount) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *steamID64bit = [userDefault objectForKey:UserDefaultKeySteamID64Bit]?[userDefault objectForKey:UserDefaultKeySteamID64Bit]:@"";
        NSMutableDictionary *paramAccount = [@{@"key":SteamAPIKey,@"steamids":steamID64bit} mutableCopy];
        self.paramAccount = paramAccount;
        
        NSString *steamID32bit = [userDefault objectForKey:UserDefaultKeySteamID32Bit]?[userDefault objectForKey:UserDefaultKeySteamID32Bit]:@"";
        NSMutableDictionary *paramMatch = [@{@"key":SteamAPIKey,@"language":SteamParamLanguage,@"account_id":steamID32bit} mutableCopy];
        self.paramMatch = paramMatch;
    }else{
        NSMutableDictionary *paramAccount = [@{@"key":SteamAPIKey,@"steamids":self.accountItem.steamId64bit} mutableCopy];
        self.paramAccount = paramAccount;
        
        NSMutableDictionary *paramMatch = [@{@"key":SteamAPIKey,@"language":SteamParamLanguage,@"account_id":self.accountItem.steamId32bit} mutableCopy];
        self.paramMatch = paramMatch;
    }
}

- (void)initData{
    //init hero data
    NSString *heroPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"hero.plist"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    YSJLog(@"%@",heroPath);
    if ([fileManager fileExistsAtPath:heroPath] == NO){
        NSDictionary *param = @{@"key":SteamAPIKey,@"language":SteamParamLanguage};
        [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/IEconDOTA2_570/GetHeroes/v1" isPost:NO parameters:param complete:^(id response) {
            NSArray *arr = response[@"result"][@"heroes"];
            YSJLog(@"%@",arr);
            [fileManager createFileAtPath:heroPath contents:nil attributes:nil];
            [arr writeToFile:heroPath atomically:YES];
            [self loadHeroPlistData];
        } fail:^(NSURLSessionTask *operation, NSError *error) {
            [self showHudWithTitle:Key(@"serviceIsBusy")];
        }];
    }else{
        [self loadHeroPlistData];
    }
    
    //init items data
    NSString *itemPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"item.plist"];
    YSJLog(@"%@",itemPath);
    if ([fileManager fileExistsAtPath:itemPath] == NO){
        NSDictionary *param = @{@"key":SteamAPIKey,@"language":SteamParamLanguage};
        [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/IEconDOTA2_570/GetGameItems/v1" isPost:NO parameters:param complete:^(id response) {
            NSArray *arr = response[@"result"][@"items"];
            YSJLog(@"%@",arr);
            [fileManager createFileAtPath:itemPath contents:nil attributes:nil];
            [arr writeToFile:itemPath atomically:YES];
            [self loadItemPlistData];
        } fail:^(NSURLSessionTask *operation, NSError *error) {
            [self showHudWithTitle:Key(@"serviceIsBusy")];
        }];
    }else{
        [self loadItemPlistData];
    }
    
    YSJTableViewCellGroup *groupAccount = [[YSJTableViewCellGroup alloc]init];
    groupAccount.header = Key(@"account");
    [self.dataArr addObject:groupAccount];
    
    YSJTableViewCellGroup *groupMatch = [[YSJTableViewCellGroup alloc]init];
    groupMatch.header = Key(@"matches");
    [self.dataArr addObject:groupMatch];
    
    
    IIViewDeckController *deckVC = (IIViewDeckController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    self.deckVC = deckVC;
}

- (void)loadHeroPlistData{
    if ([[Dota2HelperCommonTools shareTools] herosDic]) {
        return;
    }
    NSString *heroPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"hero.plist"];
    //arrayWithContentsOfURL        ok
    NSArray *heroArr = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:heroPath isDirectory:NO]];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in heroArr) {
        Hero *hero = [Hero heroWithDic:dic];
        [tempDic setObject:hero forKey:hero.heroId];
    }
    [[Dota2HelperCommonTools shareTools] setHerosDic:tempDic];
}

- (void)loadItemPlistData{
    if ([[Dota2HelperCommonTools shareTools] itemsDic]) {
        return;
    }
    NSString *itemPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"item.plist"];
    //arrayWithContentsOfFile       ok
    NSArray *itemArr = [NSArray arrayWithContentsOfFile:itemPath];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in itemArr) {
        Item *item = [Item itemWithDic:dic];
        [tempDic setObject:item forKey:item.itemId];
    }
    [[Dota2HelperCommonTools shareTools] setItemsDic:tempDic];
}

- (void)loadAccountData{
    NSString *steamID = [self.paramAccount objectForKey:@"steamids"];
    if (!steamID || [steamID isEqualToString:@""]) {
        return;
    }
    [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/" isPost:NO parameters:self.paramAccount complete:^(id response) {
        YSJLog(@"%@",response);
        NSDictionary *dic = [response[@"response"][@"players"] firstObject];
        if (dic) {
            if (self.isMainAccount) {
                AccountItem *accountItem = [AccountItem itemWithDic:dic];
                self.accountItem = accountItem;
                [self checkRightLoveItem];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                long long steamID32Bit = [accountItem.steamId64bit longLongValue] - Steam64BitCalculateConstant;
                [self.paramMatch setObject:[NSString stringWithFormat:@"%lld",steamID32Bit] forKey:@"account_id"];
                [userDefault setObject:[NSString stringWithFormat:@"%lld",steamID32Bit] forKey:UserDefaultKeySteamID32Bit];
                [userDefault setObject:accountItem.steamId64bit forKey:UserDefaultKeySteamID64Bit];
            }
            
            YSJTableViewCellGroup *groupAccount = self.dataArr[0];
            groupAccount.itemArr = @[self.accountItem];
            
            YSJTableViewCellGroup *groupMatch = self.dataArr[1];
            groupMatch.itemArr = [NSArray array];
            [self.paramMatch removeObjectForKey:SteamParamStartAtMatchId];
            self.lastSteamId64Bit = self.accountItem.steamId64bit;
            [self loadMatchHistory];
        }else{
            [self endGetDataWithTitle:Key(@"accountHide")];
            if (self.lastSteamId64Bit) {
                [self.paramAccount setObject:self.lastSteamId64Bit forKey:@"steamids"];
            }
        }
    } fail:^(NSURLSessionTask *operation, NSError *error) {
        [self endGetDataWithTitle:Key(@"serviceIsBusy")];
    }];
}

- (void)loadMatchHistory{
    [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1" isPost:NO parameters:self.paramMatch complete:^(id response) {
        NSMutableArray *arr = [response[@"result"][@"matches"] mutableCopy];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        //去重
        for (int i = 0; i < arr.count; i++) {
            MatchItem *matchItem = [MatchItem itemWithDic:arr[i] AccountItem:self.accountItem];
            [tempArr addObject:matchItem];
        }
        if ([self.paramMatch objectForKey:SteamParamStartAtMatchId]) {
            for (int i = 0; i < tempArr.count; i++) {
                MatchItem *matchItem = tempArr[i];
                if ([matchItem.matchId isEqualToString:[self.paramMatch objectForKey:SteamParamStartAtMatchId]]) {
                    [tempArr removeObject:matchItem];
                    break;
                }
            }
        }
        if (arr.count == 0) {
            [self showHudWithTitle:Key(@"noMoreMatchData")];
            [self endGetDataWithTitle:nil];
            return;
        }
        YSJTableViewCellGroup *groupMatch = self.dataArr[1];
        NSMutableArray *oriArr = [groupMatch.itemArr mutableCopy];
        [oriArr addObjectsFromArray:tempArr];
        groupMatch.itemArr = oriArr;
        [self endGetDataWithTitle:nil];
    } fail:^(NSURLSessionTask *operation, NSError *error) {
        [self endGetDataWithTitle:Key(@"serviceIsBusy")];
    }];
}

- (void)endGetDataWithTitle:(NSString *)title{
    if (title) {
        [self showHudWithTitle:title];
    }
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)checkRightLoveItem{
    UIBarButtonItem *rightBarItem = self.navigationItem.rightBarButtonItem;
    UIButton *btn = rightBarItem.customView;
    if (!btn) {
        return;
    }
    NSArray *lovePlayerArr = [[Dota2HelperCommonTools shareTools] lovePlayerArr];
    for (NSDictionary *dic in lovePlayerArr) {
        if ([dic[LovePlayerKeySteamID32Bit] isEqualToString:self.accountItem.steamId32bit]) {
            btn.selected = YES;
            return;
        }
    }
    btn.selected = NO;
}

#pragma mark - btnClicked
- (void)settingBarButtonItemClicked{
//    IIViewDeckController *deckVC = (IIViewDeckController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    IIViewDeckController *deckVC = self.deckVC;
    if ([deckVC isSideClosed:IIViewDeckLeftSide]) {
        [deckVC toggleLeftView];
        [UIView animateWithDuration:deckVC.openSlideAnimationDuration animations:^{
            self.coverView.alpha = 0.2;
        }];
    }else{
        [deckVC toggleLeftView];
        [UIView animateWithDuration:deckVC.openSlideAnimationDuration animations:^{
            self.coverView.alpha = 0.0;
        }];
    }
}

- (void)loveBtnClicked{
    UIBarButtonItem *rightBarItem = self.navigationItem.rightBarButtonItem;
    UIButton *btn = rightBarItem.customView;
    
    NSMutableArray *loveArr = [[[Dota2HelperCommonTools shareTools] lovePlayerArr] mutableCopy];
    if (!loveArr) {
        loveArr = [NSMutableArray array];
    }
    if (btn.selected) {
        for (NSDictionary *dic in loveArr) {
            if ([dic[LovePlayerKeySteamID32Bit] isEqualToString:self.accountItem.steamId32bit]) {
                [loveArr removeObject:dic];
                [[Dota2HelperCommonTools shareTools] setLovePlayerArr:loveArr];
                [self showHudWithTitle:Key(@"cancelCollectPlayer")];
                break;
            }
        }
    }else{
        NSDictionary *playerDic = @{
                LovePlayerKeyUserHeadImgUrl:self.accountItem.iconImgUrl,
                LovePlayerKeyUserName:self.accountItem.personName,
                LovePlayerKeySteamID64Bit:self.accountItem.steamId64bit,
                LovePlayerKeySteamID32Bit:self.accountItem.steamId32bit};
        [loveArr addObject:playerDic];
        [[Dota2HelperCommonTools shareTools] setLovePlayerArr:loveArr];
        [self showHudWithTitle:Key(@"collectPlayer")];
    }
    btn.selected = !btn.selected;
}

#pragma mark - LeftViewController Delegate
- (void)userInputSteamID32Bit:(NSString *)SteamID32Bit{
    //注销逻辑
    if ([SteamID32Bit isEqualToString:@""]) {
        YSJTableViewCellGroup *groupAccount = self.dataArr[0];
        groupAccount.itemArr = nil;
        YSJTableViewCellGroup *groupMatch = self.dataArr[1];
        groupMatch.itemArr = nil;
        [self.tableView reloadData];
        [self settingBarButtonItemClicked];
        return;
    }
    //更换账号逻辑
    long long steamID64Bit = [SteamID32Bit longLongValue] + Steam64BitCalculateConstant;
    
    [self.paramAccount setObject:[NSString stringWithFormat:@"%lld",steamID64Bit] forKey:@"steamids"];
    [self loadAccountData];
    [self settingBarButtonItemClicked];
}

#pragma mark - TableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YSJTableViewCellGroup *group = self.dataArr[section];
    return group.itemArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 44;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    YSJTableViewCellGroup *group = self.dataArr[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    YSJTableViewCellGroup *group = self.dataArr[section];
    return group.footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSJTableViewCellGroup *group = self.dataArr[indexPath.section];
    YSJTableViewCellBasicItem *item = group.itemArr[indexPath.row];
    CommonTableViewCell *cell = [CommonTableViewCell cellWithTableView:tableView item:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSJTableViewCellGroup *group = self.dataArr[indexPath.section];
    if (indexPath.section == 0) {
        if (!self.isMainAccount) {
            return;
        }
        AccountViewController *accountVC = [[AccountViewController alloc]initWithAccountItem:group.itemArr[0] shouldShowMatches:NO];
        
        [self.navigationController pushViewController:accountVC animated:YES];
    }else{
        MatchItem *matchItem = group.itemArr[indexPath.row];
        MatchDetailViewController *detailVC = [MatchDetailViewController detailWithMatchID:matchItem.matchId];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableDictionary *)paramAccount{
    if (!_paramAccount) {
        _paramAccount = [NSMutableDictionary dictionary];
    }
    return _paramAccount;
}

- (NSMutableDictionary *)paramMatch{
    if (!_paramMatch) {
        _paramMatch = [NSMutableDictionary dictionary];
    }
    return _paramMatch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
