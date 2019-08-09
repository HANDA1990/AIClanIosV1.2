//
//  WaterQualityViewController.m
//  AIClan
//
//  Created by hd on 2018/10/22.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "WaterQualityViewController.h"
#import "WSLineChartView.h"
#import "WaterQualitySetViewController.h"

@interface WaterQualityViewController ()
{
    UITableView *_Maintableview;
    NSArray *orderinfoArr;
}

@end

@implementation WaterQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"水质监测器";
    self.view.backgroundColor = XXColor(230, 230, 230, 1);
    [self addRightButton:@"" imageName:@"shuiset" action:^(int status, NSString *searchKey) {
        WaterQualitySetViewController *wtVc = [WaterQualitySetViewController new];
        wtVc.equipId = self.equipId;
        [self.navigationController pushViewController:wtVc animated:YES];
    }];
    [self topViewLoad];
    [self loadTableView];
    [self reloadDatas];
    
//    [self reloadTemperature];
}

- (void)reloadDatas{
    [AppRequest Request_Normalpost:@"szjcsssj" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary *rs = result[@"retRes"];
            NSString *zlStr;
            switch ([rs[@"zl"] intValue]) {
                case 0:
                    zlStr = @"无";
                    break;
                case 1:
                    zlStr = @"极优";
                    break;
                case 2:
                    zlStr = @"优良";
                    break;
                case 3:
                    zlStr = @"良";
                    break;
                case 4:
                    zlStr = @"一般";
                    break;
                case 5:
                    zlStr = @"差";
                    break;
                default:
                    break;
            }
            [(UILabel *)[self.view viewWithTag:10] setText:zlStr];
            
            [(UILabel *)[self.view viewWithTag:20] setText:[NSString stringWithFormat:@"PH质量／%@ ℃",rs[@"wd"]]];
            [(UILabel *)[self.view viewWithTag:21] setText:[NSString stringWithFormat:@"PH质量／%@",rs[@"ph"]]];
            [(UILabel *)[self.view viewWithTag:22] setText:[NSString stringWithFormat:@"TDS质量／%@",rs[@"tds"]]];
            
            [(UIImageView *)[self.view viewWithTag:40] setImage:[UIImage imageNamed:[self checkImgeResult:rs[@"wd_zl"]]]];
            [(UIImageView *)[self.view viewWithTag:41] setImage:[UIImage imageNamed:[self checkImgeResult:rs[@"ph_zl"]]]];
            [(UIImageView *)[self.view viewWithTag:42] setImage:[UIImage imageNamed:[self checkImgeResult:rs[@"tds_zl"]]]];

            [(UILabel *)[self.view viewWithTag:30] setText:[NSString stringWithFormat:@"%@",[self checkResult:rs[@"wd_zl"]]]];
            [(UILabel *)[self.view viewWithTag:31] setText:[NSString stringWithFormat:@"%@",[self checkResult:rs[@"ph_zl"]]]];
            [(UILabel *)[self.view viewWithTag:32] setText:[NSString stringWithFormat:@"%@",[self checkResult:rs[@"tds_zl"]]]];

        }
    } failed:^(NSError *error) {
        
    }];
}
- (NSString *)checkResult:(NSString *)str
{
    NSString *zlStr;
    switch ([str intValue]) {
        case 0:
            zlStr = @"正常";
            break;
        case 1:
            zlStr = @"偏低";
            break;
        case 2:
            zlStr = @"偏高";
            break;

        default:
            break;
    }
    return zlStr;
}
- (NSString *)checkImgeResult:(NSString *)str
{
    NSString *zlStr;
    switch ([str intValue]) {
        case 0:
            zlStr = @"px";
            break;
        case 1:
            zlStr = @"low";
            break;
        case 2:
            zlStr = @"high";
            break;
            
        default:
            break;
    }
    return zlStr;
}
- (void)topViewLoad{
    float topHeight = Height_NavBar;
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(10, topHeight + 10, self.view.width - 20, 115)];
    topV.layer.cornerRadius = 4;
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    [topV setShadowLayer:topV];
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 115)];
    leftV.layer.cornerRadius = 4.0;
    leftV.backgroundColor = XXColor(245, 245, 245, 0.8);
    [topV addSubview:leftV];
    
    UILabel *beizLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftV.width, leftV.height / 2)];
    beizLab.text = @"当前水质";
    beizLab.textColor = [UIColor darkGrayColor];
    beizLab.textAlignment = NSTextAlignmentCenter;
    beizLab.font = [UIFont fontWithName:FONTNAME size:15.0];
    [leftV addSubview:beizLab];
    
    UILabel *beizLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, beizLab.bottom - 10, leftV.width, leftV.height / 2)];
    beizLab2.text = @"优";
    beizLab2.tag = 10;
    beizLab2.textAlignment = NSTextAlignmentCenter;
    beizLab2.textColor = MainColor(1);
    beizLab2.font = [UIFont fontWithName:FONTNAME size:45.0];
    [leftV addSubview:beizLab2];
    
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(leftV.right, 0, topV.width - leftV.right, 115)];
    rightV.layer.cornerRadius = 4.0;
    rightV.backgroundColor = [UIColor clearColor];
    [topV addSubview:rightV];
    
    NSArray *colorArray = @[XXColor(245, 61, 69, 1), XXColor(253, 184, 63, 1), XXColor(15, 154, 254, 1)];
    
    
    for (int k = 0; k < colorArray.count; k ++) {
        UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(20, 20 + 30 * k, 7, 17)];
        colorV.layer.cornerRadius = 3.0;
        
        [colorV setBackgroundColor:colorArray[k]];
        [rightV addSubview:colorV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(colorV.right + 5, colorV.y, 140, 17)];
        infoLab.text = @"已添加鱼缸/12";
        infoLab.tag = 20 + k;
        infoLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        infoLab.textColor = XXColor(160, 160, 160, 1);
        [rightV addSubview:infoLab];
    }
    
    NSArray *imageArray = @[@"high", @"px",@"low"];

    for (int k = 0; k < colorArray.count; k ++) {
        UIImageView *colorV = [[UIImageView alloc] initWithFrame:CGRectMake(rightV.width - 70, 15 + 30 * k, 23, 23)];
        [colorV setImage:[UIImage imageNamed:imageArray[k]]];
        colorV.tag = 40 +k;
        [rightV addSubview:colorV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(colorV.right + 5, colorV.y + 5, 140, 17)];
        infoLab.tag = 30 + k;
        infoLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        infoLab.textColor = XXColor(160, 160, 160, 1);
        [rightV addSubview:infoLab];
    }
}
- (void)loadTableView{
    float topHeight = Height_NavBar;

    // 1.创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, topHeight + 132, self.view.width, self.view.height - 195); // frame中的size指UIScrollView的可视范围
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    NSArray *colorArray = @[XXColor(245, 61, 69, 1), XXColor(253, 184, 63, 1), XXColor(15, 154, 254, 1)];
    NSArray *txtArray = @[@"水温监测",@"PH值监测",@"TDC值监测"];
    NSArray *typeArray = @[@"wd",@"ph",@"tds"];

    //scrollView加载图标
    for (int k = 0; k < 3; k ++) {
        UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(10, 10 + 220 * k, self.view.width - 20, 200)];
        topV.layer.cornerRadius = 4;
        topV.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:topV];
        [topV setShadowLayer:topV];
        
        UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(20, 17.5, 5, 15)];
        colorV.layer.cornerRadius = 3.0;
        [colorV setBackgroundColor:colorArray[k]];
        [topV addSubview:colorV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(colorV.right + 5, colorV.y, 140, 17)];
        infoLab.text = txtArray[k];
        infoLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        infoLab.textColor = colorArray[k];
        [topV addSubview:infoLab];
        
        UILabel *oldLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 110, colorV.y, 70, 17)];
        oldLab.text = @"历史记录";
        oldLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        oldLab.textColor = XXColor(160, 160, 160, 1);
        [topV addSubview:oldLab];

        UIImageView *arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(oldLab.right, colorV.y - 1, 10, 16)];
        [arrowImgV setImage:[UIImage imageNamed:@"more"]];
        [topV addSubview:arrowImgV];
        
        
        //  请求统计图数据
        [self reloadTemperature:topV data_Type:typeArray[k]];

    }
    

    
    // 设置UIScrollView的滚动范围（内容大小）
    scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 50);
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    UIButton *deletBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 670, self.view.width, 50)];
    deletBtn.backgroundColor = [UIColor whiteColor];
    [deletBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    [deletBtn setTitle:@"删除设备" forState:UIControlStateNormal];
    [deletBtn setTitleColor:XXColor(255, 84, 141, 1) forState:UIControlStateNormal];
    [scrollView addSubview:deletBtn];
    
}

