//
//  BrandsDroganWdViewController.m
//  AIClan
//
//  Created by hd on 2019/5/20.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "BrandsDroganWdViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ApplyWdViewController.h"
@interface BrandsDroganWdViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
}

@end

@implementation BrandsDroganWdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网点";
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height  - 2) style:UITableViewStylePlain];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    //    [_Maintableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
    [self.view addSubview:_Maintableview];
    
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 60, self.view.height - 60, 150, 30)];
    enterBtn.backgroundColor =NavColor;
    enterBtn.layer.cornerRadius = 8;
    [enterBtn setTitle:@"申请加盟" forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont fontWithName:@"STXinwei" size:22];
    [self.view addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(HandleEnter) forControlEvents:UIControlEventTouchUpInside];
}
- (void)HandleEnter
{
    [self.navigationController pushViewController:[ApplyWdViewController new] animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = XXColor(240, 240, 240, 1);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.view.width - 40, 150)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 8;
        [cell.contentView addSubview:bgView];

        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 35, 120, 120)];
        [headView setImage:[UIImage imageNamed:@"龙鱼图片"]];
        headView.backgroundColor = [UIColor whiteColor];
        headView.layer.cornerRadius = 8;
        headView.layer.masksToBounds = YES;
        [cell.contentView addSubview:headView];
        
        
        UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(headView.right + 20, 35, self.view.width, 25)];
        [infoLab2 setText:@"盘龙水族"];
        [infoLab2 setFont:[UIFont fontWithName:@"STXinwei" size:18]];
        [cell.contentView addSubview:infoLab2];
        
        UILabel *infoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(headView.right + 23,infoLab2.bottom + 3, 80, 18)];
        [infoLab3 setText:@"可提供上门服务"];
        infoLab3.textColor = NavColor;
        infoLab3.layer.borderColor = NavColor.CGColor;
        infoLab3.layer.borderWidth = 1;
        [infoLab3 setFont:[UIFont fontWithName:@"STXinwei" size:10]];
        [cell.contentView addSubview:infoLab3];
        
        UIImageView *locView = [[UIImageView alloc] initWithFrame:CGRectMake(headView.right + 20, infoLab3.bottom + 15, 15, 20)];
        [locView setImage:[UIImage imageNamed:@"地址"]];
        [cell.contentView addSubview:locView];
        
        UILabel *infoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(locView.right + 5, infoLab3.bottom, self.view.width - headView.right - 60, 50)];
        infoLab4.numberOfLines = 0;
        infoLab4.textColor = [UIColor darkGrayColor];
        [infoLab4 setText:@"湖北武汉市洪山区光谷大道888号花鸟鱼虫市场A666号"];
        [infoLab4 setFont:[UIFont fontWithName:@"STXinwei" size:13]];
        [cell.contentView addSubview:infoLab4];
        
        UILabel *infoLab5 = [[UILabel alloc] initWithFrame:CGRectMake(headView.right + 20, bgView.bottom - 30, self.view.width - headView.right - 50, 30)];
        [infoLab5 setText:@"1688人访问| 了解更多>"];
        infoLab5.textAlignment = NSTextAlignmentRight;
        [infoLab5 setFont:[UIFont fontWithName:@"STXinwei" size:14]];
        [cell.contentView addSubview:infoLab5];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view showResult:@"暂未开通详情"];
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
