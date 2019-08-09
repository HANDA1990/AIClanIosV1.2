//
//  PieChartView.h
//  AIClan
//
//  Created by hd on 2018/10/19.
//  Copyright © 2018年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView
@property(nonatomic, strong)NSArray *colorArray;

@property(nonatomic, strong) NSArray *PieArray;

- (id)initWithFrame:(CGRect)frame arrs:(NSArray *)arrs;

@end
