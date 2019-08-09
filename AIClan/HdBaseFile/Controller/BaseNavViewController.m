
//
//  BaseNavViewController.m
//  PlasticNet
//
//  Created by hd on 15/9/17.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:MainColor(1)];
    // Do any additional setup after loading the view.
}

- (void)setNavgationHiddens:(BaseNavViewController *)weakNav{
    weakNav.navigationBar.translucent=YES;
    UIColor *color=[UIColor clearColor];
    CGRect rect =CGRectMake(0,0,self.view.frame.size.width,64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [weakNav.navigationBar setBackgroundImage:image forBarMetrics:(UIBarMetricsDefault)];
    weakNav.navigationBar.clipsToBounds=YES;
}

- (void)setNavgationshow:(BaseNavViewController *)weakNav{
    weakNav.navigationBar.translucent=NO;
    UIColor *color=[UIColor clearColor];
    CGRect rect =CGRectMake(0,0,self.view.frame.size.width,64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIGraphicsEndImageContext();
    weakNav.navigationBar.clipsToBounds=NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1)
    {
        self.interactivePopGestureRecognizer.delegate = self;
        viewController.navigationItem.leftBarButtonItem =[self createBackButton:self.title];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.interactivePopGestureRecognizer] && [self.viewControllers count]==1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)popself
{
//    UIViewController *viewcontroler = (UIViewController *)[self.viewControllers objectAtIndex:self.viewControllers.count -1];
//    if ([viewcontroler isKindOfClass:[WaterQualitySetViewController class]]) {
//        WaterQualitySetViewController *water = (WaterQualitySetViewController *)viewcontroler;
//        [water.dataArray removeAllObjects];
//        water.dataArray = nil;
//        return;
//    }
    [self popViewControllerAnimated:YES];
//    if ([self.viewControllers count] == 1) {
//        [self setNavgationHiddens:(BaseNavViewController *)self.navigationController];
//
//    }
}

-(UIBarButtonItem*) createBackButton:(NSString *)title
{
    UIImage* image= [UIImage imageNamed:@"return_arrow"];
    CGRect backframe= CGRectMake(0, 0, 44, 44);
    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
