//
//  NewEquipmentViewController.m
//  AIClan
//
//  Created by hd on 2018/11/1.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "NewEquipmentViewController.h"
#import "ConnectSocket.h"
#import "NewEquipByHandViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface NewEquipmentViewController ()<ConnectSocketdelegate>
{
    UIButton *imageV;
    ConnectSocket *consk;
    UILabel *imageLab;
    NSString *ssid;
}
@end

@implementation NewEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加新设备";
    [AppRequest Request_Normalpost:@"keys" json:@{} controller:self completion:^(id result, NSInteger statues) {
       
        if (statues == 1) {
            [self addRightButton:@"" imageName:@"wifipath" action:^(int status, NSString *searchKey) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result[@"retRes"][0]]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result[@"retRes"][0]]];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result[@"retRes"][1]]];
                }
            }];
        }
    } failed:^(NSError *error) {
        
    }];
 
    
    imageV = [[UIButton alloc] initWithFrame:CGRectMake(-10, 60, self.view.frame.size.width, self.view.frame.size.height - 84)];
    [imageV setImage:[UIImage imageNamed:@"wifiProt"] forState:UIControlStateNormal];
    [imageV addTarget:self action:@selector(ClickConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageV];
    imageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imageV.bottom - 200, self.view.width, 20)];
    imageLab.textColor = [UIColor grayColor];
    [imageLab setTextAlignment:NSTextAlignmentCenter];
    [imageLab setText:@"点击图标输入Wi-Fi账号及密码"];
    [self.view addSubview:imageLab];
    
    consk = [ConnectSocket new];
    consk.delegate = self;
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 40, self.view.width, 40)];
    [bottomBtn setBackgroundColor:NavColor];
    [bottomBtn setTitle:@"手动添加" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(AddByhandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    [self wifiSSID];
}

- (NSString *)wifiSSID {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }    return ssid;
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)ClickConnect{
    [self creatAlertController_alert];

}

- (void)AddByhandle{
    //_acccardtype_id
    NewEquipByHandViewController *newEquiVc = [NewEquipByHandViewController new];
    newEquiVc.acccardtype_id = _acccardtype_id;
    [self.navigationController pushViewController:newEquiVc animated:YES];
}
//创建一个alertview
-(void)creatAlertController_alert {
    //跟上面的流程差不多，记得要把preferredStyle换成UIAlertControllerStyleAlert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"wifi信息" message:@"请填写使用的wifi名称及密码" preferredStyle:UIAlertControllerStyleAlert];
    
    //可以给alertview中添加一个输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Wifi名称";
        [textField resignFirstResponder];
        textField.text = ssid;
    }];
    //可以给alertview中添加一个输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Wifi密码";
        [textField canResignFirstResponder];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSString *accout = alert.textFields.firstObject.text;
        NSString *pasword = alert.textFields.lastObject.text;
        NSLog(@"%@",alert.textFields.firstObject.text);

        NSLog(@"%@",alert.textFields.lastObject.text);
        if (accout.length == 0 || pasword.length == 0)
        {
            [self.view showResult:@"请填写账号密码"];
            return ;
        }
        else{
            [consk initConnectSoket:@"192.168.4.1" portstr:@"8899" account:accout password:pasword];

        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReturnConnectInfo:(NSString *)info
{
    NSLog(@"%@",info);
    if (info.length == 1) {
        if ([info intValue] == 0) {
            [self.view showResultLong:@"请先连接设备热点，才能连接成功"];
        }
    }
    else {
        [consk closeEquipRd:@"11"];
        [SVProgressHUD show];

        [self RequestAddData:info];
    }
}

- (void)RequestAddData:(NSString *)info{
    NSString *lexinsStr = [info substringToIndex:3];
    NSString *equipId = [info substringWithRange:NSMakeRange(4, info.length-4)];
    NSString *sendStr = [lexinsStr stringByAppendingString:equipId];
    [AppRequest Request_Normalpost:@"bdsb" json:@{@"acccardtype_id":_acccardtype_id ? _acccardtype_id : @"0",@"card_id":sendStr} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [SVProgressHUD dismiss];
            [imageV setHidden:YES];
            [imageLab setHighlighted:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(didRereshNewEquipment)]) {
                    [self.delegate didRereshNewEquipment];
                }
            }];
        }
        [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];

        
    } failed:^(NSError *error) {
        [self RequestAddData:info];

        //[SVProgressHUD dismiss];
        
    }];
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
