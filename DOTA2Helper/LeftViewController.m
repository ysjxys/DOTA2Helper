//
//  LeftViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "LeftViewController.h"
#import "UIView+YSJ.h"
#import "YSJTableViewCellGroup.h"
#import "YSJTableViewCellBasicItem.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CommonTableViewCell.h"
#import "Dota2HelperCommonTools.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@property (nonatomic, strong) YSJTableViewCellGroup *groupLovePlayer;
@end

@implementation LeftViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_dataArr) {
        [self initData];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:UserDefaultKeySteamID32Bit]) {
        YSJTableViewCellGroup *group1 = self.dataArr[0];
        YSJTableViewCellBasicItem *item11 = group1.itemArr[0];
        item11.title = [NSString stringWithFormat:@"steamID: %@",[userDefault objectForKey:UserDefaultKeySteamID32Bit]];
    }
    
    YSJTableViewCellGroup *group2 = self.dataArr[1];
    YSJTableViewCellBasicItem *item21 = group2.itemArr[0];
    NSString *cache = [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] getSize] countStyle:NSByteCountFormatterCountStyleFile];
    item21.title = [NSString stringWithFormat:@"%@ %@",Key(@"clearCache"),cache];
    
    [self initLoveList];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGBA(20, 20, 20, 1);
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initViews];
}

- (void)initLoveList{
    NSArray *loveArr = [[Dota2HelperCommonTools shareTools] lovePlayerArr];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in loveArr) {
        YSJTableViewCellBasicItem *basicItem = [YSJTableViewCellBasicItem itemWithTitle:dic[LovePlayerKeyUserName] desc:nil rightViewType:rightViewTypeNone];
        basicItem.leftImgUrlStr = dic[LovePlayerKeyUserHeadImgUrl];
        basicItem.selectedOption = ^{
            [self.delegate userInputSteamID32Bit:dic[LovePlayerKeySteamID32Bit]];
        };
        [tempArr addObject:basicItem];
    }
    self.groupLovePlayer.itemArr = tempArr;
    self.groupLovePlayer.header = tempArr.count>0?Key(@"collectPlayer"):@"";
}

- (void)initViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)initData{
    YSJTableViewCellGroup *group1 = [[YSJTableViewCellGroup alloc]init];
    
    YSJTableViewCellBasicItem *item11 = [YSJTableViewCellBasicItem itemWithTitle:Key(@"pleaseInputYourSteamID") desc:nil rightViewType:rightViewTypeNone];
    item11.selectedOption = ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:Key(@"pleaseInputYourSteamID") delegate:self cancelButtonTitle:Key(@"cancel") otherButtonTitles:Key(@"sure"), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 0;
        [alert show];
    };
    group1.itemArr = @[item11];
    
    
    YSJTableViewCellGroup *group2 = [[YSJTableViewCellGroup alloc]init];
    
    NSString *cache = [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] getSize] countStyle:NSByteCountFormatterCountStyleFile];
    NSString *title21 = [NSString stringWithFormat:@"%@ %@",Key(@"clearCache"),cache];
    
    YSJTableViewCellBasicItem *item21 = [YSJTableViewCellBasicItem itemWithTitle:title21 desc:nil rightViewType:rightViewTypeNone];
    item21.selectedOption = ^{
        [self clearCache];
    };
    group2.itemArr = @[item21];
    
    YSJTableViewCellGroup *group3 = [[YSJTableViewCellGroup alloc]init];
    YSJTableViewCellBasicItem *item31 = [YSJTableViewCellBasicItem itemWithTitle:Key(@"loginOut") desc:nil rightViewType:rightViewTypeNone];
    item31.selectedOption = ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:Key(@"sureToLoginOut") delegate:self cancelButtonTitle:Key(@"cancel") otherButtonTitles:Key(@"sure"), nil];
        alert.tag = 1;
        [alert show];
    };
    group3.itemArr = @[item31];
    
    _dataArr = @[group1, group2, group3, self.groupLovePlayer];
}



- (void)clearCache{
//    float beforeSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    
    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
        
//        float afterSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//        NSString *str = [NSString stringWithFormat:@"一共腾出%.2lfM的空间",beforeSize-afterSize];
        YSJLog(@"%@",str);
        [self showHudWithTitle:Key(@"clearFinished")];
    }];
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    YSJLog(@"selected index:%ld",buttonIndex);
    if (buttonIndex == 0) {
        return;
    }
    if (alertView.tag == 0) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        [tf resignFirstResponder];
        [self.delegate userInputSteamID32Bit:tf.text];
    }else if (alertView.tag == 1){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:UserDefaultKeySteamID64Bit];
        [userDefault removeObjectForKey:UserDefaultKeySteamID32Bit];
        YSJTableViewCellGroup *group1 = self.dataArr[0];
        YSJTableViewCellBasicItem *item11 = group1.itemArr[0];
        item11.title = Key(@"pleaseInputYourSteamID");
        [self.delegate userInputSteamID32Bit:@""];
    }
}

#pragma mark - TableView Delegate & Datasource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    YSJTableViewCellGroup *group = self.dataArr[section];
    return group.header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YSJTableViewCellGroup *group = self.dataArr[section];
    return group.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSJTableViewCellGroup *group = self.dataArr[indexPath.section];
    CommonTableViewCell *cell = [CommonTableViewCell cellWithTableView:tableView item:group.itemArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSJTableViewCellGroup *group = self.dataArr[indexPath.section];
    YSJTableViewCellBasicItem *item = group.itemArr[indexPath.row];
    item.selectedOption();
}

#pragma  mark - init method

- (YSJTableViewCellGroup *)groupLovePlayer{
    if (!_groupLovePlayer) {
        _groupLovePlayer = [[YSJTableViewCellGroup alloc]init];
    }
    return _groupLovePlayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
