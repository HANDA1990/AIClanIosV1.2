//
//  MyMD5.m
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MyMD5



+ (NSString *)stringMD5:(NSString *)strString{
    if (strString) {
        const char* original_str=[strString UTF8String];
        
        unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
        
        CC_MD5(original_str, strlen(original_str), digist);
        
        NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
        
        for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
            
            [outPutStr appendFormat:@"%02x", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
            
        }
        
        return [outPutStr lowercaseString];
    }
    return nil;
}

+ (NSString *)MD5up:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i] ];
    
    return [result uppercaseString];
}


+(NSString*)fileMD5:(NSString*)path
 {
//     NSString *docDir, *filePath;
//     NSFileManager *fileManager;
//     
//     docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//     filePath = [docDir stringByAppendingPathComponent:path];
//     NSLog(@"%@", filePath);
//     fileManager = [NSFileManager defaultManager];
     NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
     if( handle== nil ){
            return @"ERROR GETTING FILE MD5"; // file didnt exist
     }
     CC_MD5_CTX md5;
     CC_MD5_Init(&md5);
     BOOL done = NO;
     while(!done)
             {
                 NSData* fileData = [handle readDataOfLength:256];
                CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
                   if( [fileData length] == 0 ) done = YES;
                }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                             digest[0], digest[1],
                                            digest[2], digest[3],
                                              digest[4], digest[5],
                                              digest[6], digest[7],
                                              digest[8], digest[9],
                                              digest[10], digest[11],
                                              digest[12], digest[13],
                                              digest[14], digest[15]];
         return s;
}
@end
