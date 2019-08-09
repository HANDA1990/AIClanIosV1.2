//
//  ViewController.m
//  AIClan
//
//  Created by hd on 2018/10/15.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ViewController.h"
//#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "HdLoginViewController.h"
#import "BaseNavViewController.h"
#import "CWCarousel.h"
#import "CWPageControl.h"

#define kViewTag 666

@interface ViewController ()<CWCarouselDatasource, CWCarouselDelegate>
{
    NSArray *dataArr;
}
@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, assign) BOOL openCustomPageControl;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI:0];

}

- (UIView *)animationView{
    if(!_animationView) {
        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        self.animationView.backgroundColor = XXColor(245, 245, 245, 1);
        
    }
    return _animationView;
}
- (void)configureUI:(NSInteger)tag {
    dataArr = @[@"p1",@"p2",@"p3",@"p4"];

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
    [self.carousel freshCarousel];

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
    if(!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, self.view.width, self.view.height)];
        imgView.tag = kViewTag;
        [cell.contentView addSubview:imgView];
        
    }
    [imgView setImage:[UIImage imageNamed:dataArr[indexPath.row]]];

    return cell;
}
#pragma mark - 代理方法
/** 点击图片回调 */
- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    if (index < dataArr.count - 2) {
        return;
    }

    
    
    [NSUserDefaults setBool:YES forKey:@"isRead"];
    AppDelegate* appDelagete =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelagete.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[HdLoginViewController new]];
    
    [UIView animateWithDuration:0.4 animations:^{
        
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


@end
