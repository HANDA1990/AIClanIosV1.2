//
//  ProfessorViewController.m
//  AIClan
//
//  Created by hd on 2018/11/3.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ProfessorViewDetailController.h"
#import "PromptlyOrderViewController.h"
#import "NavCheckViewController.h"

@interface ProfessorDetailViewController ()
{
    NSDictionary *infoDIc;
}
@end

@implementation ProfessorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家介绍";
    [self loadDatas];
}
- (void)loadDatas{
    [AppRequest Request_Normalpost:@"yyzjinfo" json:@{@"id":_profrssorId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            infoDIc = result[@"retRes"];
            [self topView];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)topView
{
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    [topV setBackgroundColor:NavColor];
    [self.view addSubview:topV];
    
    UIView *topV2 = [[UIView alloc] initWithFrame:CGRectMake(0, topV.bottom, self.view.width, 120)];
    [topV2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topV2];
    
    UIImageView *logoImgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 50, 110, 100, 100)];
    [logoImgv setBackgroundColor:[UIColor grayColor]];
    logoImgv.layer.masksToBounds = YES;
    logoImgv.layer.borderWidth = 1;
    logoImgv.layer.borderColor = NavColor.CGColor;
    [logoImgv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,infoDIc[@"file_url"]]]];
    logoImgv.layer.cornerRadius = logoImgv.width / 2;
    [self.view addSubview:logoImgv];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, topV.bottom + 60, self.view.width, 30)];
    infoLab.text = [NSString stringWithFormat:@"%@ | %@",infoDIc[@"title"],infoDIc[@"zhuanye"]];
    infoLab.attributedText = [self ChangeBfWordColor:infoLab.text];
    infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLab];
    
    UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, infoLab.bottom , self.view.width, 20)];
    infoLab2.text = [NSString stringWithFormat:@"%@",infoDIc[@"biaoqian"]];
    infoLab2.textAlignment = NSTextAlignmentCenter;
    infoLab2.textColor = [UIColor lightGrayColor];
    infoLab2.font = [UIFont fontWithName:FONTNAME size:15.0];
    [self.view addSubview:infoLab2];
    [self loadWebView:topV2];
    
    UIButton *handBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    handBtn.backgroundColor = NavColor;
    [handBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [handBtn addTarget:self action:@selector(yuyue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:handBtn];
}
- (void)loadWebView:(UIView *)upView{
    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(15, upView.bottom + 10, self.view.width - 30, self.view.height - upView.bottom - 50)];
    webV.scrollView.alwaysBounceHorizontal = YES;
    webV.scrollView.bounces = NO;
    [self.view addSubview:webV];
//    [webV setScalesPageToFit:YES];
//    webV.delegate = self;
    NSMutableString *mutHtmlStr = [NSMutableString stringWithString:infoDIc[@"app_contents"]];
//    mutHtmlStr.string = [mutHtmlStr stringByReplacingOccurrencesOfString:@"img" withString:@"img width=100%"];
    [webV loadHTMLString:mutHtmlStr baseURL:nil];
    
}
- (void)yuyue{
//    [(NavCheckViewController *)self.navigationController setNavgationHiddens:(NavCheckViewController *)self.navigationController];
    
    PromptlyOrderViewController *prompVc = [PromptlyOrderViewController new];
    prompVc.infoDic = infoDIc;
    NavCheckViewController *nav = [[NavCheckViewController alloc]initWithRootViewController:prompVc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

//部分字体颜色
- (NSMutableAttributedString *)ChangeBfWordColor:(NSString *)changeStr{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:changeStr];
    NSRange range2 = [[str string] rangeOfString:infoDIc[@"title"]];
    [str addAttribute:NSForegroundColorAttributeName value:NavColor range:range2];
    return str;
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
