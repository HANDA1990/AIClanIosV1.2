//
//  NewsCenterViewController.m
//  AIClan
//
//  Created by hd on 2018/11/19.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "NewsCenterViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NewsDetailViewController.h"

@interface NewsCenterViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *orderinfoArr;
    UITextField *searchTxt;
    UIButton *searchBtn;
}
@end

@implementation NewsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    bgV.backgroundColor = NavColor;
    bgV.userInteractionEnabled = YES;
    [self.view addSubview:bgV];
    if (!searchTxt) {
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, self.view.width - 100, 40)];
        searchTxt.layer.borderWidth = 0.5;
        searchTxt.userInteractionEnabled = YES;
        searchTxt.layer.borderColor = [UIColor whiteColor].CGColor;
        searchTxt.backgroundColor = [UIColor whiteColor];
        searchTxt.layer.cornerRadius = 4.0f;
        searchTxt.placeholder = @"请输入搜索关键字";
        [self.navigationController.navigationBar addSubview:searchTxt];
        
        searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchTxt.right - 40, 5, 30, 30)];
        [searchBtn setImage:[UIImage imageNamed:@"searchic"] forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:searchBtn];
        [searchBtn addTarget:self action:@selector(clickReloads) forControlEvents:UIControlEventTouchUpInside];
    }

    [self loadTableView];

}

- (void)viewWillDisappear:(BOOL)animated{
    searchTxt.hidden = YES;
    searchBtn.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    searchTxt.hidden = NO;
    searchBtn.hidden = NO;
    [self clickReloads];
}
- (void)loadTableView{
    
    float hb = Height_NavBar;
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, self.view.frame.size.width, self.view.frame.size.height - hb) style:UITableViewStyleGrouped];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor grayColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    
}

- (void)clickReloads{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"news" json:@{@"title":searchTxt.text ? searchTxt.text : @"",@"page":@"1",@"page_size":@"50"} controller:self completion:^(id result, NSInteger statues) {
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
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIView *redPointV = [[UIView alloc] initWithFrame:CGRectMake(5, 15, 10, 10)];
        redPointV.backgroundColor = [UIColor redColor];
        redPointV.layer.cornerRadius = redPointV.width / 2;
        [cell.contentView addSubview:redPointV];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.width - 20, 20)];
        titleLab.tag = 1000;
        titleLab.font = [UIFont systemFontOfSize:20.0];
        [cell.contentView addSubview:titleLab];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLab.bottom, self.view.width - 20, 30)];
        infoLab.tag = 1001;
        infoLab.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:infoLab];
        
        UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, infoLab.bottom, self.view.width - 20, 30)];
        infoLab2.tag = 1002;
        infoLab2.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:infoLab2];
    }
    
    NSDictionary *infoDic = orderinfoArr[indexPath.row];
    [(UILabel *)[cell.contentView viewWithTag:1000] setText:infoDic[@"title"]];
    [(UILabel *)[cell.contentView viewWithTag:1001] setText:[self getTimeFromTimesTamp:infoDic[@"create_time"]]];
    [(UILabel *)[cell.contentView viewWithTag:1002] setText:infoDic[@"sub_title"]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController *newsDetailVc = [NewsDetailViewController new];
    newsDetailVc.newsid = orderinfoArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:newsDetailVc animated:YES];
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
