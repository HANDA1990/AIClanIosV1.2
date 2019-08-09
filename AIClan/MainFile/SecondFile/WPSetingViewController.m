//
//  WPSetingViewController.m
//  AIClan
//
//  Created by hd on 2018/11/29.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "WPSetingViewController.h"
#import "CircularSliderViewController.h"

@interface WPSetingViewController ()<UIActionSheetDelegate>
{
    UISwitch *switchB;
}
@end

@implementation WPSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self addRightButton:@"提交" imageName:@"" action:^(int status, NSString *searchKey) {
//
//    }];
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, self.view.width, 40)];
    bgV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgV];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 10, 40)];
    [title setText:@"开关设置"];
    title.font = [UIFont systemFontOfSize:20];
    [bgV addSubview:title];
    
    
    UILabel *titleno = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100, 0,80, 40)];
    titleno.tag = 1000;
    titleno.textAlignment = NSTextAlignmentRight;
    [titleno setText:@"未设置"];
    titleno.textColor = NavColor;
    [bgV addSubview:titleno];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [bgV addSubview:lineV];
    lineV.backgroundColor = [UIColor blackColor];
    [self addSwitch:bgV];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadsbkgjinfo];
}

- (NSString *)setStateStr:(int)resInt
{
    NSString *restr = @"";
    if (resInt == 0) {
        restr = @"未设置";
    }
    else if (resInt == 1){
        restr = @"正在设置";

    }
    else if (resInt == 2){
        restr = @"设置成功";

    }
    else if (resInt == 3){
        restr = @"设置失败";

    }
    return restr;
}

- (void)reloadsbkgjinfo{
    [AppRequest Request_Normalpost:@"sbkgjinfo" json:@{@"id":_equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary *res = result[@"retRes"];
            int resInt = [res[@"sz_status"]intValue];
            int v_1Int = [res[@"v_1"]intValue];

            [(UILabel *)[self.view viewWithTag:1000] setText:[self setStateStr:resInt]];
            switchB.on = v_1Int == 1 ? YES : NO;
        }
    } failed:^(NSError *error) {
        
    }];
    
    [AppRequest Request_Normalpost:@"sbzlinfo" json:@{@"id":_equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary *res = result[@"retRes"];
            int resInt = [res[@"sz_status"]intValue];
            [(UILabel *)[self.view viewWithTag:1001] setText:[self setStateStr:resInt]];
            [(UILabel *)[self.view viewWithTag:10001] setText:[NSString stringWithFormat:@"%@",res[@"v_1"]]];
        }
    } failed:^(NSError *error) {
        
    }];
    
    [AppRequest Request_Normalpost:@"sbyxinfo" json:@{@"id":_equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary *res = result[@"retRes"];
            int resInt = [res[@"sz_status"]intValue];
            [(UILabel *)[self.view viewWithTag:1002] setText:[self setStateStr:resInt]];
            [(UILabel *)[self.view viewWithTag:10002] setText:[NSString stringWithFormat:@"%@",res[@"v_1"]]];
        }
    } failed:^(NSError *error) {
        
    }];
    
    [AppRequest Request_Normalpost:@"sbtsinfo" json:@{@"id":_equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary *res = result[@"retRes"];
            int resInt = [res[@"sz_status"]intValue];

            [(UILabel *)[self.view viewWithTag:1003] setText:[self setStateStr:resInt]];
            [(UILabel *)[self.view viewWithTag:10003] setText:[NSString stringWithFormat:@"%@",res[@"v_1"]]];
            [(UILabel *)[self.view viewWithTag:10005] setText:[NSString stringWithFormat:@"%@",res[@"v_2"]]];

        }
    } failed:^(NSError *error) {
        
    }];
    
    [AppRequest Request_Normalpost:@"sbyxmsinfo" json:@{@"id":_equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary *res = result[@"retRes"];
            int resInt = [res[@"sz_status"]intValue];
            [(UILabel *)[self.view viewWithTag:10004] setText:[self workModle:res[@"v_1"]]];
            [(UILabel *)[self.view viewWithTag:1004] setText:[self setStateStr:resInt]];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (NSString *)workModle:(NSString *)v_1{
    NSString *v1str;
    switch ([v_1 intValue]) {
        case 0:
            v1str = @"投食模式";
        case 1:
            v1str = @"运行模式";
        case 2:
            v1str = @"造浪模式";
            break;
            
        default:
            break;
    }
    return  v1str;
}
- (void)addSwitch:(UIView *)bgV{
    UIView *bgV2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgV.bottom, self.view.width, 40)];
    bgV2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgV2];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
    [imgV setImage:[UIImage imageNamed:@"wpkg"]];
    [bgV2 addSubview:imgV];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right + 10, 0, self.view.width - 10, 40)];
    [title2 setText:@"设备开关"];
    [bgV2 addSubview:title2];

    switchB = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.width - 60, 5, 60, 30)];
    [bgV2 addSubview:switchB];
    [switchB addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    
    UIView *centerV = [[UIView alloc] initWithFrame:CGRectMake(0, bgV2.bottom + 10, self.view.width, self.view.height - bgV2.bottom - 10)];
    [self.view addSubview:centerV];
    centerV.backgroundColor = [UIColor whiteColor];

    [self addCenterV:centerV];
}
- (void)valueChanged:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *v_1s;
    if (isButtonOn) {
        v_1s = @"1";
    }else {
        v_1s = @"0";
    }
    
    [AppRequest Request_Normalpost:@"sbkgj" json:@{@"id":_equipId,@"v_1":v_1s} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            switchButton.on = isButtonOn;
        }
        else
        {
            switchButton.on = !isButtonOn;
        }
    } failed:^(NSError *error) {
        switchButton.on = !isButtonOn;

    }];
}

