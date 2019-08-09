//
//  ServiceGridViewController.m
//  AIClan
//
//  Created by hd on 2018/12/24.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ServiceGridViewController.h"
#import "CWCarousel.h"
#import "CWPageControl.h"

#import "ProfessorViewDetailController.h"
#import "NavCheckViewController.h"
#import "WebsiteViewController.h"
#import "MemoViewController.h"
#import "PromptlyOrderViewController.h"
#import "ConsultViewController.h"

#define kViewTag 666

@interface ServiceGridViewController ()<CWCarouselDatasource, CWCarouselDelegate>
{
    NSArray *dataArr;
}
@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIView *animationView;

@end

@implementation ServiceGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgV.backgroundColor = XXColor(240, 240, 240, 1);
    imgV.userInteractionEnabled = YES;
    self.view = imgV;
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [topV setBackgroundColor:NavColor];
    [self.view addSubview:topV];
    topV.userInteractionEnabled = YES;

    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 80)];
    [titleLab setText:@"服务"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:30];
    titleLab.textColor = [UIColor whiteColor];
    [topV addSubview:titleLab];
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 25, 25)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"website"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(cickJump:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(10, leftBtn.bottom, 60, 20)];
    [txtLab setText:@"全部网点"];
    txtLab.font = [UIFont systemFontOfSize:11.5];
    txtLab.textColor = [UIColor whiteColor];
    [topV addSubview:txtLab];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 50, 40, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"unforget"] forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(cickJump:) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:rightBtn];
    UILabel *txtLab2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 50, leftBtn.bottom, 60, 20)];
    [txtLab2 setText:@"备忘"];
    txtLab2.font = [UIFont systemFontOfSize:11.5];
    txtLab2.textColor = [UIColor whiteColor];
    [topV addSubview:txtLab2];
    [self loadCenterView];
    
    [self reloadDatas];

}

- (void)cickJump:(UIButton *)btn
{
    if (btn.tag == 1) {
        WebsiteViewController *webV = [WebsiteViewController new];
        webV.title = @"网点查询";
        [self.navigationController pushViewController:webV animated:YES];
    }
    else if (btn.tag == 2){
        MemoViewController *memoVc = [MemoViewController new];
        memoVc.title = @"备忘设置";
        [self.navigationController pushViewController:memoVc animated:YES];
    }
}
- (void)reloadDatas{
    [AppRequest Request_Normalpost:@"yyzj" json:@{@"page":@"1",@"page_size":@"50"} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            dataArr = result[@"retRes"];
     
            [self.carousel freshCarousel];
            
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)loadCenterView{
    int hb = Height_NavBar + 58;
    [self configureUI:@"专家特约" rect:CGRectMake(30, hb, self.view.width / 2 - 40, 0.4 * self.view.height)];
    [self shangmen];
    [self loadbottom];

}
- (UIView *)animationView{
    //275 523
    if(!_animationView) {
        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2 - 40, 0.4 * self.view.height)];
        self.animationView.backgroundColor = [UIColor clearColor];
        self.animationView.layer.masksToBounds = YES;
        
    }
    return _animationView;
}

- (void)loadbottom{
    for (int k = 0; k < 2; k ++) {
        int hb = Height_NavBar + 20;

        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(k == 0 ? 30 : self.view.width / 2 + 10, hb + 50+0.4 * self.view.height, self.view.width / 2 - 40, self.view.width / 2 - 10)];
        [self.view addSubview:bgV];
        bgV.layer.cornerRadius = 4.0;
        bgV.layer.borderWidth = 0.5;
        bgV.layer.borderColor = NavColor.CGColor;
        bgV.layer.masksToBounds = YES;
        
        UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgV.width, 35)];
        topLab.text = k == 0 ? @"免费咨询" : @"联系我们";
        topLab.backgroundColor = NavColor;
        topLab.textColor = [UIColor whiteColor];
        topLab.textAlignment = NSTextAlignmentCenter;
        [bgV addSubview:topLab];

        UIButton *imgV = [[UIButton alloc] initWithFrame:CGRectMake(bgV.width / 2 - 40, (bgV.height - 35)/2 - 10, 80, 80)];
        [imgV  setImage:[UIImage imageNamed:k == 0 ? @"freeC" : @"connectUs"] forState:UIControlStateNormal];
        imgV.tag = k + 3;

        [imgV addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];

        [bgV addSubview:imgV];
    }
}

