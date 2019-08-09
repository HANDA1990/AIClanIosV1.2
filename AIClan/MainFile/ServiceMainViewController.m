//
//  ServiceMainViewController.m
//  AIClan
//
//  Created by hd on 2018/10/15.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ServiceMainViewController.h"
#import "ProfesserViewController.h"
#import "WebsiteViewController.h"
#import "MemoViewController.h"
@interface ServiceMainViewController ()

@end

@implementation ServiceMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ProfesserViewController *viewVc1 = [ProfesserViewController new];
    WebsiteViewController *viewVc2 = [WebsiteViewController new];
    MemoViewController *viewVc3 = [MemoViewController new];
    
    [self initWithtitleArray:@[viewVc1,viewVc2,viewVc3] titleArray:@[@"专家咨询",@"网点咨询",@"备忘设置"] selectNum:0];

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
