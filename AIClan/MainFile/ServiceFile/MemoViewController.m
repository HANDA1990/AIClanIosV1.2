//
//  MemoViewController.m
//  AIClan
//
//  Created by hd on 2018/10/17.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "MemoViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MemoDetailViewController.h"

@interface MemoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *orderinfoArr;
}

@end

@implementation MemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    [navColor setBackgroundColor:NavColor];
    [self.view addSubview:navColor];
    
    [self addRightButton:@"新增" imageName:@"" action:^(int status, NSString *searchKey) {
        MemoDetailViewController *memoDvc = [MemoDetailViewController new];
        memoDvc.title = @"新增备忘";
        [self.navigationController pushViewController:memoDvc animated:YES];
    }];
    [self TopView];
    [self loadTableView];
}
- (void)TopView{
    float hb = Height_NavBar;
    UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, hb + 10, self.view.width - 20, 45)];
    topBtn.backgroundColor = [UIColor whiteColor];
    topBtn.layer.cornerRadius = 4.0;
    [self.view addSubview:topBtn];

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 75, 9.5, 24, 24)];
    [imageV setImage:[UIImage imageNamed:@"addMo"]];
    [topBtn addSubview:imageV];
    UILabel *addLab = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right+5, 2, self.view.width - imageV.right, 45)];
    addLab.text = @"添加备忘设置";
    addLab.textColor = XXColor(200, 200, 200, 1);
    addLab.font = [UIFont fontWithName:FONTNAME size:16];
    [topBtn addSubview:addLab];

}
- (void)loadTableView{
    float hb = Height_NavBar;
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,hb + 65, self.view.frame.size.width, self.view.frame.size.height - hb - 65) style:UITableViewStylePlain];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor whiteColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self handleDatas];
}

- (void)handleDatas{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"bwxx" json:@{@"page":@"1",@"page_size":@"50"} controller:self completion:^(id result, NSInteger statues) {
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
    return  0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
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
        cell.backgroundColor = self.view.backgroundColor;
        
        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 20, 85)];
        bgV.backgroundColor = [UIColor whiteColor];
        bgV.layer.cornerRadius = 4.0;
        [cell.contentView addSubview:bgV];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.width - 30, 43)];
        [timeLab setText:@"时间：2018-09-27    23:00:00"];
        timeLab.tag = 100;
        timeLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        [bgV addSubview:timeLab];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(25, timeLab.bottom, self.view.width - 100, 0.5)];
        lineV.backgroundColor = XXColor(200, 200, 200, 1);
        [bgV addSubview:lineV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(timeLab.x, lineV.bottom, 50, 42)];
        infoLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        [infoLab setText:@"事宜："];
        [bgV addSubview:infoLab];
        
        UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(infoLab.right, lineV.bottom, self.view.width - 120, 42)];
        infoLab2.tag = 101;
        infoLab2.textColor = MainColor(1);
        infoLab2.numberOfLines = 0;
        infoLab2.font = [UIFont fontWithName:FONTNAME size:15.0];
        [infoLab2 setText:@"检查设备关联信息"];
        [bgV addSubview:infoLab2];
        
    }
    [(UILabel *)[cell.contentView viewWithTag: 100] setText:[NSString stringWithFormat:@"%@",[self getTimeFromTimesTamp:orderinfoArr[indexPath.row][@"create_time"]]]];
    [(UILabel *)[cell.contentView viewWithTag: 101] setText:[NSString stringWithFormat:@"%@",orderinfoArr[indexPath.row][@"title"]]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemoDetailViewController *memoDvc = [MemoDetailViewController new];
    memoDvc.memoType = 1;
    memoDvc.title = @"备忘详情";
    memoDvc.idStr = orderinfoArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:memoDvc animated:YES];
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [AppRequest Request_Normalpost:@"bwxxdel" json:@{@"id":orderinfoArr[indexPath.row][@"id"]} controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                [self handleDatas];
                
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
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
