//
//  UIView+Progress.m
//  快快信息管理系统
//
//  Created by dadalang on 14-9-18.
//  Copyright (c) 2014年 kk-university. All rights reserved.
//

#import "UIView+Progress.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"

@implementation UIView (Progress)


- (void)showProgress:(BOOL)show text:(NSString *)text
{
    if (show) {
        JGProgressHUD *HUD;
        if ([(JGProgressHUD *)[self viewWithTag:2014] isKindOfClass:[JGProgressHUD class]]) {
            HUD = (JGProgressHUD *)[self viewWithTag:2014];
            [HUD showInView:self];
            
        }
        else{
            HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)2];
            HUD.tag = 2014;
        }
        
        HUD.textLabel.text = text;
        HUD.delegate = self;
//        HUD.userInteractionEnabled = _blockUserInteraction;
        [HUD showInView:self];
        
        HUD.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    }
    else
    {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[JGProgressHUD class]]) {
                JGProgressHUD *HUD = (JGProgressHUD *)subView;
                [HUD dismiss];
                break;
            }
        }
        
    }
}
- (void)showResult:(NSString *)text
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)2];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        HUD.indicatorView = NO;
        
        HUD.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        HUD.textLabel.text = text;
        [HUD showInView:self];

        HUD.position = JGProgressHUDPositionCenter;
        

    });
    
    [HUD dismissAfterDelay:1];

}
- (void)showResultLong:(NSString *)text
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        HUD.indicatorView = NO;
        
        HUD.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        HUD.textLabel.text = text;
        [HUD showInView:self];
        
        HUD.position = JGProgressHUDPositionCenter;
        
        
    });
    
    [HUD dismissAfterDelay:1.5];
    
}

- (void)progress:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:HUD.style];
    HUD.delegate = self;
    HUD.textLabel.text = @"Uploading...";
    [HUD showInView:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.25 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.5 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.75 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:1.0 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD dismiss];
    });
}

- (void)zoomAnimationWithRing:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.indicatorView = [[JGProgressHUDRingIndicatorView alloc] initWithHUDStyle:HUD.style];
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    HUD.delegate = self;
    HUD.textLabel.text = @"Downloading...";
    [HUD showInView:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.25 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.5 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.75 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:1.0 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD dismiss];
    });
}

-(void)textOnly:(NSString *)text{
    
    
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)2];
//    HUD.indicatorView = NO;
    HUD.textLabel.text = text;
    
    HUD.delegate = self;
    HUD.position = JGProgressHUDPositionBottomCenter;
//    HUD.marginInsets = (UIEdgeInsets) {
//        .top = 0.0f,
//        .bottom = 20.0f,
//        .left = 0.0f,
//        .right = 0.0f,
//    };
//    
    [HUD showInView:self];
    
    [HUD dismissAfterDelay:2.0f];

}

- (CGRect)loadImgViewSize:(UIImage *)image {
    if (image) {
        float fianW;
        float fianH;
        if (image.size.width >= image.size.height) {
            fianH = (self.width - 30) / 2 * image.size.height / image.size.width;
            fianW = (self.width - 30) / 2;
        }
        else{
            fianH = (self.width - 30) / 2 ;
            fianW = (self.width - 30) / 2 * image.size.width / image.size.height;
            
        }
        return CGRectMake((self.width - 30) / 4 - fianW / 2, (self.width - 30) / 4 - fianH / 2, fianW, fianH);
    }
    return CGRectMake(0,0,(self.width - 30) / 2,(self.width - 30) / 2);
}

- (CGRect)loadImggoodsViewSize:(UIImage *)image {
    if (image) {
        float fianW;
        float fianH;
        if (image.size.width >= image.size.height) {
            fianH = (self.width - 30) / 2 * image.size.height / image.size.width;
            fianW = (self.width - 30) / 2;
        }
        else{
            fianH = (self.width - 30) / 2 ;
            fianW = (self.width - 30) / 2 * image.size.width / image.size.height;
            
        }
        return CGRectMake((self.width - 30) / 4 - fianW * 0.8/ 2, (self.width - 30) / 4 - fianH * 0.8/ 2 - 10, fianW * 0.8, fianH * 0.8);
    }
    return CGRectMake(0,0,(self.width - 30) / 2,(self.width - 30) / 2);
}

- (CGRect)loadspImgViewSize:(UIImage *)image {
    if (image) {
        float fianW;
        float fianH;
        if (image.size.width >= image.size.height) {
            fianH = (self.width - 30) / 2 * image.size.height / image.size.width;
            fianW = (self.width - 30) / 2;
        }
        else{
            fianH = (self.width - 30) / 2 ;
            fianW = (self.width - 30) / 2 * image.size.width / image.size.height;
            
        }
        return CGRectMake((self.width - 30) / 4 - fianW / 2 + (self.width + 10) / 2, (self.width - 30) / 4 - fianH / 2, fianW, fianH);
    }
    return CGRectMake((self.width + 10) / 2,0,(self.width - 30) / 2,(self.width - 30) / 2);
}

@end
