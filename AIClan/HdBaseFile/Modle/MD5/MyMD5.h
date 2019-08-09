//
//  MyMD5.h
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MyMD5 : NSObject {
    
}
/*****
 2011.09.15
 创建： shen
 MD5 加密
 *****/

+(NSString *)stringMD5:(NSString *)strString;

+(NSString*)fileMD5:(NSString*)path;

+(NSString *)MD5up:(NSString *)string;
@end

