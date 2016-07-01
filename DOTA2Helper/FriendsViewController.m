//
//  FriendsViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/20.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "FriendsViewController.h"
#import "AccountItem.h"
#import "YSJWebService.h"
#import "FriendItem.h"
#import "MJRefresh.h"
#import "AccountViewController.h"
#import "CommonTableViewCell.h"

@interface FriendsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation FriendsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadData];
}

- (void)loadData{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *steamID64bit = [userDefault objectForKey:UserDefaultKeySteamID64Bit];
    NSDictionary *paramFriends = @{@"key":SteamAPIKey,@"steamid":steamID64bit,@"relationship":@"friend"};
    [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/ISteamUser/GetFriendList/v0001/" isPost:NO parameters:paramFriends complete:^(id response) {
        NSMutableArray *tempArr = [response[@"friendslist"][@"friends"] mutableCopy];
        NSMutableString *accountStr = [NSMutableString string];
        for (NSDictionary *dic in tempArr) {
            [accountStr appendFormat:@"%@|",dic[@"steamid"]];
        }
        NSDictionary *paramAccounts = @{@"key":SteamAPIKey,@"steamids":accountStr};
        [YSJWebService requestTarget:self withUrl:@"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/" isPost:NO parameters:paramAccounts complete:^(id response) {
            NSArray *arr = response[@"response"][@"players"];
            NSMutableArray *friendArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                FriendItem *item = [FriendItem itemWithDic:dic];
                for (NSDictionary *friendDic in tempArr) {
                    if ([friendDic[@"steamid"] longLongValue] == [item.steamId64bit longLongValue]) {
                        item.friendTime = friendDic[@"friend_since"];
                        [tempArr removeObject:friendDic];
                        [friendArr addObject:item];
                        break;
                    }
                }
            }
            for (int i = 0; i < friendArr.count; i++) {
                FriendItem *itemI = friendArr[i];
                long offTimeI = [itemI.lastLoginTime longValue];
                for (int j = i+1; j < friendArr.count; j++) {
                    FriendItem *itemJ = friendArr[j];
                    long offTimeJ = [itemJ.lastLoginTime longValue];
                    if (offTimeI < offTimeJ) {
                        [friendArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                        offTimeI = offTimeJ;
                    }
                }
            }
            self.dataArr = friendArr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } fail:^(NSURLSessionTask *operation, NSError *error) {
            [self showHudWithTitle:Key(@"serviceIsBusy")];
            [self.tableView.mj_header endRefreshing];
        }];
    } fail:^(NSURLSessionTask *operation, NSError *error) {
        [self showHudWithTitle:Key(@"serviceIsBusy")];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)initViews{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTableViewCell *cell = [CommonTableViewCell cellWithTableView:tableView item:self.dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountItem *accountItem = self.dataArr[indexPath.row];
    AccountViewController *accountVC = [[AccountViewController alloc]initWithAccountItem:accountItem shouldShowMatches:YES];
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
