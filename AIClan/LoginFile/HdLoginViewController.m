//
//  HdLoginViewController.m
//  TeaByGame
//
//  Created by hd on 2017/8/24.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "HdLoginViewController.h"
#import "PlForgetPasswordViewController.h"
#import "HDMainViewController.h"
#import "AppDelegate.h"
#import "CheckData.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NavCheckViewController.h"
#import "AppDelegate.h"
#import "BaseNavViewController.h"
#import "HdRegistViewController.h"
#import "JPUSHService.h"
#import "HdWxLogining.h"

@interface HdLoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,wxLogindelegate>
{
    UIImageView *bgImgV;
    TPKeyboardAvoidingTableView *_Maintableview;
    NSMutableArray *dataArray;
    UITextField *paswtxtFeild;
    
}
@end

@implementation HdLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainColor(1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"登录";

    
    UIImageView *titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 91.5, 140, 183, 132)];
    [titleImgV setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:titleImgV];
    
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, titleImgV.bottom, self.view.frame.size.width, self.view.frame.size.height - titleImgV.bottom) style:UITableViewStyleGrouped];
    
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self Autologin];
}

- (void)viewWillDisappear:(BOOL)animated
{
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    for(UIView *subV in cell.contentView.subviews)
    {
        [subV removeFromSuperview];
    }
    if (indexPath.row == 0) {
        
        UIImageView *phone = [[UIImageView alloc] initWithFrame:CGRectMake(27, 0, 27, 27)];
        [phone setImage:[UIImage imageNamed:@"phone"]];
        phone.userInteractionEnabled = YES;
        [cell.contentView addSubview:phone];

        self.nametxtFeild = [[UITextField alloc] initWithFrame:CGRectMake(phone.right + 15, 0, self.view.width - phone.right - 50, 30)];
        [self.nametxtFeild setFont:[UIFont fontWithName:FONTNAME size:14.0]];
        self.nametxtFeild.placeholder = @"请输入手机号";
        self.nametxtFeild.textColor = [UIColor whiteColor];
//        self.nametxtFeild.text = @"17139061224";
        self.nametxtFeild.delegate = self;
        [self.nametxtFeild setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:self.nametxtFeild];

        UIView *lineV = [[UILabel alloc] initWithFrame:CGRectMake(27, 35, self.view.width - 54, 0.5)];
        [lineV setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lineV];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.nametxtFeild.placeholder attributes:dict];
        [self.nametxtFeild setAttributedPlaceholder:attribute];
        
    }
    else if (indexPath.row == 1)
    {
        
        UIImageView *phone = [[UIImageView alloc] initWithFrame:CGRectMake(27, 0, 27, 27)];
        [phone setImage:[UIImage imageNamed:@"password"]];
        phone.userInteractionEnabled = YES;
        [cell.contentView addSubview:phone];
        
        paswtxtFeild = [[UITextField alloc] initWithFrame:CGRectMake(phone.right + 15, 0, self.view.width - phone.right - 50, 30)];
        [paswtxtFeild setFont:[UIFont fontWithName:FONTNAME size:14.0]];
        paswtxtFeild.textColor = [UIColor whiteColor];
        paswtxtFeild.placeholder = @"请输入密码";
        paswtxtFeild.secureTextEntry = YES;
//        paswtxtFeild.text = @"123456";
        paswtxtFeild.delegate = self;
        [cell.contentView addSubview:paswtxtFeild];
        
        UIView *lineV = [[UILabel alloc] initWithFrame:CGRectMake(27, 35, self.view.width - 54, 0.5)];
        [lineV setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lineV];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:paswtxtFeild.placeholder attributes:dict];
        [paswtxtFeild setAttributedPlaceholder:attribute];
        

    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];

    UIButton *remenberBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 140, 40, 280, 40)];
    [remenberBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [remenberBtn setBackgroundColor:[UIColor whiteColor]];
    remenberBtn.titleLabel.font = [UIFont fontWithName:FONTNAME size:17.0];
    [remenberBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [remenberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerV addSubview:remenberBtn];
    
    UIButton *helpLab = [[UIButton alloc] initWithFrame:CGRectMake(remenberBtn.x, remenberBtn.bottom + 40, 100, 24)];
    helpLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [helpLab setTitle:@"立即注册" forState:UIControlStateNormal];
    [helpLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpLab.titleLabel.font = [UIFont fontWithName:FONTNAME size:14.0];
    [helpLab setBackgroundImage:[UIImage imageNamed:@"smbright"] forState:UIControlStateNormal];
    [helpLab addTarget:self action:@selector(clcikregist) forControlEvents:UIControlEventTouchUpInside];
    
    [headerV addSubview:helpLab];
    
    UIButton *forgetLab = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 100 - remenberBtn.x, remenberBtn.bottom + 40, 100, 24)];
    forgetLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetLab setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetLab.titleLabel.font = [UIFont fontWithName:FONTNAME size:14.0];
    [forgetLab setBackgroundImage:[UIImage imageNamed:@"smbleft"] forState:UIControlStateNormal];
    [forgetLab addTarget:self action:@selector(clickFogetPs) forControlEvents:UIControlEventTouchUpInside];
    [headerV addSubview:forgetLab];
    
    UIButton *wxbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width  / 2 - 20, remenberBtn.bottom + 70, 40, 40)];
    [wxbtn setImage:[UIImage imageNamed:@"wxlogin"] forState:UIControlStateNormal];
    [wxbtn addTarget:self action:@selector(clickWxBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [headerV addSubview:wxbtn];
    
 
    
    return headerV;
}

- (void)clickWxBtn
{
   
    [[HdWxLogining sharedManager] WxRegist];
    [[HdWxLogining sharedManager] WechatLoginClick:self];
}

- (void)ComepleteLogin:(NSDictionary *)retuernInfo
{
    [self.view showResult:@"微信登录授权暂未开放"];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)clickAction
{
    
//    NSString *registrationID;
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
//        if (registrationID == NULL){
////            [self.view showResult:@"消息推送绑定失败"];
//
//        }
//
//    }];
    
   
    NSDictionary *chekDic = @{@"account":self.nametxtFeild.text,@"password":paswtxtFeild.text,@"jpush_id":@""};
    if (![CheckData checkLoginStatus:chekDic]) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:@"登录.."];
    [AppRequest Request_Normalpost:@"login" json:chekDic controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [NSUserDefaults setString:@"YES" forKey:BYBOSS];
            [NSUserDefaults setUserObject:chekDic forKey:LOGININFO];
            [NSUserDefaults setString:result[@"retRes"][@"login_verf"] forKey:LOGINVERF];
            
            [self loginAppdelegate:1];
        }
        [SVProgressHUD dismiss];
        [self.view showResult:result[@"retErr"]];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
   
}

