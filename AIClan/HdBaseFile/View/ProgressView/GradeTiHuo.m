//
//  GradeTiHuo.m
//  TeaByGame
//
//  Created by hd on 2017/9/16.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "GradeTiHuo.h"

@implementation GradeTiHuo
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:0.5];
        [self addSubViewLayer];
    }
    return self;
    
}
+ (instancetype)sharedManager {
    static GradeTiHuo *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
//猜奖提示框
- (void)addSubViewLayer
{
    CGRect rectf = self.frame;

    UIView *gradAlertV = [[UIView alloc] initWithFrame:CGRectMake(rectf.size.width / 2 - 125, rectf.size.height / 2 - 100, 250, 150)];
    gradAlertV.layer.cornerRadius = 4.0;
    [gradAlertV setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:gradAlertV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gradAlertV.width, 30)];
    [titleLab setBackgroundColor:XXColor(198, 46, 0, 1)];
    [titleLab setText:@"提示"];
    [titleLab setTextColor:[UIColor whiteColor]];
    [gradAlertV addSubview:titleLab];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(gradAlertV.width - 30, 0, 30, 30)];
    [rightBtn setTitle:@"X" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [gradAlertV addSubview:rightBtn];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLab.bottom + 5, gradAlertV.width, 65)];
    [infoLab setTextAlignment:NSTextAlignmentCenter];
    infoLab.tag = 20170917;
    infoLab.font = [UIFont systemFontOfSize:14.0];
    infoLab.numberOfLines = 0;
    [gradAlertV addSubview:infoLab];
    
    
    
    UIButton *getGoodBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, infoLab.bottom + 10, gradAlertV.width - 60, 35)];
    getGoodBtn.tag = 1002;
    [getGoodBtn.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
    getGoodBtn.layer.cornerRadius = 4.0;
    [getGoodBtn setTitle:@"去提货" forState:UIControlStateNormal];
    [getGoodBtn setBackgroundColor:XXColor(198, 46, 0, 1)];
    [getGoodBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [gradAlertV addSubview:getGoodBtn];
    
}

- (void)clickAction:(UIButton *)btn{
    self.hidden = btn.tag == 1002 ? NO : YES;
    if ([self.delegaty respondsToSelector:@selector(normalViewJumpWithtag:)]) {
        [self.delegaty normalViewJumpWithtag:btn.tag == 1002 ? 1002 :0];
    }
}
- (void)showGradSelectView:(NSString *)message{
    UILabel *orderLab = (UILabel *)[self viewWithTag:20170917];
    [orderLab setText:message];
    self.hidden = NO;
}
- (void)hiddeGradSelectView{
    self.hidden = YES;
}
@end
