//
//  GradeBtn.m
//  TeaByGame
//
//  Created by hd on 2017/9/6.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "GradeBtn.h"

@implementation GradeBtn

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubViewLayer];
    }
    return self;
    
}

- (void)addSubViewLayer{
    UIButton *gradBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [gradBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gradBtn setTitle:@"榜" forState:UIControlStateNormal];
    gradBtn.layer.cornerRadius = gradBtn.width / 2;
//    [gradBtn setBackgroundColor:XXColor(114, 208, 250, 1)];
    [gradBtn setBackgroundColor:XXColor(30, 30, 30, 0.5)];
    
    [gradBtn addTarget:self action:@selector(enterBang:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gradBtn];
    
//    UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, gradBtn.bottom, self.width, 30)];
//    [orderBtn setTitle:@"说明" forState:UIControlStateNormal];
//    orderBtn.titleLabel.numberOfLines = 1;
//    [orderBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
//    [orderBtn setBackgroundColor:XXColor(114, 208, 250, 1)];
//    [orderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [orderBtn addTarget:self action:@selector(enterBang:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:orderBtn];
}

- (void)enterBang:(UIButton *)btn{
    if ([self.delegaty respondsToSelector:@selector(normalViewJump)]) {
        [self.delegaty normalViewJump];
    }
}
@end
