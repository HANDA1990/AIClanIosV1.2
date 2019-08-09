//
//  SmartMainViewController.m
//  AIClan
//
//  Created by hd on 2018/12/24.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "SmartMainViewController.h"

@interface SmartMainViewController ()

@end

@implementation SmartMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgV setImage:[UIImage imageNamed:@"zhineng"]];
    imgV.userInteractionEnabled = YES;
    self.view = imgV;
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [topV setBackgroundColor:NavColor];
    topV.userInteractionEnabled = YES;
    [self.view addSubview:topV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 80)];
    [titleLab setText:@"智能"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:30];
    titleLab.textColor = [UIColor whiteColor];
    [topV addSubview:titleLab];
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 25, 25)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"changeYg"] forState:UIControlStateNormal];
    [topV addSubview:leftBtn];
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(10, leftBtn.bottom, 60, 20)];
    [txtLab setText:@"切换鱼缸"];
    [leftBtn addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
    txtLab.font = [UIFont systemFontOfSize:11.5];
    txtLab.textColor = [UIColor whiteColor];
    [topV addSubview:txtLab];
    [self loadBaseView:topV];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadTopDatas];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;

}
- (void)changeBtn
{
    self.navigationController.tabBarController.selectedIndex = 0;
}
- (void)loadBaseView:(UIView *)topV{
    
    UILabel *tempuLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100, 20, 70, 40)];
    tempuLab.text = @"28";
    tempuLab.tag = 11;
    tempuLab.textAlignment = NSTextAlignmentRight;
    tempuLab.font = [UIFont systemFontOfSize:42];
    tempuLab.textColor = [UIColor whiteColor];
    [topV addSubview:tempuLab];
    
    UILabel *sL = [[UILabel alloc] initWithFrame:CGRectMake(tempuLab.right,  40, 20, 15)];
    sL.text = @"℃";
    sL.textAlignment = NSTextAlignmentLeft;
    sL.font = [UIFont boldSystemFontOfSize:17];
    sL.textColor = [UIColor whiteColor];
    [topV addSubview:sL];
    
    UILabel *placeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 110, tempuLab.bottom - 5, 100, 50)];
    placeLab.numberOfLines = 0;
    placeLab.tag = 12;
    placeLab.text = @"多云转中雨\n武汉.洪山";
    placeLab.font = [UIFont systemFontOfSize:15];
    placeLab.textColor = [UIColor whiteColor];
    [topV addSubview:placeLab];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 2;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    placeLab.attributedText = [[NSAttributedString alloc] initWithString:placeLab.text attributes:attributes];
    placeLab.textAlignment = NSTextAlignmentRight;

}
- (void)loadTopDatas{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"indexinfo" json:@{} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 1) {
            [(UILabel *)[self.view viewWithTag:11] setText:[NSString stringWithFormat:@"%@",result[@"retRes"][@"tq"][@"wd"]]];
            [(UILabel *)[self.view viewWithTag:12] setText:[NSString stringWithFormat:@"%@\n%@",result[@"retRes"][@"tq"][@"info"],result[@"retRes"][@"tq"][@"address"]]];
            
        }
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
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
