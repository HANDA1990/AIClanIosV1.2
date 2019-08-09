//
//  LogWriteViewController.m
//  AIClan
//
//  Created by hd on 2018/11/21.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "LogWriteViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "LLImagePickerView.h"

@interface LogWriteViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSDictionary *orderinfoDic;
    NSString * txtfstr;
    NSString * txtvstr;
    NSMutableArray *imgArr;

}
@property (nonatomic, strong) UIView *photoViewBackgroudView;

@end

@implementation LogWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    bgV.backgroundColor = NavColor;
    bgV.userInteractionEnabled = YES;
    [self.view addSubview:bgV];
    [self addRightButton:@"发布" imageName:@"" action:^(int status, NSString *searchKey) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];

        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       txtfstr,@"title",
                                       txtvstr,@"contents",
                                       nil];
        [SVProgressHUD show];
        [AppRequest Request_FileGroupPost:@"tjyyrz" jsonDic:mutDic imageDatas:imgArr vedioArr:nil controller:self completion:^(id result, NSInteger statues) {
            if (statues == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
            [SVProgressHUD dismiss];
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];

        }];
    }];
    self.title = @"发布日志";
    imgArr = [NSMutableArray new];

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
    return self.view.height * 2;
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
    txtF.returnKeyType = UIReturnKeyDone;
    txtF.layer.borderWidth = 0.5f;
    txtF.backgroundColor = [UIColor whiteColor];
    txtF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.contentView addSubview:txtF];
    
    UILabel *titlex = [[UILabel alloc] initWithFrame:CGRectMake(20, txtF.bottom, self.view.width- 40, 40)];
    titlex.text = @"正文：";
    [cell.contentView addSubview:titlex];
    
    UITextView *infoTxt = [[UITextView alloc] initWithFrame:CGRectMake(20, titlex.bottom, self.view.width- 40, 120)];
    [cell.contentView addSubview:infoTxt];
    infoTxt.returnKeyType = UIReturnKeyDone;
    infoTxt.delegate = self;
    infoTxt.layer.cornerRadius = 4.0;
    infoTxt.layer.borderWidth = 0.5f;
    infoTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.contentView addSubview:infoTxt];

    
    UILabel *titley = [[UILabel alloc] initWithFrame:CGRectMake(20, infoTxt.bottom + 20, self.view.width- 40, 40)];
    titley.text = @"图片：";
    [cell.contentView addSubview:titley];
    
    _photoViewBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(5, titley.bottom + 10, self.view.width - 10, 160)];
    _photoViewBackgroudView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:_photoViewBackgroudView];
    
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, _photoViewBackgroudView.width, 0) CountOfRow:3];
    pickerV.tag = 1000;
    pickerV.type = LLImageTypeAll;
    pickerV.maxImageSelected = 8;
    pickerV.allowPickingVideo = YES;
    [_photoViewBackgroudView addSubview: pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
//        [self reloadHeight:_photoViewBackgroudView];
        for (LLImagePickerModel *model in list) {
            [imgArr addObject:@{@"img":model.image,@"state":@1}];
        }
    }];
    
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
