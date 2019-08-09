//
//  OrderAlert.m
//  TeaByGame
//
//  Created by hd on 2017/9/15.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "OrderAlert.h"

@implementation OrderAlert
-(instancetype)init{
    if (self =[super init]) {
    }
    return self;
    
}

+ (instancetype)sharedManager {
    static OrderAlert *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

//猜奖提示框
- (void)addSubViewLayer
{
    CGRect rectf = [UIApplication sharedApplication].keyWindow.frame;
    
    UIView *gradBgV = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    gradBgV.tag = viewtags;
    gradBgV.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:gradBgV];
    
    UIView *gradAlertV = [[UIView alloc] initWithFrame:CGRectMake(rectf.size.width / 2 - 125, rectf.size.height / 2 - 100, 250, 150)];
    gradAlertV.layer.cornerRadius = 4.0;
    gradAlertV.tag = 20170916;
    [gradAlertV setBackgroundColor:[UIColor whiteColor]];
    [gradBgV addSubview:gradAlertV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gradAlertV.width, 30)];
    [titleLab setBackgroundColor:XXColor(198, 46, 0, 1)];
    [titleLab setText:@"提示"];
    [gradAlertV addSubview:titleLab];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(gradAlertV.width - 30, 0, 30, 30)];
    [rightBtn setTitle:@"X" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [gradAlertV addSubview:rightBtn];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLab.bottom + 5, gradAlertV.width, 70)];
    [infoLab setTextAlignment:NSTextAlignmentCenter];
    infoLab.font = [UIFont systemFontOfSize:14.0];
    infoLab.numberOfLines = 0;
    infoLab.tag = 20170917;
    [gradAlertV addSubview:infoLab];
    
    UIButton *guessBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, infoLab.bottom + 5, 70, 35)];
    guessBtn.tag = 1001;
    guessBtn.layer.cornerRadius = 4.0;
    [guessBtn.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
    [guessBtn setTitle:@"确定" forState:UIControlStateNormal];
    [guessBtn setBackgroundColor:XXColor(192, 160, 100, 1)];
    [guessBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [gradAlertV addSubview:guessBtn];
    
    UIButton *getGoodBtn = [[UIButton alloc] initWithFrame:CGRectMake(gradAlertV.width - guessBtn.right, infoLab.bottom + 5, 70, 35)];
    getGoodBtn.tag = 1002;
    [getGoodBtn.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
    getGoodBtn.layer.cornerRadius = 4.0;
    [getGoodBtn setTitle:@"取消" forState:UIControlStateNormal];
    [getGoodBtn setBackgroundColor:XXColor(136, 15, 8, 1)];
    [getGoodBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [gradAlertV addSubview:getGoodBtn];
    
}

- (void)clickAction:(UIButton *)btn{
    [[UIApplication sharedApplication].keyWindow viewWithTag:viewtags].hidden = YES;
    if (btn.tag == 1001) {
        if ([self.delegaty respondsToSelector:@selector(normalViewJumpWithtag:)]) {
            [self.delegaty normalViewJumpWithtag:1001];
        }
    }
    else if (btn.tag == 1002){
        if ([self.delegaty respondsToSelector:@selector(normalViewJumpWithtag:)]) {
            [self.delegaty normalViewJumpWithtag:1002];
        }
    }
}
- (void)showGradSelectView:(NSString *)message{
    UIView *orderV = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:viewtags];
    UILabel *orderLab = (UILabel *)[orderV viewWithTag:20170917];
    [orderLab setText:message];
    orderV.hidden = NO;
}
- (void)hiddeGradSelectView{
    [[UIApplication sharedApplication].keyWindow viewWithTag:viewtags].hidden = YES;
    
      }
@end
