//
//  BaseViewController.h
//  TeaByGame
//
//  Created by hd on 2017/8/24.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


//右侧规则按钮
- (void)addRuleRightBtn;

- (void)addLeftButton:(NSString *)titlestr imageName:(NSString *)imageName action:(void(^)(int status,NSString *searchKey))btnClickBlock;

- (void)addLeftButton:(NSString *)titlestr withImgName:(NSString *)withImgName action:(void(^)(int status,NSString *searchKey))btnClickBlock;


- (void)addRightButton:(NSString *)firstImgName secondName:(NSString *)secondName action:(void(^)(int status,NSString *searchKey))btnClickBlock;

- (void)addRightButton:(NSString *)titlestr imageName:(NSString *)imageName action:(void(^)(int status,NSString *searchKey))btnClickBlock;

- (void)addShadow:(UIView *)V;

- (NSString *)getTimeFromTimesTamp:(NSString *)timeStr;

- (void)addTwoSizeButton:(NSString *)firstImgName secondName:(NSString *)secondName action:(void(^)(int status,NSString *searchKey))btnClickBlock;

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;

@end
