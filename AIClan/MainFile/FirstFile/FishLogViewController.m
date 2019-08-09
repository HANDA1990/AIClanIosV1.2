//
//  FishLogViewController.m
//  AIClan
//
//  Created by hd on 2018/11/21.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "FishLogViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "FishLogDetailViewController.h"
#import "LogWriteViewController.h"

@interface FishLogViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *orderinfoArr;

}
@end

@implementation FishLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"养鱼日志";
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    bgV.backgroundColor = NavColor;
    [self.view addSubview:bgV];
    [self addRightButton:@"写日志" imageName:@"" action:^(int status, NSString *searchKey) {
        [self.navigationController pushViewController:[LogWriteViewController new] animated:YES];
    }];
    float hb = Height_NavBar;

    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, self.view.frame.size.width, self.view.frame.size.height - hb) style:UITableViewStyleGrouped];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor grayColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    [self clickReloads];
}

- (void)clickReloads{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"yyrz" json:@{@"page":@"1",@"page_size":@"50"} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            orderinfoArr = result[@"retRes"];
            [_Maintableview reloadData];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderinfoArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 80, 80)];
        logoImgV.tag = 999;
        [cell.contentView addSubview:logoImgV];

        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(logoImgV.right + 5, 10, self.view.width - 20, 20)];
        titleLab.tag = 1000;
        titleLab.font = [UIFont fontWithName:FONTNAME size:14.0];
        titleLab.font = [UIFont systemFontOfSize:20.0];
        [cell.contentView addSubview:titleLab];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(logoImgV.right + 5, titleLab.bottom, self.view.width - 20, 30)];
        infoLab.tag = 1001;
        infoLab.font = [UIFont fontWithName:FONTNAME size:14.0];
        infoLab.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:infoLab];
        
        UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(logoImgV.right + 5, infoLab.bottom, self.view.width - 20, 20)];
        infoLab2.tag = 1002;
        infoLab2.font = [UIFont fontWithName:FONTNAME size:14.0];
        infoLab2.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:infoLab2];
    }
    NSDictionary *infoDic = orderinfoArr[indexPath.row];
    [(UIImageView *)[cell.contentView viewWithTag:999] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,infoDic[@"file_url"]]] placeholderImage:EMPTYIMG];

    [(UILabel *)[cell.contentView viewWithTag:1000] setText:infoDic[@"title"]];
    [(UILabel *)[cell.contentView viewWithTag:1001] setText:[self getTimeFromTimesTamp:infoDic[@"create_time"]]];
    [(UILabel *)[cell.contentView viewWithTag:1002] setText:infoDic[@"sub_title"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDic = orderinfoArr[indexPath.row];

    FishLogDetailViewController *logDtVc = [FishLogDetailViewController new];
    logDtVc.logid = infoDic[@"id"];
    [self.navigationController pushViewController:logDtVc animated:YES];
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
