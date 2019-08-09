//
//  PlForgetPasswordViewController.m
//  PlasticNet
//
//  Created by hd on 15/10/10.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import "PlForgetPasswordViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NSObject+NSString_MessageDigest.h"
#import "NavCheckViewController.h"
#import "AppDelegate.h"

@interface PlForgetPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_Maintableview;
    NSMutableArray *dataArray;
    NSInteger _sec;
    UIImageView *bgImgV;
    UIButton *tempBtn;

}


@end

@implementation PlForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"找回密码";


    _sec = 59;
    
    dataArray = [[NSMutableArray alloc] init];

    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"phone2",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入手机号码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"pas",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入密码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"pas",@"imageUrl",
                          @"",@"txtContent",
                          @"请重复输入密码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
//    yzm
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"yzm",@"imageUrl",
                          @"",@"txtContent",
                          @"请重复输入验证码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    _Maintableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStyleGrouped];
    
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.separatorColor = NavColor;
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
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
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return self.view.height - 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 62)];
        [bgV setImage:[UIImage imageNamed:@"textf"]];
        bgV.userInteractionEnabled = YES;
        [cell.contentView addSubview:bgV];
        
        
        UIImageView *zhLab = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 27, 27)];
        zhLab.tag = 100;
        [bgV addSubview:zhLab];
        
        UITextField *txtFeild = [[UITextField alloc] initWithFrame:CGRectMake(zhLab.right + 15, 0,  self.view.width - zhLab.right - 45, 35)];
        
        [txtFeild setFont:[UIFont systemFontOfSize:16.0]];
        txtFeild.delegate = self;
        txtFeild.tag = 101;
        [txtFeild setReturnKeyType:UIReturnKeyDone];
        [bgV addSubview:txtFeild];
        
        UIView *lineV = [[UILabel alloc] initWithFrame:CGRectMake(30, txtFeild.bottom + 5, self.view.width - zhLab.right, 0.5)];
        [lineV setBackgroundColor:XXColor(200, 200, 200, 1)];
        [bgV addSubview:lineV];
        
        UIButton *verBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 140, 0, 90, 40)];
        verBtn.tag = 102;
        [verBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [verBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        verBtn.hidden = YES;
        [verBtn addTarget:self action:@selector(clickRequestVerf:) forControlEvents:UIControlEventTouchUpInside];
        [bgV addSubview:verBtn];
        
        
    }
    [(UIImageView *)[cell.contentView viewWithTag:100]setImage:[UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"]]];
    
    [(UITextField *)[cell.contentView viewWithTag:101] setPlaceholder:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Placeholder"]];
    [(UITextField *)[cell.contentView viewWithTag:101] setText:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"txtContent"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = XXColor(180.0, 180, 180, 1);
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:((UITextField *)[cell.contentView viewWithTag:101]).placeholder attributes:dict];
    [(UITextField *)[cell.contentView viewWithTag:101] setAttributedPlaceholder:attribute];
    
    if (indexPath.row == 0)
    {
        [(UITextField *)[cell.contentView viewWithTag:101] setKeyboardType:UIKeyboardTypeNumberPad];
        [[cell.contentView viewWithTag:102] setFrame:CGRectMake(220, 5, 70, 25)];
        
    }
    if (indexPath.row == 3)
        [cell.contentView viewWithTag:102].hidden = NO;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    UIButton *remenberBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 140, 0, 280, 35)];
    remenberBtn.tag = 100;
    remenberBtn.backgroundColor = NavColor;
    [remenberBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    remenberBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    remenberBtn.backgroundColor = NavColor;
    [remenberBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [headerV addSubview:remenberBtn];
    return headerV;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = nil;
    
    cell = (UITableViewCell *)textField.superview.superview.superview;
    NSIndexPath *path = [_Maintableview indexPathForCell:cell];
    [[dataArray objectAtIndex:path.row] setValue:textField.text forKey:@"txtContent"];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)clickAction
{
    NSDictionary *registerdic = nil;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    registerdic = @{@"account":[dataArray[0] objectForKey:@"txtContent"],
                    @"password":[dataArray[2] objectForKey:@"txtContent"],
                    @"verf":[dataArray[3] objectForKey:@"txtContent"],
                    };
    
    if ([CheckData checkNowStatus:registerdic]) {
        
        [self.view showProgress:YES text:@"正在修改.."];
        [AppRequest Request_Normalpost:@"resetpass" json:registerdic controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self.view showResult:[result objectForKey:@"retErr"]];
        } failed:^(NSError *error) {
        }];
    }
}



- (void)clickRequestVerf:(UIButton *)btn
{
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview.superview;

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
    [AppRequest Request_Normalpost:@"sendverf" json:@{@"phone":[dataArray[0] objectForKey:@"txtContent"]} controller:self completion:^(id result, NSInteger statues) {
        
        if (statues == 1) {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:tempBtn repeats:YES];
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
