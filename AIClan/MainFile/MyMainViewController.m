//
//  MyMainViewController.m
//  AIClan
//
//  Created by hd on 2018/10/15.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "MyMainViewController.h"
#import "AppDelegate.h"
#import "HdLoginViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ModifyMyViewController.h"
#import "NewsCenterViewController.h"
#import "FishknowleViewController.h"
#import "FishLogViewController.h"
#import "LogViewController.h"
#import "ConsultViewController.h"
#import "WebLoadViewController.h"
#import "NavCheckViewController.h"
#import "DroganFishViewController.h"
#import "BrandsViewController.h"

@interface MyMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *orderinfoArr;
    UILabel *titleLab;
    UILabel *titleLab2;
    UIImageView *imagV;
}

@end

@implementation MyMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    bgV.backgroundColor = NavColor;
    [self.view addSubview:bgV];
//    self.view.backgroundColor = NavColor;
    [self addRightButton:@"setting" secondName:@"help" action:^(int status, NSString *searchKey) {
        if (status == 1000) {
            [self ClickModify];
        }
        else if (status == 1001){
            [self.navigationController pushViewController:[LogViewController new] animated:YES];

        }
    }];
//    [self addRightButton:@"" imageName:@"help" action:^(int status, NSString *searchKey) {
//        AppDelegate* appDelagete =  (AppDelegate*)[UIApplication sharedApplication].delegate;
//
//        appDelagete.window.rootViewController = [HdLoginViewController new];
//        [UIView animateWithDuration:0.4 animations:^{
//
//            appDelagete.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.4, 1.4);
//            appDelagete.window.rootViewController.view.alpha = 1;
//        } completion:^(BOOL finished) {
//            appDelagete.window.rootViewController.view.alpha = 1;
//        }];
//        appDelagete.window.rootViewController.view.transform = CGAffineTransformIdentity;
//    }];
    
    
    [self loadTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self userdata];
}

- (void)userdata
{
    [AppRequest Request_Normalpost:@"userinfo" json:@{} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [imagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,result[@"retRes"][@"file_url"]]] placeholderImage:EMPTYIMG];
            [titleLab setText:result[@"retRes"][@"title"]];
//            [titleLab2 setText:result[@"retRes"][@"file_url"]];

        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)loadTableView{
    
    
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  520;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 520)];
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 230)];
    topV.backgroundColor = NavColor;
    [headV addSubview:topV];

    imagV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 80, 80)];
    imagV.backgroundColor = [UIColor lightGrayColor];
    imagV.layer.masksToBounds = YES;
    imagV.layer.cornerRadius = imagV.width / 2;
    imagV.tag = 100;
    imagV.image = EMPTYIMG;
    [topV addSubview:imagV];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imagV.right + 10, 35, self.view.width - 120, 20)];
    [titleLab setText:@"蔡雨峰"];
    titleLab.tag = 101;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont fontWithName:FONTNAME size:20.0];
    [topV addSubview:titleLab];
    
    titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(imagV.right + 10, titleLab.bottom + 5, self.view.width - 120, 20)];
    [titleLab2 setText:@"当前积分256"];
    titleLab2.textColor = [UIColor whiteColor];
    titleLab2.tag = 102;
    titleLab2.font = [UIFont fontWithName:FONTNAME size:15.0];
    [topV addSubview:titleLab2];
    
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 93, titleLab.y + 5, 73, 30)];
    modifyBtn.layer.cornerRadius = 15.0;
    modifyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    modifyBtn.layer.borderWidth = 1.0;
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [modifyBtn setTitle:@"消息中心" forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(ClickCenter) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:modifyBtn];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, imagV.bottom + 15, self.view.width -20, 0.5)];
    [lineV setBackgroundColor:[UIColor whiteColor]];
    [topV addSubview:lineV];
    
    
    UIView *gridV = [[UIView alloc] initWithFrame:CGRectMake(0, lineV.bottom, self.view.width, 90)];
    [topV addSubview:gridV];
    
    for (int k = 0; k < 5; k ++) {
        UIButton *gridBtn = [[UIButton alloc] initWithFrame:CGRectMake(gridV.width / 5 * k, 10, gridV.width / 5, 40)];
        [gridBtn setTitle:@"" forState:UIControlStateNormal];
        [gridBtn.titleLabel setFont:[UIFont systemFontOfSize:40]];
        [gridV addSubview:gridBtn];
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake( gridV.width / 5 * k, gridBtn.bottom+5, gridV.width / 5, 20)];
        [infoLab setText:@""];
        infoLab.textAlignment = NSTextAlignmentCenter;
        infoLab.font = [UIFont fontWithName:FONTNAME size:15];
        infoLab.textColor = [UIColor whiteColor];
        [gridV addSubview:infoLab];

    }
    
    UIImageView *promotImgv = [[UIImageView alloc] initWithFrame:CGRectMake(25, topV.bottom - 20, self.view.width - 50, 50)];
    [promotImgv setImage:[UIImage imageNamed:@"warning-bg"]];

    UIImageView *iconImgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 23, 20)];
    [iconImgv setImage:[UIImage imageNamed:@"warning"]];
    [promotImgv addSubview:iconImgv];
    
    UIImageView *linev = [[UIImageView alloc] initWithFrame:CGRectMake(iconImgv.right + 10, 5, 0.5, 40)];
    [linev setImage:[UIImage imageNamed:@"line"]];
    [promotImgv addSubview:linev];
    
    UILabel *warnLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImgv.right + 20, 2, 100, 40)];
    warnLab.text = @"暂无预警信息";
    warnLab.textAlignment = NSTextAlignmentLeft;
    warnLab.font = [UIFont systemFontOfSize:15];
    [promotImgv addSubview:warnLab];
    
    UIView *gridV2 = [[UIView alloc] initWithFrame:CGRectMake(0, topV.bottom, self.view.width, 280)];
    gridV2.backgroundColor = [UIColor whiteColor];
    [headV addSubview:gridV2];
    
