//
//  SelectView.h
//  AIClan
//
//  Created by hd on 2019/5/6.
//  Copyright © 2019年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableivew;
@property(nonatomic,strong)NSMutableArray *array;//数据源
@property (nonatomic,strong)NSMutableArray *selectorPatnArray;//存放选中数据
@end
