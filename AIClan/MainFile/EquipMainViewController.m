//
//  EquipMainViewController.m
//  AIClan
//
//  Created by hd on 2018/10/15.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "EquipMainViewController.h"
#import "MedalCell.h"
#import "LogViewController.h"
#import "WaterQualityViewController.h"
#import "NavCheckViewController.h"
#import "FishbowlControlViewController.h"
#import "NewEquipmentViewController.h"
#import "WaterLevelViewController.h"
#import "WPSetingViewController.h"
#import "EditWaterQualityViewController.h"
#import "ControlTstViewController.h"

@interface EquipMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NewEquipmentAdddelegate,NewEditedelegate>
{
    int itemWidth;
    UIScrollView *leftV;
    UIButton *warBtn;
    NSString *groupid;
    
    NSString *tempname;
    NSString *tempid;
    UILabel *warnLab;
    
    BOOL closeD;
}
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *medals;
@end

@implementation EquipMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LIGHTGRAY;
    itemWidth = 140;
    groupid = @"0";
    self.medals = [NSMutableArray new];
    [self addRightButton:@"help" secondName:@"add" action:^(int status, NSString *searchKey) {
        if (status == 1001) {   
            NewEquipmentViewController *newEquiVc = [NewEquipmentViewController new];
            newEquiVc.delegate = self;
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:newEquiVc] animated:YES completion:^{
                
            }];
        }
        else
        {
            [self.navigationController pushViewController:[LogViewController new] animated:YES];
        }
    }];
    //初始化上中下试图
    [self topViewLoad];
    [self leftListViewLoad];
    [self rightListView];
    
    tempname = @"常用";
    tempid = @"0";
//    //初始化常用数据
//    [self loadBaseRightData:@"0"acccardStr:@"常用"];
    
 

}
- (void)viewWillAppear:(BOOL)animated
{
    //每次页面刷新上 左列表数据
    [self loadTopDatas];
    [self loadLeftDatas];
    
    [self loadBaseRightData:tempid acccardStr:tempname];

}
- (void)topViewLoad{
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 193)];
    topV.backgroundColor = MainColor(1);
    topV.userInteractionEnabled = YES;
    [self.view addSubview:topV];
    UILabel *todayInfo = [[UILabel alloc] initWithFrame:CGRectMake(25, 73, self.view.width - 50, 28)];
    todayInfo.tag = 10;
    todayInfo.numberOfLines = 0;
    todayInfo.text = @"今天是 2018年07月18日 星期六 农历六月初二";
    todayInfo.font = [UIFont fontWithName:FONTNAME size:13];
    todayInfo.textColor = [UIColor whiteColor];
    [topV addSubview:todayInfo];
    
    UILabel *tempuLab = [[UILabel alloc] initWithFrame:CGRectMake(25, todayInfo.bottom - 5, 70, 80)];
    tempuLab.text = @"28";
    tempuLab.tag = 11;
    tempuLab.textAlignment = NSTextAlignmentRight;
    tempuLab.font = [UIFont systemFontOfSize:55];
    tempuLab.textColor = [UIColor whiteColor];
    [topV addSubview:tempuLab];
    
    UILabel *sL = [[UILabel alloc] initWithFrame:CGRectMake(tempuLab.right, todayInfo.bottom + 40, 20, 15)];
    sL.text = @"℃";
    sL.textAlignment = NSTextAlignmentLeft;
    sL.font = [UIFont boldSystemFontOfSize:14];
    sL.textColor = [UIColor whiteColor];
    [topV addSubview:sL];
    
    UILabel *placeLab = [[UILabel alloc] initWithFrame:CGRectMake(sL.right + 20, todayInfo.bottom + 5, 100, 60)];
    placeLab.numberOfLines = 0;
    placeLab.tag = 12;
    placeLab.text = @"武汉.洪山\n多云转中雨";
    placeLab.font = [UIFont systemFontOfSize:15];
    placeLab.textColor = [UIColor whiteColor];
    [topV addSubview:placeLab];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    placeLab.attributedText = [[NSAttributedString alloc] initWithString:placeLab.text attributes:attributes];
    
    UIImageView *promotImgv = [[UIImageView alloc] initWithFrame:CGRectMake(25, 170.5, self.view.width - 50, 45)];
    [promotImgv setImage:[UIImage imageNamed:@"warning-bg"]];
    [topV addSubview:promotImgv];
    
    UIImageView *iconImgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 23, 20)];
    [iconImgv setImage:[UIImage imageNamed:@"warning"]];
    [promotImgv addSubview:iconImgv];
    
    UIImageView *linev = [[UIImageView alloc] initWithFrame:CGRectMake(iconImgv.right + 10, 10, 0.5, 24)];
    [linev setImage:[UIImage imageNamed:@"line"]];
    [promotImgv addSubview:linev];
    
    warnLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImgv.right + 20, 0, 200, 40)];
    warnLab.text = @"暂无预警信息";
    warnLab.textAlignment = NSTextAlignmentLeft;
    warnLab.font = [UIFont systemFontOfSize:15];
    [promotImgv addSubview:warnLab];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    warnLab.alpha = 1;
    closeD = true;
}

