//
//  NSObject+NSString_MessageDigest.h
//  dk2
//
//  Created by 程子扬 on 14-10-24.
//  Copyright (c) 2014年 chengziyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MessageDigest)

- (NSString *)md2;

- (NSString *)md4;

- (NSString *)md5;

- (NSString *)sha1;

- (NSString *)sha224;

- (NSString *)sha256;

- (NSString *)sha384;

- (NSString *)sha512;

@end
