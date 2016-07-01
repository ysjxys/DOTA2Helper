//
//  AccountViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/20.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "AccountViewController.h"
#import "UIView+YSJ.h"
#import "AccountItem.h"
#import "YSJTableViewCellBasicItem.h"
#import "NSNumber+YSJ.h"
#import "FriendItem.h"
#import "UIImageView+WebCache.h"
#import "HistoryViewController.h"
#import "UIBarButtonItem+YSJ.h"
#import "CommonTableViewCell.h"
#import "Dota2HelperCommonTools.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) AccountItem *accountItem;
@property (nonatomic, assign) BOOL shouldShowMatches;
@end

@implementation AccountViewController

- (instancetype)initWithAccountItem:(AccountItem *)accountItem shouldShowMatches:(BOOL)shouldShowMatches{
    self = [super init];
    self.accountItem = accountItem;
    self.shouldShowMatches = shouldShowMatches;
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithAccountItem: instead" userInfo:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkRightLoveItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initViews];
}

- (void)initData{
    self.nameLabel.text = self.accountItem.personName;
    
    NSMutableArray *tempArr = [NSMutableArray array];
    if (self.shouldShowMatches) {
        YSJTableViewCellBasicItem *item1 = [[YSJTableViewCellBasicItem alloc]init];
        item1.title = Key(@"matches");
        item1.rightViewType = rightViewTypeArrow;
        item1.selectedOption = ^{
            HistoryViewController *historyVC = [[HistoryViewController alloc]initWithAccountItem:self.accountItem];
            [self.navigationController pushViewController:historyVC animated:YES];
        };
        [tempArr addObject:item1];
    }
    
    YSJTableViewCellBasicItem *item2 = [[YSJTableViewCellBasicItem alloc]init];
    item2.title = @"Steam ID";
    item2.rightDesc = self.accountItem.steamId32bit;
    item2.rightViewType = rightViewTypeLabel;
    [tempArr addObject:item2];
    
    YSJTableViewCellBasicItem *item3 = [[YSJTableViewCellBasicItem alloc]init];
    item3.title = Key(@"createAccountTime");
    item3.rightDesc = [self.accountItem.createdTime since1970NumStrWithFormatter:@"yyyy-MM-dd"];
    item3.rightViewType = rightViewTypeLabel;
    [tempArr addObject:item3];
    
    YSJTableViewCellBasicItem *item4 = [[YSJTableViewCellBasicItem alloc]init];
    item4.title = Key(@"lastLoginOffTime");
    item4.rightDesc = [self.accountItem.lastLoginTime since1970NumStrWithFormatter:@"yyyy-MM-dd"];
    item4.rightViewType = rightViewTypeLabel;
    [tempArr addObject:item4];
    
    if ([self.accountItem isKindOfClass:[FriendItem class]]) {
        YSJTableViewCellBasicItem *item5 = [[YSJTableViewCellBasicItem alloc]init];
        FriendItem *friendItem = (FriendItem *)self.accountItem;
        item5.title = Key(@"friendTime");
        item5.rightDesc = [friendItem.friendTime since1970NumStrWithFormatter:@"yyyy-MM-dd"];
        item5.rightViewType = rightViewTypeLabel;
        [tempArr addObject:item5];
    }
    
    YSJTableViewCellBasicItem *item6 = [[YSJTableViewCellBasicItem alloc]init];
    item6.title = Key(@"profileurl");
    item6.rightViewType = rightViewTypeArrow;
    item6.selectedOption = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.accountItem.profileUrl]];
    };
    [tempArr addObject:item6];
    
    self.dataArr = tempArr;
}

- (void)initViews{
    UIBarButtonItem *loveBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"play_heart_2"] edgeInsets:UIEdgeInsetsZero higlightedImage:[UIImage imageNamed:@"play_heart_selected"] target:self action:@selector(loveBtnClicked)];
    self.navigationItem.rightBarButtonItem = loveBarButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _headBackView.clipsToBounds = YES;
    _headBackView.layer.cornerRadius = _headBackView.width/2;
    _headBackView.layer.borderColor = [[UIColor blackColor] CGColor];
    _headBackView.layer.borderWidth = 1.0f;
    
    _headImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.accountItem.iconImgUrl] placeholderImage:[UIImage imageNamed:@"placeholder image"]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTableViewCell *cell = [CommonTableViewCell cellWithTableView:tableView item:self.dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSJTableViewCellBasicItem *basicItem = self.dataArr[indexPath.row];
    if (basicItem.selectedOption) {
        basicItem.selectedOption();
    }
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
