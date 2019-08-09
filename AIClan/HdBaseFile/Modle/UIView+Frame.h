//
//  UIView+Frame.h
//  ocdk
//
//  Created by 程子扬 on 15-5-16.
//  Copyright (c) 2015年 程子扬. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Frame)
-(CGFloat) x;
-(CGFloat) y;
-(CGFloat) right;
-(CGFloat) bottom;
-(CGFloat) width;
-(CGFloat) height;
-(void) setX:(CGFloat) x;
-(void) setY:(CGFloat) y;
-(void) setRight:(CGFloat)right;
-(void) setBottom:(CGFloat) bottom;
-(void) setWidth:(CGFloat) width;
-(void) setHeight:(CGFloat) height;
- (UIView *)setShadowLayer:(UIView *)shadowV;
    
@end
