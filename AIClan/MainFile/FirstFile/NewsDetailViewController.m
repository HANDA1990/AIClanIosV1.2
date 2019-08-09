//
//  NewsDetailViewController.m
//  AIClan
//
//  Created by hd on 2018/11/20.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *webV;
}

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    [navColor setBackgroundColor:NavColor];
    [self.view addSubview:navColor];
    
    self.title = @"消息详情";
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, navColor.bottom + 10, self.view.width - 20, 20)];
    titleLab.tag = 1000;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:titleLab];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLab.bottom, self.view.width - 20, 20)];
    infoLab.tag = 1001;
    infoLab.textColor = [UIColor lightGrayColor];
    infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLab];
    
    
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, infoLab.bottom, self.view.width, self.view.height - infoLab.bottom)];
    webV.scrollView.alwaysBounceHorizontal = YES;
    webV.scrollView.bounces = NO;
    [self.view addSubview:webV];
//    [webV setScalesPageToFit:YES];
    webV.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"newsinfo" json:@{@"id":self.newsid} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            
            [(UITextField *)[self.view viewWithTag:1000] setText:result[@"retRes"][@"title"]];
            [(UITextField *)[self.view viewWithTag:1001] setText:[self getTimeFromTimesTamp:result[@"retRes"][@"create_time"]]];

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