- (void)shangmen{
    int hb = Height_NavBar + 58;

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 + 10, hb, self.view.width / 2 - 40, 0.4 * self.view.height)];
    [self.view addSubview:bgV];
    bgV.layer.cornerRadius = 4.0;
    bgV.layer.borderWidth = 0.5;
    bgV.layer.borderColor = NavColor.CGColor;
    bgV.backgroundColor = [UIColor clearColor];
    bgV.layer.masksToBounds = YES;
    
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgV.width, 35)];
    topLab.text = @"专业咨询";
    topLab.backgroundColor = NavColor;
    topLab.textColor = [UIColor whiteColor];
    topLab.textAlignment = NSTextAlignmentCenter;
    [bgV addSubview:topLab];
    
    UIButton *imgV = [[UIButton alloc] initWithFrame:CGRectMake(0, topLab.bottom, bgV.width, bgV.height - 35)];
    imgV.tag = 2;
    [imgV setImage:[UIImage imageNamed:@"profession"] forState:UIControlStateNormal];
    [imgV addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:imgV];
    
}
- (void)testClick:(UIButton *)btn
{
    
    ConsultViewController *consVc = [ConsultViewController new];
   
    NavCheckViewController *nav = [[NavCheckViewController alloc]initWithRootViewController:consVc];
//    [nav setNavgationHiddens:nav];
    [self presentViewController:nav animated:YES completion:^{
        if (btn.tag == 2)
            [consVc ListdataRefresh:Alpro];
        else if (btn.tag == 3)
            [consVc ListdataRefresh:Alfree];
        else if(btn.tag == 4)
            [consVc ListdataRefresh:Alconnect];
    }];
}

- (void)configureUI:(NSString *)des rect:(CGRect)rect {
    
    UIView *bgV = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:bgV];
    bgV.layer.cornerRadius = 4.0;
    bgV.layer.borderWidth = 0.5;
    bgV.layer.borderColor = NavColor.CGColor;
    bgV.backgroundColor = NavColor;
    bgV.layer.masksToBounds = YES;
    
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgV.width, 35)];
    topLab.text = des;
    topLab.backgroundColor = NavColor;
    topLab.textColor = [UIColor whiteColor];
    topLab.textAlignment = NSTextAlignmentCenter;
    [bgV addSubview:topLab];

    [bgV addSubview:self.animationView];
    
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
    
    CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:[self styleFromTag:0]];
    CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero
                                                    delegate:self
                                                  datasource:self
                                                  flowLayout:flowLayout];
    carousel.translatesAutoresizingMaskIntoConstraints = NO;
    carousel.backgroundColor = XXColor(245, 245, 245, 1);
    [self.animationView addSubview:carousel];
    NSDictionary *dic = @{@"view" : carousel};
    [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[view]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:dic]];
    [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35-[view]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:dic]];
    
    
    carousel.isAuto = NO;
    carousel.autoTimInterval = 0;
    carousel.endless = NO;
    self.carousel = carousel;
    
    [self.carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
    [self.carousel freshCarousel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.carousel controllerWillAppear];
    self.navigationController.navigationBar.hidden = YES;

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.carousel controllerWillDisAppear];
    self.navigationController.navigationBar.hidden = NO;
}

- (CWCarouselStyle)styleFromTag:(NSInteger)tag {
    //@[@"正常样式", @"横向滑动两边留白", @"横向滑动两边留白渐变效果", @"两边被遮挡效果"]
    switch (tag) {
        case 0:
            return CWCarouselStyle_Normal;
            break;
        case 1:
            return CWCarouselStyle_H_1;
            break;
        case 2:
            return CWCarouselStyle_H_2;
            break;
        case 3:
            return CWCarouselStyle_H_3;
            break;
        default:
            return CWCarouselStyle_Unknow;
            break;
    }
}

- (NSInteger)numbersForCarousel {
    if (dataArr.count)
        return dataArr.count;
    return 0;
}

