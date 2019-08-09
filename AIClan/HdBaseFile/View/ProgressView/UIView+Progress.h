//
//  UIView+Progress.h
//  快快信息管理系统
//
//  Created by dadalang on 14-9-18.
//  Copyright (c) 2014年 kk-university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGProgressHUD.h"

typedef enum{
	ResultViewTypeOK,
	ResultViewTypeFaild,
	ResultViewTypeCancel,
} ResultViewType;

@interface UIView (Progress)<JGProgressHUDDelegate>

//@property (nonatomic)BOOL blockUserInteraction;
- (void)showProgress:(BOOL)show text:(NSString *)text;

- (void)showResult:(NSString *)text;

-(void)textOnly:(NSString *)text;

- (void)showResultLong:(NSString *)text;


- (CGRect)loadImggoodsViewSize:(UIImage *)image;

- (CGRect)loadImgViewSize:(UIImage *)image;

- (CGRect)loadspImgViewSize:(UIImage *)image;


@end
