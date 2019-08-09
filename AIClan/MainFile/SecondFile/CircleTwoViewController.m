
//
//  CircleTwoViewController.m
//  AIClan
//
//  Created by hd on 2018/12/16.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "CircleTwoViewController.h"
#import "MTTCircularSlider.h"

#define Color292c30 [UIColor colorWithRed:41 / 255.0 green:44 / 255.0 blue:48 / 255.0 alpha:1]
#define Color14191e [UIColor colorWithRed:20 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1]
#define Colorfeb913 [UIColor colorWithRed:254 / 255.0 green:185 / 255.0 blue:19 / 255.0 alpha:1]

@interface CircleTwoViewController ()
@property (nonatomic, strong) MTTCircularSlider* defaultSlider;
@property (nonatomic, strong) UILabel* angleLabel;
@end

@implementation CircleTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addRightButton:@"确定" imageName:@"" action:^(int status, NSString *searchKey) {
        [self.handleInfo setObject:self.angleLabel.text forKey:@"value"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.defaultSlider];
    [self.view addSubview:self.angleLabel];
}
- (MTTCircularSlider*)defaultSlider
{
    if (!_defaultSlider) {
        _defaultSlider = [[MTTCircularSlider alloc] initWithFrame:CGRectMake(10,100, self.view.width - 20, self.view.width - 20)];
        _defaultSlider.lineWidth = 40;
        _defaultSlider.transform = CGAffineTransformRotate(_defaultSlider.transform, -M_PI / 2);
        _defaultSlider.angle = [_v_x floatValue] * 360.0 / _baseFloat;
        _defaultSlider.maxValue = 360.0;
        _defaultSlider.selectColor = Colorfeb913;
        _defaultSlider.unselectColor = Color14191e;
        _defaultSlider.tag = 1;
        [_defaultSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //        [_defaultSlider addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _defaultSlider;
}
- (void)sliderValueChanged:(MTTCircularSlider*)slider
{
    switch (slider.tag) {
        case 2:
            self.defaultSlider.minAngle = slider.angle;
            break;
        case 3:
            self.defaultSlider.maxAngle = slider.angle;
            break;
    }

    self.angleLabel.text = [NSString stringWithFormat:@"%.1f", self.defaultSlider.angle* _baseFloat / 360.0 + _addFloat];
}
- (UILabel*)angleLabel
{
    if (!_angleLabel) {
        _angleLabel = [UILabel new];
        _angleLabel.frame = CGRectMake(0, 0, 120, 40);
        _angleLabel.center = self.defaultSlider.center;
        _angleLabel.textAlignment = NSTextAlignmentCenter;
        _angleLabel.font = [UIFont boldSystemFontOfSize:30];
        _angleLabel.textColor = Colorfeb913;
        _angleLabel.text = [NSString stringWithFormat:@"%.1f", [_v_x floatValue]  + _addFloat];
    }
    return _angleLabel;
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
