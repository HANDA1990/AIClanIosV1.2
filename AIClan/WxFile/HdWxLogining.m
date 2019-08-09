
//
//  HdWxLogining.m
//  TeaByGame
//
//  Created by hd on 2017/8/24.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "HdWxLogining.h"
#import "HdLoginViewController.h"
#import "MyMD5.h"

#define WXAppID @"wx51aed9df5c7523f3"
#define WXPartnerID @"1246473401"
#define WXAPPKey @"53a4d7d9d03b79bae1f8f7b5902141c1"

@implementation HdWxLogining



+ (instancetype)sharedManager {
    static HdWxLogining *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)WxRegist{
    
    [WXApi registerApp:WX_App_ID];
//    [WeiboSDK registerApp:@""];

}


- (void) handleOpenURL:(NSURL *) url
{
    [WXApi handleOpenURL:url delegate:self];
    
//    [WeiboSDK handleOpenURL:url delegate:self];
    //[WeiboSDK enableDebugMode:YES];
}
- (void)WechatLoginClick:(id)controller{
    _delegaty = controller;
    wxSelf = controller;
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        [((UIViewController *)controller).view showProgress:YES text:@"微信授权登录.."];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WXPatient_App_ID, refreshToken];
        [AppRequest Request_WxRefreshPost:refreshUrlStr controller:self completion:^(id result, NSInteger statues) {
//            [controller.view showProgress:NO text:@"微信登录.."];
            
            if (statues == 1) {
                if ([self.delegaty respondsToSelector:@selector(ComepleteLogin:)]) {
                    [self.delegaty ComepleteLogin: result];
                }
            }
        } failed:^(NSError *error) {
            [((UIViewController *)controller).view showProgress:NO text:@"微信登录.."];
            
        }];
    }
    else if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController:controller];
    }
}
+ (BOOL)checkWxInstalled{
    BOOL installed = [WXApi isWXAppInstalled];
    return installed;
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController:(UIViewController *)weakSelf {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [weakSelf presentViewController:alert animated:YES completion:nil];
}
#pragma mark wxdelegate responsed
- (void)onResp:(BaseResp *)resp{
    
    NSLog(@"resp:%@",resp);
    
    if ([resp isKindOfClass:[PayResp class]]) {
        if ([self.delegaty respondsToSelector:@selector(ComepletePayed:)]) {
            [self.delegaty ComepletePayed:resp];
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        [wxSelf.view showProgress:YES text:@"微信登录.."];
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, temp.code];
        [AppRequest Request_WxPost:accessUrlStr controller:self completion:^(id result, NSInteger statues) {
            [wxSelf.view showProgress:NO text:@"微信登录.."];
            if (statues == 1) {
                if ([self.delegaty respondsToSelector:@selector(ComepleteLogin:)]) {
                    [self.delegaty ComepleteLogin: result];
                }
            }
        } failed:^(NSError *error) {
            [wxSelf.view showProgress:NO text:@"微信登录.."];
        }];
    }
}

-(void) onReq:(BaseReq*)req{
    NSLog(@"req:%@",req);
  
}

- (void)wxPayed:(NSDictionary *)orderDic
{
    PayReq *req = [[PayReq alloc] init];
    req.prepayId = [orderDic objectForKey:@"prepayid"];
    req.partnerId = [orderDic objectForKey:@"partnerid"];
    req.package = [orderDic objectForKey:@"packages"];
    req.timeStamp = [[orderDic objectForKey:@"timestamp"] intValue];
    req.nonceStr = [orderDic objectForKey:@"noncestr"];
    req.sign = [orderDic objectForKey:@"sign"];

    NSLog(@"%@",req);
    [WXApi sendReq:req];
}
- (NSString*)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WXAPPKey];
    //得到MD5 sign签名
    NSString *md5Sign =[MyMD5 stringMD5:contentString];
    
    return md5Sign;
}
- (void)wxShare:(int)scence shareUrlStr:(NSDictionary *)shareUrlStr{
    if (![WXApi isWXAppInstalled]) {
        [[UIApplication sharedApplication].keyWindow showResult:@"请先安装微信客户端"];
        return;
    }
   
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = scence;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = [[NSString alloc] initWithFormat:@"乐租精品-%@",shareUrlStr[@"title"]];//分享标题
    urlMessage.description = [[NSString alloc] initWithFormat:@"乐租联盟店精心为您推荐：商品价:¥%@\n租赁最低至：¥%@",shareUrlStr[@"price"]?shareUrlStr[@"price"]:@"xx(点击可见)",shareUrlStr[@"zl_price1"]?shareUrlStr[@"zl_price1"]:@"xx(点击可见)"];//分享描述
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,shareUrlStr[@"file_url"]]] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//        [urlMessage setThumbImage:[self imageWithImage:image scaledToSize:CGSizeMake(100, 100)]];
//        //创建多媒体对象
//        WXWebpageObject *webObj = [WXWebpageObject object];
//        webObj.webpageUrl = shareUrlStr[@"http_url"];//分享链接
//        
//        //    完成发送对象实例
//        urlMessage.mediaObject = webObj;
//        sendReq.message = urlMessage;
//        
//        //发送分享信息
//        [WXApi sendReq:sendReq];
//    }];
 
}

