//
//  ModelController.h
//  pageViewcontroller
//
//  Created by zhongsheng-WJ on 14-6-16.
//  Copyright (c) 2014年 zhongsheng-WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfViewController:(UIViewController *)viewController;


- (id)initWithViewController:(NSArray *)controllerArray;

@end
