//
//  PromptlyOrderViewController.m
//  AIClan
//
//  Created by hd on 2018/11/4.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "PromptlyOrderViewController.h"
#import "LLImagePickerView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "HistorySubMaineViewController.h"

@interface PromptlyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    UITextView *_noteTextView;
    UIView *headV;
    NSMutableArray *imgArr;
    NSMutableArray *vedioArr;
    
    UITextField *txtF1;
    UITextField *txtF2;
}
@property (nonatomic, strong) UIView *vedioViewBackgroudView;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIView *photoViewBackgroudView;



@property (nonatomic, strong) UIView *textViewBackgroudView;

@property (nonatomic, strong) UIView *connectViewBackgroudView;
@end

@implementation PromptlyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imgArr = [NSMutableArray new];
    vedioArr = [NSMutableArray new];
    self.title = @"预约专家";
    [self addRightButton:@"提交" imageName:@"" action:^(int status, NSString *searchKey) {
        
        if (!txtF1.text) {
            txtF1.text = @"";
        }
        if (!txtF2.text) {
            txtF2.text = @"";
        }
        if (!_noteTextView.text) {
            _noteTextView.text = @"";
        }
        
        if (!txtF1.text.length) {
            [self.view showResult:@"请填写联系人"];
            return ;

        }
        if (!txtF2.text.length) {
            [self.view showResult:@"请填写联系人电话"];
            return ;

        }
       
        if (imgArr.count == 0) {
            [self.view showResult:@"请上传图片"];
            return ;
        }
        if (vedioArr.count == 0) {
            [self.view showResult:@"请上传视频"];
            return ;
        }
        if (!_noteTextView.text.length) {
            _noteTextView.text = @"预约";
        }
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       _infoDic[@"id"],@"yyzj_id",
                                       txtF1.text,@"link_man",
                                       txtF2.text,@"link_phone",
                                       _noteTextView.text,@"contents",
                                       nil];
        [SVProgressHUD show];
        [AppRequest Request_TestPhotospost:mutDic imageDatas:imgArr vedioArr:vedioArr controller:self
                                completion:^(id result, NSInteger statues) {
                                    [SVProgressHUD dismiss];
                                    [[UIApplication sharedApplication].keyWindow showResult:result[@"retErr"]];
            if (statues == 1) {
                [self.navigationController pushViewController:[HistorySubMaineViewController new] animated:YES];
            }
                                             } failed:^(NSError *error) {
                                                 [SVProgressHUD dismiss];

                                             }];
    }];
    float hb = Height_StatusBar;
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,Height_StatusBar, self.view.frame.size.width, self.view.frame.size.height - hb) style:UITableViewStylePlain];
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
    
    UIImageView *logoImgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 80, 80)];
    [logoImgv setBackgroundColor:[UIColor grayColor]];
    logoImgv.layer.masksToBounds = YES;
    logoImgv.layer.borderWidth = 1;
    logoImgv.layer.borderColor = NavColor.CGColor;
    [logoImgv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_infoDic[@"file_url"]]]];
    logoImgv.layer.cornerRadius = logoImgv.width / 2;
    [headV addSubview:logoImgv];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(logoImgv.right + 10, 20, self.view.width, 40)];
    infoLab.text = [NSString stringWithFormat:@"%@ | %@",_infoDic[@"title"],_infoDic[@"zhuanye"]];
    infoLab.attributedText = [self ChangeBfWordColor:infoLab.text];
    infoLab.textAlignment = NSTextAlignmentLeft;
    [headV addSubview:infoLab];
    
    UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(logoImgv.right + 10, infoLab.bottom , self.view.width, 20)];
    infoLab2.text = [NSString stringWithFormat:@"%@",_infoDic[@"biaoqian"]];
    infoLab2.textAlignment = NSTextAlignmentLeft;
    infoLab2.textColor = [UIColor lightGrayColor];
    infoLab2.font = [UIFont fontWithName:FONTNAME size:15.0];
    [headV addSubview:infoLab2];
    
    UILabel *infoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(logoImgv.right + 10, infoLab2.bottom , self.view.width, 30)];
    infoLab3.text = [NSString stringWithFormat:@"%@",_infoDic[@"sub_title"]];
    infoLab3.textAlignment = NSTextAlignmentLeft;
    infoLab3.textColor = [UIColor darkGrayColor];
    infoLab3.font = [UIFont fontWithName:FONTNAME size:15.0];
    [headV addSubview:infoLab3];
    
    _photoViewBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(5, logoImgv.bottom + 10, self.view.width - 10, 160)];
    _photoViewBackgroudView.backgroundColor = [UIColor whiteColor];
    [headV addSubview:_photoViewBackgroudView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(8, 5, 4, 20)];
    [lineV setBackgroundColor:NavColor];
    [_photoViewBackgroudView addSubview:lineV];
    
    UILabel *Photolab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width, 20)];
    Photolab.font = [UIFont systemFontOfSize:17.0];
    Photolab.textColor = NavColor;
    [Photolab setText:@"添加图片"];
    [_photoViewBackgroudView addSubview:Photolab];
    
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, Photolab.bottom, _photoViewBackgroudView.width, 0) CountOfRow:3];
    pickerV.tag = 1000;
    pickerV.type = LLImageTypePhotoAndCamera;
    pickerV.maxImageSelected = 8;
    pickerV.allowPickingVideo = NO;
    [_photoViewBackgroudView addSubview: pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        [self reloadHeight:_photoViewBackgroudView];
        [imgArr removeAllObjects];
        for (LLImagePickerModel *model in list) {
            [imgArr addObject:@{@"img":model.image,@"state":@1}];
        }
    }];
    
    
    //此处刷新
    _vedioViewBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(5, _photoViewBackgroudView.bottom + 10, self.view.width - 10, 160)];
    _vedioViewBackgroudView.backgroundColor = [UIColor whiteColor];
    [headV addSubview:_vedioViewBackgroudView];
    
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(8, 5, 4, 20)];
    [lineV2 setBackgroundColor:NavColor];
    [_vedioViewBackgroudView addSubview:lineV2];
    
    UILabel *vediolab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width, 20)];
    vediolab.font = [UIFont systemFontOfSize:17.0];
    [vediolab setText:@"添加视频"];
    vediolab.textColor = NavColor;
    [_vedioViewBackgroudView addSubview:vediolab];
    
    LLImagePickerView *pickerV2 = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, vediolab.bottom, _vedioViewBackgroudView.width, 0) CountOfRow:3];
    pickerV2.type = LLImageTypeTapeAndVideo;
    pickerV2.maxImageSelected = 1;
    [_vedioViewBackgroudView addSubview: pickerV2];
    [pickerV2 observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        NSLog(@"%@",list);
        for (LLImagePickerModel *model in list) {
            if (model.isVideo) {
                [vedioArr addObject:@{@"path":model.mediaURL,@"state":@2}];
            }
        }
    }];
    
    
    _textViewBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(5, _vedioViewBackgroudView.bottom + 10, self.view.width - 10, 145)];
    _textViewBackgroudView.backgroundColor = [UIColor whiteColor];
    [headV addSubview:_textViewBackgroudView];
    
    
    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(8, 5, 4, 20)];
    [lineV3 setBackgroundColor:NavColor];
    [_textViewBackgroudView addSubview:lineV3];
    
    UILabel *PROlab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width, 20)];
    PROlab.font = [UIFont systemFontOfSize:17.0];
    [PROlab setText:@"预约留言"];
    PROlab.textColor = NavColor;
    [_textViewBackgroudView addSubview:PROlab];
    
    //文本输入框
    _noteTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, PROlab.bottom + 10, _textViewBackgroudView.width - 10, 100)];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    [_noteTextView setBackgroundColor:XXColor(245, 245, 245, 1)];
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    _noteTextView.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
    [_textViewBackgroudView addSubview:_noteTextView];
    
    
    
    _connectViewBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(5, _textViewBackgroudView.bottom + 10, self.view.width - 10, 120)];
    _connectViewBackgroudView.backgroundColor = [UIColor whiteColor];
    [headV addSubview:_connectViewBackgroudView];
    UILabel *PROlab2;
    PROlab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width, 20)];
    PROlab2.font = [UIFont systemFontOfSize:17.0];
    [PROlab2 setText:@"联系方式"];
    PROlab2.textColor = NavColor;

    [_connectViewBackgroudView addSubview:PROlab2];

    txtF1 = [[UITextField alloc] initWithFrame:CGRectMake(5, 30, self.view.frame.size.width-20, 30)];
    txtF1.layer.cornerRadius = 2.0;
    txtF1.placeholder = @"联系姓名";
    txtF1.backgroundColor = XXColor(245, 245, 245, 1);
    [_connectViewBackgroudView addSubview:txtF1];
    
    txtF2 = [[UITextField alloc] initWithFrame:CGRectMake(5, 65, self.view.frame.size.width-20, 30)];
    txtF2.layer.cornerRadius = 2.0;
    txtF2.keyboardType = UIKeyboardTypePhonePad;
    txtF2.placeholder = @"联系电话";
    txtF2.backgroundColor = XXColor(245, 245, 245, 1);
    [_connectViewBackgroudView addSubview:txtF2];
    
    return headV;
}

- (void)reloadHeight:(UIView *)photoV{
    LLImagePickerView *photbV = (LLImagePickerView *)[photoV viewWithTag:1000];
    photoV.height = photbV.height + 25;
    
    _vedioViewBackgroudView.y = photoV.bottom + 10;
    _textViewBackgroudView.y = _vedioViewBackgroudView.bottom + 10;
    _connectViewBackgroudView.y = _textViewBackgroudView.bottom + 10;

    [_Maintableview reloadData];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//部分字体颜色
- (NSMutableAttributedString *)ChangeBfWordColor:(NSString *)changeStr{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:changeStr];
    NSRange range2 = [[str string] rangeOfString:_infoDic[@"title"]];
    [str addAttribute:NSForegroundColorAttributeName value:NavColor range:range2];
    return str;
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
    if (!headV) {
        float hb = Height_NavBar;
        return  self.view.height + hb;
    }
    return _connectViewBackgroudView.bottom;
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
@end
