//
//  HdRegistViewController.m
//  TeaByGame
//
//  Created by hd on 2017/8/24.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "HdRegistViewController.h"
#import "CheckData.h"
#import "AppDelegate.h"
#import "HDMainViewController.h"
#import "HdLoginViewController.h"
#import "NavCheckViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "WebInfoViewController.h"

@interface HdRegistViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSMutableArray *dataArray;
    NSInteger _sec;
    UIButton *tempBtn;
    UILabel *promotLab;
    UIImageView *bgImgV;
    UITableViewCell *codeCell;

}
@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation HdRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注 册";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *LogoImgV = [[UIImageView alloc] initWithFrame:self.view.frame];
    LogoImgV.userInteractionEnabled = YES;
    [LogoImgV setImage:[UIImage imageNamed:@"download"]];
    [self.view addSubview:LogoImgV];
    
//    [(NavCheckViewController *)self.parentViewController setNavgationHiddens:(NavCheckViewController *)self.navigationController];

    _sec = 59;
    
    dataArray = [[NSMutableArray alloc] init];
    
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"phone2",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入手机号",@"Placeholder",
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
    [dataArray addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"yzm",@"imageUrl",
                          @"",@"txtContent",
                          @"请输入验证码",@"Placeholder",
                          [NSNumber numberWithInt:1],@"kind",
                          nil]];
    
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStyleGrouped];
    
//    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
//    _Maintableview.scrollEnabled = NO;
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
//        verBtn.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
//        [verBtn setBackgroundColor:NavColor];
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
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    
    promotLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.width - 20, 15)];
    [promotLab setFont:[UIFont systemFontOfSize:13.0]];
    [promotLab setTextColor:[UIColor whiteColor]];
    [headerV addSubview:promotLab];
    
    
    UIButton *xybtn = [[UIButton alloc] init];
    
    xybtn.frame = CGRectMake(40, 0, self.view.width/2, 30);
    xybtn.tag = 99;
    [xybtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [xybtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    xybtn.titleLabel.font = [UIFont systemFontOfSize:16];
    xybtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我已同意《爱鱼宝》协议"];
    NSRange strRange = {8,[str length]-8};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [xybtn setAttributedTitle:str forState:UIControlStateNormal];
    [xybtn addTarget:self action:@selector(RegistWord) forControlEvents:UIControlEventTouchUpInside];
    [headerV addSubview:xybtn];
    
    
    UIButton *remenberBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 140, 80, 280, 35)];
    remenberBtn.tag = 100;
    remenberBtn.backgroundColor = NavColor;
    remenberBtn.layer.cornerRadius = 4.0;
    [remenberBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    remenberBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [remenberBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [headerV addSubview:remenberBtn];
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 140, remenberBtn.bottom + 90, 280, 35)];
    loginBtn.tag = 101;
    [loginBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont fontWithName:FONTNAME size:17.0];
    [loginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"已有账号?直接登录" forState:UIControlStateNormal];
    [headerV addSubview:loginBtn];
    
    return headerV;
}
- (void)RegistWord
{
    WebInfoViewController *webInfoVc = [WebInfoViewController new];
    webInfoVc.isXY = YES;
    webInfoVc.infoUrl = @"http://szx.yshdszx.com/admin.php/publics/infopage";
    [self.navigationController pushViewController:webInfoVc animated:YES];
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
    if (btn.tag == 101) {
        [self.navigationController pushViewController:[HdLoginViewController new] animated:YES];
        return;
    }
    if (btn.tag == 99) {
//        [self presentViewController:[[NavCheckViewController alloc] initWithRootViewController:[UpdateRedListViewController new]] animated:YES completion:^{}];
//        return;
    }
    
    NSDictionary *registerdic = nil;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    registerdic = @{@"account":[dataArray[0] objectForKey:@"txtContent"],
                    @"password":[dataArray[2] objectForKey:@"txtContent"],
                    @"verf":[dataArray[3] objectForKey:@"txtContent"],
                    };
    
    if ([CheckData checkNowStatus:registerdic]) {
        
        [self.view showProgress:YES text:@"正在注册.."];
        [AppRequest Request_Normalpost:@"reg" json:registerdic controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                [AppRequest Request_Normalpost:@"login" json:@{@"account":registerdic[@"account"],@"password":registerdic[@"password"],@"jpush_id":@""} controller:self completion:^(id result, NSInteger statues) {
                    if (statues == 1) {
                        [NSUserDefaults setString:@"YES" forKey:BYBOSS];
                        [NSUserDefaults setUserObject:@{@"account":registerdic[@"account"],@"password":registerdic[@"password"]} forKey:LOGININFO];
                        [NSUserDefaults setString:result[@"retRes"][@"login_verf"] forKey:LOGINVERF];
                        
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
                    [self.view showResult:result[@"retErr"]];
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
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview.superview;
    NSIndexPath *indexPath = [_Maintableview indexPathForCell:cell];
    if (indexPath.row == 2) {
        codeCell = cell;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadScanView];
                });
            } else {
                [self.view showResult:@"无权限访问相机,请到设置中更改权限"];
            }
        }];
        return;
    }
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

- (void)loadScanView {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:layer];
    //开始捕获
    [self.session startRunning];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        AVCaptureVideoPreviewLayer *avPlayer = (AVCaptureVideoPreviewLayer *)self.view.layer.sublayers[2];
        [avPlayer removeFromSuperlayer];
        NSLog(@"%@",metadataObject.stringValue);
        [(UITextField *)[codeCell viewWithTag:101] setText:metadataObject.stringValue];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
