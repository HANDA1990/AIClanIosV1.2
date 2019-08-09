//
//  ProfesserViewController.m
//  AIClan
//
//  Created by hd on 2018/10/17.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ProfesserViewController.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "ProfessorViewDetailController.h"
#import "NavCheckViewController.h"
#import "HistorySubMaineViewController.h"
#import "WebsiteViewController.h"
#import "MemoViewController.h"
#import "PromptlyOrderViewController.h"

#define kViewTag 666
@interface ProfesserViewController ()
<CWCarouselDatasource, CWCarouselDelegate>
{
        NSArray *dataArr;
}

@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, assign) BOOL openCustomPageControl;
@end

@implementation ProfesserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTwoSizeButton:@"network" secondName:@"memo_set" action:^(int status, NSString *searchKey) {
        if (status == 1000) {
            WebsiteViewController *webV = [WebsiteViewController new];
            webV.title = @"网点查询";
            [self.navigationController pushViewController:webV animated:YES];
        }
        else if (status == 1001){
            MemoViewController *memoVc = [MemoViewController new];
            memoVc.title = @"备忘设置";
            [self.navigationController pushViewController:memoVc animated:YES];

        }
    }];
    self.view.backgroundColor = XXColor(245, 245, 245, 1);
    self.openCustomPageControl = false;
    [self configureUI:2];
    [self reloadDatas];

}
- (void)reloadDatas{
    [AppRequest Request_Normalpost:@"yyzj" json:@{@"page":@"1",@"page_size":@"50"} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            dataArr = result[@"retRes"];
            /* 自定pageControl */
            
//            CGRect frame = self.animationView.bounds;
//            if(self.openCustomPageControl) {
//                CWPageControl *control = [[CWPageControl alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
//                control.center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) - 10);
//                control.pageNumbers = dataArr.count;
//                control.currentPage = 0;
//                self.carousel.customPageControl = control;
//            }
            [self.carousel freshCarousel];

        }
    } failed:^(NSError *error) {
        
    }];
}
- (UIView *)animationView{
    if(!_animationView) {
        float hb = Height_NavBar;
        float tb = Height_TabBar;

        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(5, hb + 20, CGRectGetWidth(self.view.frame) - 5, self.view.height - hb - tb - 60)];
        self.animationView.backgroundColor = XXColor(245, 245, 245, 1);
        
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
    
   CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:[self styleFromTag:tag]];
    CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero
                                                    delegate:self
                                                  datasource:self
                                                  flowLayout:flowLayout];
    carousel.translatesAutoresizingMaskIntoConstraints = NO;
    carousel.backgroundColor = XXColor(245, 245, 245, 1);
    [self.animationView addSubview:carousel];
    NSDictionary *dic = @{@"view" : carousel};
    [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:dic]];
    [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
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
    if(!bgV) {
        bgV = [[UIButton alloc] initWithFrame:CGRectMake( cell.contentView.bounds.size.width - 30, cell.contentView.bounds.size.height - 30, 48, 48)];
        bgV.tag = kViewTag+11;
        [bgV setImage:[UIImage imageNamed:@"historyyy"] forState:UIControlStateNormal];
        [bgV addTarget:self action:@selector(HistoryYYY) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:bgV];
//
    }
    
    if(!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, cell.contentView.bounds.size.width, cell.contentView.bounds.size.width)];
        imgView.tag = kViewTag;
        
        [cell.contentView addSubview:imgView];
   
    }
    if(!liv) {
        liv = [[UIView alloc] initWithFrame:CGRectMake(cell.width/ 2 + 25 - 40, imgView.bottom + 15, 5,25)];
        liv.tag = kViewTag + 10;
        liv.backgroundColor = NavColor;
        [cell.contentView addSubview:liv];
        
    }
    if(!lab) {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 10, cell.contentView.bounds.size.width,35)];
        lab.tag = kViewTag + 1;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor darkGrayColor];
        lab.text = @"沈从文";
        lab.font = [UIFont systemFontOfSize:24.0];
        [cell.contentView addSubview:lab];

    }
    if(!labinfo) {
        labinfo = [[UILabel alloc] initWithFrame:CGRectMake(0, lab.bottom - 10, cell.contentView.bounds.size.width,80)];
        labinfo.tag = kViewTag + 2;
        labinfo.font = [UIFont fontWithName:FONTNAME size:16.0];
        labinfo.textAlignment = NSTextAlignmentCenter;
        labinfo.numberOfLines = 0;
        labinfo.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:labinfo];
        
    }
    if(!cheBtn) {
        cheBtn = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width / 2 - 115, labinfo.bottom + 2, 100,35)];
        cheBtn.tag = kViewTag + 3;
        [cheBtn.titleLabel setFont:[UIFont fontWithName:FONTNAME size:16.0]];
        cheBtn.layer.borderWidth = 1;
        [cheBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cheBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [cheBtn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
        cheBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [cell.contentView addSubview:cheBtn];
        
    }
    if(!detailBtn) {
        detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width / 2 + 15, labinfo.bottom + 2,100,35)];
        detailBtn.tag = kViewTag + 4;
        [detailBtn.titleLabel setFont:[UIFont fontWithName:FONTNAME size:16.0]];

        [detailBtn setTitleColor:NavColor forState:UIControlStateNormal];
        [detailBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];

        detailBtn.layer.borderWidth = 1;
        detailBtn.layer.borderColor = NavColor.CGColor;
        [cell.contentView addSubview:detailBtn];
        
    }
    
    if (indexPath.row - 1 < dataArr.count) {
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row - 1];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL, dic[@"file_url"]]] placeholderImage:[UIImage imageNamed:@""]];
        [lab setText:dic[@"title"]];
        NSString *tags = dic[@"tags"];
        tags = [tags stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        [labinfo setText:tags];
    }


    return cell;
}
- (void)clickShow:(UIButton *)btn
{
    UICollectionViewCell *cell = (UICollectionViewCell *)btn.superview.superview;
    NSIndexPath *path = [self.carousel.carouselView indexPathForCell:cell];
    NSDictionary *dic = [dataArr objectAtIndex:path.row - 1];

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

- (void)HistoryYYY
{
    [self.navigationController pushViewController:[HistorySubMaineViewController new] animated:YES];
}
- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    NSLog(@"...%ld...", (long)index);
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
