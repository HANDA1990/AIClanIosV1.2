//
//  NewEquipByHandViewController.m
//  AIClan
//
//  Created by hd on 2018/11/29.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "NewEquipByHandViewController.h"
#import "XYMScanView.h"
#import <AVFoundation/AVFoundation.h>
@interface NewEquipByHandViewController ()<XYMScanViewDelegate>
{
    UITextField *inputId;
    XYMScanView *scanV;
}
@end

@implementation NewEquipByHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手动添加设备";
    float hb = Height_NavBar;
    inputId = [[UITextField alloc] initWithFrame:CGRectMake(10,  hb + 10, self.view.width - 120, 30)];
    inputId.layer.cornerRadius = 4.0;
    inputId.backgroundColor = [UIColor whiteColor];
    inputId.placeholder = @" 请输入设备ID或扫描包装二维码";
    [self.view addSubview:inputId];

    UIButton *saoBn = [[UIButton alloc] initWithFrame:CGRectMake(inputId.right + 10, hb+10, 30, 30)];
    [saoBn setBackgroundImage:[UIImage imageNamed:@"sm"] forState:UIControlStateNormal];
    [saoBn addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saoBn];

    UIButton *addBn = [[UIButton alloc] initWithFrame:CGRectMake(saoBn.right + 10, hb+10, 50, 30)];
    addBn.backgroundColor = NavColor;
    [addBn setTitle:@"添加" forState:UIControlStateNormal];
    [addBn addTarget:self action:@selector(createSao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBn];

}

-(void)startScan{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!scanV) {
                    scanV = [[XYMScanView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
                    scanV.delegate = self;
                    [self.view addSubview:scanV];
                }
                else
                {
                    [scanV startRunning];
                }
                scanV.hidden = NO;
            });
        } else {
            //            [self.view showResult:@"无权限访问相机,请到设置中更改权限"];
        }
    }];
    
    //    XYMScanViewController *scanView = [XYMScanViewController new];
    //
    //    [self.navigationController pushViewController:scanView animated:YES];
}
-(void)getScanDataString:(NSString*)scanDataString{
    inputId.text = scanDataString;
    [scanV stopRunning];
    scanV.hidden = YES;

}

- (void)createSao{
    if (!inputId.text.length) {
        [self.view showResult:@"请先填写设备id"];
        return;
    }
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"bdsb" json:@{@"acccardtype_id":_acccardtype_id ? _acccardtype_id : @"",@"card_id":inputId.text ? inputId.text : @""} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
        [SVProgressHUD dismiss];

    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];

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
