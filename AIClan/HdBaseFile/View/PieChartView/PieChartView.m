
//
//  PieChartView.m
//  AIClan
//
//  Created by hd on 2018/10/19.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

- (void)drawRect:(CGRect)rect {
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    //数据数组
    NSArray *array = @[@20,@20,@20,@20,@20];
    //颜色数组
    self.colorArray = @[XXColor(214, 71, 158, 1), XXColor(51, 161, 234, 1), XXColor(89, 211, 210, 1),XXColor(254, 213, 75, 1),XXColor(253, 140, 108, 1)];
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    //中心点
    CGPoint center = CGPointMake(w * 0.5, h * 0.5);
    //半径
    CGFloat radius = w * 0.5 - 5;
    //起点角度
    CGFloat startA = 0;
    //终点角度
    CGFloat endA = 0;
    //扫过角度范围
    CGFloat angle = 0;
    for (int i = 0; i < array.count; i ++) {
        startA = endA;
        angle = [array[i] integerValue] / 100.0 * M_PI * 2;
        endA = startA + angle;
        //弧形路径
        //clockwise: 是否是按照时钟的方向旋转(是否顺时针)
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        //连接中心, 构成扇形
        [path addLineToPoint:center];
        //填充颜色
        [(UIColor *)self.colorArray[i] set];
        CGContextAddPath(ctx, path.CGPath);
        // 将上下文渲染到视图
        CGContextFillPath(ctx);
        
    }
}

@end
