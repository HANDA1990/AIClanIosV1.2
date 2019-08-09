//
//  ConsultViewController.m
//  AIClan
//
//  Created by hd on 2019/5/13.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "ConsultViewController.h"
#import "WebLoadViewController.h"
#import "NavCheckViewController.h"

@interface ConsultViewController ()
{
    UIScrollView *tempScrollView ;
}
@end

@implementation ConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tempScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    tempScrollView.contentSize = CGSizeMake(self.view.width,self.view.height);
    [self.view addSubview:tempScrollView];
}


- (void)ListdataRefresh:(TTGState)stateType
{
    
    switch (stateType) {
        case Alpro:
        {
            [self cellViewLoad1:(self.view.width - 280)/3 originty:20 name:@"鱼 病 咨 询" tag:0];
            [self cellViewLoad1:(self.view.width - 280)/3 * 2 + 140 originty:20 name:@"海 水 咨 询" tag:1];
            [self cellViewLoad1:(self.view.width - 280)/3 originty:250 name:@"草缸造景咨询" tag:2];
            [self cellViewLoad1:(self.view.width - 280)/3 * 2 + 140 originty:250 name:@"鱼 缸 结 构\n及水流工程" tag:3];

            self.title = @"专业咨询";
        }
            break;
        case Alfree:
        {
            tempScrollView.contentSize = CGSizeMake(self.view.width,self.view.height*1.25);

            [self cellViewLoad3:(self.view.width - 280)/3 originty:20 name:@"鱼 病 咨 询" tag:0];
            [self cellViewLoad3:(self.view.width - 280)/3 * 2 + 140 originty:20 name:@"海 水 咨 询" tag:1];
            [self cellViewLoad3:(self.view.width - 280)/3 originty:250 name:@"草缸造景咨询" tag:2];
            [self cellViewLoad3:(self.view.width - 280)/3 * 2 + 140 originty:250 name:@"鱼 缸 结 构\n及水流工程" tag:3];
            [self cellViewLoad3:(self.view.width - 280)/3 originty:480 name:@"水族其他问题" tag:4];

            self.title = @"免费咨询";
        }
            break;
        case Alconnect:
        {
            [self cellViewLoad2:20 originty:20  name:@"合    作\n意    向" tag:5];
            [self cellViewLoad2:20 originty:190 name:@"加    入\n我    们" tag:6];
            [self cellViewLoad2:20 originty:360 name:@"投    诉\n建    议"  tag:7];
            self.title = @"联系我们";
        }
            break;
        default:
            break;
    }
  
}
- (void)cellViewLoad1:(float)origintx originty:(float)originty name:(NSString *)name tag:(int)tag{
    NSArray *imgA = @[@"zx1",@"zx2",@"zx3",@"zx4"];
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(origintx, originty, 140, 210)];
    bgV.tag = tag;
    bgV.layer.cornerRadius = 10;
    bgV.layer.masksToBounds = YES;
    [bgV setBackgroundColor:[UIColor whiteColor]];
    [tempScrollView addSubview:bgV];
    
    UIButton *bgV2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 140, 210)];
    bgV2.tag = tag;
    bgV2.layer.cornerRadius = 10;
    bgV2.layer.masksToBounds = YES;
    [bgV2 setBackgroundColor:[UIColor whiteColor]];
    [bgV2 addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:bgV2];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgV.width, 40)];
    nameLab.tag = 100;
    //STXinwei DFPKaiW5-GB
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.text = name;
    nameLab.font = [UIFont fontWithName:@"STXinwei" size:20.0];

    if (bgV.tag == 4) {
        nameLab.numberOfLines = 0;
        nameLab.font = [UIFont fontWithName:@"STXinwei" size:15.0];

    }

    nameLab.layer.masksToBounds = YES;
    nameLab.backgroundColor = NavColor;
    [bgV addSubview:nameLab];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, nameLab.bottom + 30, bgV2.width - 20, (bgV2.width-20) * 0.96)];
    [imgV setImage:[UIImage imageNamed:imgA[tag]]];
    [bgV2 addSubview:imgV];
    
}
- (void)cellViewLoad3:(float)origintx originty:(float)originty name:(NSString *)name tag:(int)tag{
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(origintx, originty, 140, 210)];
    bgV.tag = tag;
    bgV.layer.cornerRadius = 10;
    bgV.layer.masksToBounds = YES;
    [bgV setBackgroundColor:[UIColor whiteColor]];
    [tempScrollView addSubview:bgV];

    UIButton *bgV2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 210)];
    bgV2.tag = tag;
    bgV2.layer.cornerRadius = 10;
    bgV2.layer.masksToBounds = YES;
    [bgV2 setBackgroundColor:[UIColor whiteColor]];
    [bgV2 addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:bgV2];

    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgV.width, 40)];
    nameLab.tag = 100;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.text = name;
    nameLab.font = [UIFont fontWithName:@"STXinwei" size:20.0];

    if (bgV.tag == 7) {
        nameLab.numberOfLines = 0;
        nameLab.font = [UIFont fontWithName:@"STXinwei" size:15.0];
    }

    nameLab.layer.masksToBounds = YES;
    nameLab.backgroundColor = NavColor;
    [bgV addSubview:nameLab];
    
    NSArray *imgA = @[@"zx1",@"zx2",@"zx3",@"zx4",@"zx5"];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, nameLab.bottom + 10, bgV2.width - 20, (bgV2.width-20) * 0.96)];
    [imgV setImage:[UIImage imageNamed:imgA[tag]]];
    [bgV2 addSubview:imgV];
    
}
- (void)cellViewLoad2:(float)origintx originty:(float)originty name:(NSString *)name tag:(int)tag{

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(origintx, originty,self.view.width - origintx * 2, 150)];
    bgV.tag = tag;
    bgV.layer.cornerRadius = 10;
    bgV.layer.masksToBounds = YES;
    [bgV setBackgroundColor:[UIColor whiteColor]];
    [tempScrollView addSubview:bgV];

    UIButton *bgV2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.width - origintx * 2, 150)];
    bgV2.tag = tag;
    bgV2.layer.cornerRadius = 10;
    bgV2.layer.masksToBounds = YES;
    [bgV2 setBackgroundColor:[UIColor whiteColor]];
    [bgV2 addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:bgV2];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgV.width / 2, 150)];
    nameLab.tag = 100;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = NavColor;
    nameLab.text = name;
    nameLab.numberOfLines = 0;
    nameLab.font = [UIFont fontWithName:@"STXinwei" size:30.0];
    nameLab.layer.masksToBounds = YES;
    nameLab.backgroundColor = [UIColor whiteColor];
    [bgV addSubview:nameLab];
    
    
    NSArray *imgA = @[@"zx6",@"zx7",@"zx8"];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(nameLab.right - 10, 15, (bgV2.height -20) * 1.28, bgV2.height -20)];
    [imgV setImage:[UIImage imageNamed:imgA[tag-5]]];
    [bgV2 addSubview:imgV];
}
- (void)clickShow:(UIButton *)btn
{
    WebLoadViewController *webv = [WebLoadViewController new];
    webv.tag = btn.tag;
    NSString *titleStr = [((UILabel *)[btn.superview viewWithTag:100]).text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    webv.title = titleStr;
    [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:webv] animated:YES completion:^{
        
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
