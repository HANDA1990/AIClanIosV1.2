//
//  WaterQualitySetViewController.m
//  AIClan
//
//  Created by hd on 2018/12/16.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "WaterQualitySetViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CircleTwoViewController.h"

@interface WaterQualitySetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    
}

@end

@implementation WaterQualitySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据设置";
    
   
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"sw",@"img",@"报警开关设置",@"title",@"未设置",@"state", nil];
    
    NSMutableArray *firstArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"报警开关",@"title",@"未设置",@"state",@-1,@"value", nil];
    [firstArr addObject:dic];
    [dataDic setObject:firstArr forKey:@"arr"];
    
    NSMutableDictionary *dataDic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"sw",@"img",@"水温(单位C)",@"title",@"未设置",@"state", nil];
    
    NSMutableArray *firstArr1 = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"极高值",@"title",@"未设置",@"state",@"",@"value", nil];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"高值",@"title",@"未设置",@"state",@"",@"value", nil];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"极低值",@"title",@"未设置",@"state",@"",@"value", nil];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"低值",@"title",@"未设置",@"state",@"",@"value", nil];

    [firstArr1 addObject:dic1];
    [firstArr1 addObject:dic2];
    [firstArr1 addObject:dic3];
    [firstArr1 addObject:dic4];
    [dataDic1 setObject:firstArr1 forKey:@"arr"];
    
    NSMutableDictionary *dataDic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ph",@"img",@"PH值",@"title",@"未设置",@"state", nil];
    
    
    NSMutableArray *firstArr2 = [[NSMutableArray alloc] init];
  
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"高值",@"title",@"未设置",@"state",@"",@"value", nil];
    NSMutableDictionary *dic6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"低值",@"title",@"未设置",@"state",@"",@"value", nil];
    
    [firstArr2 addObject:dic5];
    [firstArr2 addObject:dic6];

    [dataDic2 setObject:firstArr2 forKey:@"arr"];
    
    NSMutableDictionary *dataDic3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"tds",@"img",@"TDS基准值设置",@"title",@"未设置",@"state", nil];
    NSMutableArray *firstArr3 = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableDictionary *dic7 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"基准值",@"title",@"未设置",@"state",@"",@"value", nil];

    [firstArr3 addObject:dic7];
    [dataDic3 setObject:firstArr3 forKey:@"arr"];
    
    NSMutableDictionary *dataDic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"sbjy",@"img",@"设备校验",@"title",@"未设置",@"state", nil];
    NSMutableArray *firstArr4 = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableDictionary *dic8 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"校验数据（1）",@"title",@"未设置",@"state",@"",@"value", nil];
    NSMutableDictionary *dic9 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"校验数据（2）",@"title",@"未设置",@"state",@"",@"value", nil];

    [firstArr4 addObject:dic8];
    [firstArr4 addObject:dic9];

    [dataDic4 setObject:firstArr4 forKey:@"arr"];
    
    _dataArray = [NSMutableArray new];
    [_dataArray addObject:dataDic];
    [_dataArray addObject:dataDic1];
    [_dataArray addObject:dataDic2];
    [_dataArray addObject:dataDic3];
    [_dataArray addObject:dataDic4];

    [self addRightButton:@"保存" imageName:@"" action:^(int status, NSString *searchKey) {
        NSMutableDictionary *handleDic;

        handleDic = [NSMutableDictionary new];
        
        NSMutableDictionary *kgDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.equipId,@"id",_dataArray[0][@"arr"][0][@"state"],@"v_1", nil];

        [AppRequest Request_Normalpost:@"szbjkg" json:kgDic controller:self completion:^(id result, NSInteger statues) {
            [self.view showResult:result[@"retErr"]];
            if (statues == 0) {
                [_dataArray[0][@"arr"][0] setObject:@"0" forKey:@"state"];
                [_Maintableview reloadData];
                return ;
            }
        } failed:^(NSError *error) {
            
        }];
        
        
        NSMutableDictionary *kgDic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       self.equipId,@"id",
                                       _dataArray[1][@"arr"][0][@"value"],@"v_4",
                                       _dataArray[1][@"arr"][1][@"value"],@"v_3",
                                       _dataArray[1][@"arr"][2][@"value"],@"v_2",
                                       _dataArray[1][@"arr"][3][@"value"],@"v_1", nil];
        [AppRequest Request_Normalpost:@"szbjwd" json:kgDic2 controller:self completion:^(id result, NSInteger statues) {
            [self.view showResult:result[@"retErr"]];

        } failed:^(NSError *error) {
            
        }];
        
        NSMutableDictionary *kgDic3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       self.equipId,@"id",
                                       _dataArray[2][@"arr"][0][@"value"],@"v_2",
                                       _dataArray[2][@"arr"][1][@"value"],@"v_1", nil];
        [AppRequest Request_Normalpost:@"szbjph" json:kgDic3 controller:self completion:^(id result, NSInteger statues) {
            [self.view showResult:result[@"retErr"]];

        } failed:^(NSError *error) {
            
        }];
            
        
        
        NSMutableDictionary *kgDic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.equipId,@"id",_dataArray[3][@"arr"][0][@"value"],@"v_1", nil];
        [AppRequest Request_Normalpost:@"szbjtds" json:kgDic4 controller:self completion:^(id result, NSInteger statues) {
            [self.view showResult:result[@"retErr"]];

        } failed:^(NSError *error) {
            
        }];
        
        
        if ([_dataArray[4][@"arr"][0][@"value"]intValue] == 0) {
            return;
        }
        
        
        NSMutableDictionary *kgDic5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       self.equipId,@"id",
                                       _dataArray[4][@"arr"][0][@"value"],@"ph_value",
                                       @"1",@"num", nil];
        [AppRequest Request_Normalpost:@"phjz" json:kgDic5 controller:self completion:^(id result, NSInteger statues) {
            [self.view showResult:result[@"retErr"]];
            if (status == 1) {
                if ([_dataArray[4][@"arr"][1][@"value"]intValue] == 0) {
                    return;
                }
                NSMutableDictionary *kgDic6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               self.equipId,@"id",
                                               _dataArray[4][@"arr"][1][@"value"],@"ph_value",
                                               @"2",@"num", nil];
                [AppRequest Request_Normalpost:@"phjz" json:kgDic6 controller:self completion:^(id result, NSInteger statues) {
                    [self.view showResult:result[@"retErr"]];
                    
                } failed:^(NSError *error) {
                    
                }];
            }
        } failed:^(NSError *error) {
            
        }];
      
    }];
    [self loadDs];

}
- (void)viewWillAppear:(BOOL)animated
{
    [_Maintableview reloadData];
}