#pragma mark - Delegate
- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    UIImageView *imgView = [cell.contentView viewWithTag:kViewTag];
    UIView *liv = [cell.contentView viewWithTag:kViewTag+10];
    
    UILabel *lab = [cell.contentView viewWithTag:kViewTag+1];
    UILabel *labinfo = [cell.contentView viewWithTag:kViewTag+2];
    
    UIButton *cheBtn = [cell.contentView viewWithTag:kViewTag+3];
    UIButton *detailBtn = [cell.contentView viewWithTag:kViewTag+4];
    
    UIButton *bgV = [cell.contentView viewWithTag:kViewTag+11];
    [cell.contentView setShadowLayer:cell.contentView];
    //    cell.layer.masksToBounds = YES;
    cell.contentView.layer.cornerRadius = 4;
    
    if(!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, self.view.width / 2 - 40)];
        imgView.tag = kViewTag;
        
        [cell.contentView addSubview:imgView];
        
    }
    if(!liv) {
        liv = [[UIView alloc] initWithFrame:CGRectMake(cell.width/ 2 - 20, imgView.bottom + 2, 3,13)];
        liv.tag = kViewTag + 10;
        liv.backgroundColor = NavColor;
        [cell.contentView addSubview:liv];
        
    }
    if(!lab) {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 3, cell.contentView.bounds.size.width,15)];
        lab.tag = kViewTag + 1;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor darkGrayColor];
        lab.text = @"沈从文";
        lab.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:lab];
        
    }
    if(!labinfo) {
        labinfo = [[UILabel alloc] initWithFrame:CGRectMake(0, lab.bottom, cell.contentView.bounds.size.width,25)];
        labinfo.tag = kViewTag + 2;
        labinfo.font = [UIFont fontWithName:FONTNAME size:10.0];
        labinfo.textAlignment = NSTextAlignmentCenter;
        labinfo.numberOfLines = 0;
        labinfo.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:labinfo];
        
    }
    if(!cheBtn) {
        cheBtn = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width / 2 - 60, labinfo.bottom , 50,20)];
        cheBtn.tag = kViewTag + 3;
        [cheBtn.titleLabel setFont:[UIFont fontWithName:FONTNAME size:8.0]];
        cheBtn.layer.borderWidth = 1;
        [cheBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cheBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [cheBtn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
        cheBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [cell.contentView addSubview:cheBtn];
        
    }
    if(!detailBtn) {
        detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width / 2 + 5, labinfo.bottom, 50,20)];
        detailBtn.tag = kViewTag + 4;
        [detailBtn.titleLabel setFont:[UIFont fontWithName:FONTNAME size:8.0]];
        
        [detailBtn setTitleColor:NavColor forState:UIControlStateNormal];
        [detailBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
        
        detailBtn.layer.borderWidth = 1;
        detailBtn.layer.borderColor = NavColor.CGColor;
        [cell.contentView addSubview:detailBtn];
        
    }
    
    if (indexPath.row< dataArr.count) {
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row ];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL, dic[@"file_url"]]] placeholderImage:[UIImage imageNamed:@""]];
        [lab setText:dic[@"title"]];
        NSString *tags = dic[@"tags"];
        tags = [tags stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        [labinfo setText:tags];
    }
    
    
    return cell;
}
#pragma mark - 代理方法
/** 点击图片回调 */
- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
   
}
- (void)clickShow:(UIButton *)btn
{
    UICollectionViewCell *cell = (UICollectionViewCell *)btn.superview.superview;
    NSIndexPath *path = [self.carousel.carouselView indexPathForCell:cell];
    NSDictionary *dic = [dataArr objectAtIndex:path.row];
    
    if (btn.tag == kViewTag + 3) {
        ProfessorDetailViewController *professVc = [ProfessorDetailViewController new];
        NavCheckViewController *nav = [[NavCheckViewController alloc]initWithRootViewController:professVc];
        [nav setNavgationHiddens:nav];
        professVc.profrssorId = dic[@"id"];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
    else if (btn.tag == kViewTag + 4) {
        PromptlyOrderViewController *prompVc = [PromptlyOrderViewController new];
        prompVc.infoDic = dic;
        NavCheckViewController *nav = [[NavCheckViewController alloc]initWithRootViewController:prompVc];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
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
