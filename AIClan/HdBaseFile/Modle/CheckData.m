

//
//  CheckData.m
//  TeaByGame
//
//  Created by hd on 2017/9/7.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "CheckData.h"

@implementation CheckData



+ (BOOL)checkTelphone:(NSString *)mobileNum{
    //    NSString * MOBILE = @"^(13[\\d]{9}|15[\\d]{9}|18[\\d]{9})$";
    NSString *MOBILE = @"^(13[0-9]|15[012356789]|17[1678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}


+ (NSInteger)checkNowStatus:(NSDictionary *)registerdic
{
    if (![[registerdic objectForKey:@"account"] length]) {
        [[UIApplication sharedApplication].keyWindow showResult:@"手机号码不能为空"];
        return 0;
    }
    
    else if (![[registerdic objectForKey:@"verf"] length])
    {
        [[UIApplication sharedApplication].keyWindow showResult:@"验证码不能为空"];
        return 0;
        
    }

    else if (![self checkTelphone:registerdic[@"account"]])
    {
        [[UIApplication sharedApplication].keyWindow showResult:@"手机号码格式错误"];
        return 0;
    }
    return 1;
}

+ (NSInteger)checkLoginStatus:(NSDictionary *)logindic
{
    if (![logindic objectForKey:@"account"] || ![[logindic objectForKey:@"account"] length]) {
        [[UIApplication sharedApplication].keyWindow showResult:@"手机号码不能为空"];
        return 0;
    }
    else if (![logindic objectForKey:@"password"] || ![[logindic objectForKey:@"password"] length])
    {
        [[UIApplication sharedApplication].keyWindow showResult:@"密码不能为空"];
        return 0;
        
    }
    else if (![self checkTelphone:logindic[@"account"]])
    {
        [[UIApplication sharedApplication].keyWindow showResult:@"手机号码格式错误"];
        return 0;
    }
    return 1;
}

+ (NSInteger)checkWxStatus:(NSDictionary *)registerdic
{
    if (![[registerdic objectForKey:@"account"] length]) {
        [[UIApplication sharedApplication].keyWindow showResult:@"手机号码不能为空"];
        return 0;
    }
    
    else if (![[registerdic objectForKey:@"verf"] length])
    {
        [[UIApplication sharedApplication].keyWindow showResult:@"验证码不能为空"];
        return 0;
        
    }
    
    return 1;
}

+ (NSString *)setSpecialText{
    int statue = [NSUserDefaults intForKey:@"isonline"];
    
//    if(statue == 1){
        return @"升级";
//    }
//    return @"抽奖";
}

+ (NSString *)CkBText{
    int statue = [NSUserDefaults intForKey:@"isonline"];
    
//    if(statue == 1){
        return @"金币";
//    }
//    return @"积分";
}


@end
