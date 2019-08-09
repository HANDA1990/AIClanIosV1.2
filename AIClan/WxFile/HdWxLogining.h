//
//  HdWxLogining.h
//  TeaByGame
//
//  Created by hd on 2017/8/24.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
//#import "WeiboSDK.h"


@protocol wxLogindelegate<NSObject>

- (void)ComepleteLogin:(NSDictionary *)retuernInfo;

- (void)ComepletePayed:(BaseResp *)payInfo;

@end

@interface HdWxLogining : NSObject<WXApiDelegate/*,WeiboSDKDelegate*/>
{
    UIViewController *wxSelf;
}
@property (nonatomic ,weak) id<wxLogindelegate>delegaty;

+ (instancetype)sharedManager;
    
- (void)WechatLoginClick:(UIViewController *)controller;

- (void) handleOpenURL:(NSURL *) url;

- (void)WxRegist;

- (void)wxPayed:(NSDictionary *)orderDic;

- (void)wxShare:(int)scence shareUrlStr:(NSDictionary *)shareUrlStr;

- (void)wxShare:(int)scence shareImg:(UIImage *)shareImg;

- (void)QRCodeShare:(UIView *)bgV;

+ (BOOL)checkWxInstalled;

@end
