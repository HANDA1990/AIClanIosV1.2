//
//  FishLogDetailViewController.m
//  AIClan
//
//  Created by hd on 2018/11/21.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "FishLogDetailViewController.h"
#import "TPKeyboardAvoidingTableView.h"

@interface FishLogDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSDictionary *orderinfoDic;
    CGFloat heightT;
    CGFloat heightF;
}

@end

@implementation FishLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    bgV.backgroundColor = NavColor;
    bgV.userInteractionEnabled = YES;
    [self.view addSubview:bgV];
    float hb = Height_NavBar;
    
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, self.view.frame.size.width, self.view.frame.size.height - hb) style:UITableViewStyleGrouped];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    [self clickReloads];
}
- (void)clickReloads{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"yyrzinfo" json:@{@"id":self.logid} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            orderinfoDic = result[@"retRes"];
            self.title = orderinfoDic[@"title"];
            heightT = [self getLabelHeightWithText:self.title width:self.view.width - 20 font:16.0];

            heightF = [self getLabelHeightWithText:orderinfoDic[@"contents"] width:self.view.width - 20 font:15.0];
            [_Maintableview reloadData];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([orderinfoDic[@"img_file_urls"] isKindOfClass:[NSArray class]]) {
        return [orderinfoDic[@"img_file_urls"] count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  heightF + heightT + 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 20, heightF + heightT + 20)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, heightT)];
    titleLab.text = orderinfoDic[@"sub_title"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:FONTNAME size:16];
    titleLab.numberOfLines = 0;
    [headV addSubview:titleLab];
    
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLab.bottom + 5, self.view.width - 20, heightF)];
    titleLab2.text = orderinfoDic[@"contents"];
    titleLab2.textColor = [UIColor grayColor];
    titleLab2.font = [UIFont fontWithName:FONTNAME size:15];
    titleLab2.numberOfLines = 0;
    [headV addSubview:titleLab2];

    return headV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.width - 10;
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 20, self.view.width - 20)];
        imgV.tag = 1000;
        [cell.contentView addSubview:imgV];
    }
    NSString *imgStr = orderinfoDic[@"img_file_urls"][indexPath.row];

    [(UIImageView *)[cell.contentView viewWithTag:1000] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,imgStr]] placeholderImage:EMPTYIMG];
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
