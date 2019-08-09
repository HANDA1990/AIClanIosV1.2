//
//  AppRequest.h
//  PlasticNet
//
//  Created by hd on 15/9/17.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HDCompletionBlock)(id result, NSInteger statues);
typedef void (^HDFailedBlock)(NSError *error);

@interface AppRequest : NSObject


+ (void)Request_Normalpost:(NSString *)requestAction json:(NSDictionary *)json controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+ (void)Request_WxRefreshPost:(NSString *)accessUrlStr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+ (void)Request_WxPost:(NSString *)accessUrlStr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+ (void)Request_GuessPost:(NSString *)requestURL controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;


+ (void)Request_WxPayTest:(NSString *)accessUrlStr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+ (void)Request_TestPhotospost:(NSMutableDictionary *)jsonDic imageDatas:(NSArray *)imagedatas vedioArr:(NSArray *)vedioArr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+ (void)Request_SinglePhotoPost:(NSString *)uploadedfile imageDatas:(NSData *)imagedatas controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+ (void)Request_FileGroupPost:(NSString *)reqName jsonDic:(NSMutableDictionary *)jsonDic imageDatas:(NSArray *)imagedatas vedioArr:(NSArray *)vedioArr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed;

+(NSString *)convertToJsonData:(NSDictionary *)dict;

@end
