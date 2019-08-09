//
//  HistorySubMaineViewController.m
//  AIClan
//
//  Created by hd on 2018/11/4.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "HistorySubMaineViewController.h"
#import "HistoryContentViewController.h"

@interface HistorySubMaineViewController ()

@end

@implementation HistorySubMaineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史预约";
    HistoryContentViewController *viewVc1 = [HistoryContentViewController new];
    viewVc1.yyStatus = @"1";
    HistoryContentViewController *viewVc2 = [HistoryContentViewController new];
    viewVc2.yyStatus = @"2";
    HistoryContentViewController *viewVc3 = [HistoryContentViewController new];
    viewVc3.yyStatus = @"3";

    [self initWithtitleArray:@[viewVc1,viewVc2,viewVc3] titleArray:@[@"未处理",@"已完成",@"已作废"] selectNum:0];

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
