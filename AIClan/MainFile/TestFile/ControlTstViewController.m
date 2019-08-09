//
//  ControlTstViewController.m
//  AIClan
//
//  Created by hd on 2018/12/23.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ControlTstViewController.h"

@interface ControlTstViewController ()
{
    float bValue;
    BOOL temp;
    UIImage *originImg;
    NSTimer *timer;
    CGFloat angle;
    UIImageView *animateV;
}
@end

@implementation ControlTstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgV setImage:[UIImage imageNamed:@"appControl"]];
    imgV.userInteractionEnabled = YES;
    self.view = imgV;
    
    float hb = Height_NavBar;
    animateV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 92, hb + 100, 184, 184)];
    animateV.tag = 100;
    [animateV setImage:[UIImage imageNamed:@"sky"]];
    originImg = [UIImage imageNamed:@"sky"];
    [self.view addSubview:animateV];
    
    bValue = 1.50f;
    temp = false;
    
//    [self animateRoatation:animateV];
    
    [self changeAlpha];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 50, 50)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
}
- (void)changeBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)animateRoatation:(UIView *)view{
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 2;
        [self animateRoatation:view];
    }];
    
   
                            
}

- (void)changeAlpha{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (bValue > 1.0) {
            bValue  = 1.0;
            temp = true;
        }
        if (bValue < 0.5){
            bValue = 0.5;
            temp = false;
        }
        
        if (temp)
            bValue -= 0.1;
        else
            bValue += 0.1;
        animateV.alpha = bValue;
    } completion:^(BOOL finished) {
        [self changeAlpha];
        
    }];
   
}
-(void)timerSelector
{
//    float value = [(NSNumber*)[sender userInfo] floatValue];    //取回之前传入的数据
    animateV.image = [self modifyImgLight:animateV.image];

}

- (UIImage *)modifyImgLight:(UIImage *)img{
    
    UIImage *myImage = originImg;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:myImage.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    // 修改亮度   -1---1   数越大越亮
    
    if (bValue > 0.3) {
        bValue  = 0.3;
        temp = true;
    }
    if (bValue < 0.0){
        bValue = 0.0;
        temp = false;
    }
  
    if (temp)
        bValue -= 0.1;
    else
        bValue += 0.1;
    
    NSLog(@"%.1f",bValue);
    [lighten setValue:@(bValue) forKey:@"inputBrightness"];
    // 修改饱和度  0---2
    //[lighten setValue:@(0.5) forKey:@"inputSaturation"];
    // 修改对比度  0---4
    //[lighten setValue:@(0.5) forKey:@"inputContrast"];
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    // 得到修改后的图片
    myImage = [UIImage imageWithCGImage:cgImage];
    // 释放对象
    CGImageRelease(cgImage);
    return myImage;
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
