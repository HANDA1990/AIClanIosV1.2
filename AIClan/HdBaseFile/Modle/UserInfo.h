//
//  UserInfo.h
//  SAT抢考位
//
//  Created by dahan on 15/5/22.
//  Copyright (c) 2015年 dadaMarker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSString *tid;
    NSString *sid;
    NSString *acEmail;
    NSString *acMobile;
    NSString *acQq;
    NSString *birthday;
    NSString *gender;
    NSString *nameNick;
    NSString *photoUrl;
    NSString *userId;
    NSString *passWord;
    NSDictionary *userBdDic;
    NSString *grab_userid;
    NSString *bd_mobile;
    
    NSString *account_type_id;
    NSString *address;
    NSString *company_name;

    NSString *host_ip;
    NSString *img_ip;
    NSString *imgupdate_ip;

}


@property (nonatomic, retain)NSString *tid;
@property (nonatomic, retain)NSString *sid;
@property (nonatomic, retain)NSString *acEmail;
@property (nonatomic, retain)NSString *acMobile;
@property (nonatomic, retain)NSString *acQq;
@property (nonatomic, retain)NSString *birthday;
@property (nonatomic, retain)NSString *gender;
@property (nonatomic, retain)NSString *nameNick;
@property (nonatomic, retain)NSString *photoUrl;
@property (nonatomic, retain)NSString *userId;
@property (nonatomic, retain)NSString *passWord;
@property (nonatomic, retain)NSDictionary *userBdDic;
@property (nonatomic, retain)NSString *grab_userid;
@property (nonatomic, retain)NSString *bd_mobile;

@property (nonatomic, retain)NSString *account_type_id;
@property (nonatomic, retain)NSString *address;
@property (nonatomic, retain)NSString *company_name;


@property (nonatomic, retain)NSString *host_ip;
@property (nonatomic, retain)NSString *img_ip;
@property (nonatomic, retain)NSString *imgupdate_ip;

@end
