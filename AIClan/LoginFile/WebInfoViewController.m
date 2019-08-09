//
//  WebInfoViewController.m
//  lzLmsApp
//
//  Created by hd on 2018/4/23.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "WebInfoViewController.h"
#import "ShareView.h"
@interface WebInfoViewController ()<UIWebViewDelegate>
{
    UIWebView *webV;
    ShareView *shareV;

}
@end

@implementation WebInfoViewController
//http://www.lovelezu.com/index.php?s=/News/index.html
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _isXY ? @"隐私协议": @"平台信息";
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    webV.scrollView.alwaysBounceHorizontal = YES;
    webV.scrollView.bounces = NO;
    [self.view addSubview:webV];
    [webV setScalesPageToFit:YES];
    webV.delegate = self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    self.infoUrl = nil;
    self.content = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (!_isXY) {
        self.navigationController.navigationBar.translucent=NO;
        UIColor *color=[UIColor clearColor];
        CGRect rect =CGRectMake(0,0,self.view.frame.size.width,64);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        UIGraphicsEndImageContext();
        self.navigationController.navigationBar.clipsToBounds=NO;
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    }
   

    if (self.infoUrl) {
        NSURL *url = [NSURL URLWithString:self.infoUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //加载网页
        [webV loadRequest:request];
    }
    else{
        NSMutableString *mutHtmlStr = [NSMutableString stringWithString:self.content];
        mutHtmlStr.string = [mutHtmlStr stringByReplacingOccurrencesOfString:@"img" withString:@"img width=100%"];
        [webV loadHTMLString:mutHtmlStr baseURL:nil];
        
    }
}

#pragma mark UIWebViewDelegate

//即将加载某个请求的时候调用
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    //简单的请求拦截处理
    NSString *strM = request.URL.absoluteString;
    if ([strM containsString:@"360"]) {
        return NO;
    }
    return YES;
}

//1.开始加载网页的时候调用
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showProgress:YES text:@"加载中..."];
    NSLog(@"webViewDidStartLoad");
}

//2.加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [self.view showProgress:NO text:@"加载中..."];

//    self.goBack.enabled = self.webView.canGoBack;
//    self.goForward.enabled = self.webView.canGoForward;
}

//3.加载失败的时候调用
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

@end
