//
//  FishbowlControlViewController.m
//  AIClan
//
//  Created by hd on 2018/10/25.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "FishbowlControlViewController.h"
#import "EditWaterQualityViewController.h"
#import "NewEquipmentViewController.h"
#import "NavCheckViewController.h"

@interface FishbowlControlViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_Maintableview;
    NSArray *reData;
}
@end

@implementation FishbowlControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"鱼缸管理";
    
    [self addRightButton:@"" imageName:@"add" action:^(int status, NSString *searchKey) {
        EditWaterQualityViewController *editV = [EditWaterQualityViewController new];
        editV.acccardtype_id = @"0";
        editV.acccardStr = @"";
        [self.navigationController pushViewController:editV animated:YES];
    }];
    
    _Maintableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    _Maintableview.scrollEnabled = NO;
    [self.view addSubview:_Maintableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadBaseDatas];
}
- (void)reloadBaseDatas{
    [AppRequest Request_Normalpost:@"yglists" json:@{} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            reData = result[@"retRes"];
            [_Maintableview reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return reData.count;
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
    return 50;
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
        
        UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.view.width, 0.5)];
        linev.backgroundColor = XXColor(180, 180, 180, 1);
        [cell.contentView addSubview:linev];
        
    }
    cell.imageView.image = [UIImage imageNamed:@"fishBowl"];
    cell.textLabel.text = reData[indexPath.row][@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@个设备",reData[indexPath.row][@"counts"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditWaterQualityViewController *editV = [EditWaterQualityViewController new];
    editV.acccardtype_id = reData[indexPath.row][@"id"];
    editV.acccardStr = reData[indexPath.row][@"title"];
    [self.navigationController pushViewController:editV animated:YES];
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [AppRequest Request_Normalpost:@"scsb" json:@{@"id":reData[indexPath.row][@"id"]} controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                [self reloadBaseDatas];

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
