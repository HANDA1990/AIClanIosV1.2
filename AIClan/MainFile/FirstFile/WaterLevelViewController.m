//
//  WaterLevelViewController.m
//  AIClan
//
//  Created by hd on 2018/11/3.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "WaterLevelViewController.h"

@interface WaterLevelViewController ()
{
    UISwitch* openbutton;
    UILabel *titleLab3;
}
@end

@implementation WaterLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ReloadView];
    [self reloadData];
}
- (void)ReloadView{
    float hb = Height_NavBar;
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0,hb+ 5, self.view.width, 100)];
    [self.view addSubview:bgV];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width / 2, 50)];
    titleLab.text = @"报警设置";
    [bgV setShadowLayer:bgV];
    [bgV addSubview:titleLab];
    
    titleLab3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width -80, 0, 70, 50)];
    titleLab3.text = @"未设置";
    titleLab3.textColor = NavColor;
    [bgV addSubview:titleLab3];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 50.5, self.view.width - 20, 0.5)];
    lineV.backgroundColor = [UIColor grayColor];
    [bgV addSubview:lineV];
    
    UIImageView *icornImgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, lineV.bottom +  13, 25, 25)];
    [icornImgV setImage:[UIImage imageNamed:@"openclose"]];
    [bgV addSubview:icornImgV];
    
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(icornImgV.right + 10, lineV.bottom, self.view.width / 2, 50)];
    titleLab2.text = @"报警开关";
    [bgV addSubview:titleLab2];
    
    openbutton = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 70, lineV.bottom + 10, 60, 30)];
    openbutton.onTintColor = NavColor;

    // 添加事件
    [openbutton addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    // 开关事件切换通知
    [bgV addSubview:openbutton];
    
    UIButton *deletBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bgV.bottom + 10, self.view.width, 50)];
    deletBtn.backgroundColor = [UIColor whiteColor];
    [deletBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    [deletBtn setTitle:@"删除设备" forState:UIControlStateNormal];
    [deletBtn setTitleColor:XXColor(255, 84, 141, 1) forState:UIControlStateNormal];
    [self.view addSubview:deletBtn];

}
- (void)reloadData{
    NSArray *stateArr = @[@"未设置",@"正在设置",@"设置成功",@"设置失败"];
    [AppRequest Request_Normalpost:@"kginfo" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            titleLab3.text = stateArr[[[result[@"retRes"] objectForKey:@"sz_status"] intValue]];
            if ([[result[@"retRes"] objectForKey:@"v_1"] intValue] == 0) {
                openbutton.on = NO;
            }
            else
            {
                openbutton.on = YES;
            }
        }
    } failed:^(NSError *error) {
        
    }];
}
-(void)switchChange:(id)sender
{
    UISwitch* openbutton = (UISwitch*)sender;
    Boolean ison = openbutton.isOn;
    NSString *v_1;
    if(ison){
        v_1 = @"1";
        
    }else{
        v_1 = @"0";

    }
    [SVProgressHUD show];

    [AppRequest Request_Normalpost:@"szbjkg" json:@{@"id":self.equipId,@"v_1":v_1} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 0) {
            openbutton.on = false;
        }
        [self.view showResult:result[@"retErr"]];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

- (void)clickDelete
{
    [self creatAlertController_alert];
   
}

//创建一个alertview
-(void)creatAlertController_alert {
    //跟上面的流程差不多，记得要把preferredStyle换成UIAlertControllerStyleAlert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认是否删除设备" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        
        [AppRequest Request_Normalpost:@"scsb" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
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
