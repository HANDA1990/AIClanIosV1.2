//
//  UIView+Frame.m
//  ocdk
//
//  Created by 程子扬 on 15-5-16.
//  Copyright (c) 2015年 程子扬. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
-(CGFloat) x{
    return self.frame.origin.x;
}

-(CGFloat) y{
    return self.frame.origin.y;
}

-(CGFloat) right{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat) bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat) width{
    return self.frame.size.width;
}

-(CGFloat) height{
    return self.frame.size.height;
}

-(void) setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

-(void) setY:(CGFloat)y{
    CGRect rect = self.frame;
     rect.origin.y = y;
    self.frame = rect;
}

-(void) setRight:(CGFloat)right{
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

-(void) setBottom:(CGFloat)bottom{
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

-(void) setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

-(void) setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (UIView *)setShadowLayer:(UIView *)shadowV{
    
    shadowV.layer.shadowOpacity = 0.5;// 阴影透明度
    shadowV.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    shadowV.layer.shadowRadius = 5;// 阴影扩散的范围控制
    shadowV.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    shadowV.backgroundColor = [UIColor whiteColor];
    
    return shadowV;
}

@end
