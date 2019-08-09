//
//  CapacityMainViewController.m
//  AIClan
//
//  Created by hd on 2018/10/15.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "CapacityMainViewController.h"
#import "XZMPieView.h"
#import "HistoryOperateViewController.h"

@interface CapacityMainViewController ()
{
    NSDictionary *pieCharDic;
}
@end

@implementation CapacityMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"zntj" json:@{} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            pieCharDic = result[@"retRes"];
            [self topView];
            [self centerView];
            [self bottomView];
        }
        [SVProgressHUD dismiss];
        
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
- (void)topView{
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(10, Height_NavBar+10, self.view.width - 20, 100)];
    topV.layer.cornerRadius = 4;
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    
    for (int i = 0; i < 3; i ++) {
        UIView *UnitV = [[UIView alloc] initWithFrame:CGRectMake(topV.width / 3 * i, 0, topV.width / 3, 100)];
        [topV addSubview:UnitV];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, UnitV.width, 60)];
        numberLab.textAlignment = NSTextAlignmentCenter;
        numberLab.textColor = MainColor(1);
        numberLab.font = [UIFont fontWithName:FONTNAME size:60];
        [UnitV addSubview:numberLab];
        
        UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(10, numberLab.bottom + 3, 15, 15)];
        colorV.layer.cornerRadius = 4.0;
        [colorV setBackgroundColor:MainColor(1)];
        [UnitV addSubview:colorV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(colorV.right + 5, numberLab.bottom, UnitV.width - colorV.right, 25)];
        infoLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        infoLab.textColor = XXColor(180, 180, 180, 1);
        [UnitV addSubview:infoLab];
        
        if (i == 0) {
            infoLab.text = @"已添加鱼缸";
            numberLab.text = [NSString stringWithFormat:@"%@",pieCharDic[@"ygsl"]];

        }
        else if (i == 1){
            numberLab.textColor = XXColor(31, 130, 254, 1);
            colorV.backgroundColor = XXColor(31, 130, 254, 1);
            infoLab.text = @"已添加设备";
            numberLab.text = [NSString stringWithFormat:@"%@",pieCharDic[@"sbsl"]];

        }
        else if (i == 2){
            numberLab.text = [NSString stringWithFormat:@"%@",pieCharDic[@"ycsb"]];
            numberLab.textColor = XXColor(252, 54, 47, 1);
            colorV.backgroundColor = XXColor(252, 54, 47, 1);
            infoLab.text = @"异常设备";

        }
    }
}
- (void)centerView{
    float hb = Height_NavBar;
    UIView *V = [[UIView alloc] initWithFrame:CGRectMake(10, hb+120, self.view.width - 20, 200)];
    V.backgroundColor = [UIColor whiteColor];
    V.layer.cornerRadius = 4.0;
    [self.view addSubview:V];
    
    UILabel *equipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    equipLab.text = @"设备分布";
    [V addSubview:equipLab];
    


    NSArray *colorArray = @[XXColor(214, 71, 158, 1), XXColor(51, 161, 234, 1), XXColor(89, 211, 210, 1),XXColor(254, 213, 75, 1),XXColor(253, 140, 108, 1)];
    NSArray *titleArr = @[[NSString stringWithFormat:@"水质监测/%@",pieCharDic[@"sbfb"][0][@"nums"]],
                          [NSString stringWithFormat:@"智能水泵/%@",pieCharDic[@"sbfb"][1][@"nums"]],
                          [NSString stringWithFormat:@"水位报警器/%@",pieCharDic[@"sbfb"][2][@"nums"]],
                          [NSString stringWithFormat:@"断电报警器/%@",pieCharDic[@"sbfb"][3][@"nums"]],
                          [NSString stringWithFormat:@"换水机器人/%@",pieCharDic[@"sbfb"][4][@"nums"]]];
    
    XZMPieView *pieChartV = [[XZMPieView alloc]initWithFrame:CGRectMake(15, equipLab.bottom + 15, 150, 150)];
    [V addSubview:pieChartV];
//    pieChartV.sectorSpace = (arc4random() % 5)/10.0;
    [pieChartV setDatas:[self getDatas] colors:colorArray];
    [pieChartV stroke];
    
    for (int k = 0; k < colorArray.count; k ++) {
        UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(pieChartV.right + 15, equipLab.bottom + 20 + 25 * k, 15, 15)];
        colorV.layer.cornerRadius = 4.0;
        
        [colorV setBackgroundColor:colorArray[k]];
        [V addSubview:colorV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(colorV.right + 3, colorV.y - 9, 140, 36)];
        infoLab.text = titleArr[k];
        infoLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        infoLab.textColor = XXColor(160, 160, 160, 1);
        [V addSubview:infoLab];
        
        NSRange range = [infoLab.text rangeOfString:@"/"];
         NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:infoLab.text];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:MainColor(1)
         
                              range:NSMakeRange(range.location, infoLab.text.length - range.location)];
        
        infoLab.attributedText = AttributedStr;
    }
}