- (void)addCenterV:(UIView *)centerV {
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [centerV addSubview:bgV];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 10, 40)];
    [title setText:@"运行设置"];
    title.font = [UIFont systemFontOfSize:20];
    [bgV addSubview:title];
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [bgV addSubview:lineV2];
    lineV2.backgroundColor = [UIColor blackColor];
    
    UIView *rtV = [self addCenterV2:centerV upV:bgV setName:@"造浪模式"];
    rtV = [self addCenterV2:centerV upV:rtV setName:@"运行模式"];
    rtV = [self addCenterV:centerV upV:rtV];
    rtV = [self addCenterV2:centerV upV:rtV setName:@"当前模式"];
    [self bottmViewAdd:centerV topV:rtV];

}

- (UIView *)addCenterV2:(UIView *)centerV upV:(UIView *)upV setName:(NSString *)setName{
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, upV.bottom, self.view.width, 40)];
    [centerV addSubview:bgV];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
  
   
    [bgV addSubview:imgV];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right + 10, 0, self.view.width - 10, 40)];
    [title2 setText:setName];
    [bgV addSubview:title2];

    UILabel *titleno = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100, 0,80, 40)];
    [titleno setText:@"未设置"];
    titleno.textAlignment = NSTextAlignmentRight;
    titleno.textColor = NavColor;
    [bgV addSubview:titleno];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [bgV addSubview:lineV];
    lineV.backgroundColor = [UIColor blackColor];

    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bgV.bottom, self.view.width, 40)];
    [centerV addSubview:selectBtn];

    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView *arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 32, 6.5, 27, 27)];
    [arrowImgV setImage:[UIImage imageNamed:@"morese"]];
    [selectBtn addSubview:arrowImgV];
    
    UILabel *titleno2 = [[UILabel alloc] initWithFrame:CGRectMake(arrowImgV.x - 100, 0,100, 40)];
    [titleno2 setText:@""];
    
    titleno2.textAlignment = NSTextAlignmentRight;
    titleno2.textColor = [UIColor darkGrayColor];
    [selectBtn addSubview:titleno2];
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [selectBtn addSubview:lineV2];
    lineV2.backgroundColor = [UIColor blackColor];

    
    if ([setName isEqualToString: @"造浪模式"]) {
        [imgV setImage:[UIImage imageNamed:@"yangyu"]];
        selectBtn.tag = 1;
        titleno.tag = 1001;
        titleno2.tag = 10001;
    }
    else if (([setName isEqualToString: @"运行模式"])){
        [imgV setImage:[UIImage imageNamed:@"wpgl"]];
        selectBtn.tag =2;
        titleno.tag = 1002;
        titleno2.tag = 10002;

    }
    else if (([setName isEqualToString: @"当前模式"])){
        [imgV setImage:[UIImage imageNamed:@"wpgl"]];
        selectBtn.tag =3;
        titleno.tag = 1004;
        titleno2.tag = 10004;

    }
    
    return selectBtn;
}
- (UIView *)addCenterV:(UIView *)centerV upV:(UIView *)upV{
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, upV.bottom, self.view.width, 40)];
    [centerV addSubview:bgV];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
    [imgV setImage:[UIImage imageNamed:@"wpyx"]];
    [bgV addSubview:imgV];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right + 10, 0, self.view.width - 10, 40)];
    [title2 setText:@"投食模式"];
    [bgV addSubview:title2];
    
    UILabel *titleno = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100, 0,80, 40)];
    [titleno setText:@"未设置"];
    titleno.tag = 1003;
    titleno.textAlignment = NSTextAlignmentRight;
    titleno.textColor = NavColor;
    [bgV addSubview:titleno];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [bgV addSubview:lineV];
    lineV.backgroundColor = [UIColor blackColor];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bgV.bottom, self.view.width, 40)];
    [centerV addSubview:selectBtn];
    selectBtn.tag = 4;
    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right + 10, 0, 40, 40)];
    lab1.text = @"高位";
    [selectBtn addSubview:lab1];
    
    UIImageView *arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 32, 6.5, 27, 27)];
    [arrowImgV setImage:[UIImage imageNamed:@"morese"]];
    [selectBtn addSubview:arrowImgV];
    
    UILabel *titleno2 = [[UILabel alloc] initWithFrame:CGRectMake(arrowImgV.x - 60, 0,60, 40)];
    [titleno2 setText:@"2"];
    titleno2.textAlignment = NSTextAlignmentRight;
    titleno2.tag = 10003;
    titleno2.textColor = [UIColor darkGrayColor];
    [selectBtn addSubview:titleno2];
    
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [selectBtn addSubview:lineV2];
    lineV2.backgroundColor = [UIColor blackColor];
    
    
    UIButton *selectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, selectBtn.bottom, self.view.width, 40)];
    [centerV addSubview:selectBtn2];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right + 10, 0, 40, 40)];
    lab2.text = @"低位";
    [selectBtn2 addSubview:lab2];
    selectBtn2.tag = 5;
    [selectBtn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *arrowImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 32, 6.5, 27, 27)];
    [arrowImgV2 setImage:[UIImage imageNamed:@"morese"]];
    [selectBtn2 addSubview:arrowImgV2];
    
    UILabel *titlen3 = [[UILabel alloc] initWithFrame:CGRectMake(arrowImgV.x - 60, 0,60, 40)];
    [titlen3 setText:@""];
    titlen3.tag = 10005;
    titlen3.textAlignment = NSTextAlignmentRight;
    titlen3.textColor = [UIColor darkGrayColor];
    [selectBtn2 addSubview:titlen3];
    
    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.width, 0.5)];
    [selectBtn2 addSubview:lineV3];
    lineV3.backgroundColor = [UIColor blackColor];
    
    return selectBtn2;
}
- (void)bottmViewAdd:(UIView *)centerV topV:(UIView *)topV{
    
    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0, topV.bottom + 10, self.view.width, 20)];
    [centerV addSubview:lineV3];
    lineV3.backgroundColor = self.view.backgroundColor;
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineV3.bottom, self.view.width, 40)];
    [deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [deleteBtn setTitle:@"删除设备" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickDelet) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:deleteBtn];
    
    UIView *lineV4 = [[UIView alloc] initWithFrame:CGRectMake(0, deleteBtn.bottom, self.view.width, centerV.height - deleteBtn.bottom)];
    [centerV addSubview:lineV4];
    lineV4.backgroundColor = self.view.backgroundColor;
}
- (void)clickDelet{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"scsb" json:@{@"id":_equipId} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)selectBtn:(UIButton *)btn{
    
    CircularSliderViewController *circularVc = [CircularSliderViewController new];
    circularVc.dangweiid = _equipId;
    
    NSString *v_x;
    for (UIView *infoLab in btn.subviews) {
        if ([infoLab isKindOfClass:[UILabel class]]) {
            if (infoLab.tag == 10004) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"模式选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"投食模式", @"运行模式", @"造浪模式", nil];
                actionSheet.delegate = self;
                [actionSheet showInView:self.view];
                return;
            }
            if (infoLab.tag == 10001 || infoLab.tag == 10002 || infoLab.tag == 10003 ||infoLab.tag == 10005) {
                v_x = [(UILabel *)infoLab text];
                circularVc.sendtag = infoLab.tag;
                circularVc.v_x = v_x;
                break;
            }
           
        }
    }
    circularVc.dangweiid = _equipId;
    circularVc.v_x = v_x;
    [self.navigationController pushViewController:circularVc animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self ModelChangeReQuest:[NSString stringWithFormat:@"%d",buttonIndex]];
}

- (void)ModelChangeReQuest:(NSString *)v_1str{
    [SVProgressHUD showWithStatus:@"更换模式"];
    [AppRequest Request_Normalpost:@"sbyxms" json:@{@"id":self.equipId,@"v_1":v_1str} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD showSuccessWithStatus:result[@"retErr"]];
        if (statues == 1) {
            [(UILabel *)[self.view viewWithTag:10004] setText:[self workModle:v_1str]];

        }
    } failed:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@""];

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
