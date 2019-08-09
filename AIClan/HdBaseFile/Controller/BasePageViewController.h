//
//  BasePageViewController.h
//  PlasticNet
//
//  Created by hd on 15/10/10.
//  Copyright (c) 2015年 hd. All rights reserved.
//

#import "BaseViewController.h"
#import "Protocoldelegate.h"

@interface BasePageViewController : BaseViewController

@property (nonatomic, assign) NSInteger select;


@property (nonatomic, assign)id <Protocoldelegate>delegaty;

+(instancetype)sharedManager;

- (void)initWithtitleArray: (NSArray *)ViewController titleArray:(NSArray *)titleArray selectNum:(NSInteger)selectNum;


- (void)setSwitchTitle:(NSInteger )idstr titleStr:(NSString *)titleStr;



- (void)appearSelected:(NSInteger)select;
@end
