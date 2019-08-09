//
//  IntelligentViewController.m
//  AIClan
//
//  Created by hd on 2019/5/5.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "IntelligentViewController.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "SelectView.h"

@interface IntelligentViewController ()
<CWCarouselDatasource, CWCarouselDelegate>

@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, assign) BOOL openCustomPageControl;
@end

@implementation IntelligentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXColor(245, 245, 245, 1);

    
    [self addTwoSizeButton:@"jsq" secondName:@"plhs" action:^(int status, NSString *searchKey) {
        if (status == 1000) {
           
        }
        else if (status == 1001){
            if ([[UIApplication sharedApplication].keyWindow viewWithTag:1808]) {
                [[[UIApplication sharedApplication].keyWindow viewWithTag:1808] setHidden:NO];
            }
            else{
                SelectView *selectV = [[SelectView alloc] init];
                selectV.tag = 1808;
                [[UIApplication sharedApplication].keyWindow addSubview:selectV];
            }
       
        }
    }];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(10, Height_NavBar + 10, self.view.width - 20, 100)];
    [topView setShadowLayer:topView];
    [self.view addSubview:topView];
    
    UILabel *ygLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    ygLab.text = @"鱼缸总数\n45个";
    ygLab.textAlignment = NSTextAlignmentRight;
    ygLab.numberOfLines = 0;
    ygLab.font = [UIFont systemFontOfSize:18];
    [topView addSubview:ygLab];
    [self setStateView:topView];
    
    
    //滑动翻页
    self.openCustomPageControl = false;
    [self configureUI:2];
    [self reloadDatas];
}
- (void)setStateView:(UIView *)bgV{
    UIView *okV = [[UIView alloc] initWithFrame:CGRectMake(IS_IPHONE_X ? 80 : 110, 17, 20, 15)];
    okV.layer.cornerRadius = 4.0;
    [okV setBackgroundColor:NavColor];
    [bgV addSubview:okV];
    
    UILabel *ygLab = [[UILabel alloc] initWithFrame:CGRectMake(okV.right, 15, 100, 20)];
    ygLab.text = @" 运行正常(43)";
    ygLab.font = [UIFont systemFontOfSize:13.0];
    [bgV addSubview:ygLab];
    
    
    UIView *okV2 = [[UIView alloc] initWithFrame:CGRectMake(ygLab.right + 15, 17, 20, 15)];
    okV2.layer.cornerRadius = 4.0;
    [okV2 setBackgroundColor:XXColor(158.0, 36.0, 42.0, 1)];
    [bgV addSubview:okV2];
    
    UILabel *ygLab2 = [[UILabel alloc] initWithFrame:CGRectMake(okV2.right, 15, 100, 20)];
    ygLab2.text = @" 运行异常(43)";
    ygLab2.font = [UIFont systemFontOfSize:13.0];
    [bgV addSubview:ygLab2];
    
    UIView *Linev = [[UIView alloc] initWithFrame:CGRectMake(IS_IPHONE_X ? 80 : 110, bgV.height / 2, bgV.width - 130, 0.5)];
    Linev.backgroundColor = [UIColor grayColor];
    [bgV addSubview:Linev];

    UIView *okV3 = [[UIView alloc] initWithFrame:CGRectMake(IS_IPHONE_X ? 80 : 110, 67, 20, 15)];
    okV3.layer.cornerRadius = 4.0;
    [okV3 setBackgroundColor:XXColor(82, 105, 181, 1)];
    [bgV addSubview:okV3];
    
    UILabel *ygLab4 = [[UILabel alloc] initWithFrame:CGRectMake(okV3.right, 65, 120, 20)];
    ygLab4.text = @" 已绑换水设备(43)";
    ygLab4.font = [UIFont systemFontOfSize:13.0];
    [bgV addSubview:ygLab4];
    
    
    UIView *okV4 = [[UIView alloc] initWithFrame:CGRectMake(ygLab.right + 15, 67, 20, 15)];
    okV4.layer.cornerRadius = 4.0;
    [okV4 setBackgroundColor:XXColor(226.0, 133.0, 76.0, 1)];
    [bgV addSubview:okV4];
    
    UILabel *ygLab5 = [[UILabel alloc] initWithFrame:CGRectMake(okV4.right, 65, 120, 20)];
    ygLab5.text = @" 未绑换水设备(43)";
    ygLab5.font = [UIFont systemFontOfSize:13.0];
    [bgV addSubview:ygLab5];

}

- (void)reloadDatas{
    [self.carousel freshCarousel];

}
- (UIView *)animationView{
    if(!_animationView) {
//        float hb = Height_NavBar;
        float tb = Height_TabBar;
        float margin_top = Height_NavBar    ;
        margin_top += 120;
        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(5, margin_top, CGRectGetWidth(self.view.frame), self.view.height - margin_top - tb - 10)];
        
    }
    return _animationView;
}

