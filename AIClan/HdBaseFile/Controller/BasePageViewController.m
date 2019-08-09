//
//  BasePageViewController.m
//  PlasticNet
//
//  Created by hd on 15/10/10.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import "BasePageViewController.h"
#import "ModelController.h"

@interface BasePageViewController ()<UIPageViewControllerDelegate>
{
    UIPageViewController *_pageViewController;
    ModelController *_modelController;
    UIView *_selectLineView;
    UIButton *_selectButton;
    
    NSMutableArray *_buttonArray;
    
    NSInteger arrayCount;
    
    NSInteger typeSelf;

}
@end

@implementation BasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


+(instancetype)sharedManager {
    
    static BasePageViewController *soundManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundManager = [[self alloc]init];
    });
    
    return soundManager;
}

- (void)initWithtitleArray: (NSArray *)ViewController titleArray:(NSArray *)titleArray selectNum:(NSInteger)selectNum {
//    if (self = [super init]) {
    
        arrayCount = titleArray.count;
        _select = selectNum;
        
        _selectLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 33 + self.navigationController.navigationBar.bottom, self.view.width / arrayCount, 2)];
//        [UIColor NavColorChangeto:NAV_TYPE];
        [_selectLineView setBackgroundColor:MainColor(1)];
        [self.view addSubview:_selectLineView];
    
        UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 + self.navigationController.navigationBar.bottom, self.view.width, 1)];
        downLineView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:downLineView];
    
        _buttonArray  = [[NSMutableArray alloc] init];
        for (int i = 0; i < titleArray.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * self.view.width / arrayCount, self.navigationController.navigationBar.bottom, self.view.width / titleArray.count, 35)];
            button.tag = i;
            
            [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];

         
            if (i == selectNum) {
                [button setTitleColor:MainColor(1) forState:UIControlStateNormal];
                _selectButton = button;
            }
            else
            {
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [self.view addSubview:button];
        }
        
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _modelController = [[ModelController alloc] initWithViewController:ViewController];
        [_pageViewController setViewControllers:@[[_modelController viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        _pageViewController.dataSource = _modelController;
        _pageViewController.delegate = self;
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        
        CGRect pageViewRect = self.view.bounds;
        pageViewRect.origin.y = 36 + self.navigationController.navigationBar.bottom;
        pageViewRect.size.height -= (self.navigationController.navigationBar.bottom + 36);
        _pageViewController.view.frame = pageViewRect;
        
        [_pageViewController didMoveToParentViewController:self];
        self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
        
    
//    }
//    return self;
}
- (void)appearSelected:(NSInteger)select{
    self.select = select;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self selected:self.select];

}
- (void)setSwitchTitle:(NSInteger )idstr titleStr:(NSString *)titleStr{
    if ([[self.view viewWithTag:idstr] isKindOfClass:[UIButton class]]) {
        UIButton *titleBtn = (UIButton *)[self.view viewWithTag:idstr];
        [titleBtn setTitle:titleStr forState:UIControlStateNormal];
    }
    
}

- (void)selected:(NSInteger)temp
{
        [UIView animateWithDuration:0.25 animations:^{
            
//            ((UIButton *)_buttonArray[temp]).backgroundColor = [UIColor whiteColor];
            [_selectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [(UIButton *)_buttonArray[temp] setTitleColor:MainColor(1) forState:UIControlStateNormal];
            _selectButton = (UIButton *)_buttonArray[temp];
            _selectLineView.transform = CGAffineTransformMakeTranslation(temp * self.view.width / arrayCount, 0);//坐标位置移动
            
            
        }];
    
    
    
    [_pageViewController setViewControllers:@[[_modelController viewControllerAtIndex:temp]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}
- (void)clickButton:(UIButton *)sender
{
    UIPageViewControllerNavigationDirection direction;
    
    if (_selectButton.x > sender.x) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else if (_selectButton.x <= sender.x)
    {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    [self changeButton:sender];
    
    [_pageViewController setViewControllers:@[[_modelController viewControllerAtIndex:sender.tag]] direction:direction animated:YES completion:nil];
}

- (void)changeButton:(UIButton *)sender
{
    self.select = sender.tag;
    if (typeSelf) {
        [sender setTitleColor:MainColor(1) forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor whiteColor]];
        _selectButton = sender;

        for (UIButton *childBtn in _buttonArray) {
            if (childBtn != sender) {
                [childBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [childBtn setBackgroundColor:[UIColor clearColor]];
            }
        }
        
    }
    else
    {
        
        [UIView animateWithDuration:0.25 animations:^{
            [_selectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [sender setTitleColor:MainColor(1) forState:UIControlStateNormal];
            _selectLineView.transform = CGAffineTransformMakeTranslation(sender.tag * self.view.width / arrayCount, 0);
            _selectButton = sender;
        }];
    }
        
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    [self changeButton:[_buttonArray objectAtIndex:[_modelController indexOfViewController:pageViewController.viewControllers[0]]]];
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
