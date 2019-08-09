//
//  BaseNavViewController.h
//  PlasticNet
//
//  Created by hd on 15/9/17.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavViewController : UINavigationController

- (void)setNavgationHiddens:(BaseNavViewController *)weakNav;

- (void)setNavgationshow:(BaseNavViewController *)weakNav;

@end
