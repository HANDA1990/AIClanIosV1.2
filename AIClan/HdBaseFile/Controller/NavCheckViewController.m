//
//  NavCheckViewController.m
//  SAT抢考位
//
//  Created by dahan on 15/6/4.
//  Copyright (c) 2015年 dadaMarker. All rights reserved.
//

#import "NavCheckViewController.h"
#import "HdLoginViewController.h"
#import "WebInfoViewController.h"
#import "WaterQualityViewController.h"
#import "FishbowlControlViewController.h"
#import "NewEquipmentViewController.h"
#import "PlForgetPasswordViewController.h"
#import "HdRegistViewController.h"
#import "ProfessorViewDetailController.h"
#import "PromptlyOrderViewController.h"
#import "WaterLevelViewController.h"
#import "WPSetingViewController.h"
#import "EditWaterQualityViewController.h"
#import "WaterQualitySetViewController.h"
#import "WebLoadViewController.h"
#import "ConsultViewController.h"
#import "BrandsDroganWdViewController.h"
@interface NavCheckViewController ()<UINavigationControllerDelegate>
@end

@implementation NavCheckViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [[UINavigationBar appearance] setBarTintColor:NavColor];
    
}
- (void)setNavgationHiddens:(NavCheckViewController *)weakNav{
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
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1)
    {
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    viewController.navigationItem.leftBarButtonItem =[self createBackButton:self.title];

}



-(UIBarButtonItem*) createBackButton:(NSString *)title
{
    UIImage* image= [UIImage imageNamed:@"return_arrow"];
    CGRect backframe= CGRectMake(10, 0, 40, 40);
    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
    backButton.backgroundColor = [UIColor clearColor];

    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;

    // return [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(popself)];
    
}
- (void)popself
{
//    WPSetingViewController
    UIViewController *currentViewController = [self.childViewControllers lastObject];
    if ([currentViewController isKindOfClass:[HdLoginViewController class]] || [currentViewController isKindOfClass:[WebInfoViewController class]] ||[currentViewController isKindOfClass:[WaterQualityViewController class]] || [currentViewController isKindOfClass:[WaterQualityViewController class]] || [currentViewController isKindOfClass:[FishbowlControlViewController class]]|| [currentViewController isKindOfClass:[NewEquipmentViewController class]] ||  [currentViewController isKindOfClass:[PlForgetPasswordViewController class] ] || [currentViewController isKindOfClass:[HdRegistViewController class]] || [currentViewController isKindOfClass:[ProfessorDetailViewController class]] || [currentViewController isKindOfClass:[PromptlyOrderViewController class]] || [currentViewController isKindOfClass:[WaterLevelViewController class]] || [currentViewController isKindOfClass:[WPSetingViewController class]] ||[currentViewController isKindOfClass:[EditWaterQualityViewController class]]||
        [currentViewController isKindOfClass:[WebLoadViewController class]] ||
        [currentViewController isKindOfClass:[ConsultViewController class]]||
        [currentViewController isKindOfClass:[BrandsDroganWdViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        return;
        
    }
    if ([currentViewController isKindOfClass:[WaterQualitySetViewController class]]) {
        WaterQualitySetViewController *water = (WaterQualitySetViewController *)currentViewController;
        [water.dataArray removeAllObjects];
        water.dataArray = nil;
    }
    [self popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
