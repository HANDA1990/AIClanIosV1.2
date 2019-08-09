//
//  ModelController.m
//  pageViewcontroller
//
//  Created by zhongsheng-WJ on 14-6-16.
//  Copyright (c) 2014年 zhongsheng-WJ. All rights reserved.
//

#import "ModelController.h"



@interface ModelController()<UIPageViewControllerDataSource>
{
    NSMutableArray *_viewControllerArray;
}
@end

@implementation ModelController

- (id)initWithViewController:(NSArray *)controllerArray
{
    self = [super init];
    if (self) {
        // Create the data model.
        _viewControllerArray = [NSMutableArray arrayWithArray:controllerArray];
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([_viewControllerArray count] == 0) || (index >= [_viewControllerArray count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    return [_viewControllerArray objectAtIndex:index];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [_viewControllerArray indexOfObject:viewController];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_viewControllerArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