- (void)Autologin{
    NSString *byPhone = [NSUserDefaults stringForKey:BYBOSS];
    if ([byPhone isEqualToString:@"YES"]) {
        NSString *loginStr = [NSUserDefaults stringForKey:LOGINVERF];
        if (loginStr) {
            [SVProgressHUD showWithStatus:@"登录.."];
            [AppRequest Request_Normalpost:@"verflogin" json:@{@"login_verf":loginStr} controller:self completion:^(id result, NSInteger statues) {
                [[UIApplication sharedApplication].keyWindow showProgress:NO text:@"登录中.."];
                if (statues == 1) {
                    [NSUserDefaults setString:result[@"retRes"][@"login_verf"] forKey:LOGINVERF];

                    [self loginAppdelegate:1];
                }
                else{
                    [[UIApplication sharedApplication].keyWindow showResultLong:result[@"retErr"]];
                    
                }
                [SVProgressHUD dismiss];

            } failed:^(NSError *error) {
                [SVProgressHUD dismiss];

            }];
        }
    }
}

- (void)loginAppdelegate:(NSInteger)enterTag{
    AppDelegate* appDelagete =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelagete.window.rootViewController = [HDMainViewController new];

    [UIView animateWithDuration:0.4 animations:^{
        
        appDelagete.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.4, 1.4);
        appDelagete.window.rootViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        appDelagete.window.rootViewController.view.alpha = 1;
    }];
    appDelagete.window.rootViewController.view.transform = CGAffineTransformIdentity;
}
- (NSInteger)checkNowStatus:(NSDictionary *)registerdic
{
    if (![[registerdic objectForKey:@"app_user"] length]) {
        [self.view showResult:@"手机号码不能为空"];
        return 0;
    }
    else  if (!paswtxtFeild.text.length) {
        [self.view showResult:@"密码不能为空"];
        return 0;
    }
    else if (![self checkTelphone:[registerdic objectForKey:@"app_user"]])
    {
//        [self.view showResult:@"手机号码错误"];
        return 0;
        
    }
    return 1;
}


- (BOOL)checkTelphone:(NSString *)mobileNum{
    NSString * MOBILE = @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)clcikregist
{
    [self.navigationController pushViewController:[HdRegistViewController new] animated:YES];
}
- (void)clickFogetPs
{
    [self.navigationController pushViewController:[PlForgetPasswordViewController new] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