- (void)configureUI:(NSInteger)tag {
    
    [self.view addSubview:self.animationView];
    
    CATransition *tr = [CATransition animation];
    tr.type = @"cube";
    tr.subtype = kCATransitionFromRight;
    tr.duration = 0.25;
    [self.animationView.layer addAnimation:tr forKey:nil];
    
    if(self.carousel) {
        [self.carousel releaseTimer];
        [self.carousel removeFromSuperview];
        self.carousel = nil;
    }
    
    CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_H_2];
    CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero
                                                    delegate:self
                                                  datasource:self
                                                  flowLayout:flowLayout];
    carousel.translatesAutoresizingMaskIntoConstraints = NO;
    carousel.backgroundColor = XXColor(245, 245, 245, 1);
    [self.animationView addSubview:carousel];
    NSDictionary *dic = @{@"view" : carousel};
    float margin_top = 0;
    [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:dic]];
    [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]-0-|",margin_top]
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:dic]];
    

    carousel.isAuto = NO;
    carousel.autoTimInterval = 2;
    carousel.endless = NO;
    self.carousel = carousel;
    
    [self.carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.carousel controllerWillAppear];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.carousel controllerWillDisAppear];
}
- (NSInteger)numbersForCarousel {
    
    return 3;
}
#define kViewTag 666

