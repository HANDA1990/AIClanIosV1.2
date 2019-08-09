//
//  GradeSelectView.m
//  TeaByGame
//
//  Created by hd on 2017/9/7.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "GradeSelectView.h"

@implementation GradeSelectView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:0.5];
        [self addSubViewLayer];
    }
    return self;
    
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
    [titleLab setText:@"下单成功"];
    [titleLab setTextColor:[UIColor whiteColor]];
    [gradAlertV addSubview:titleLab];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(gradAlertV.width - 30, 0, 30, 30)];
    [rightBtn setTitle:@"X" forState:UIControlStateNormal];
    rightBtn.tag = 1000;
    [rightBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [gradAlertV addSubview:rightBtn];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLab.bottom + 5, gradAlertV.width, 30)];
    [infoLab setTextAlignment:NSTextAlignmentCenter];
    [infoLab setText:[NSString stringWithFormat:@"你需要%@商品吗?",[CheckData setSpecialText]]];
    
    [gradAlertV addSubview:infoLab];
    
    UIButton *guessBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, infoLab.bottom + 30, 70, 35)];
    guessBtn.tag = 1001;
    guessBtn.layer.cornerRadius = 4.0;
    [guessBtn.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
    [guessBtn setTitle:@"猜奇偶" forState:UIControlStateNormal];
    [guessBtn setBackgroundColor:XXColor(249, 195, 12, 1)];
    [guessBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [gradAlertV addSubview:guessBtn];
    
    UIButton *getGoodBtn = [[UIButton alloc] initWithFrame:CGRectMake(gradAlertV.width - guessBtn.right, infoLab.bottom + 30, 70, 35)];
    getGoodBtn.tag = 1002;
    [getGoodBtn.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
    getGoodBtn.layer.cornerRadius = 4.0;
    [getGoodBtn setTitle:@"去提货" forState:UIControlStateNormal];
    [getGoodBtn setBackgroundColor:XXColor(198, 46, 0, 1)];
    [getGoodBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [gradAlertV addSubview:getGoodBtn];
    
}

- (void)clickAction:(UIButton *)btn{
//    [[UIApplication sharedApplication].keyWindow viewWithTag:viewtags].hidden = YES;
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
    else if (btn.tag == 1000){
        self.hidden = YES;
    }
}
- (void)showGradSelectView{
    self.hidden = NO;
}
- (void)hiddeGradSelectView{
    self.hidden = YES;
}
@end
