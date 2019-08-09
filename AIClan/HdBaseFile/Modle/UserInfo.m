//
//  UserInfo.m
//  SAT抢考位
//
//  Created by dahan on 15/5/22.
//  Copyright (c) 2015年 dadaMarker. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize tid;
@synthesize sid;
@synthesize acEmail;
@synthesize acMobile;
@synthesize acQq;
@synthesize birthday;
@synthesize gender;
@synthesize nameNick;
@synthesize photoUrl;
@synthesize userId;
@synthesize passWord;
@synthesize userBdDic;
@synthesize grab_userid;
@synthesize bd_mobile;


//
@synthesize account_type_id;
@synthesize address;
@synthesize company_name;

@synthesize host_ip;
@synthesize img_ip;
@synthesize imgupdate_ip;


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self) {
        self.tid = [decoder decodeObjectForKey:@"tid"];
        self.sid = [decoder decodeObjectForKey:@"sid"];
        self.acEmail = [decoder decodeObjectForKey:@"acEmail"];
        self.acMobile = [decoder decodeObjectForKey:@"acMobile"];
        self.acQq = [decoder decodeObjectForKey:@"acQq"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.nameNick = [decoder decodeObjectForKey:@"nameNick"];
        self.photoUrl = [decoder decodeObjectForKey:@"photoUrl"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.passWord = [decoder decodeObjectForKey:@"passWord"];
        self.userBdDic = [decoder decodeObjectForKey:@"userBdDic"];
        self.grab_userid = [decoder decodeObjectForKey:@"grab_userid"];
        self.bd_mobile = [decoder decodeObjectForKey:@"bd_mobile"];

        
        self.account_type_id = [decoder decodeObjectForKey:@"account_type_id"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.company_name = [decoder decodeObjectForKey:@"company_name"];

        self.host_ip = [decoder decodeObjectForKey:@"host_ip"];
        self.img_ip = [decoder decodeObjectForKey:@"img_ip"];
        self.imgupdate_ip = [decoder decodeObjectForKey:@"imgupdate_ip"];

    }
    return self;

}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tid forKey:@"tid"];
    [encoder encodeObject:self.sid forKey:@"sid"];
    [encoder encodeObject:self.acEmail forKey:@"acEmail"];
    [encoder encodeObject:self.acMobile forKey:@"acMobile"];
    [encoder encodeObject:self.acQq forKey:@"acQq"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.nameNick forKey:@"nameNick"];
    [encoder encodeObject:self.photoUrl forKey:@"photoUrl"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.passWord forKey:@"passWord"];
    [encoder encodeObject:self.userBdDic forKey:@"userBdDic"];
    [encoder encodeObject:self.grab_userid forKey:@"grab_userid"];
    [encoder encodeObject:self.bd_mobile forKey:@"bd_mobile"];

    [encoder encodeObject:self.bd_mobile forKey:@"account_type_id"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.company_name forKey:@"company_name"];

    [encoder encodeObject:self.host_ip forKey:@"host_ip"];
    [encoder encodeObject:self.img_ip forKey:@"img_ip"];
    [encoder encodeObject:self.imgupdate_ip forKey:@"imgupdate_ip"];

}
@end
