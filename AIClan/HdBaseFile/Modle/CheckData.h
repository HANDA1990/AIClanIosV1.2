//
//  CheckData.h
//  TeaByGame
//
//  Created by hd on 2017/9/7.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckData : NSObject

+ (BOOL)checkTelphone:(NSString *)mobileNum;

+ (NSInteger)checkNowStatus:(NSDictionary *)registerdic;

+ (NSInteger)checkLoginStatus:(NSDictionary *)logindic;

+ (NSInteger)checkWxStatus:(NSDictionary *)registerdic;


+ (NSString *)setSpecialText;
+ (NSString *)CkBText;
@end