- (void)wxShare:(int)scence shareImg:(UIImage *)shareImg{
    if (![WXApi isWXAppInstalled]) {
        [[UIApplication sharedApplication].keyWindow showResult:@"请先安装微信客户端"];
        return;
    }
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = scence;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    WXImageObject * imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(shareImg);
    //    完成发送对象实例
    urlMessage.mediaObject = imageObject;
    sendReq.message = urlMessage;
    [WXApi sendReq:sendReq];
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,imgUrl]] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//    }];

}

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    NSInteger newWidth = (NSInteger)newSize.width;
    NSInteger newHeight = (NSInteger)newSize.height;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    
    [image drawInRect:CGRectMake(0 , 0,newWidth, newHeight)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (UIImage *)zipImageWithData:(UIImage *)image {
    CGFloat origanSize = [self getImageLengthWithImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    if (origanSize > 1024) {
        imageData=UIImageJPEGRepresentation(image, 0.1);
    } else if (origanSize > 512) {
        imageData=UIImageJPEGRepresentation(image, 0.5);
    }
    else if (origanSize > 320) {
        imageData=UIImageJPEGRepresentation(image, 0.32);
    }
    UIImage *image1 = [UIImage imageWithData:imageData];
    return image1;
}
- (CGFloat)getImageLengthWithImage:(UIImage *)image {
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    CGFloat length = [imageData length]/1000;
    return length;
}

#pragma weibo

#pragma mark -- WeiboSDKDelegate


//- (void)weiboShare{
//
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = @"http://";
//    authRequest.scope = @"all";
//
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messagetoShre] authInfo:authRequest access_token:@"token"];
//
//
//    if (![WeiboSDK isWeiboAppInstalled]) {
//        request.message.text = [NSString stringWithFormat:@"%@%@",@"茗品雅汇",@"https://fir.im/sd4w"];
//
////        [[UIApplication sharedApplication].keyWindow showResult:@"请安装新浪"];;
//    }else {
//
//    }
//    [WeiboSDK sendRequest:request];
//
//}
//- (WBMessageObject *)messagetoShre
//{
//    WBMessageObject *message = [WBMessageObject message];
//
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = @"茗品雅汇";
//    webpage.description = [NSString stringWithFormat:@"我们不仅仅是商城，更是游戏把玩的福地，购买即可中大奖！%f", [[NSDate date] timeIntervalSince1970]];
//    webpage.thumbnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"AppIcon"], 1.0);
//    webpage.webpageUrl = @"https://fir.im/sd4w";
//    message.mediaObject = webpage;
//    return message;
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        if (response.statusCode == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"新浪微博分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"新浪微博分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class]){
//        if (response.statusCode == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"新浪微博授权成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"新浪微博授权失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//
//}
//
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
//
//}

@end
