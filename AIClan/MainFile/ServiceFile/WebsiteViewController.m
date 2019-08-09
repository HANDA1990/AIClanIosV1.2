//
//  WebsiteViewController.m
//  AIClan
//
//  Created by hd on 2018/10/17.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "WebsiteViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationManager.h>


@interface WebsiteViewController ()<UITableViewDelegate,UITableViewDataSource,BMKLocationAuthDelegate,BMKLocationManagerDelegate,UITextFieldDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *orderinfoArr;
    BMKLocationManager *_locationManager;
    UITextField *searchTxt;
}
@end

@implementation WebsiteViewController

- (void)viewDidLoad {
    UIView *navColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    [navColor setBackgroundColor:NavColor];
    [self.view addSubview:navColor];
    self.view.backgroundColor = XXColor(245, 245, 245, 1);
    [self searchReload];
    [self loadTableView];
    [self locationReload];

}
- (void)searchReload{
    float hb = Height_NavBar;
    searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(10, hb + 10, self.view.width - 20, 45)];
    searchTxt.backgroundColor = [UIColor whiteColor];
    searchTxt.delegate = self;
    searchTxt.layer.cornerRadius = 4.0;
    searchTxt.returnKeyType = UIReturnKeyDone;
    searchTxt.placeholder = @"请输入搜索关键字";
    [self.view addSubview:searchTxt];
    
}
- (void)loadTableView{
    float hb = Height_NavBar;

    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,searchTxt.bottom+5, self.view.frame.size.width, self.view.frame.size.height - searchTxt.bottom-5) style:UITableViewStylePlain];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor whiteColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    
}
- (void)viewWillAppear:(BOOL)animated{
  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderinfoArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imagV.backgroundColor = [UIColor lightGrayColor];
        imagV.layer.masksToBounds = YES;
        imagV.layer.cornerRadius = imagV.width / 2;
        imagV.tag = 100;
        imagV.image = [UIImage imageNamed:@"pl_empty"];
        [cell.contentView addSubview:imagV];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imagV.right + 10, 10, self.view.width - 120, 20)];
        [titleLab setText:@"武汉市盘龙水族水族咨询处"];
        titleLab.tag = 101;
        titleLab.font = [UIFont fontWithName:FONTNAME size:15.0];
        [cell.contentView addSubview:titleLab];
        
        UILabel *longLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width / 2, 10,  self.view.width / 2 - 10, 20)];
        longLab.tag = 102;
        //longLab.numberOfLines = 0;
        longLab.font = [UIFont fontWithName:FONTNAME size:13.0];
        [longLab setText:@"12KM"];
        longLab.textColor = XXColor(252, 100, 0, 1);
        [cell.contentView addSubview:longLab];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(imagV.right + 10, titleLab.bottom, 80, 20)];
        infoLab.tag = 103;
        infoLab.numberOfLines = 0;
        infoLab.font = [UIFont fontWithName:FONTNAME size:14.0];
        [infoLab setText:@"服务星级："];
        [cell.contentView addSubview:infoLab];
        
        for (int i = 0; i < 5; i ++) {
            UIImageView *wxV = [[UIImageView alloc] initWithFrame:CGRectMake(infoLab.right + 25 * i, titleLab.bottom - 5, 20, 20)];
            wxV.layer.cornerRadius = imagV.width / 2;
            wxV.tag = 1000+i;
            wxV.image = [UIImage imageNamed:@"wx_yes"];
            [cell.contentView addSubview:wxV];
        }
        
        
        
        UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(imagV.right + 10, infoLab.bottom+5, self.view.width - 120, 10)];
        infoLab2.tag = 104;
        infoLab2.numberOfLines = 0;
        infoLab2.font = [UIFont fontWithName:FONTNAME size:13.0];
        [infoLab2 setText:@"服务项目：鱼类疫苗、营养饲料、增氧器材"];
        [cell.contentView addSubview:infoLab2];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, infoLab2.bottom + 10, self.view.width, 10)];
        lineV.backgroundColor = XXColor(245, 245, 245, 1);
        [cell.contentView addSubview:lineV];
    }
    UIImageView *imagV = (UIImageView *)[cell.contentView viewWithTag:100];
    [imagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,orderinfoArr[indexPath.row][@"file_url"]]] placeholderImage:EMPTYIMG];
    int nub = [orderinfoArr[indexPath.row][@"xingji"] intValue];
    for (int k = 0; k < 5; k ++) {
        UIImageView *imagV = (UIImageView *)[cell.contentView viewWithTag:1000+k];
        if (k < nub) {
            [imagV setImage:[UIImage imageNamed:@"wx_yes"]];
        }
        else
        {
            [imagV setImage:[UIImage imageNamed:@"wx_no"]];

        }
    }

    
    UILabel *titleV = (UILabel *)[cell.contentView viewWithTag:101];
    [titleV setText:orderinfoArr[indexPath.row][@"title"]];
    
    UILabel *longLab = (UILabel *)[cell.contentView viewWithTag:102];
    [longLab setText:orderinfoArr[indexPath.row][@"jl"]];


    UILabel *infoLab2 = (UILabel *)[cell.contentView viewWithTag:104];
    [infoLab2 setText:[NSString stringWithFormat:@"服务项目：%@",orderinfoArr[indexPath.row][@"sub_title"]]];


    return cell;
}

- (void)locationReload{
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"19T9AHdGWlhMgUHDFOOFt6C7L6YAyvkH" authDelegate:self];
    [self locationManager];
}
- (void)locationManager{
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
    [_locationManager startUpdatingLocation];

}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error
{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {//得到定位信息，添加annotation
        if (location.location) {
            NSLog(@"LOC = %@",location.location);
            [self handleDatas:[NSString stringWithFormat:@"%lf",location.location.coordinate.latitude] lng:[NSString stringWithFormat:@"%lf",location.location.coordinate.longitude]];
        }
        if (location.rgcData) {
            
            NSLog(@"rgc = %@",[location.rgcData description]);
        }
        [_locationManager stopUpdatingLocation];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)handleDatas:(NSString *)lat lng:(NSString *)lng{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"wangdian" json:@{@"lng":lng,@"lat":lat,@"title":searchTxt.text,@"page":@"1",@"page_size":@"50"} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            orderinfoArr = result[@"retRes"];
            [_Maintableview reloadData];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
@end
