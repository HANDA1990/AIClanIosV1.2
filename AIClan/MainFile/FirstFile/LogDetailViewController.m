//
//  LogDetailViewController.m
//  AIClan
//
//  Created by hd on 2018/11/14.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "LogDetailViewController.h"

@interface LogDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *webV;
}

@end

@implementation LogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    [navColor setBackgroundColor:NavColor];
    [self.view addSubview:navColor];
    
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, Height_NavBar, self.view.width, self.view.height)];
    webV.scrollView.alwaysBounceHorizontal = YES;
    webV.scrollView.bounces = NO;
    [self.view addSubview:webV];
//    [webV setScalesPageToFit:YES];
    webV.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"czsminfo" json:@{@"id":self.logid} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSString *contentstr = result[@"retRes"][@"app_contents"];
            
            NSMutableString *mutHtmlStr = [NSMutableString stringWithString:contentstr];
//            mutHtmlStr.string = [mutHtmlStr stringByReplacingOccurrencesOfString:@"img" withString:@"img width=100%"];
            [webV loadHTMLString:mutHtmlStr baseURL:nil];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
