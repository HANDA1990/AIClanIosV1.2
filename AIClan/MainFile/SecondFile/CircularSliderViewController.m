//
//  CircularSliderViewController.m
//  AIClan
//
//  Created by hd on 2018/11/29.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "CircularSliderViewController.h"
#import "MTTCircularSlider.h"

#define Color292c30 [UIColor colorWithRed:41 / 255.0 green:44 / 255.0 blue:48 / 255.0 alpha:1]
#define Color14191e [UIColor colorWithRed:20 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1]
#define Colorfeb913 [UIColor colorWithRed:254 / 255.0 green:185 / 255.0 blue:19 / 255.0 alpha:1]

@interface CircularSliderViewController ()
@property (nonatomic, strong) MTTCircularSlider* defaultSlider;
@property (nonatomic, strong) UILabel* angleLabel;

@end

@implementation CircularSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_sendtag == 10001 ) {
        self.title = @"造浪强度";
    }
    else if (_sendtag == 10002){
        self.title = @"运行模式";
    }
    else if (_sendtag == 10003){
        self.title = @"投食高位";
    }
    else if (_sendtag == 10004){
        self.title = @"当前模式";
    }
    else if (_sendtag == 10005){
        self.title = @"投食低位";
    }
    [self addRightButton:@"确定" imageName:@"" action:^(int status, NSString *searchKey) {
        NSString *str;
        NSDictionary *dic;
        if (_sendtag == 10001 ) {
            str = @"sbzl";
            dic = @{@"id":_dangweiid,@"v_1":self.angleLabel.text};
        }
        else if (_sendtag == 10002){
            str = @"sbyx";
            dic = @{@"id":_dangweiid,@"v_1":self.angleLabel.text};

        }
        else if (_sendtag == 10003){
            str = @"sbts";
            dic = @{@"id":_dangweiid,@"v_1":self.angleLabel.text,@"v_2":_v_x};

        }
        else if (_sendtag == 10004){
            str = @"sbyxms";
            dic = @{@"id":_dangweiid,@"v_1":self.angleLabel.text};

        }
        else if (_sendtag == 10005){
            str = @"sbts";
            dic = @{@"id":_dangweiid,@"v_1":_v_x,@"v_2":self.angleLabel.text};

        }
        [SVProgressHUD show];
        [AppRequest Request_Normalpost:str json:dic controller:self completion:^(id result, NSInteger statues) {
            if(statues == 1)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];

        }];
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
        
        if ( _sendtag == 10001 || _sendtag == 10002 || _sendtag == 10004) {
            _defaultSlider.angle = [_v_x floatValue] * 360 / 100;
        }
        else{
            _defaultSlider.angle = [_v_x floatValue] * 360 / 125;

        }
        _defaultSlider.maxValue = 360;
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
    
    if ( _sendtag == 10001 || _sendtag == 10002 || _sendtag == 10004) {
        self.angleLabel.text = [NSString stringWithFormat:@"%.1ld", self.defaultSlider.angle* 99 / 360 +1];

    }
    else
    {
        self.angleLabel.text = [NSString stringWithFormat:@"%.1ld", self.defaultSlider.angle* 125 / 360 +10];
    }
}
- (UILabel*)angleLabel
{
    if (!_angleLabel) {
        _angleLabel = [UILabel new];
        _angleLabel.frame = CGRectMake(0, 0, 120, 40);
        _angleLabel.center = self.defaultSlider.center;
        _angleLabel.textAlignment = NSTextAlignmentCenter;
        _angleLabel.font = [UIFont boldSystemFontOfSize:40];
        _angleLabel.textColor = Colorfeb913;
        _angleLabel.text = _v_x;
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
