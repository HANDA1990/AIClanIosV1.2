//
//  BaseViewController.m
//  TeaByGame
//
//  Created by hd on 2017/8/24.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "EquipMainViewController.h"
#import "CapacityMainViewController.h"
#import "ProfesserViewController.h"
#import "ShoppingMainViewController.h"
#import "MyMainViewController.h"
#import "SmartMainViewController.h"
#import "ServiceGridViewController.h"
#import "IntelligentViewController.h"

@interface BaseViewController ()

@end

static char *btnClickAction;

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
}

- (id)init {
    if (self = [super init]) {

        if (![self isKindOfClass:[EquipMainViewController class]] &&
            ![self isKindOfClass:[MyMainViewController class]] &&
            ![self isKindOfClass:[CapacityMainViewController class]] &&
            ![self isKindOfClass:[ProfesserViewController class]] &&
            ![self isKindOfClass:[SmartMainViewController class]] &&
            ![self isKindOfClass:[ServiceGridViewController class]] &&
            ![self isKindOfClass:[IntelligentViewController class]]) {
            self.hidesBottomBarWhenPushed = YES;
            
        }
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        {
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeAll;
        }
        if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)])
        {
            self.modalPresentationCapturesStatusBarAppearance = YES;
        }
    }
    return self;
}

- (void)addLeftButton:(NSString *)titlestr imageName:(NSString *)imageName action:(void(^)(int status,NSString *searchKey))btnClickBlock
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
    [rightButton.layer setCornerRadius:2.];
    [rightButton setBackgroundColor:XXColor(255, 100, 96, 1)];
    rightButton.tag = 1000;
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [rightButton setTitle:titlestr forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(rightButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)addLeftButton:(NSString *)titlestr withImgName:(NSString *)withImgName action:(void(^)(int status,NSString *searchKey))btnClickBlock
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
    rightButton.tag = 1000;
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton setTitle:titlestr forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [rightButton setImage:[UIImage imageNamed:withImgName] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(rightButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)addRightButton:(NSString *)titlestr imageName:(NSString *)imageName action:(void(^)(int status,NSString *searchKey))btnClickBlock
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
    [rightButton.layer setCornerRadius:2.];
    rightButton.tag = 1000;
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [rightButton setTitle:titlestr forState:UIControlStateNormal];

    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(rightButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}
- (void)addRightButton:(NSString *)firstImgName secondName:(NSString *)secondName action:(void(^)(int status,NSString *searchKey))btnClickBlock
{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    [leftButton.layer setCornerRadius:2.];
    leftButton.tag = 1000;
    [leftButton setImage:[UIImage imageNamed:firstImgName] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(IS_IPHONE_X ? -15 :0, 0, 0, 0)];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(leftButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(leftButton.right, 5, 30, 30)];
    [rightButton.layer setCornerRadius:2.];
    rightButton.tag = 1001;
    [rightButton setImage:[UIImage imageNamed:secondName] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(IS_IPHONE_X ? -15 :0, 0, 0, 0)];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    objc_setAssociatedObject(rightButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:leftButton], [[UIBarButtonItem alloc] initWithCustomView:rightButton], nil];;
}

- (void)addTwoSizeButton:(NSString *)firstImgName secondName:(NSString *)secondName action:(void(^)(int status,NSString *searchKey))btnClickBlock
{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    [leftButton.layer setCornerRadius:2.];
    leftButton.tag = 1000;
    [leftButton setImage:[UIImage imageNamed:firstImgName] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(IS_IPHONE_X ? -15 :0, 0, 0, 0)];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(leftButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(leftButton.right, 5, 30, 30)];
    [rightButton.layer setCornerRadius:2.];
    rightButton.tag = 1001;
    [rightButton setImage:[UIImage imageNamed:secondName] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(IS_IPHONE_X ? -15 :0, 0, 0, 0)];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    objc_setAssociatedObject(rightButton, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

}

- (void)btnClick:(UIButton *)btn
{
    void (^btnClickBlock) (NSInteger statues, NSString *searchKey) = objc_getAssociatedObject(btn, &btnClickAction);
    btnClickBlock(btn.tag,nil);
    
}
- (void)addRuleRightBtn{
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStyleDone target:self action:@selector(btnClick)];
    [barbtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = barbtn;
}

- (void)addShadow:(UIView *)V{
    V.layer.masksToBounds=YES;
    V.layer.shadowColor = [UIColor blackColor].CGColor;
    V.layer.shadowOffset = CGSizeMake(10, 10);
    V.layer.shadowOpacity = 0.9;
    V.layer.shadowRadius = 4.0;
}

- (NSString *)getTimeFromTimesTamp:(NSString *)timeStr
{
    if ([timeStr isEqualToString:@"0"]) {
        return @"";
    }
    double time = [timeStr doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //将时间转换为字符串
    
    NSString *timeS = [formatter stringFromDate:myDate];
    
    return timeS;
    
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONTNAME size:font]} context:nil];
    
    return rect.size.height;
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
