//
//  AppRequest.m
//  PlasticNet
//
//  Created by hd on 15/9/17.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import "AppRequest.h"
#import "AFNetworking.h"
#import "NavCheckViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "MyMD5.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AppRequest


#pragma -mark 通用接口

+ (NSString *)dictToJSONString:(NSDictionary *)dict
{
    NSString *string = nil;
    for (id key in dict)
    {
        if (string == nil) {
            string = [NSString stringWithFormat:@"{\"%@\":\"%@\"", key, [dict objectForKey:key]];
        }
        else
        {
            string = [NSString stringWithFormat:@"%@,\"%@\":\"%@\"", string, key, [dict objectForKey:key]];
        }
    }
    if (!string)
        string = @"{}";
    else
        string = [NSString stringWithFormat:@"%@}", string];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
    string = [string stringByReplacingOccurrencesOfString:@"\"(" withString:@"["];
    string = [string stringByReplacingOccurrencesOfString:@")\"" withString:@"]"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    NSLog(@"%@", string);
    return string;
}
// 字典转json字符串方法

+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSLog(mutStr);
    return mutStr;
    
}
+ (void)Request_Normalpost:(NSString *)requestAction json:(NSDictionary *)json controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    __weak typeof (UIViewController *)weakController = (UIViewController *)controller;
    // 开始请求
    __weak typeof(self) wSelf = self;
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *current = [formatter stringFromDate:now];
    NSString *datastr;
    if ([requestAction isEqualToString:@"tjsbdyg"]) {
        datastr = [self convertToJsonData:json];
    }
    else
    {
        datastr = [self dictToJSONString:json];
    }
    datastr = [datastr stringByAppendingString:@"nimdaae"];
    datastr = [datastr stringByAppendingString:requestAction];
    datastr = [datastr stringByAppendingString:current];
    NSLog(@"需要加密:%@",datastr);

    datastr = [MyMD5 stringMD5:datastr];
    NSString *url = [NSString stringWithFormat:@"http://szx.yshdszx.com/api.php/Index/%@/from/ios/keystr/%@",requestAction,datastr];
//    reqparameter = [reqparameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url==%@==%@", url,json);
    
    [manager POST:url parameters:json success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![weakController isMemberOfClass:[AppDelegate class]]) {
                [weakController.view showProgress:NO text:@""];
            }
        
            if (!wSelf) {
                return ;
            }
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (!jsonDic) {
                if (![weakController isMemberOfClass:[AppDelegate class]]) {
                    [weakController.view showResult:@"返回数据错误"];
                }
                return;
            }
            NSInteger retcode = [[jsonDic objectForKey:@"retInt"] intValue];
            NSString *reterro = jsonDic[@"retErr"];
        if ([reterro isEqualToString:@"loginerr"]) {
                if ([weakController isMemberOfClass:[ViewController class]]) {
                    [weakController.view showResult:@"用户失效，请重新登录"];
                    return;

                }
                completion(jsonDic,retcode);
                
                [NSUserDefaults removeObjectForKey:BYBOSS];
                [NSUserDefaults removeObjectForKey:LOGININFO];
                [NSUserDefaults removeObjectForKey:LOGINVERF];
                AppDelegate* appDelagete =  (AppDelegate*)[UIApplication sharedApplication].delegate;
                ViewController *vc = [ViewController new];
                appDelagete.window.rootViewController = vc;
                [UIView animateWithDuration:0.4 animations:^{
                    
                    appDelagete.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.4, 1.4);
                    appDelagete.window.rootViewController.view.alpha = 1;
                } completion:^(BOOL finished) {
                    appDelagete.window.rootViewController.view.alpha = 1;
                }];
                appDelagete.window.rootViewController.view.transform = CGAffineTransformIdentity;
                return;
            }
            
            completion(jsonDic,retcode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failed(error);
    
            if (![weakController isKindOfClass:[AppDelegate class]]) {
                [weakController.view showProgress:NO text:@""];
            }
            if (error.code == -1004) {
                if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] intValue] == 61) {
                 if (![weakController isKindOfClass:[AppDelegate class]])
                    [weakController.view showResult:@"无法连接到服务器"];
    
                }
                else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] intValue] == 51)
                {
                 if (![weakController isKindOfClass:[AppDelegate class]])
                    [weakController.view showResult:@"无法连接到网络"];
                }
            }
            else if (error.code == -1001)
            {
             if (![weakController isKindOfClass:[AppDelegate class]])
                [weakController.view showResult:@"请求超时,请不要离开再尝试一次"];
            }
            else if (error.code == -1011)
            {
                 if (![weakController isKindOfClass:[AppDelegate class]])
                [weakController.view showResult:@"服务器异常"];//404
    
            }
            else if (error.code == -1022){
                if (![weakController isKindOfClass:[AppDelegate class]])
                    [weakController.view showResult:@"网络异常"];//
                
            }
            else if (error.code == -1009)
            {
                 if (![weakController isKindOfClass:[AppDelegate class]])
                [weakController.view showResult:@"似乎已断开互联网连接"];//404
    
            }
        }];
}