#pragma mark - Delegate
- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setShadowLayer:cell];
    
    UILabel *lab = [cell.contentView viewWithTag:kViewTag+1];
    
    UIView *okV3 = [cell.contentView viewWithTag:kViewTag+2];
    
    UILabel *ygLab4 = [cell.contentView viewWithTag:kViewTag+3];

    
    UILabel *wendu = [cell.contentView viewWithTag:kViewTag+4];
    UILabel *Ph = [cell.contentView viewWithTag:kViewTag+5];
    UILabel *TDS = [cell.contentView viewWithTag:kViewTag+6];

    
    UILabel *wenduLab = [cell.contentView viewWithTag:kViewTag+7];
    UILabel *phLab = [cell.contentView viewWithTag:kViewTag+8];
    UILabel *TDSLav = [cell.contentView viewWithTag:kViewTag+9];

    UIView *pfV = [cell.contentView viewWithTag:kViewTag+10];

    UILabel *pflab = [cell.contentView viewWithTag:kViewTag+11];
    UILabel *pflab2 = [cell.contentView viewWithTag:kViewTag+12];
    UILabel *pflab3 = [cell.contentView viewWithTag:kViewTag+13];
    UILabel *pflab4 = [cell.contentView viewWithTag:kViewTag+14];

    UIButton *handleBtn = [cell.contentView viewWithTag:kViewTag+15];

    if (!lab) {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, cell.contentView.width, 30)];
        lab.tag = kViewTag + 1;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"当前鱼缸名称";
        lab.font = [UIFont systemFontOfSize:20.0];
        [cell.contentView addSubview:lab];
    }
    
    if (!okV3) {
        okV3 = [[UIView alloc] initWithFrame:CGRectMake(cell.contentView.width - 70, 30, 15, 10)];
        okV3.layer.cornerRadius = 4.0;
        okV3.tag = kViewTag + 2;
        [okV3 setBackgroundColor:[UIColor redColor]];
        [cell.contentView addSubview:okV3];
    }
   
    if (!ygLab4) {
        ygLab4 = [[UILabel alloc] initWithFrame:CGRectMake(okV3.right, 27, 120, 20)];
        ygLab4.text = @" 异常";
        ygLab4.textColor = [UIColor redColor];
        ygLab4.tag = kViewTag + 3;
        ygLab4.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:ygLab4];
    }
    
    if (!wendu) {
        wendu = [[UILabel alloc] initWithFrame:CGRectMake(28, lab.bottom + 15, 50, 30)];
        wendu.text = @"20";
        wendu.textColor = NavColor;
        wendu.textAlignment = NSTextAlignmentCenter;
        wendu.tag = kViewTag + 4;
        wendu.font = [UIFont systemFontOfSize:30.0];
        [cell.contentView addSubview:wendu];
    }
    
    if (!wenduLab) {
        wendu = [[UILabel alloc] initWithFrame:CGRectMake(25, wendu.bottom + 5, 65, 30)];
        wendu.text = @"当前水温";
        wendu.textAlignment = NSTextAlignmentCenter;
        wendu.tag = kViewTag + 7;
        wendu.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:wendu];
    }
    
    if (!Ph) {
        Ph = [[UILabel alloc] initWithFrame:CGRectMake(cell.width/2 - 25, lab.bottom + 15, 50, 30)];
        Ph.text = @"5.8";
        Ph.textColor = NavColor;
        Ph.textAlignment = NSTextAlignmentCenter;
        Ph.tag = kViewTag + 5;
        Ph.font = [UIFont systemFontOfSize:30.0];
        [cell.contentView addSubview:Ph];
    }
    
    if (!phLab) {
        phLab = [[UILabel alloc] initWithFrame:CGRectMake(cell.width/2 - 20, Ph.bottom + 5, 70, 30)];
        phLab.text = @"当前PH值";
        phLab.textAlignment = NSTextAlignmentCenter;
        phLab.tag = kViewTag + 8;
        phLab.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:phLab];
    }
    
    if (!TDS) {
        TDS = [[UILabel alloc] initWithFrame:CGRectMake(cell.width - 78, lab.bottom + 15, 60, 30)];
        TDS.text = @"260";
        TDS.textColor = [UIColor redColor];
        TDS.textAlignment = NSTextAlignmentCenter;
        TDS.tag = kViewTag + 6;
        TDS.font = [UIFont systemFontOfSize:30.0];
        [cell.contentView addSubview:TDS];
    }
    if (!TDSLav) {
        TDSLav = [[UILabel alloc] initWithFrame:CGRectMake(cell.width - 78, TDS.bottom + 5, 60, 30)];
        TDSLav.text = @"当前TDS";
        TDSLav.textAlignment = NSTextAlignmentCenter;
        TDSLav.tag = kViewTag + 9;
        TDSLav.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:TDSLav];
    }
    if (!pfV) {
        pfV = [[UIView alloc] initWithFrame:CGRectMake(10, TDSLav.bottom + 20, cell.contentView.width - 20, cell.contentView.width - 100)];
        pfV.tag = kViewTag + 10;
        pfV.layer.cornerRadius = 4.0;
        pfV.layer.borderWidth = 1;
        pfV.layer.borderColor = NavColor.CGColor;
        [cell.contentView addSubview:pfV];

    }
    
    if (!pflab) {
        pflab = [[UILabel alloc] initWithFrame:CGRectMake(pfV.x + 20, TDSLav.bottom + 50, cell.contentView.width, 15)];
        pflab.text = @"鱼缸评分：78 分";
        pflab.textColor = NavColor;
        pflab.textAlignment = NSTextAlignmentLeft;
        pflab.tag = kViewTag + 11;
        pflab.font = [UIFont systemFontOfSize:25.0];
        [cell.contentView addSubview:pflab];
    }
    
    if (!pflab2) {
        pflab2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.width / 2 - 45, pflab.bottom + 10, 200, 100)];
        pflab2.numberOfLines = 0;
        pflab2.textColor = [UIColor grayColor];
        pflab2.text = @"1.是否使用全套智能产品\n2.水质是否在最优区间\n3.是否定期维护鱼缸\n4.是否定期给鱼制作检疫\n5.等等...";
        pflab2.textAlignment = NSTextAlignmentLeft;
        pflab2.tag = kViewTag + 12;
        pflab2.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:pflab2];
    }
    
    if (!pflab3) {
        pflab3 = [[UILabel alloc] initWithFrame:CGRectMake(pfV.x + 20, pflab2.bottom + 15, cell.contentView.width, 15)];
        pflab3.text = @"温馨提示：";
        pflab3.textColor = NavColor;
        pflab3.textAlignment = NSTextAlignmentLeft;
        pflab3.tag = kViewTag + 13;
        pflab3.font = [UIFont systemFontOfSize:25.0];
        [cell.contentView addSubview:pflab3];
    }
    
    if (!pflab4) {
        pflab4 = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.width / 2 - 45, pflab3.bottom - 15, 200, 100)];
        pflab4.numberOfLines = 0;
        pflab4.textColor = [UIColor grayColor];
        pflab4.text = @"1.四季交替时给鱼只检疫\n2.定期补充硝化细菌维他命\n3.下雨时不要换水\n4.大量换水时添加水质稳定剂\n5.水质长期偏差或波动太大检疫咨询专家";
        pflab4.textAlignment = NSTextAlignmentLeft;
        pflab4.tag = kViewTag + 14;
        pflab4.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:pflab4];
    }
    
    if (!handleBtn) {
        handleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, pfV.bottom + 10, cell.contentView.width - 40, 40)];
        handleBtn.layer.cornerRadius = 4.0;
        handleBtn.backgroundColor = XXColor(90, 209, 149, 1);
        [handleBtn setTitle:@"未绑定换水设备" forState:UIControlStateNormal];
        [cell.contentView addSubview:handleBtn];

    }

    return cell;

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
