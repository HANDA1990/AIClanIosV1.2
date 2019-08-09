//
//  NotificationAlert.m
//  TeaByGame
//
//  Created by hd on 2017/9/13.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "NotificationAlert.h"

@implementation NotificationAlert

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubViewLayer];
    }
    return self;
    
}
- (void)addSubViewLayer{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.layer.cornerRadius = imgV.width / 2;
    imgV.layer.cornerRadius = imgV.width / 2;
    imgV.layer.masksToBounds = YES;
    [imgV setBackgroundColor:XXColor(30, 30, 30, 0.5)];
    imgV.tag = 302;
    [self addSubview:imgV];
    
    UILabel *gradBtn = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.width - 30, 30)];
    gradBtn.tag = 301;
    gradBtn.layer.masksToBounds = YES;
    gradBtn.layer.cornerRadius = imgV.width / 2;
    [gradBtn setTextAlignment:NSTextAlignmentCenter];
    [gradBtn setFont:[UIFont systemFontOfSize:9.0]];
    [gradBtn setText:@"客户1     优惠订购成功 10分钟前"];
    [gradBtn setTextColor:[UIColor whiteColor]];
    [self addSubview:gradBtn];
    self.userInteractionEnabled = YES;
    [self setBackgroundColor:XXColor(30, 30, 30, 0.5)];

}

- (void)showGradeDialog
{
    [AppRequest Request_Normalpost:@"tz" json:nil controller:self.nextResponder.nextResponder completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            reciveArr = result[@"retRes"];
            UILabel *promotLab = (UILabel *)[self viewWithTag:301];
            UIImageView *promotImg = (UIImageView *)[self viewWithTag:302];
            
            [timer setFireDate:[NSDate date]];
           __block int k = 0;
            if (!timer) {
            
//                if (@available(iOS 10.0, *)) {
//                    timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                        self.alpha = 0;
//                        if (k < reciveArr.count) {
//                            promotLab.text = reciveArr[k][@"title"];
//                            [promotImg sd_setImageWithURL:[NSURL URLWithString:reciveArr[k][@"file_url"]]];
//                            k ++;
//                            
//                            [UIView beginAnimations:nil context:nil];
//                            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//                            [UIView setAnimationDuration:1.0];
//                            [UIView setAnimationDelegate:self];
//                            self.alpha = 1.0;
//                            [UIView commitAnimations];
//                        }
//                        else{
//                            self.alpha = 0;
//                            [timer setFireDate:[NSDate distantFuture]];
//                            k = 0;
//                        }
//                    }];
//                } else {
//
//                   
//                }
                addk = 0;
                timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }
            
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)timerAction{
    UILabel *promotLab = (UILabel *)[self viewWithTag:301];
    UIImageView *promotImg = (UIImageView *)[self viewWithTag:302];
    self.alpha = 0;
    if (addk < reciveArr.count) {
        promotLab.text = reciveArr[addk][@"title"];
        [promotImg sd_setImageWithURL:[NSURL URLWithString:reciveArr[addk][@"file_url"]]];
        addk ++;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        self.alpha = 1.0;
        [UIView commitAnimations];
    }
    else{
        self.alpha = 0;
        [timer setFireDate:[NSDate distantFuture]];
        addk = 0;
    }
}
@end
