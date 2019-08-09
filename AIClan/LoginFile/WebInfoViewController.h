//
//  WebInfoViewController.h
//  lzLmsApp
//
//  Created by hd on 2018/4/23.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "BaseViewController.h"

@interface WebInfoViewController : BaseViewController

@property (nonatomic, strong) NSString *infoUrl;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) BOOL isXY;
@property (nonatomic, strong) NSDictionary *bannerDic;

@end
