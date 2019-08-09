//
//  WxLoginViewController.m
//  TeaByGame
//
//  Created by hd on 2017/9/21.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "WxLoginViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CheckData.h"
#import "AppDelegate.h"
#import "HDMainViewController.h"
#import "NavCheckViewController.h"

@interface WxLoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSMutableArray *dataArray;
    NSInteger _sec;
    UIButton *tempBtn;
}

@end

@implementation WxLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(NavCheckViewController *)self.parentViewController setNavgationHiddens:(NavCheckViewController *)self.navigationController];
    
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:self.view.frame];
    [bgImgV setImage:[UIImage imageNamed:@"yy_bbg"]];
    [self.view addSubview:bgImgV];
    
    UIImageView *titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(bgImgV.width / 2 - 20, 70, 40, 154)];
    [titleImgV setImage:[UIImage imageNamed:@"logotop"]];
    [bgImgV addSubview:titleImgV];
    
    _sec = 59;
    
    dataArray = [[NSMutableArray alloc] init];
    
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"+86:",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入手机号码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"验证码:",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入验证码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"认证码:",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入认证码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    
    
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 3 + 20, self.view.frame.size.width, self.view.frame.size.height / 2) style:UITableViewStyleGrouped];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    _Maintableview.scrollEnabled = NO;
    [self.view addSubview:_Maintableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2 - 140, 0, 280, 35)];
        [bgV setImage:[UIImage imageNamed:@"textf"]];
        bgV.userInteractionEnabled = YES;
        [cell.contentView addSubview:bgV];
        
        
        UILabel *zhLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
        [zhLab setTextColor:XXColor(100.0, 100.0, 100.0, 1)];
        [zhLab setTextAlignment:NSTextAlignmentCenter];
        [zhLab setFont:[UIFont systemFontOfSize:13.0]];
        zhLab.tag = 100;
        [bgV addSubview:zhLab];
        
        UIView *lineV = [[UILabel alloc] initWithFrame:CGRectMake(zhLab.right, 7.5, 1, 20)];
        [lineV setBackgroundColor:XXColor(208, 131, 107, 1)];
        [bgV addSubview:lineV];
        
        UITextField *txtFeild = [[UITextField alloc] initWithFrame:CGRectMake(lineV.right + 15, 0,  280, 35)];
        
        [txtFeild setFont:[UIFont systemFontOfSize:14.0]];
        txtFeild.delegate = self;
        txtFeild.tag = 101;
        [txtFeild setReturnKeyType:UIReturnKeyDone];
        [bgV addSubview:txtFeild];
        
        UIButton *verBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        verBtn.tag = 102;
        verBtn.layer.cornerRadius = 10.0;
        [verBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        verBtn.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
        [verBtn setBackgroundColor:NavColor];
        [verBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        verBtn.hidden = YES;
        [verBtn addTarget:self action:@selector(clickRequestVerf:) forControlEvents:UIControlEventTouchUpInside];
        [bgV addSubview:verBtn];
    }
    [(UILabel *)[cell.contentView viewWithTag:100] setText:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"]];
    
    [(UITextField *)[cell.contentView viewWithTag:101] setPlaceholder:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Placeholder"]];
    [(UITextField *)[cell.contentView viewWithTag:101] setText:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"txtContent"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = XXColor(180.0, 180, 180, 1);
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:((UITextField *)[cell.contentView viewWithTag:101]).placeholder attributes:dict];
    [(UITextField *)[cell.contentView viewWithTag:101] setAttributedPlaceholder:attribute];
    
    if (indexPath.row == 2 || indexPath.row == 3)
    {
        [(UITextField *)[cell.contentView viewWithTag:101] setSecureTextEntry:YES];
    }
    else if (indexPath.row == 1)
    {
        [cell.contentView viewWithTag:102].hidden = NO;
        [(UITextField *)[cell.contentView viewWithTag:101] setKeyboardType:UIKeyboardTypeNumberPad];
        [[cell.contentView viewWithTag:102] setFrame:CGRectMake(200, 5, 70, 25)];

    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    UIButton *remenberBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 35)];
    remenberBtn.tag = 100;
    [remenberBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    remenberBtn.layer.cornerRadius = 15;
    [remenberBtn setTintColor:[UIColor whiteColor]];
    remenberBtn.backgroundColor = NavColor;
    remenberBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [remenberBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    [bgV addSubview:remenberBtn];
    return bgV;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell * cell = (UITableViewCell *)textField.superview.superview.superview;
    NSIndexPath *path = [_Maintableview indexPathForCell:cell];
    [[dataArray objectAtIndex:path.row] setValue:textField.text forKey:@"txtContent"];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)clickAction:(UIButton *)btn
{
    
    NSDictionary *registerdic = nil;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    registerdic = @{@"account":[dataArray[0] objectForKey:@"txtContent"],
                    @"numbers":[dataArray[2] objectForKey:@"txtContent"],
                    @"verf":[dataArray[1] objectForKey:@"txtContent"],
                    @"openid":self.wxUserDic[@"openid"],
                    @"title":self.wxUserDic[@"nickname"],
                    @"file_url":self.wxUserDic[@"headimgurl"],
                    };
    
    if ([CheckData checkWxStatus:registerdic]) {
        
        [self.view showProgress:YES text:@"绑定中.."];
        [AppRequest Request_Normalpost:@"reg" json:registerdic controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                
                [AppRequest Request_Normalpost:@"verflogin" json:@{@"openid":self.wxUserDic[@"openid"]} controller:self completion:^(id result, NSInteger statues) {
                    if (statues == 1) {
                        [NSUserDefaults setString:@"NO" forKey:BYBOSS];
                        [NSUserDefaults setString:self.wxUserDic[@"openid"] forKey:WXLOGIN];
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                            AppDelegate* appDelagete =  (AppDelegate*)[UIApplication sharedApplication].delegate;
                            appDelagete.window.rootViewController = [HDMainViewController new];
                            [UIView animateWithDuration:0.4 animations:^{
                                
                                appDelagete.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.4, 1.4);
                                appDelagete.window.rootViewController.view.alpha = 1;
                            } completion:^(BOOL finished) {
                                appDelagete.window.rootViewController.view.alpha = 1;
                            }];
                            appDelagete.window.rootViewController.view.transform = CGAffineTransformIdentity;
                            
                        }];
                    }
                } failed:^(NSError *error) {
                    
                }];
                
            }
            [self.view showResult:[result objectForKey:@"retErr"]];
        } failed:^(NSError *error) {
        }];
    }
}
- (void)clickRequestVerf:(UIButton *)btn
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (![[dataArray[0] objectForKey:@"txtContent"]length ]) {
        [self.view showResult:@"手机号码不能为空"];
        
    }
    else if (![CheckData checkTelphone:[dataArray[0] objectForKey:@"txtContent"]])
    {
        [self.view showResult:@"请先输入正确手机号码"];
        
    }
    else if(_sec == 59)
    {
        tempBtn = btn;
        [self beginRequest];
    }
    else
    {
        [self.view showResult:@"正在获取验证码"];
        
    }
    
}

- (void)beginRequest
{
    [self.view showProgress:YES text:@"请求验证码"];
    [AppRequest Request_Normalpost:@"sendmsg" json:@{@"phone":[dataArray[0] objectForKey:@"txtContent"],@"type":@"reg"} controller:self completion:^(id result, NSInteger statues) {
        
        if (statues == 1) {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:tempBtn repeats:YES];
            [tempBtn setBackgroundColor:[UIColor lightGrayColor]];
            [tempBtn setTitle:@"重新获取59" forState:UIControlStateNormal];
            [self.view showResult:@"正在请求验证码"];
        }
        [self.view showResult:result[@"retErr"]];
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO text:@"失败"];
    }];
    
}
- (void)timerFired:(NSTimer *)sender
{
    UIButton *Verificodebtn = sender.userInfo;
    [Verificodebtn setTitle:[NSString stringWithFormat:@"重新获取%ld",(long)(_sec > 0 ? --_sec : 0)] forState:UIControlStateNormal];
    if (_sec == 0) {
        
        [Verificodebtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [Verificodebtn setBackgroundColor:NavColor];
        
        [sender invalidate];
        _sec = 59;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
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
