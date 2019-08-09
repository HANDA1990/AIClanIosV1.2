//
//  MemoDetailViewController.m
//  AIClan
//
//  Created by hd on 2018/11/6.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "MemoDetailViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "LYSDatePickerController.h"

@interface MemoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LYSDatePickerSelectDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSDictionary *orderinfoDic;
    NSString * txtfstr;
    NSString * txtvstr;
    NSString * timevstr;

}
@end

@implementation MemoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.memoType == 0) {
        [self addRightButton:@"提交" imageName:@"" action:^(int status, NSString *searchKey) {
            [SVProgressHUD show];
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [AppRequest Request_Normalpost:@"tjbwxx" json:@{@"title":[NSString stringWithFormat:@"%@",txtfstr],@"contents":[NSString stringWithFormat:@"%@",txtvstr],@"tx_time":timevstr ? timevstr : @""} controller:self completion:^(id result, NSInteger statues) {
                if (statues == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
                [SVProgressHUD dismiss];
                
            } failed:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }];
    }
    else if (self.memoType == 1){
        [SVProgressHUD show];
        [AppRequest Request_Normalpost:@"bwxxinfo" json:@{@"id":self.idStr} controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                orderinfoDic = result[@"retRes"];
                [_Maintableview reloadData];
            }
            [SVProgressHUD dismiss];
            
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
   

    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,65, self.view.frame.size.width, self.view.frame.size.height - 65) style:UITableViewStylePlain];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor whiteColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    return self.view.height;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.view.backgroundColor;
    }
    for (UIView *cellV in cell.contentView.subviews) {
        [cellV removeFromSuperview];
    }
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width- 40, 40)];
    title.text = @"标题：";
    [cell.contentView addSubview:title];
    
    UITextField *txtF = [[UITextField alloc] initWithFrame:CGRectMake(20, title.bottom, self.view.width - 40, 40)];
    txtF.layer.cornerRadius = 4.0;
    txtF.delegate = self;
    txtF.text = orderinfoDic[@"title"];
    txtF.returnKeyType = UIReturnKeyDone;
    txtF.layer.borderWidth = 0.5f;
    txtF.backgroundColor = [UIColor whiteColor];
    txtF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.contentView addSubview:txtF];
    if (self.memoType == 1)
        txtF.enabled = NO;
    
    UILabel *titlex = [[UILabel alloc] initWithFrame:CGRectMake(20, txtF.bottom, self.view.width- 40, 40)];
    titlex.text = @"正文：";
    [cell.contentView addSubview:titlex];
    
    UITextView *infoTxt = [[UITextView alloc] initWithFrame:CGRectMake(20, titlex.bottom, self.view.width- 40, 120)];
    [cell.contentView addSubview:infoTxt];
    infoTxt.text = orderinfoDic[@"contents"];
    infoTxt.returnKeyType = UIReturnKeyDone;
    infoTxt.delegate = self;
    infoTxt.layer.cornerRadius = 4.0;
    infoTxt.layer.borderWidth = 0.5f;
    infoTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.contentView addSubview:infoTxt];
    if (self.memoType == 1)
        infoTxt.editable = NO;
    
    UILabel *titley = [[UILabel alloc] initWithFrame:CGRectMake(20, infoTxt.bottom + 20, self.view.width- 40, 40)];
    titley.text = @"提醒时间：";
    [cell.contentView addSubview:titley];
    
    UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, titley.bottom , self.view.width - 40, 40)];
    timeBtn.layer.cornerRadius = 4.0;
    timeBtn.backgroundColor = [UIColor whiteColor];
    timeBtn.layer.borderWidth = 0.5f;
    [timeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [timeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [timeBtn addTarget:self action:@selector(clickShowTime:) forControlEvents:UIControlEventTouchUpInside];
    timeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [timeBtn setTitle:[self getTimeFromTimesTamp:orderinfoDic[@"tx_time"]] forState:UIControlStateNormal];
    [cell.contentView addSubview:timeBtn];
    if (self.memoType == 1)
        timeBtn.enabled = NO;
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    txtfstr = textField.text ? textField.text : @"";

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    txtvstr = textView.text ? textView.text : @"";
}

- (void)clickShowTime:(UIButton *)btn{
    LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
//    datePicker.headerView.backgroundColor = [UIColor colorWithRed:84/255.0 green:150/255.0 blue:242/255.0 alpha:1];
    datePicker.headerView.backgroundColor = [UIColor whiteColor];
    datePicker.indicatorHeight = 1;
    datePicker.delegate = self;
    datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
    datePicker.headerView.leftItem.textColor = [UIColor redColor];
    datePicker.headerView.rightItem.textColor = NavColor;
    datePicker.pickHeaderHeight = 40;
    datePicker.pickType = LYSDatePickerTypeDayAndTime;
    datePicker.minuteLoop = YES;
    datePicker.headerView.showTimeLabel = NO;
    datePicker.weakDayType = LYSDatePickerWeakDayTypeCNShort;
    datePicker.showWeakDay = YES;
    [datePicker setDidSelectDatePicker:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDate = [dateFormat stringFromDate:date];
        [btn setTitle:currentDate forState:UIControlStateNormal];
        timevstr = currentDate;
    }];
    [datePicker showDatePickerWithController:self];
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
