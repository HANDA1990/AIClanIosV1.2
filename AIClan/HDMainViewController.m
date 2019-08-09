//
//  MainViewController.m
//  PlasticNet
//
//  Created by hd on 15/9/17.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import "HDMainViewController.h"
#import "BaseNavViewController.h"
#import "NavCheckViewController.h"
#import "HdLoginViewController.h"
#import "EquipMainViewController.h"
#import "CapacityMainViewController.h"
#import "ProfesserViewController.h"
#import "ShoppingMainViewController.h"
#import "MyMainViewController.h"

#import "SmartMainViewController.h"
#import "ServiceGridViewController.h"
#import "IntelligentViewController.h"

@interface HDMainViewController ()<UITabBarControllerDelegate,UITabBarDelegate>
{
    UIView *selectVew;
}
@end

@implementation HDMainViewController

- (NSString *)hexStringFromString:(NSString *)string{
    
    int x = 54+52+32+30+30+42+42+32+39+32+35+30+30+31+34+34+30+36+38+30+42+44+34+31+42+42+35;
    
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    unsigned long hexHe = 0;

    for(int i=0;i<[myD length] - 1;i++)
    {
        
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]];///16进制数
        if (newHexStr.length == 1) {
            int ll = [self hexToint:newHexStr];
            hexHe += ll;
        }
        else
        {
            NSString *firstStr = [newHexStr substringToIndex:1];
            NSString *secondStr = [newHexStr substringFromIndex:1];
            int hl =  [self hexToint:firstStr];
            
            int ll = [self hexToint:secondStr];

            hexHe += (hl * 16 + ll);
        }
    }
    hexHe = hexHe / 16 + hexHe % 16;
    NSLog(@"%lu",hexHe);

    return hexStr;
}
- (int)hexToint:(NSString *)Hexstr
{
    int retuenInt;
    if ([Hexstr isEqualToString:@"A"] || [Hexstr isEqualToString:@"a"]) {
        retuenInt = 10;
    }
    else if ([Hexstr isEqualToString:@"B"] || [Hexstr isEqualToString:@"b"]) {
        retuenInt = 11;

    }
    else if ([Hexstr isEqualToString:@"C"] || [Hexstr isEqualToString:@"c"]) {
        retuenInt = 12;

    }
    else if ([Hexstr isEqualToString:@"D"] || [Hexstr isEqualToString:@"d"]) {
        retuenInt = 13;

    }
    else if ([Hexstr isEqualToString:@"E"] || [Hexstr isEqualToString:@"e"]) {
        retuenInt = 14;

    }
    else if ([Hexstr isEqualToString:@"F"] || [Hexstr isEqualToString:@"f"]) {
        retuenInt = 15;

    }
    else
    {
        retuenInt = [Hexstr intValue];
    }
    return retuenInt;
}

- (BOOL)checkDatasP:(NSString *)myDs{
    NSData *myD =[myDs dataUsingEncoding:NSASCIIStringEncoding];
    
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    unsigned long hexHe = 0;
    for(int i=0;i<[myD length] - 1;i++)
        
    {
        unsigned long newHex = bytes[i]&0xff;
        
        unsigned long num1 = newHex;
        hexHe += num1;
        
    }
    unsigned long hexyu = hexHe % 256;
    NSLog(@"hexyu = %lu",hexyu);
    
    if (hexyu == bytes[[myD length] - 1]) {
        return YES;
    }
    
    return NO;
}

- (void)viewDidLoad {
    
    [self hexStringFromString:@"TR-200BB2925001440680BD41BB5&"];
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRootVC];
}
- (NSString *)GetNewNowVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
- (void)setRootVC
{
    EquipMainViewController *textVC = [[EquipMainViewController alloc] init];
    BaseNavViewController *textNav = [[BaseNavViewController alloc] initWithRootViewController:textVC];
    UIImage *unselectedImage = [UIImage imageNamed:@"equipNo"];
    UIImage *selectedImage = [UIImage imageNamed:@"equip"];
    textVC.title = @"";

    textNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设备"
                                                      image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
 [textNav setNavgationHiddens:textNav];
    
    ServiceGridViewController *serviceVC = [[ServiceGridViewController alloc] init];
    
    BaseNavViewController *serviceNav = [[BaseNavViewController alloc] initWithRootViewController:serviceVC];
    unselectedImage = [UIImage imageNamed:@"service"];
    selectedImage = [UIImage imageNamed:@"serviceNo"];
    [serviceNav setNavgationHiddens:serviceNav];
    
    serviceVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"服务"
                                                      image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    CapacityMainViewController *orderVC = [[CapacityMainViewController alloc] init];
    IntelligentViewController *orderVC = [[IntelligentViewController alloc] init];

    BaseNavViewController *proNav = [[BaseNavViewController alloc] initWithRootViewController:orderVC];
    unselectedImage = [UIImage imageNamed:@"smartNo"];
    selectedImage = [UIImage imageNamed:@"smart"];
    orderVC.title = @"智能统计";
    
//    SmartMainViewController *orderVC = [[SmartMainViewController alloc] init];
//    BaseNavViewController *proNav = [[BaseNavViewController alloc] initWithRootViewController:orderVC];
//    unselectedImage = [UIImage imageNamed:@"smartNo"];
//    selectedImage = [UIImage imageNamed:@"smart"];
    proNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"智能"
                                                      image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

//    [proNav setNavgationHiddens:proNav];

    
//    ShoppingMainViewController *serviceVC = [[ShoppingMainViewController alloc] init];
//    BaseNavViewController *serviceNav = [[BaseNavViewController alloc] initWithRootViewController:serviceVC];
//    unselectedImage = [UIImage imageNamed:@"nav3"];
//    selectedImage = [UIImage imageNamed:@"nav3a"];
//    serviceVC.title = @"商城";
//    //    [disNav setNavgationHiddens:disNav];
//
//    serviceVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:serviceVC.title
//                                                     image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                             selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   
    MyMainViewController *MyVC = [[MyMainViewController alloc] init];
    BaseNavViewController *MyNav = [[BaseNavViewController alloc] initWithRootViewController:MyVC];
    unselectedImage = [UIImage imageNamed:@"nav4"];
    selectedImage = [UIImage imageNamed:@"myself"];
    MyVC.title = @"";
    [MyNav setNavgationHiddens:MyNav];
    
    MyVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                         image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                 selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    self.viewControllers = @[textNav,proNav,serviceNav,MyNav];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.selectedIndex = 2;
    self.delegate = self;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor(1)} forState:UIControlStateSelected];
    [self setHidesBottomBarWhenPushed:YES];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
