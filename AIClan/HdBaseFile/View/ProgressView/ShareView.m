//
//  ShareView.m
//  TeaByGame
//
//  Created by hd on 2017/9/28.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "ShareView.h"
#import "HdWxLogining.h"
#import "NSString+QRCode.h"

@implementation ShareView

-(instancetype)init{
    if (self =[super init]) {
        [self loadBaseView];
    }
    return self;
    
}

- (void)loadBaseView{
    self.hidden = YES;
    [self setBackgroundColor:XXColor(30, 30, 30, 0.6)];
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addTarget:self action:@selector(hideBackView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bottomV = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height, self.width, 100)];
    [bottomV setBackgroundColor:[UIColor whiteColor]];
    [bottomV addTarget:self action:@selector(clickOut) forControlEvents:UIControlEventTouchUpInside];
    bottomV.tag = 1009;
    [self addSubview:bottomV];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 150) / 4, 25, 48, 48)];
    btn.tag = 1001;
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"朋友圈" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [btn setImage:[UIImage imageNamed:@"wxq"] forState:UIControlStateNormal];
    [bottomV addSubview:btn];
    [self setButtonContentCenter:btn];
    [btn addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 150) * 2 / 4 + 50, 30, 48, 48)];
    btn2.tag = 1002;
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"微信好友" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [btn2 setImage:[UIImage imageNamed:@"wxpy"] forState:UIControlStateNormal];
    [bottomV addSubview:btn2];
    [self setButtonContentCenter:btn2];
    [btn2 addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 150) * 3 /4 + 100 , 25, 48, 48)];
    btn3.tag = 1003;
    [btn3 setTitle:@"二维码" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"qcode"] forState:UIControlStateNormal];
    [bottomV addSubview:btn3];
    [self setButtonContentCenter:btn3];
    [btn3 addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];

    [self QRCodeShare];

}

-(void)setButtonContentCenter:(UIButton *)button
{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    
    //设置按钮内边距
    imgViewSize = button.imageView.bounds.size;
    titleSize = button.titleLabel.bounds.size;
    btnSize = button.bounds.size;
    CGFloat heightSpace = -10;
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [button setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height, - imgViewSize.width, 0.0, 0.0);
    [button setTitleEdgeInsets:titleEdge];
}

- (void)showShare:(UIButton *)btn
{
    if (btn.tag == 1001) {
        if (shareUrlStr) {
            [[HdWxLogining sharedManager] wxShare:1 shareUrlStr:shareUrlStr];
        }
        else if (shareImg){
            [[HdWxLogining sharedManager] wxShare:1 shareImg:shareImg];

        }
        [self hideBackView];

    }
    else if (btn.tag == 1002){
        if (shareUrlStr) {
            [[HdWxLogining sharedManager] wxShare:0 shareUrlStr:shareUrlStr];
        }
        else if (shareImg){
            [[HdWxLogining sharedManager] wxShare:0 shareImg:shareImg];
            
        }
        [self hideBackView];


    }
    else if (btn.tag == 1003){
        [[self viewWithTag:1009] setHidden:YES];
        [[self viewWithTag:1005] setHidden:NO];
      
    }
}

- (void)sendUrlinfo:(NSDictionary *)urlStr{
    CGFloat qrSize = self.bounds.size.width - 10;
    UIImage* image = [urlStr[@"http_url"] createQRCode:qrSize height:qrSize];
    [(UIImageView*)[self viewWithTag:1005] setWidth:image.size.width];
    [(UIImageView*)[self viewWithTag:1005] setHeight:image.size.height];
    [(UIImageView*)[self viewWithTag:1005] setImage:image];
    [(UIImageView*)[self viewWithTag:1005] setCenter:CGPointMake(self.center.x, self.center.y)];
    shareImg = nil;
    shareUrlStr = urlStr;
}

- (void)sendimgCode:(UIImage *)imgCode{
    CGFloat qrSize = self.bounds.size.width - 10;
    UIImage* image = imgCode;
    [(UIImageView*)[self viewWithTag:1005] setWidth:qrSize];
    [(UIImageView*)[self viewWithTag:1005] setHeight:qrSize];
    [(UIImageView*)[self viewWithTag:1005] setImage:image];
    [(UIImageView*)[self viewWithTag:1005] setCenter:CGPointMake(self.center.x, self.center.y)];
    shareImg = imgCode;

    shareUrlStr = nil;
}

- (void)QRCodeShare{
    UIImageView* imageView = [[UIImageView alloc] init];
    [imageView layer].magnificationFilter = kCAFilterNearest;
    imageView.tag = 1005;
    imageView.hidden = YES;
    [self addSubview:imageView];
}

- (void)clickOut{
    [self hideBackView];
}

- (void)hideBackView{
    [UIView animateWithDuration:0.4 animations:^{
        [(UIView *)[self viewWithTag:1009] setFrame:CGRectMake(0, self.height, self.width, 100)];
        [[self viewWithTag:1005] setHidden:YES];
    } completion:^(BOOL finished) {
        self.hidden = YES;

    }];
}
- (void)showBGview{
    self.hidden = NO;
    [[self viewWithTag:1009] setHidden:NO];
    [UIView animateWithDuration:0.4 animations:^{
        [(UIView *)[self viewWithTag:1009] setFrame:CGRectMake(0, self.height - 100, self.width, 100)];
    }];
}
@end
