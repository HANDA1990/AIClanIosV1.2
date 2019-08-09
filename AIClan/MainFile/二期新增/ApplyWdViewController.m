//
//  ApplyWdViewController.m
//  AIClan
//
//  Created by hd on 2019/5/20.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "ApplyWdViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "LLImagePickerView.h"

@interface ApplyWdViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    UIView *headV;

}
@end

@implementation ApplyWdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请加盟";
    float hb = Height_StatusBar;

    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,hb, self.view.frame.size.width, self.view.frame.size.height - hb) style:UITableViewStylePlain];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
}

- (UIView *)loadTopView{
    if (headV)
        return headV;
    
    headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    [self addTextFeild:10 text:@"门店名称"];
    [self addTextView:10 + 40 +10];
    [self addTextFeild:10 + 180 +20 text:@"门店位置"];
    [self addTextFeild:10 + 180 +20 + 40 + 10 text:@"详细地址"];
    [self addTextFeild:10 + 180 +20 + (40 + 10)*2 text:@"联系电话"];
    [self addImgHandleView];
 
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 125, 520, 250, 40)];
    enterBtn.backgroundColor =NavColor;
    enterBtn.layer.cornerRadius = 15;
    [enterBtn setTitle:@"提      交" forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont fontWithName:@"STXinwei" size:25];
    [headV addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(HandleEnter) forControlEvents:UIControlEventTouchUpInside];
  
    UILabel *mdLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, enterBtn.bottom + 5, self.view.width - 20, 40)];
    mdLab2.text = @"招商热线：4000888888";
    mdLab2.textAlignment = NSTextAlignmentCenter;
    mdLab2.font = [UIFont fontWithName:@"STXinwei" size:25];
    [headV addSubview:mdLab2];
    
    return headV;

}
- (void)HandleEnter
{
    
}
- (void)addTextFeild:(float)originY text:(NSString *)text{
    UIView *mdbgV = [[UIView alloc] initWithFrame:CGRectMake(15, originY, self.view.width - 30, 40)];
    mdbgV.layer.cornerRadius = 4;
    mdbgV.backgroundColor = [UIColor whiteColor];
    [headV addSubview:mdbgV];
    
    UILabel *mdLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    mdLab.text = text;
    mdLab.font = [UIFont fontWithName:@"STXinwei" size:20];
    [mdbgV addSubview:mdLab];
    
    UITextField *mdF = [[UITextField alloc] initWithFrame:CGRectMake(mdLab.right, 0, mdbgV.width - mdLab.right, 40)];
    [mdbgV addSubview:mdF];
}

- (void)addTextView:(float)originY{
    UIView *mdbgV = [[UIView alloc] initWithFrame:CGRectMake(15, originY, self.view.width - 30, 140)];
    mdbgV.layer.cornerRadius = 4;
    mdbgV.backgroundColor = [UIColor whiteColor];
    [headV addSubview:mdbgV];
    
    UILabel *mdLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    mdLab.text = @"门店简介";
    mdLab.font = [UIFont fontWithName:@"STXinwei" size:20];
    [mdbgV addSubview:mdLab];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, mdLab.bottom, mdbgV.width - 30, 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [mdbgV addSubview:lineV];
    
    UITextView *mdF = [[UITextView alloc] initWithFrame:CGRectMake(10, lineV.bottom, mdbgV.width - mdLab.right, 100)];
    [mdbgV addSubview:mdF];
}

- (void)addImgHandleView
{
    UIView *mdbgV = [[UIView alloc] initWithFrame:CGRectMake(15, 360, self.view.width - 30, 100)];
    mdbgV.layer.cornerRadius = 4;
    mdbgV.backgroundColor = [UIColor whiteColor];
    [headV addSubview:mdbgV];
    
    UILabel *mdLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    mdLab.text = @"上传图片";
    mdLab.font = [UIFont fontWithName:@"STXinwei" size:20];
    [mdbgV addSubview:mdLab];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, mdLab.bottom, mdbgV.width - 30, 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [mdbgV addSubview:lineV];
    
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0,28, mdbgV.width, 0) CountOfRow:3];
    pickerV.tag = 1000;
    pickerV.type = LLImageTypePhotoAndCamera;
    pickerV.maxImageSelected = 8;
    pickerV.allowPickingVideo = NO;
    [mdbgV addSubview: pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  self.view.height;
//    if (!headV) {
//        float hb = Height_NavBar;
//        return  self.view.height + hb;
//    }
//    return _connectViewBackgroudView.bottom;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self loadTopView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.01;
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
    }
    return cell;
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
