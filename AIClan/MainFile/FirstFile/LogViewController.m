//
//  LogViewController.m
//  AIClan
//
//  Created by hd on 2018/10/17.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "LogViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "LogDetailViewController.h"

@interface LogViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSMutableArray *dataArray;
}

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"操作日志";
    UIView *navColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    [navColor setBackgroundColor:NavColor];
    [self.view addSubview:navColor];
    
    dataArray = [[NSMutableArray alloc] init];
    float hd = Height_NavBar;
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, self.view.frame.size.width, self.view.frame.size.height - hd) style:UITableViewStyleGrouped];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    _Maintableview.scrollEnabled = NO;
    [self.view addSubview:_Maintableview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"czsm" json:@{} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:result[@"retRes"]];
            [_Maintableview reloadData];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = dataArray[indexPath.row][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogDetailViewController *logDetialVc = [LogDetailViewController new];
    logDetialVc.logid = dataArray[indexPath.row][@"id"];
    logDetialVc.title = dataArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:logDetialVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
