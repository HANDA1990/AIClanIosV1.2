//
//  SelectedViewController.m
//  AIClan
//
//  Created by hd on 2018/11/14.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "SelectedViewController.h"
#import "LYSDatePickerController.h"

@interface SelectedViewController ()<LYSDatePickerSelectDelegate>
{

}
@end

@implementation SelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"时间筛选";
    float hb = Height_NavBar;

    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + hb, self.view.width, 100)];
    [self.view addSubview:topV];
    
    [topV setShadowLayer:topV];
    UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 50)];
    startLab.text = @"起始时间";
    startLab.textColor = [UIColor darkGrayColor];
    [topV addSubview:startLab];

    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(startLab.right+10, 0, self.view.width -(startLab.right+10) , 50)];
    [startBtn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.tag = 1000;
    startBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [startBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [topV addSubview:startBtn];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(20, startBtn.bottom, self.view.width - 20, 0.5)];
    lineV.backgroundColor = [UIColor darkGrayColor];
    [topV addSubview:lineV];
    
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(20, lineV.bottom, 100, 50)];
    endLab.text = @"结束时间";
    endLab.textColor = [UIColor darkGrayColor];
    [topV addSubview:endLab];

    UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(startLab.right+10, lineV.bottom, self.view.width -(startLab.right+10), 50)];
    endBtn.tag = 1001;
    endBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [endBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [topV addSubview:endBtn];
    [endBtn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *handleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topV.bottom + 30, self.view.width - 40, 50)];
    handleBtn.tag = 1002;
    [handleBtn setTitle:@"提交" forState:UIControlStateNormal];
    handleBtn.backgroundColor = NavColor;
    [self.view addSubview:handleBtn];
    [handleBtn addTarget:self action:@selector(handleView) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickShow:(UIButton *)btn{
    LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
    datePicker.headerView.backgroundColor = [UIColor whiteColor];
    datePicker.indicatorHeight = 1;
    datePicker.delegate = self;
    datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
    datePicker.headerView.leftItem.textColor = [UIColor redColor];
    datePicker.headerView.rightItem.textColor = NavColor;
    datePicker.pickHeaderHeight = 40;
    datePicker.pickType = LYSDatePickerTypeDay;
    datePicker.minuteLoop = YES;
    datePicker.headerView.showTimeLabel = NO;
    datePicker.weakDayType = LYSDatePickerWeakDayTypeCNShort;
    datePicker.showWeakDay = YES;
    [datePicker setDidSelectDatePicker:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [dateFormat stringFromDate:date];
        [btn setTitle:currentDate forState:UIControlStateNormal];
        if (btn.tag == 1000) {
            self.startTime = currentDate;
        }
        else if (btn.tag == 1001)
        {
            self.endTime = currentDate;
        }
    }];
    [datePicker showDatePickerWithController:self];
}

- (void)handleView
{
    [self.navigationController popViewControllerAnimated:YES];
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