- (void)viewDidAppear:(BOOL)animated
{
    warnLab.alpha = 0;

    closeD = false;

    [AppRequest Request_Normalpost:@"newlog" json:@{@"times":@""} controller:self completion:^(id result, NSInteger statues) {
        if ([result[@"retInt"] intValue] == 1) {
            if([result[@"retRes"] count] > 0)
                [self doRefresh:result[@"retRes"] i:0];
        }
       
     
    } failed:^(NSError *error) {
        
    }];
}

- (void)doRefresh: (NSArray *)Arr i:(int) i{
    
    if (closeD) {
        return;
    }
    __block int is = i;

    if (is == Arr.count) {
        is = 0;
    }
    warnLab.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
    } completion:^(BOOL finished) {
        warnLab.alpha = 1;
        warnLab.text = Arr[is][@"title"];
        is ++;
        [self doRefresh:Arr i:is];
    }];
  
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//      
//    });
}

- (void)leftListViewLoad{
    float h = Height_TabBar;
    leftV = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 230, 50, self.view.height - 230 - 21-h)];
    leftV.showsHorizontalScrollIndicator =NO;
    leftV.showsHorizontalScrollIndicator =YES;
    leftV.layer.cornerRadius = 4.0;
    leftV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftV];
    
    warBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 50, 57)];
    [warBtn addTarget:self action:@selector(TargetClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftV addSubview:warBtn];
    
    UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 23, 23)];
    [iconImgV setImage:[UIImage imageNamed:@"cy1"]];
    [warBtn addSubview:iconImgV];
    
    UILabel *warnLab = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImgV.bottom + 4, 50, 20)];
    warnLab.font = [UIFont fontWithName:FONTNAME size:11.0];
    [warnLab setTextColor:MainColor(1)];
    warnLab.textAlignment = NSTextAlignmentCenter;
    [warnLab setText:@"常用"];
    [warBtn addSubview:warnLab];
    UIImageView *linev = [[UIImageView alloc] initWithFrame:CGRectMake(10, warBtn.bottom, 30, 0.5)];
    linev.backgroundColor = XXColor(180, 180, 180, 1);
    [leftV addSubview:linev];

}
- (void)rightListView{
    float h = Height_TabBar;
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(66, 230, self.view.width - 74, self.view.height - 230 - 21-h)];
    leftV.layer.cornerRadius = 4.0;
    leftV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftV];
    
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftV.width, 50)];
    typeLab.layer.cornerRadius = 4.0;
    typeLab.tag = 30;
    typeLab.text = @"常用";
    typeLab.font = [UIFont fontWithName:FONTNAME size:14.0];
    typeLab.textAlignment = NSTextAlignmentLeft;
    typeLab.backgroundColor = XXColor(235, 235, 235, 1);
    [leftV addSubview:typeLab];
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 45, leftV.width, 5)];
    bottomV.backgroundColor = XXColor(235, 235, 235, 1);
    [leftV addSubview:bottomV];
    
    [self initCollectionView:leftV];
}
- (void)loadTopDatas{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"indexinfo" json:@{} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 1) {
            [(UILabel *)[self.view viewWithTag:10] setText:[NSString stringWithFormat:@"%@",result[@"retRes"][@"dates"]]];
            [(UILabel *)[self.view viewWithTag:11] setText:[NSString stringWithFormat:@"%@",result[@"retRes"][@"tq"][@"wd"]]];
            [(UILabel *)[self.view viewWithTag:12] setText:[NSString stringWithFormat:@"%@\n%@",result[@"retRes"][@"tq"][@"info"],result[@"retRes"][@"tq"][@"address"]]];
            
        }
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)loadLeftDatas
{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"yglists" json:@{} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 1) {
            
            for (UIView *subV in leftV.subviews) {
                if ( subV.tag > 0) {
                    [subV removeFromSuperview];
                }
            }
            NSMutableArray *resArr = [[NSMutableArray alloc] init];
            [resArr addObject:@{@"title":@"默认",@"id":@"-100"}];
            [resArr addObjectsFromArray: result[@"retRes"]];

            for (int k = 0; k < [resArr count]; k ++) {
                UIButton *warnLab = [[UIButton alloc] initWithFrame:CGRectMake(10, 67 + 50 * k, 30, 50)];
                warnLab.titleLabel.font = [UIFont fontWithName:FONTNAME size:11.0];
                [warnLab setTitle:[NSString stringWithFormat:@"%@",resArr[k][@"title"]] forState:UIControlStateNormal];
                warnLab.tag = [resArr[k][@"id"]intValue];
                
                [warnLab setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [warnLab setTitleColor:MainColor(1) forState:UIControlStateHighlighted];
                [warnLab setTitleColor:MainColor(1) forState:UIControlStateSelected];
                
                if ([resArr[k][@"id"]intValue] == [tempid intValue]) {
                    [warnLab setTitleColor:MainColor(1) forState:UIControlStateNormal];

                }

                [leftV addSubview:warnLab];
                [warnLab addTarget:self action:@selector(TargetClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *linev = [[UIImageView alloc] initWithFrame:CGRectMake(10, warnLab.bottom, 30, 0.5)];
                linev.tag = 99;
                linev.backgroundColor = XXColor(180, 180, 180, 1);
                [leftV addSubview:linev];
            }
            
            UIButton *setImgV = [[UIButton alloc] initWithFrame:CGRectMake(13.5, 80 + 50 * [resArr count], 23, 23)];
            setImgV.tag = 999;
            [setImgV setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
            [setImgV addTarget:self action:@selector(SetClick) forControlEvents:UIControlEventTouchUpInside];
            [leftV addSubview:setImgV];
            
            
            leftV.contentSize = CGSizeMake(50, setImgV.bottom+10);
            
        }
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}

- (void)SetClick{
    [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:[FishbowlControlViewController new]] animated:YES completion:^{
        
    }];
}

- (void)TargetClick:(UIButton *)btn{
    //变更点击状态
    [(UIImageView *) warBtn.subviews[0] setImage:[UIImage imageNamed:@"cy"]];
    [(UILabel *) warBtn.subviews[1] setTextColor:[UIColor darkGrayColor]];
    for (UIView *subV in btn.superview.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            ((UIButton *)subV).selected = NO;
        }
    }
    [self RefreshRightClickDatas:btn];
   
}
- (void)RefreshRightClickDatas:(UIButton *)btn{
    //默认鱼缸跳转到展示界面
    if (btn.tag == -100) {
        [self presentViewController:[ControlTstViewController new] animated:YES completion:^{
            
        }];
        return;
    }
    
    
    groupid = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"ygsb" json:@{@"acccardtype_id":[NSString stringWithFormat:@"%ld",btn.tag]} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 1) {
            for (UIView *labV in btn.subviews) {
                if ([labV isKindOfClass:[UILabel class]]) {
                    tempname = [(UILabel *)labV text];
                    tempid = [NSString stringWithFormat:@"%ld",btn.tag];
                    if ([[self.view viewWithTag:30] isKindOfClass:[UILabel class]]) {
                        [(UILabel *)[self.view viewWithTag:30] setText:[NSString stringWithFormat:@" %@",[(UILabel *)labV text]]];
                    }
                    break;
                }
            }
            if (btn.tag == 0) {
                [(UIImageView *) btn.subviews[0] setImage:[UIImage imageNamed:@"cy1"]];
                [(UILabel *) btn.subviews[1] setTextColor:MainColor(1)];
            }
            else
            {
                btn.selected = YES;
            }
            [self.medals removeAllObjects];
            [self.medals addObjectsFromArray:result[@"retRes"]];
            [self.medals addObject:@{@"id":@"-1",@"acccardtype_id":@"",@"card_type":@"add_device",
                                     @"title":@"",@"create_time":@"",@"is_online":@""}];
            [self.collectionView reloadData];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)loadBaseRightData:(NSString *)acccardtype_id acccardStr:(NSString *)acccardStr{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"ygsb" json:@{@"acccardtype_id":acccardtype_id} controller:self completion:^(id result, NSInteger statues) {
        [SVProgressHUD dismiss];
        if (statues == 1) {
            tempname = acccardStr;
            tempid = acccardtype_id;
            [self.medals removeAllObjects];
            [self.medals addObjectsFromArray:result[@"retRes"]];
            [self.medals addObject:@{@"id":@"-1",@"acccardtype_id":@"",@"card_type":@"add_device",
                                     @"title":@"",@"create_time":@"",@"is_online":@""}];
            [self.collectionView reloadData];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}


#pragma mark 设置CollectionView的的参数
- (void) initCollectionView:(UIView *)bgv
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width / 2 - 50, self.view.width / 2 - 50);
    flowLayout.minimumLineSpacing      = 10;
   // flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    //设置CollectionView的属性
    float h = Height_TabBar;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.view.width - 74, self.view.height - 280 - 21-h) collectionViewLayout:flowLayout]; self.collectionView.backgroundColor = [UIColor clearColor]; self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    //注册Cell
    [self.collectionView registerClass:[MedalCell class] forCellWithReuseIdentifier:@"cell"];
    [bgv addSubview:self.collectionView];
}
#pragma mark 设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { return 1; }
#pragma mark 设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.medals.count;
}
#pragma mark 设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    MedalCell *cell = (MedalCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell.imageView setImage:[UIImage imageNamed:self.medals[indexPath.row][@"card_type"]]];
    [cell.label setText:[NSString stringWithFormat:@"%@",self.medals[indexPath.row][@"title"]]];
    int onlineV =  [self.medals[indexPath.row][@"is_online"] intValue];
    cell.onlineImgV.hidden = onlineV == 0 ? NO : YES;
    if ([self.medals[indexPath.row][@"card_type"]isEqualToString:@"add_device"]) {
        cell.backgroundColor = XXColor(240, 240, 240, 1);
        [cell.imageView setFrame:CGRectMake(cell.width / 2 -40, cell.width / 2 -40, 80, 80)];
        [cell.label setBackgroundColor:[UIColor clearColor]];
        cell.onlineImgV.hidden = YES;
    }
    return cell;
    
}
#pragma mark 点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //Medal *p = self.medals[indexPath.item];

    NSString *equiID =  [NSString stringWithFormat:@"%@",self.medals[indexPath.item][@"id"]];
    NSString *equipType =  [NSString stringWithFormat:@"%@",self.medals[indexPath.item][@"card_type"]];

    if ([equiID isEqualToString:@"-1"]) {
        
        if ([tempid intValue] == 0) {
            NewEquipmentViewController *newEquiVc = [NewEquipmentViewController new];
            newEquiVc.delegate = self;
            newEquiVc.acccardtype_id = groupid;
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:newEquiVc] animated:YES completion:^{
    
            }];
        }
        else
        {
            EditWaterQualityViewController *editV = [EditWaterQualityViewController new];
            editV.acccardtype_id = tempid;
            editV.delegate = self;
            editV.acccardStr = tempname;
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:editV] animated:YES completion:^{
                
            }];
        }
      
    }
    else if([equipType isEqualToString:@"TR"])
    {
        //水质
        WaterQualityViewController *vc = [WaterQualityViewController new];
        vc.equipId = equiID;
        [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:vc] animated:YES completion:^{
            
        }];
    }
    else if ([equipType isEqualToString:@"WL"] || [equipType isEqualToString:@"WP"] || [equipType isEqualToString:@"PF"])
    {
        //水位//水泵//断电

        if ([equipType isEqualToString:@"WL"]) {
            WaterLevelViewController *watVc = [WaterLevelViewController new];

            watVc.title = @"水位报警器";
            watVc.equipId = equiID;
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:watVc] animated:YES completion:^{
                
            }];

        }
        else if ([equipType isEqualToString:@"WP"]) {
            WPSetingViewController *watVc = [WPSetingViewController new];
            watVc.title = @"智能水泵";

            watVc.equipId = equiID;
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:watVc] animated:YES completion:^{
                
            }];

        }
        else if ([equipType isEqualToString:@"PF"]) {
            WaterLevelViewController *watVc = [WaterLevelViewController new];

            watVc.title = @"断电报警器";
            watVc.equipId = equiID;
            [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:watVc] animated:YES completion:^{
                
            }];
        }
      
    }
 
    
}
#pragma mark 设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 定义返回的新增设备刷新常用模块协议
- (void)didRereshNewEquipment
{
   // [self loadBaseRightData:@"0"acccardStr:@"常用"];
}

- (void)didRereshEidteQuality:(NSString *)acccardtype_id acccardStr:(NSString *)acccardStr
{
    //[self loadBaseRightData:acccardtype_id acccardStr:@"常用"];

}
@end
