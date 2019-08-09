//
//  EditWaterQualityViewController.m
//  AIClan
//
//  Created by hd on 2018/10/26.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "EditWaterQualityViewController.h"
#import "MedalCell.h"

@interface EditWaterQualityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UITextField *txtFeild;
}
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *medals;

@property (nonatomic, strong) NSMutableArray *selectArr;
@end


@implementation EditWaterQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addRightButton:@"保存" imageName:@"" action:^(int status, NSString *searchKey) {
        NSMutableArray *ids = [NSMutableArray new];
        for (NSDictionary *selectDic in self.selectArr) {
            if ([selectDic[@"state"] intValue] == 1) {
                [ids addObject: selectDic[@"id"]];
            }
        }
        
        if ([self.acccardtype_id intValue] == 0) {
            if (!txtFeild.text.length) {
                [self.view showResult:@"请填写名称"];
            }
            else
            {
                [AppRequest Request_Normalpost:@"tjyg" json:@{@"title":txtFeild.text} controller:self completion:^(id result, NSInteger statues) {
                    if (statues == 1) {
                        NSString *accid = result[@"retRes"][@"id"];
                        [self.navigationController popViewControllerAnimated:YES];
                        [AppRequest Request_Normalpost:@"tjsbdyg" json:@{@"acccardtype_id":accid,@"ids":ids} controller:self completion:^(id result, NSInteger statues) {
                            if (statues == 1) {
                                
                            }
                            else
                            {
                                [self.view showResult:result[@"retErr"]];
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                    }
                    else
                    {
                        [self.view showResult:result[@"retErr"]];
                    }
                } failed:^(NSError *error) {
                    
                }];
            }
            return ;
        }
        
        
        
        if (!ids.count) {
            [self.view showResult:@"请至少添加一个设备"];
        }
        else
        {
            [AppRequest Request_Normalpost:@"tjsbdyg" json:@{@"acccardtype_id":self.acccardtype_id,@"ids":ids} controller:self completion:^(id result, NSInteger statues) {
                if (statues == 1) {
                    if ([self.parentViewController.childViewControllers count] > 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [self dismissViewControllerAnimated:YES completion:^{
                            if ([self.delegate respondsToSelector:@selector(didRereshEidteQuality:acccardStr:)]) {
                                [self.delegate didRereshEidteQuality:self.acccardtype_id acccardStr:self.acccardStr];
                            }
                        }];

                    }
                }
                else
                {
                    [self.view showResult:result[@"retErr"]];
                }
            } failed:^(NSError *error) {
                
            }];
        }
    
        
        if (!txtFeild.text.length) {
            [self.view showResult:@"请填写名称"];
        }
        else
        {
            [AppRequest Request_Normalpost:@"xgyg" json:@{@"id":self.acccardtype_id,@"title":txtFeild.text} controller:self completion:^(id result, NSInteger statues) {
                [self.view showResult:result[@"retErr"]];

            } failed:^(NSError *error) {
                
            }];
        }
    }];
    
    self.title = @"编辑鱼缸";
    self.medals = [NSMutableArray new];
    self.selectArr = [NSMutableArray new];
    
    [self viewReload];
    
    [self ListReload];
    [self loadBaseRightData];
}
- (void)viewReload{
    self.view.backgroundColor = [UIColor whiteColor];
    
    float ht = Height_NavBar;
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(15, ht + 10, self.view.width-30, 30)];
    topLab.text = @"鱼缸名称：";
    topLab.font = [UIFont fontWithName:FONTNAME size:16.0];
    topLab.textColor = [UIColor darkGrayColor];
    [self.view addSubview:topLab];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, topLab.bottom + 5, 25, 25)];
    [imgV setImage:[UIImage imageNamed:@"fishBowl"]];
    [self.view addSubview:imgV];
    
    txtFeild = [[UITextField alloc] initWithFrame:CGRectMake(imgV.right + 10, topLab.bottom, self.view.width - imgV.right - 10, 40)];
    txtFeild.font = [UIFont fontWithName:FONTNAME size:14.0];
    txtFeild.text = self.acccardStr;
    txtFeild.textColor = [UIColor darkGrayColor];

    [self.view addSubview:txtFeild];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, txtFeild.bottom, self.view.width - 20, 0.5)];
    [lineV setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:lineV];

}
- (void)loadBaseRightData{
    [SVProgressHUD show];
    
    if ([self.acccardtype_id intValue] == 0) {
        [AppRequest Request_Normalpost:@"ygsb" json:@{@"acccardtype_id":@"0"} controller:self completion:^(id result, NSInteger statues) {
            [SVProgressHUD dismiss];
            if (statues == 1) {
                [self.selectArr removeAllObjects];
                [self.medals removeAllObjects];
                
                for (int k = 0; k < [result[@"retRes"] count]; k ++) {
                    [self.selectArr addObject:@{@"state":@0,@"id":result[@"retRes"][k][@"id"]}];
                }
                [self.medals addObjectsFromArray:result[@"retRes"]];
                [self.collectionView reloadData];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
        [self.collectionView reloadData];
    }
    else
    {
        [AppRequest Request_Normalpost:@"ygsb" json:@{@"acccardtype_id":self.acccardtype_id} controller:self completion:^(id result, NSInteger statues) {
            [SVProgressHUD dismiss];
            if (statues == 1) {
                [self.selectArr removeAllObjects];
                [self.medals removeAllObjects];
                [self.medals addObjectsFromArray:result[@"retRes"]];
                for (int k = 0; k < [result[@"retRes"] count]; k ++) {
                    [self.selectArr addObject:@{@"state":@1,@"id":result[@"retRes"][k][@"id"]}];
                }
                [AppRequest Request_Normalpost:@"ygsb" json:@{@"acccardtype_id":@"0"} controller:self completion:^(id result, NSInteger statues) {
                    [SVProgressHUD dismiss];
                    if (statues == 1) {
                        for (int k = 0; k < [result[@"retRes"] count]; k ++) {
                            [self.selectArr addObject:@{@"state":@0,@"id":result[@"retRes"][k][@"id"]}];
                        }
                        [self.medals addObjectsFromArray:result[@"retRes"]];
                        [self.collectionView reloadData];
                    }
                } failed:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    
                }];
                [self.collectionView reloadData];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
    }
    

}
- (void)ListReload{
    float ht = Height_NavBar;

    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(15, ht + 90, self.view.width-30, 30)];
    topLab.text = @"设备列表：";
    topLab.font = [UIFont fontWithName:FONTNAME size:16.0];
    topLab.textColor = [UIColor darkGrayColor];
    [self.view addSubview:topLab];
    
    [self reloadDatas];
}
- (void)reloadDatas{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width / 2 - 30, self.view.width / 2 - 30);
    flowLayout.minimumLineSpacing      = 10;
    // flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //设置CollectionView的属性
    float h = Height_TabBar;
    float ht = Height_NavBar;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 120 + ht, self.view.width - 40, self.view.height - 130 - ht) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    //注册Cell
    [self.collectionView registerClass:[MedalCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}
#pragma mark 设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark 设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.medals.count;
}
#pragma mark 设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    MedalCell *cell = (MedalCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.layer.cornerRadius = 4.0;
    [cell.imageView setFrame:CGRectMake(cell.width / 2 -40, cell.width / 2 -40, 80, 80)];
    [cell.imageView setImage:[UIImage imageNamed:self.medals[indexPath.row][@"card_type"]]];
    [cell.label setText:self.medals[indexPath.row][@"title"]];
    [cell.selectImgV setHidden:NO];
    cell.onlineImgV.hidden = YES;
    if ([self.selectArr[indexPath.row][@"state"]intValue] == 0) {
        [cell.selectImgV setImage:[UIImage imageNamed:@"checkbox"]];
    }
    else if ([self.selectArr[indexPath.row][@"state"]intValue] == 1) {
        [cell.selectImgV setImage:[UIImage imageNamed:@"checked"]];
    }

    return cell;
    
}
#pragma mark 点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //Medal *p = self.medals[indexPath.item];
    int selectInt = [self.selectArr[indexPath.item][@"state"] intValue];
    if (selectInt == 0) {
        selectInt = 1;
    }
    else{
        selectInt = 0;
    }
    [self.selectArr setObject:@{@"state":[NSNumber numberWithInteger:selectInt],@"id":self.selectArr[indexPath.item][@"id"]} atIndexedSubscript:indexPath.item];
    [self.collectionView reloadData];
    NSLog(@"---------------------");
    
    
}
#pragma mark 设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    
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
