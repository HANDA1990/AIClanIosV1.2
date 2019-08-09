//
//  ModifyMyViewController.m
//  AIClan
//
//  Created by hd on 2018/11/7.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ModifyMyViewController.h"
#import "BaseNavViewController.h"
#import "SelectPhotoManager.h"
#import "AppDelegate.h"
#import "HdLoginViewController.h"

@interface ModifyMyViewController ()
{
    UISwitch* openbutton;
    UIButton *imgV;
    UITextField *nameLab;
    NSString *v_1;
    NSData *Imgdata;
    UIImage *defalutImg;
    
    NSString *fileStr;
}
@property (nonatomic, strong)SelectPhotoManager *photoManager;

@end

@implementation ModifyMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [(BaseNavViewController *)self.navigationController setNavgationshow:self.navigationController];
    UIView *navColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    [navColor setBackgroundColor:NavColor];
    [self.view addSubview:navColor];
    
    self.title = @"修改信息";
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, navColor.bottom + 10, self.view.width, 100)];
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    
    imgV = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    imgV.layer.masksToBounds = YES;
    imgV.layer.cornerRadius = imgV.width / 2;
    [imgV addTarget:self action:@selector(clickImgChange) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:imgV];
    
    nameLab = [[UITextField alloc] initWithFrame:CGRectMake(imgV.right +20, imgV.center.y, self.view.width - imgV.right - 40, 30)];
    nameLab.text = @"你的名称";
    [topV addSubview:nameLab];
    
    UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(imgV.right +20, nameLab.bottom, self.view.width - imgV.right - 40, 1)];
    linev.backgroundColor = [UIColor darkGrayColor];
    [topV addSubview:linev];
    
    UIView *pushV = [[UIView alloc] initWithFrame:CGRectMake(0, topV.bottom + 10, self.view.width, 40)];
    pushV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pushV];
    
    UILabel *pushLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pushV.width - 60, 40)];
    [pushLab setText:@"是否接收推送"];
    [pushV addSubview:pushLab];
    
    
    openbutton = [[UISwitch alloc]initWithFrame:CGRectMake(pushV.width - 70, 4, 60, 30)];
    openbutton.onTintColor = NavColor;
    
    // 添加事件
    [openbutton addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    // 开关事件切换通知
    [pushV addSubview:openbutton];
    
  

    UIView *firstV = [[UIView alloc] initWithFrame:CGRectMake(0, pushV.bottom + 1 , self.view.width, 40)];
    firstV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstV];

    
    UILabel *currentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2, 40)];
    currentV.backgroundColor = [UIColor clearColor];
    currentV.text = @"  当前版本";
    [firstV addSubview:currentV];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    
    UILabel *currentV2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 115, 0, 90, 40)];
    currentV2.backgroundColor = [UIColor clearColor];
    currentV2.textColor = [UIColor lightGrayColor];
    currentV2.text = [NSString stringWithFormat:@"V%@",app_Version];
    currentV2.textAlignment = NSTextAlignmentRight;
    [firstV addSubview:currentV2];


    UIView *secondV = [[UIView alloc] initWithFrame:CGRectMake(0, firstV.bottom + 1 , self.view.width, 40)];
    secondV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondV];

    
    UILabel *hotV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    hotV.backgroundColor = [UIColor whiteColor];
    [secondV addSubview:hotV];
    hotV.text = @"  客服热线";

    UILabel *hotV2 = [[UILabel alloc] initWithFrame:CGRectMake(hotV.right - 165, 0, 140, 39.5)];
    hotV2.backgroundColor = [UIColor whiteColor];
    hotV2.textAlignment = NSTextAlignmentRight;
    hotV2.textColor = [UIColor lightGrayColor];
    [secondV addSubview:hotV2];
    hotV2.text = @"13125178963";
    
    [self addRightButton:@"保存" imageName:@"" action:^(int status, NSString *searchKey) {
        [self handleClick];
    }];
    
    UIButton *handleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [handleBtn setBackgroundColor:[UIColor whiteColor]];
    [handleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [handleBtn setTitle:@"退出登录" forState: UIControlStateNormal];
    [handleBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:handleBtn];
    [self loadDatas];
}
- (void)viewDidDisappear:(BOOL)animated
{
//    [(BaseNavViewController *)self.navigationController setNavgationHiddens:self.navigationController];

}
- (void)loadDatas{
    [AppRequest Request_Normalpost:@"userinfo" json:@{} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [imgV sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,result[@"retRes"][@"file_url"]]] forState:UIControlStateNormal placeholderImage:EMPTYIMG];
            nameLab.text = [NSString stringWithFormat:@"%@",result[@"retRes"][@"title"]];
            openbutton.on = [result[@"retRes"][@"ts_status"]intValue] == 1 ? YES : NO;
            v_1 = [NSString stringWithFormat:@"%@",result[@"retRes"][@"ts_status"]];
            fileStr = result[@"retRes"][@"file_url"];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)clickImgChange{
    if (!_photoManager) {
        _photoManager =[[SelectPhotoManager alloc]init];
    }
    [_photoManager startSelectPhotoWithImageName:@"选择头像"];
    __weak typeof(self)mySelf=self;
    //选取照片成功
    _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
        
        defalutImg = image;
        //保存到本地
        
       
        Imgdata = UIImageJPEGRepresentation(image, 0.5);
        [mySelf upfile];

    };
}

- (void)upfile{
    [SVProgressHUD show];
//    [AppRequest Request_SinglePhotoPost:@"upfile" imageDatas:Imgdata controller:self completion:^(id result, NSInteger statues) {
//        if (statues == 1) {
//            [imgV setImage:defalutImg forState:UIControlStateNormal];
//            [self.view showResult:@"上传成功"];
//
//            fileStr = result[@"retRes"][@"file_url"];
//        }
//        else{
//            [self.view showResult:result[@"retErr"]];
//        }
//        [SVProgressHUD dismiss];
//    } failed:^(NSError *error) {
//        [SVProgressHUD dismiss];
//
//    }];
    
    [AppRequest Request_SinglePhotoPost:@"upfile" imageDatas:Imgdata controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [imgV setImage:defalutImg forState:UIControlStateNormal];
            [self.view showResult:@"上传成功"];
            
            fileStr = result[@"retRes"][@"file_url"];
        }
        else{
            [self.view showResult:result[@"retErr"]];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)switchChange:(id)sender
{
    UISwitch* openbutton = (UISwitch*)sender;
    Boolean ison = openbutton.isOn;
    if(ison){
        NSLog(@"打开了");
        v_1 = @"1";
        
    }else{
        NSLog(@"关闭了");
        v_1 = @"0";
    }
}
- (void)handleClick
{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"setinfo" json:@{@"title":nameLab.text,@"file_url":fileStr ? fileStr : @"",@"ts_status":v_1} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (void)loginOut
{
    AppDelegate* appDelagete =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelagete.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[HdLoginViewController new]];
    
    [UIView animateWithDuration:0.4 animations:^{
        [NSUserDefaults setString:@"NO" forKey:BYBOSS];
        appDelagete.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.4, 1.4);
        appDelagete.window.rootViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        appDelagete.window.rootViewController.view.alpha = 1;
    }];
    appDelagete.window.rootViewController.view.transform = CGAffineTransformIdentity;
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