+ (void)Request_GuessPost:(NSString *)requestURL controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    __weak typeof (UIViewController *)weakController = (UIViewController *)controller;
    // 开始请求
    __weak typeof(self) wSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@",requestURL];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakController.view showProgress:NO text:@""];
        if (!wSelf) {
            return ;
        }
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (!jsonDic) {
            completion(nil,0);
        }
        else if ([jsonDic isKindOfClass:[NSDictionary class]]){
            completion(jsonDic,1);
        }
        else{
            completion(nil,0);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
        [weakController.view showProgress:NO text:@""];
        
        if (error.code == -1004) {
            if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] intValue] == 61) {
                [weakController.view showResult:@"无法连接到服务器"];
                
            }
            else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] intValue] == 51)
            {
                [weakController.view showResult:@"无法连接到网络"];
            }
        }
        else if (error.code == -1001)
        {
            [weakController.view showResult:@"请求超时,请不要离开再尝试一次"];
        }
        else if (error.code == -1011 || error.code == -1022)
        {
            [weakController.view showResult:@"服务器异常"];//404
            
        }
        else if (error.code == -1009)
        {
            [weakController.view showResult:@"似乎已断开互联网连接"];//404
            
        }
    }];
    
}


+ (void)Request_WxPost:(NSString *)accessUrlStr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    
    [manager POST:accessUrlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"请求access的response = %@", accessDict);
        
        NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
        NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
        NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
        // 本地持久化，以便access_token的使用、刷新或者持续
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
        }
        [self RequestForUserInfo:^(id result, NSInteger statues) {
            if (statues == 1) {
                NSLog(@"authorization_code方式%@",result);
                completion(result, 1);
            }
        } failed:^(NSError *error) {
            
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
        completion(error, 0);
    }];
}

+ (void)Request_WxRefreshPost:(NSString *)accessUrlStr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    
    [manager POST:accessUrlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"请求access的response = %@", accessDict);
        
        NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
        NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
        NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
        // 本地持久化，以便access_token的使用、刷新或者持续
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
        }
        [self RequestForUserInfo:^(id result, NSInteger statues) {
            if (statues == 1) {
                NSLog(@"WX_REFRESH_TOKEN方式%@",result);
                completion(result, 1);
            }
        } failed:^(NSError *error) {
            
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
        completion(error, 0);
    }];
}


+ (void)RequestForUserInfo:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    
    [manager POST:userUrlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"请求用户信息的userDict = %@", userDict);
        completion(userDict, 1);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取userDict时出错 = %@", error);
        completion(error, 0);
    }];
}


+ (void)Request_WxPayTest:(NSString *)accessUrlStr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    
    [manager POST:accessUrlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        completion(dict, 1);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取时出错 = %@", error);
        completion(error, 0);
    }];
}
#pragma -mark 上传图片

