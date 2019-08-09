//
//  HistoryOperateViewController.m
//  AIClan
//
//  Created by hd on 2018/11/14.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "HistoryOperateViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "SelectedViewController.h"

@interface HistoryOperateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSMutableArray *dataArray;
    SelectedViewController * seleVc;
}

@end

@implementation HistoryOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    seleVc = [SelectedViewController new];
    self.view.backgroundColor = [UIColor whiteColor];
    float hb = Height_NavBar;
    UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,10+hb, self.view.width - 20, 50)];
    [topBtn setShadowLayer:topBtn];
    topBtn.layer.cornerRadius = 4.0;
    [topBtn setTitle:@"点击按日期筛选" forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(clickChangeDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBtn];

    dataArray = [[NSMutableArray alloc] init];

    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, topBtn.bottom + 5, self.view.frame.size.width, self.view.frame.size.height - topBtn.bottom) style:UITableViewStyleGrouped];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    NSString *startStr = seleVc.startTime ? seleVc.startTime : @"";
    NSString *endStr = seleVc.endTime ? seleVc.endTime : @"";

    [AppRequest Request_Normalpost:@"bjlog" json:@{@"page":@"1",@"page_size":@"50",@"type_id":self.hisStr,@"start_date":startStr,@"end_date":endStr} controller:self completion:^(id result, NSInteger statues) {
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

- (void)clickChangeDate:(UIButton*)btn
{
    [self.navigationController pushViewController:seleVc animated:YES];
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
    return 89;
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
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 27, 27)];
        [logoImgV setImage:[UIImage imageNamed:@"ds"]];
        logoImgV.tag = 100;
        [cell.contentView addSubview:logoImgV];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(logoImgV.right + 10, 0, self.view.width - logoImgV.right - 10 - logoImgV.right - 10, 37)];
        timeLab.text = @"2018-11-11 22:34";
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.tag = 101;
        [cell.contentView addSubview:timeLab];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, timeLab.bottom, self.view.width, 0.5)];
        lineV.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:lineV];
        
        UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, lineV.bottom, self.view.width, 37)];
        timeLab2.text = @"2018-11-11 22:34";
        timeLab2.tag = 102;
        timeLab2.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:timeLab2];
        
        UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, timeLab2.bottom, self.view.width, 15)];
        lineV2.backgroundColor = XXColor(245, 245, 245, 1);
        [cell.contentView addSubview:lineV2];

    }
    [(UILabel *)[cell.contentView viewWithTag:101] setText:[self getTimeFromTimesTamp:dataArray[indexPath.row][@"create_time"]]];
    [(UILabel *)[cell.contentView viewWithTag:102] setText:dataArray[indexPath.row][@"title"]];

    return cell;
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