//    NSArray *imgArr = @[@"qiccai",@"pingpai",@"yangyu",@"yulei"];
//    NSArray *titleArr = @[@"器材分类",@"品牌分类",@"养鱼日志",@"鱼类知识"];
    NSArray *imgArr = @[@"yangyu",@"yulei",@"zxsd",@"hdjf",];
    NSArray *titleArr = @[@"养鱼日志",@"鱼类知识",@"咨询速答",@"活动积分"];
    
    NSArray *imgArr2 = @[@"xpcx",@"ppxc",@"ppxc"];
    NSArray *secondArr = @[@"芯片查询",@"龙鱼馆",@"品牌馆"];

    for (int k = 0; k < titleArr.count; k ++) {
        UIButton *gridBtn = [[UIButton alloc] initWithFrame:CGRectMake(gridV.width / 4 * k, 20, gridV.width / 4, gridV.width / 4)];
        gridBtn.tag = 1000+k;
        [gridBtn addTarget:self action:@selector(MenueClick:) forControlEvents:UIControlEventTouchUpInside];
        [gridBtn setImage:[UIImage imageNamed:imgArr[k]] forState:UIControlStateNormal];
        [gridV2 addSubview:gridBtn];
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake( gridV.width / 4 * k, gridBtn.bottom - 10, gridV.width / 4, 20)];
        [infoLab setText:titleArr[k]];
        infoLab.textAlignment = NSTextAlignmentCenter;
        infoLab.font = [UIFont fontWithName:FONTNAME size:16];
        infoLab.textColor = [UIColor darkGrayColor];
        [gridV2 addSubview:infoLab];
    }
    
    for (int k = 0; k < secondArr.count; k ++) {
        UIButton *gridBtn = [[UIButton alloc] initWithFrame:CGRectMake(gridV.width / 4 * k, gridV.width / 4 + 20, gridV.width / 4, gridV.width / 4)];
        gridBtn.tag = 2000+k;
        [gridBtn addTarget:self action:@selector(MenueClick:) forControlEvents:UIControlEventTouchUpInside];
        [gridBtn setImage:[UIImage imageNamed:imgArr2[k]] forState:UIControlStateNormal];
        [gridV2 addSubview:gridBtn];
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake( gridV.width / 4 * k, gridBtn.bottom - 10, gridV.width / 4, 20)];
        [infoLab setText:secondArr[k]];
        infoLab.textAlignment = NSTextAlignmentCenter;
        infoLab.font = [UIFont fontWithName:FONTNAME size:16];
        infoLab.textColor = [UIColor darkGrayColor];
        [gridV2 addSubview:infoLab];
    }
    
    
    
    [headV addSubview:promotImgv];

    return headV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, self.view.width, 0.5)];
        [cell.contentView addSubview:lineV];
        [lineV setBackgroundColor:[UIColor darkGrayColor]];
    }
    NSArray *imgArr = @[@"luntan",@"gouwu",@"dingdan",@"dizhi"];
    NSArray *titleArr = @[@"主力论坛",@"购物车",@"全部订单",@"收货地址"];
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.textLabel.text = titleArr[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)ClickModify
{
    ModifyMyViewController *modifyVc = [ModifyMyViewController new];
    [self.navigationController pushViewController:modifyVc animated:YES];
}
- (void)ClickCenter
{
    NewsCenterViewController *newcVc = [NewsCenterViewController new];
    [self.navigationController pushViewController:newcVc animated:YES];
}

- (void)MenueClick:(UIButton *)btn{
    
    if (btn.tag < 2000) {
        if (btn.tag == 1000) {
            [self.navigationController pushViewController:[FishLogViewController new] animated:YES];
        }
        else if (btn.tag == 1001) {
            [self.navigationController pushViewController:[FishknowleViewController new] animated:YES];
        }
        else if (btn.tag == 1002)
        {
            [self.navigationController pushViewController:[ConsultViewController new] animated:YES];
        }
        else
        {
            [self.view showResult:@"活动积分功能开发中，后期更新.."];
        }
    }
    else
    {
        if (btn.tag == 2000)
        {
            WebLoadViewController *webv = [WebLoadViewController new];
            webv.title = @"芯片查询";
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:webv] animated:YES completion:^{
                
            }];
        }
        else if (btn.tag == 2001)
        {
            
            [self.navigationController pushViewController:[DroganFishViewController new] animated:YES];
        }
        else if (btn.tag == 2002)
        {
            
            [self.navigationController pushViewController:[BrandsViewController new] animated:YES];
        }
    }
  
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