+(AFHTTPSessionManager*) sessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    
//    sessinManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                               @"text/html",
//                                                               @"image/jpeg",
//                                                               @"image/png",
//                                                               @"application/octet-stream",
//                                                               @"text/json",
//                                                               nil];

    //    // 设置请求头
    //    [sessinManager.requestSerializer setValue:@"xxx" forHTTPHeaderField:@"xxxx"];
    // 时间戳
    
    
    return manager;
}

//2.发送请求
+ (void)Request_TestPhotospost:(NSMutableDictionary *)jsonDic imageDatas:(NSArray *)imagedatas vedioArr:(NSArray *)vedioArr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    AFHTTPSessionManager* sessionManager= [self sessionManager];
    
    NSString *requestAction = @"upfilelists";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *current = [formatter stringFromDate:now];
    NSLog(@"current:%@",current);
    NSString *datastr = @"";
    datastr = [datastr stringByAppendingString:@"nimdaae"];
    datastr = [datastr stringByAppendingString:requestAction];
    datastr = [datastr stringByAppendingString:current];
    datastr = [MyMD5 stringMD5:datastr];
    NSString *url = [NSString stringWithFormat:@"http://szx.yshdszx.com/api.php/Index/%@/from/ios/keystr/%@",requestAction,datastr];
    
    [sessionManager POST:url parameters:jsonDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for(NSInteger i=0; i<imagedatas.count; i++) {
            UIImage *eachImg = [imagedatas objectAtIndex:i][@"img"];
            NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
            NSLog(@"%d",eachImgData.length);

            [formData appendPartWithFileData:eachImgData name:@"uploadedfile[]" fileName:[NSString stringWithFormat:@"upfile/%d.jpg", i+1] mimeType:@"image/jpeg"];
        }

        if (vedioArr.count) {

            if (vedioArr[0][@"path"] != nil) {
                //                NSString *videoPath = [NSDocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mov", 0]];    // 这里直接强制写一个即可，之前计划是用i++来区分不明视频
                //
                //                NSURL *url = [NSURL fileURLWithPath:videoPath];
                //
                //                NSError *theErro = nil;
                //
                //                BOOL exportResult = [asset exportDataToURL:url error:&theErro];
                //
                //                NSLog(@"exportResult=%@", exportResult?@"YES":@"NO")
                
                    NSData *videoData = [NSData dataWithContentsOfURL:vedioArr[0][@"path"]];
                NSLog(@"%d",videoData.length);
                    [formData appendPartWithFileData:videoData name:@"uploadedfile[]" fileName:@"public1.MP4" mimeType:@"video/quicktime"];
            }
                
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 获取上传进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        if ([JSON[@"retInt"] integerValue] == 1) { // 返回 code 值不为 0
            NSInteger retcode = [[JSON objectForKey:@"retInt"] intValue];
            NSArray *fileArr = JSON[@"retRes"];
            
            NSMutableArray *imgArr = [NSMutableArray new];
            NSMutableArray *vedioArr = [NSMutableArray new];
            
            for (NSString *filestr in fileArr) {
                NSString *suffix = [filestr substringFromIndex:filestr.length - 3];
               

                if ([suffix isEqualToString:@"jpg"]) {
                    [imgArr addObject:filestr];
                }
                else if ([suffix isEqualToString:@"MP4"]){
                    [vedioArr addObject:filestr];
                }
            }
            
            [jsonDic setObject:imgArr forKey:@"img_file_urls"];
            [jsonDic setObject:vedioArr forKey:@"video_file_urls"];

            [AppRequest Request_Normalpost:@"tjyyxx" json:jsonDic controller:controller completion:^(id result, NSInteger statues) {
                completion(result, statues);
            } failed:^(NSError *error) {
                completion(JSON, 0);
            }];
        }
        else
        {
            completion(JSON, 0);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication].keyWindow showResult:@"图片或视频上传失败"];
        completion(@{}, 0);
        failed(error);
    }];
}
+ (void)Request_FileGroupPost:(NSString *)reqName jsonDic:(NSMutableDictionary *)jsonDic imageDatas:(NSArray *)imagedatas vedioArr:(NSArray *)vedioArr controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed{
    AFHTTPSessionManager* sessionManager= [self sessionManager];
    
    NSString *requestAction = @"upfilelists";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *current = [formatter stringFromDate:now];
    NSLog(@"current:%@",current);
    NSString *datastr = @"";
    datastr = [datastr stringByAppendingString:@"nimdaae"];
    datastr = [datastr stringByAppendingString:requestAction];
    datastr = [datastr stringByAppendingString:current];
    datastr = [MyMD5 stringMD5:datastr];
    NSString *url = [NSString stringWithFormat:@"http://szx.yshdszx.com/api.php/Index/%@/from/ios/keystr/%@",requestAction,datastr];
    
    [sessionManager POST:url parameters:jsonDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSInteger i=0; i<imagedatas.count; i++) {
            UIImage *eachImg = [imagedatas objectAtIndex:i][@"img"];
            NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
            [formData appendPartWithFileData:eachImgData name:@"uploadedfile[]" fileName:[NSString stringWithFormat:@"upfile/%d.jpg", i+1] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 获取上传进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        if ([JSON[@"retInt"] integerValue] == 1) { // 返回 code 值不为 0
            NSInteger retcode = [[JSON objectForKey:@"retInt"] intValue];
            NSArray *fileArr = JSON[@"retRes"];
            
            NSMutableArray *imgArr = [NSMutableArray new];
            NSMutableArray *vedioArr = [NSMutableArray new];
            
            for (NSString *filestr in fileArr) {
                NSString *suffix = [filestr substringFromIndex:filestr.length - 3];
                
                
                if ([suffix isEqualToString:@"jpg"]) {
                    [imgArr addObject:filestr];
                }
                else if ([suffix isEqualToString:@"MP4"]){
                    [vedioArr addObject:filestr];
                }
            }
            
            [jsonDic setObject:imgArr forKey:@"img_file_urls"];
            
            [AppRequest Request_Normalpost:reqName json:jsonDic controller:controller completion:^(id result, NSInteger statues) {
                completion(result, statues);
            } failed:^(NSError *error) {
                
            }];
        }
        else
        {
            completion(JSON, 0);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
        failed(error);
    }];
}

+ (void)Request_SinglePhotoPost:(NSString *)uploadedfile imageDatas:(NSData *)imagedatas controller:(id)controller completion:(HDCompletionBlock)completion failed:(HDFailedBlock)failed
{
    AFHTTPSessionManager* sessionManager= [self sessionManager];
    
    NSString *requestAction = uploadedfile;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *current = [formatter stringFromDate:now];
    NSLog(@"current:%@",current);
    NSString *datastr = @"";
    datastr = [datastr stringByAppendingString:@"nimdaae"];
    datastr = [datastr stringByAppendingString:requestAction];
    datastr = [datastr stringByAppendingString:current];
    datastr = [MyMD5 stringMD5:datastr];
//    NSString *url = [NSString stringWithFormat:@"http://szx.yshdszx.com/api.php/Index/%@/from/ios/keystr/%@",requestAction,datastr];
    NSString *url = @"http://10.128.24.9:20009/PrintServer/";
    [sessionManager POST:url parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        [formData appendPartWithFileData:imagedatas name:@"" fileName:@"" mimeType:@""];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 获取上传进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        if ([JSON[@"retInt"] integerValue] == 1) { // 返回 code 值不为 0
            NSInteger retcode = [[JSON objectForKey:@"retInt"] intValue];
            completion(JSON, retcode);
        }
        else
        {
            completion(JSON, 0);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
        failed(error);
    }];
}
@end
