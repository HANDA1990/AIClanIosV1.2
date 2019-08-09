//
//  MedalCell.m
//  AIClan
//
//  Created by hd on 2018/10/16.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "MedalCell.h"

@implementation MedalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        bgV.backgroundColor = XXColor(245, 245, 245, 1);
//        bgV.layer.cornerRadius = 4.0;
//        bgV.layer.borderWidth = 2;
        [self addSubview:bgV];
        
        //设置CollectionViewCell中的图像框
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgV.width / 2 - 40, 15, 80, 80)];
        [bgV addSubview:self.imageView];
        
        //设置CollectionViewCell中的图像框
        self.onlineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(bgV.width - 42, 15, 27, 27)];
        self.onlineImgV.image = [UIImage imageNamed:@"off-line"];
        [bgV addSubview:self.onlineImgV];
        
        //文本框
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, bgV.height - 35, CGRectGetWidth(self.frame), 35)];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.layer.cornerRadius = 4.0;
        self.label.textColor = XXColor(100, 100, 100, 1);
        //self.label.backgroundColor =XXColor(240, 240, 240, 1);
        self.label.textAlignment = NSTextAlignmentCenter;
        [bgV addSubview:self.label];
        
        self.selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(bgV.width - 35, 5, 27, 27)];
        [self.selectImgV setHidden:YES];
        [self.selectImgV setImage:[UIImage imageNamed:@"checkbox"]];
        [bgV addSubview:self.selectImgV];
        
    }
    return self;
}
- (void)ShowOrHideSelect:(BOOL)selectBool
{
    [self.selectImgV setHidden:selectBool];
}

@end