- (NSString *)stateStr:(NSString *)state
{
    NSString *restr;
    switch ([state intValue]) {
        case 0:
            restr = @"未设置";
            break;
        case 1:
            restr = @"正在设置";
            break;
        case 2:
            restr = @"设置成功";
            break;
        case 3:
            restr = @"设置失败";
            break;
        default:
            break;
    }
    return restr;
}
- (void)loadDs{
    [AppRequest Request_Normalpost:@"kginfo" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary * rsDic = result[@"retRes"];
            [_dataArray[0] setValue:[self stateStr:rsDic[@"sz_status"]] forKey:@"state"];
            [_dataArray[0][@"arr"][0] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_1"]] forKey:@"state"];
            
        }
        [self loadDs2];
    } failed:^(NSError *error) {
        
    }];
    
}
- (void)loadDs2{
    [AppRequest Request_Normalpost:@"bjwdinfo" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary * rsDic = result[@"retRes"];
            [_dataArray[1] setValue:[self stateStr:rsDic[@"sz_status"]] forKey:@"state"];
            [_dataArray[1][@"arr"][0] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_4"]] forKey:@"value"];
            [_dataArray[1][@"arr"][1] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_3"]] forKey:@"value"];
            [_dataArray[1][@"arr"][2] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_2"]] forKey:@"value"];
            [_dataArray[1][@"arr"][3] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_1"]] forKey:@"value"];
        }
        [self loadDs3];

    } failed:^(NSError *error) {
        
    }];
}
- (void)loadDs3{
    [AppRequest Request_Normalpost:@"phinfo" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        
        if (statues == 1) {
            NSDictionary * rsDic = result[@"retRes"];
            [_dataArray[2] setValue:[self stateStr:rsDic[@"sz_status"]] forKey:@"state"];
            [_dataArray[2][@"arr"][0] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_2"]] forKey:@"value"];
            [_dataArray[2][@"arr"][1] setObject:[NSString stringWithFormat:@"%@",rsDic[@"v_1"]] forKey:@"value"];
            [_Maintableview reloadData];
        }
        [self loadDs4];

    } failed:^(NSError *error) {
        
    }];
}
- (void)loadDs4{
    [AppRequest Request_Normalpost:@"tdsinfo" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary * rsDic = result[@"retRes"];
            [_dataArray[3] setValue:[self stateStr:rsDic[@"sz_status"]] forKey:@"state"];
            _dataArray[3][@"arr"][0][@"value"] = [NSString stringWithFormat:@"%@",rsDic[@"v_1"]];
            
            [self loadDs5];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)loadDs5{
    
    [AppRequest Request_Normalpost:@"phjzinfo" json:@{@"id":self.equipId} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSDictionary * rsDic = result[@"retRes"];
            [_dataArray[4] setValue:[self strload:rsDic[@"sz_status"]] forKey:@"state"];
            
            [self LoadTable];

//            [_Maintableview reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
}

-(NSString *)strload:(NSString *)state{
    NSString *restr;
    switch ([state intValue]) {
        case 0:
            restr = @"未校准";
            break;
        case 1:
            restr = @"开始校准";
            break;
        case 2:
            restr = @"第一次校准成功";
            break;
        case 3:
            restr = @"第二次校准开始";
            break;
        case 4:
            restr = @"校准成功";
            break;
        case 5:
            restr = @"校准失败";
            break;
        default:
            break;
    }
    return restr;
}
- (void)LoadTable{
    
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor whiteColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section][@"arr"]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40.5)];
    UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [headV addSubview:logoImgV];
    [logoImgV setImage:[UIImage imageNamed:_dataArray[section][@"img"]]];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(logoImgV.right + 5, 0, self.view.width - logoImgV.right - 100, 40)];
    [infoLab setText:_dataArray[section][@"title"]];
  
    [headV addSubview:infoLab];
    
    UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(infoLab.right, 0, 80, 40)];
    stateLab.textColor = NavColor;
    stateLab.textAlignment = NSTextAlignmentRight;
    stateLab.text = _dataArray[section][@"state"];
    [headV addSubview:stateLab];
    
    UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(0, stateLab.bottom, self.view.width, .5)];
    [linev setBackgroundColor:[UIColor blackColor]];
    [headV addSubview: linev];
    return headV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    [footV setBackgroundColor:XXColor(220, 220, 220, 1)];
    return footV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.width/2, 40)];
        titleLab.tag = 1000;
        [cell.contentView addSubview:titleLab];
        titleLab.textColor = [UIColor grayColor];
        titleLab.font = [UIFont systemFontOfSize:15.0];
        titleLab.text = @"报警开关设置";
        
        UISwitch *  switchB = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.width - 60, 5, 60, 30)];
        [cell.contentView addSubview:switchB];
        switchB.tag = 1001;

        [switchB addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
        
        UILabel *  valueLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100, 5, 60, 30)];
        [cell.contentView addSubview:valueLab];
        [valueLab setTextColor:XXColor(180, 180, 180, 1)];
        [valueLab setTextAlignment:NSTextAlignmentRight];
        valueLab.text = @"33.5";
        valueLab.tag = 1002;
        
        UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(valueLab.right, 5, 30, 30)];
        [logoImgV setImage:[UIImage imageNamed:@"morese"]];
        logoImgV.tag = 1003;
        [cell.contentView addSubview:logoImgV];
        
        UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(20, 40, self.view.width-20, .5)];
        [linev setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview: linev];
        
    }
    NSDictionary *dic =_dataArray[indexPath.section][@"arr"][indexPath.row];
    [(UILabel *)[cell.contentView viewWithTag:1000] setText:[NSString stringWithFormat:@"%@",dic[@"title"]]];
    if ([dic[@"value"] intValue] == -1) {
        [[cell.contentView viewWithTag:1001] setHidden:NO];
        [(UISwitch *)[cell.contentView viewWithTag:1001] setOn:[dic[@"state"] intValue] == 1 ? YES :NO];
        [[cell.contentView viewWithTag:1002] setHidden:YES];
        [[cell.contentView viewWithTag:1003] setHidden:YES];

    }
    else{
        [[cell.contentView viewWithTag:1001] setHidden:YES];
        [[cell.contentView viewWithTag:1002] setHidden:NO];
        [(UILabel *)[cell.contentView viewWithTag:1002] setText:[NSString stringWithFormat:@"%@",dic[@"value"]]];
        [[cell.contentView viewWithTag:1003] setHidden:NO];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =_dataArray[indexPath.section][@"arr"][indexPath.row];
    
    CircleTwoViewController *vc = [CircleTwoViewController new];
    vc.v_x = [NSString stringWithFormat:@"%@",dic[@"value"]];
//    vc.handleInfo = handleDic;
    if (indexPath.section == 1) {
        vc.baseFloat = 60.0;
        vc.addFloat = 0.0;
        vc.title = [NSString stringWithFormat:@"水温%@",dic[@"title"]];
        
        if (indexPath.row == 0) {
            vc.handleInfo = _dataArray[1][@"arr"][0];
        }
        else if (indexPath.row == 1){
            vc.handleInfo = _dataArray[1][@"arr"][1];

        }
        else if (indexPath.row == 2){
            vc.handleInfo = _dataArray[1][@"arr"][2];

        }
        else if (indexPath.row == 3){
            vc.handleInfo = _dataArray[1][@"arr"][3];

        }
    }
    else if (indexPath.section == 2){
        vc.baseFloat = 14.0;
        vc.addFloat = 0.0;
        vc.title = [NSString stringWithFormat:@"PH%@",dic[@"title"]];
        if (indexPath.row == 0) {
            vc.handleInfo = _dataArray[2][@"arr"][0];
        }
        else if (indexPath.row == 1){
            vc.handleInfo = _dataArray[2][@"arr"][1];
            
        }
    }
    else if (indexPath.section == 3){
        vc.title = @"TDS基准值";
        vc.baseFloat = 1500.0;
        vc.addFloat = 0.0;
        if (indexPath.row == 0) {
            vc.handleInfo = _dataArray[3][@"arr"][0];
        }
     
    }
    else if (indexPath.section == 4){
        vc.title = [NSString stringWithFormat:@"%@",dic[@"title"]];
        vc.baseFloat = 12.0;
        vc.addFloat = 2.0;
        if (indexPath.row == 0) {
            vc.handleInfo = _dataArray[4][@"arr"][0];
        }
        else if (indexPath.row == 1){
            vc.handleInfo = _dataArray[4][@"arr"][1];
            
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)valueChanged:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *v_1s;
    if (isButtonOn) {
        v_1s = @"1";
    }else {
        v_1s = @"0";
    }
    [_dataArray[0][@"arr"][0] setObject:v_1s forKey:@"state"];

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