- (void)bottomView{
    float hb = Height_NavBar;
    float sb = Height_StatusBar;
    float tb = Height_TabBar;
    UIButton *topV = [[UIButton alloc] initWithFrame:CGRectMake(10, hb+330, (self.view.width - 30) / 2, self.view.height - 320 - hb -sb-tb)];
    topV.layer.cornerRadius = 4;
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    topV.tag = 1001;
    [topV addTarget:self action:@selector(clcickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self bottomDetailV:topV tag:0];
    
    UIButton *rightV = [[UIButton alloc] initWithFrame:CGRectMake(topV.right + 10, hb+330, (self.view.width - 30) / 2,  self.view.height - 320 - hb -sb-tb)];
    rightV.tag = 1002;
    [rightV addTarget:self action:@selector(clcickBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightV.layer.cornerRadius = 4;
    rightV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightV];
    
    [self bottomDetailV:topV tag:0];

    [self bottomDetailV:rightV tag:1];

}
- (void)bottomDetailV:(UIView *)btv tag:(int)tag{
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, btv.width, 50)];
    lab1.text = tag == 0 ? @"历史操作" : @"历史报警";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont fontWithName:FONTNAME size:15.0];
    lab1.textColor = [UIColor darkGrayColor];
    [btv addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, lab1.bottom, btv.width, btv.height / 3)];
    lab2.text = tag == 0 ? [NSString stringWithFormat:@"%@", pieCharDic[@"czsl"]] : [NSString stringWithFormat:@"%@", pieCharDic[@"bjsl"]];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont fontWithName:FONTNAME size:50.0];
    lab2.textColor = tag == 0 ? NavColor : XXColor(252, 54, 47, 1);
    [btv addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, lab2.bottom, btv.width, 30)];
    lab3.text = @">>查看日志";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = [UIFont fontWithName:FONTNAME size:13.0];
    lab3.textColor = [UIColor darkGrayColor];
    [btv addSubview:lab3];
    
}

- (void)clcickBtn:(UIButton *)btn
{
    HistoryOperateViewController *hisVc = [HistoryOperateViewController new];
    hisVc.hisStr = btn.tag == 1001 ? @"2" : @"1";
    hisVc.title = btn.tag == 1001 ? @"历史操作" : @"历史报警";
    [self.navigationController pushViewController:hisVc animated:YES];
}
- (NSArray *)getDatas{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *pirA = pieCharDic[@"sbfb"];
    CGFloat Add = 0.0f;
    for (int i = 0; i < pirA.count ; i++) {
        CGFloat num = [pirA[i][@"nums"] floatValue];
        Add += num;
    }
    
    for (int i = 0; i < 5 ; i++) {
        CGFloat num = (float)[pirA[i][@"nums"] floatValue]/ Add * 100;
        [arr addObject:[NSNumber numberWithFloat:num]];
    }
    return arr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