- (void)reloadTemperature:(UIView *)topV data_Type:(NSString *)data_Type{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *current = [formatter stringFromDate:now];
    
    [AppRequest Request_Normalpost:@"szjctjtsj" json:@{@"id":_equipId,
                                                       @"data_type":data_Type,
                                                       @"days":current,
                                                       @"time_limit":@"5"} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [self ReloadCartogramView:topV data_Type:data_Type datasArr:result[@"retRes"]];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)ReloadCartogramView:(UIView *)topV data_Type:(NSString *)data_Type datasArr:(NSArray *)datasArr
{
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < datasArr.count; i++) {
        NSString *xdatas = [self getTimeFromTimesTamp:[NSString stringWithFormat:@"%@",datasArr[i][@"x"]]];
        NSString *ydatas = [NSString stringWithFormat:@"%@",datasArr[i][@"y"]];

        [xArray addObject:xdatas];
        [yArray addObject:[NSString stringWithFormat:@"%.2lf",[ydatas floatValue]]];
        
    }
    int ymaxValue;
    int yminValue;
    if ([data_Type isEqualToString:@"wd"]) {
        ymaxValue = 40;
        yminValue = -20;
    }
    else if ([data_Type isEqualToString:@"ph"]){
        ymaxValue = 14;
        yminValue = 0;
    }
    else {
        ymaxValue = 300;
        yminValue = 0;
    }
    WSLineChartView *wsLine = [[WSLineChartView alloc]initWithFrame:CGRectMake(-10, 50, topV.width, topV.height - 60) xTitleArray:xArray yValueArray:yArray yMax:ymaxValue yMin:yminValue];
//    wsLine.tag = 1000+tag;
    [topV addSubview:wsLine];
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
