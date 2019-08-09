//
//  BrandsViewController.m
//  AIClan
//
//  Created by hd on 2019/5/20.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "BrandsViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BrandsDroganWdViewController.h"
#import "NavCheckViewController.h"
#import "WebLoadViewController.h"

@interface BrandsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *dataArr;
    UIButton *SwitchTpBtn;
    BOOL hiddenStatusBar;
}


@end

@implementation BrandsViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat newY= scrollView.contentOffset.y;
    CGFloat lastContentOffset = 300;
    if (newY < 0) {
        hiddenStatusBar = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        if (newY != lastContentOffset ) {
            if (newY > lastContentOffset) { // scroll下滑...
                hiddenStatusBar = YES;
                
                //                [self.navigationController setNavigationBarHidden:YES animated:YES];
                self.navigationItem.leftBarButtonItem.customView.hidden = YES;
                UIView  *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                statusBar.alpha = 0.0f; //隐藏
            }else{  // scroll上滑...
                hiddenStatusBar = NO;
                
                float hb = Height_NavBar;
                
                self.navigationItem.leftBarButtonItem.customView.hidden = NO;
                
                //                [self.navigationController setNavigationBarHidden:NO animated:YES];
                UIView  *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                statusBar.alpha = 1.0f; //隐藏            }
                lastContentOffset = newY;   // 记录上一次的偏移量
            }
        }
    }
    
    [self setNeedsStatusBarAppearanceUpdate];   // 刷新状态栏的隐藏状态
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    float hb = Height_NavBar;
    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,-hb, self.view.frame.size.width, self.view.frame.size.height + hb - 2) style:UITableViewStylePlain];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor clearColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    //    [_Maintableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
    [self.view addSubview:_Maintableview];
    
    
    UIButton *fatieBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 50, self.view.height - 70, 40, 40)];
    [fatieBtn setImage:[UIImage imageNamed:@"发帖"] forState:UIControlStateNormal];
    [fatieBtn addTarget:self action:@selector(FatieClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fatieBtn];
    //[self reloadDatas];
}
-(void)FatieClick
{
    [self.view showResult:@"暂未开通发帖"];
}
- (void)viewWillAppear:(BOOL)animated
{
}
- (void)reloadDatas{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"wdyylb" json:@{@"status":@""} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            NSMutableArray *arrs = [NSMutableArray new];
            for(int i = 0; i < 13;i ++)
                [arrs addObject:[NSIndexPath indexPathForRow:i inSection:1]];
            [UIView setAnimationsEnabled:false];
            [_Maintableview reloadRowsAtIndexPaths:arrs withRowAnimation:UITableViewRowAnimationFade];
            [_Maintableview endUpdates];
            [UIView setAnimationsEnabled:true];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section == 0 ? 1 : 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  section == 0 ? 0.01 : 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *switchBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    switchBgV.backgroundColor = [UIColor whiteColor];
    [self addSwitchBtn:switchBgV];
    return switchBgV;
}
- (void)addSwitchBtn:(UIView *)bgV
{
    if (!SwitchTpBtn) {
        for (int k = 0; k < 3; k ++) {
            UIButton *addBtn = [[UIButton alloc] init];
            addBtn.frame = CGRectMake(self.view.width / 3 * k, 0, self.view.width / 3, 40);
            addBtn.titleLabel.font = [UIFont fontWithName:@"STXinwei" size:18];
            addBtn.tag = 300 + k;
            if (k == 0) {
                [addBtn setTitle:@"品牌发布" forState: UIControlStateNormal];
                [addBtn setTitleColor:XXColor(17, 141, 223, 1) forState:UIControlStateNormal];
                if (!SwitchTpBtn) {
                    SwitchTpBtn = addBtn;
                }
                
            }
            else if (k == 1)
            {
                [addBtn setTitle:@"粉丝交流" forState: UIControlStateNormal];
                [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            else if (k == 2)
            {
                [addBtn setTitle:@"精华版块" forState: UIControlStateNormal];
                [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            [addBtn addTarget:self action:@selector(SwitchClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [bgV addSubview:addBtn];
        }
    }
 
    
}

- (void)SwitchClick:(UIButton *)btn
{
    if (SwitchTpBtn) {
        [SwitchTpBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [self reloadDatas];
    [btn setTitleColor:XXColor(17, 141, 223, 1) forState:UIControlStateNormal];
    SwitchTpBtn = btn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath.section == 0 ? 465 + 130:155;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = XXColor(240, 240, 240, 1);
        
        
        
//        if (indexPath.section == 0 && indexPath.row == 0) {
            UIView *headBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 465 + 135)];
            headBgV.tag = 100;
            headBgV.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:headBgV];
            
            UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
            [headView setImage:[UIImage imageNamed:@"速倍妥"]];
            headView.userInteractionEnabled = YES;
            [headBgV addSubview:headView];
            
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 80, 150, 55, 28)];
            [addBtn addTarget:self action:@selector(Attentionclick) forControlEvents:UIControlEventTouchUpInside];
            [addBtn setImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
            [headView addSubview:addBtn];
            
            UIView *infoBv = [[UIView alloc] initWithFrame:CGRectMake(15, headView.bottom + 10, self.view.width - 30, 150)];
            infoBv.layer.cornerRadius = 8;
            infoBv.backgroundColor = [UIColor whiteColor];
            [headBgV addSubview:infoBv];
            
            
            UIImageView *icornImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
            icornImgV.layer.masksToBounds = YES;
            icornImgV.layer.cornerRadius = icornImgV.width / 2;
            icornImgV.layer.borderWidth = .5;
            icornImgV.layer.borderColor = XXColor(21, 136, 228, 1).CGColor;
            [icornImgV setImage:[UIImage imageNamed:@"速倍妥头像"]];
            [infoBv addSubview:icornImgV];
            
            UILabel *infoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.view.width, 65)];
            [infoLab2 setText:@"巴雷特龙鱼繁殖场"];
            [infoLab2 setFont:[UIFont fontWithName:@"STXinwei" size:18]];
            [infoBv addSubview:infoLab2];
            
            
            UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(5, infoLab2.bottom - 5, infoBv.width - 10, 70)];
            infoLab.numberOfLines = 0;
            [infoLab setText:@"         巴雷特马来西亚龙鱼繁殖场创办人蔡水华先生，爱好龙鱼30多年。因为对龙鱼的爱好，便在10年前创立了金龙繁殖场。渔场主要以养殖培育各类金龙鱼为主，并与印尼多家渔场密切合作。后因国内市场需求，在国内授权成立了厦门巴雷特渔业有限公司，将优质的印尼红龙及马来西亚金龙进口到国内。"];
            [infoLab setFont:[UIFont fontWithName:@"STXinwei" size:12.5]];
            
            [infoBv addSubview:infoLab];
            //添加中间按钮
            [self addBtnView:3 bgv:headBgV orginY:infoBv.bottom + 15];
            
            //添加店铺商品 + 15 + 150
            [self addShopView:3 bgv:headBgV orginY:infoBv.bottom + 55];

//        }
        UIView *headBgV2 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.view.width -20, 135)];
        headBgV2.tag = 101;
        headBgV2.layer.cornerRadius = 8.0;
        headBgV2.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:headBgV2];
        
        UIImageView *icornImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        icornImgV2.tag = 102;
        icornImgV2.layer.masksToBounds = YES;
        icornImgV2.layer.borderWidth = .5;
        icornImgV2.layer.borderColor = XXColor(21, 136, 228, 1).CGColor;
        icornImgV2.layer.cornerRadius = icornImgV2.width / 2;
        [headBgV2 addSubview:icornImgV2];

        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(icornImgV2.right + 3, 7, self.view.width / 2, 15)];
        titleLab.tag = 103;
        titleLab.textColor = XXColor(17, 141, 223, 1);
        [titleLab setFont:[UIFont fontWithName:@"STXinwei" size:16]];
        [headBgV2 addSubview:titleLab];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(icornImgV2.right + 3, titleLab.bottom + 2, self.view.width / 2, 10)];
        timeLab.tag = 104;
        timeLab.textColor = [UIColor darkGrayColor];
        [timeLab setFont:[UIFont systemFontOfSize:10.0]];
        [headBgV2 addSubview:timeLab];
        
        UILabel *problLab = [[UILabel alloc] initWithFrame:CGRectMake(20, icornImgV2.bottom + 5, self.view.width / 2, 10)];
        problLab.tag = 105;
        problLab.textColor = [UIColor darkGrayColor];
        [problLab setFont:[UIFont systemFontOfSize:12.0]];
        [headBgV2 addSubview:problLab];
        
        UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, problLab.bottom, self.view.width - 150, 60)];
        detailLab.tag = 106;
        detailLab.numberOfLines = 0;
        detailLab.textColor = [UIColor darkGrayColor];
        [detailLab setFont:[UIFont systemFontOfSize:10.0]];
        [headBgV2 addSubview:detailLab];
        
        UIImageView *rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(headBgV2.width - 100, 10, 90, 90)];
        rightImgV.tag = 107;
        [rightImgV setImage:[UIImage imageNamed:@"图片1"]];
        [headBgV2 addSubview:rightImgV];
        
        [self cellBtns:headBgV2];
        
    }
    
    UIView *headBgV = [cell.contentView viewWithTag:100];
    UIView *headBgV2 = [cell.contentView viewWithTag:101];;
    UIImageView *icornImgV2 = [cell.contentView viewWithTag:102];
    UILabel *titleLab = [cell.contentView viewWithTag:103];
    UILabel *Lab2 = [cell.contentView viewWithTag:104];
    UILabel *Lab3 = [cell.contentView viewWithTag:105];
    UILabel *Lab4 = [cell.contentView viewWithTag:106];
    
    if (indexPath.section == 0) {
        headBgV.hidden = NO;
        headBgV2.hidden = YES;
        
    }
    else
    {
        headBgV.hidden = YES;
        headBgV2.hidden = NO;
        [icornImgV2 setImage:[UIImage imageNamed:@"速倍妥头像"]];

        [titleLab setText:[NSString stringWithFormat:@"巴 雷 特 龙 鱼"]];
        [Lab2 setText:[NSString stringWithFormat:@"%@",@"2019.05.09"]];
        [Lab3 setText:[NSString stringWithFormat:@"%@",@"虎皮鱼身上长白点"]];
        [Lab4 setText:[NSString stringWithFormat:@"%@",@"       我把一雌一雄两条虎皮带到办公室去养了，并把两颗富贵竹防盗养虎皮的花瓶里了。后来发现其中一条虎皮已经死了,不知道究竟什么原因....."]];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:Lab4.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Lab4.text length])];
        Lab4.attributedText = attributedString;
        [Lab4 setFont:[UIFont fontWithName:@"STXinwei" size:IS_IPHONE_5 ?12: 16]];
        
    }
    
    
    //    }
    return cell;
    
}
- (void)Attentionclick
{
    [self.view showResult:@"暂未开通关注功能"];
}
- (void)cellBtns:(UIView *)bgV
{
    for (int k = 0; k < 4; k ++) {
        UIButton *addBtn = [[UIButton alloc] init];
        addBtn.frame = CGRectMake((self.view.width - 40 ) / 4 * k + 20, bgV.height - 22, (self.view.width - 40) / 4, 20);
        addBtn.tag = 200 + k;
        [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont fontWithName:@"STXinwei" size:13];
        [addBtn setTitleColor:XXColor(17, 141, 223, 1) forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(cellClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(addBtn.width / 2 - 32, 0, 14, 15)];
        [addBtn addSubview:leftImgV];
        
        
        
        if (k == 0) {
            [addBtn setTitle:@"3344" forState: UIControlStateNormal];
            [leftImgV setImage:[UIImage imageNamed:@"热度"]];
            
        }
        else if (k == 1)
        {
            [addBtn setTitle:@"66" forState: UIControlStateNormal];
            [leftImgV setImage:[UIImage imageNamed:@"点赞黑色"]];
            
        }
        else if (k == 2)
        {
            leftImgV.y += 2;
            [addBtn setTitle:@"88" forState: UIControlStateNormal];
            [leftImgV setImage:[UIImage imageNamed:@"留言"]];
            
        }
        else if (k == 3)
        {
            [addBtn setTitle:@"99" forState: UIControlStateNormal];
            [leftImgV setImage:[UIImage imageNamed:@"分享"]];
            
        }
        [bgV addSubview:addBtn];
    }
    
}
- (void)cellClickBtn:(UIButton *)btn
{
    if (btn.tag == 200) {
    }
    if (btn.tag == 201) {
        [self.view showResult:@"暂未开通点赞"];
    }
    if (btn.tag == 202) {
        [self.view showResult:@"暂未开通留言"];
    }
    if (btn.tag == 203) {
        [self.view showResult:@"暂未开通分享"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)addBtnView:(int)Num bgv:(UIView *)bgv orginY:(float)orginY
{
    for (int k = 0; k < Num; k ++) {
        UIButton *addBtn = [[UIButton alloc] init];
        addBtn.tag = 500 +k;
        addBtn.frame = CGRectMake(20, orginY, (bgv.width - 80)/3, 25);
        if (k==0) {
            addBtn.x = 20;
            addBtn.y = orginY;
            [addBtn setTitle:@"售前咨询  >" forState: UIControlStateNormal];
            
        }
        else if (k == 1){
            addBtn.x = (bgv.width - 80)/3 + 40;
            addBtn.y = orginY;
            [addBtn setTitle:@"售后咨询  >" forState: UIControlStateNormal];
        }
        else if (k == 2){
            addBtn.x = 2 * (bgv.width - 80)/3  + 60;
            addBtn.y = orginY;
            [addBtn setTitle:@"网点查询  >" forState: UIControlStateNormal];
        }
        [addBtn addTarget:self action:@selector(ClickDetail:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.layer.cornerRadius = 4.0;
        
        [addBtn setBackgroundColor:[UIColor whiteColor]];
        [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont fontWithName:@"STXinwei" size: 13];
        
        [bgv addSubview:addBtn];
    }
    
}
- (void)addShopView:(int)Num bgv:(UIView *)bgv orginY:(float)orginY
{
    UIView *shopBgV = [[UIView alloc] initWithFrame:CGRectMake(0, orginY, self.view.width, 160)];
    shopBgV.backgroundColor = [UIColor whiteColor];
    [bgv addSubview:shopBgV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 100, 20)];
    [titleLab setFont:[UIFont fontWithName:@"STXinwei" size:17]];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.text = @"产品展示";
    [shopBgV addSubview:titleLab];
    
    UIButton *detailBtn = [[UIButton alloc] init];
    detailBtn.frame = CGRectMake(shopBgV.width - 120, 5, 120, 20);
    [detailBtn setTitle:@"进入店铺 >" forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(DeTailShopClick) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn.titleLabel setFont:[UIFont fontWithName:@"STXinwei" size:17]];
    [shopBgV addSubview:detailBtn];

    for (int k = 0; k < Num; k ++) {
        UIButton *addBtn = [[UIButton alloc] init];
        addBtn.frame = CGRectMake(20, detailBtn.bottom +5, (shopBgV.width - 60)/3, 130);
        
        UIImageView *titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 90, 90)];
        [addBtn addSubview:titleImgV];
        titleImgV.layer.masksToBounds = YES;
        titleImgV.layer.cornerRadius = 4.0;
        titleImgV.layer.borderWidth = .5;
        titleImgV.layer.borderColor = [UIColor grayColor].CGColor;
        
        UILabel *tLab = [[UILabel alloc] initWithFrame:CGRectMake(0, addBtn.height -30, 100, 16)];
        [tLab setFont:[UIFont fontWithName:@"STXinwei" size:10]];
        tLab.text = @"速倍妥照明发色灯";
        [addBtn addSubview:tLab];
        
        UILabel *tLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, tLab.bottom, 120, 10)];
        [tLab2 setFont:[UIFont systemFontOfSize:10]];
        tLab2.backgroundColor = [UIColor clearColor];
        tLab2.textColor = [UIColor redColor];
        [addBtn addSubview:tLab2];
        
        if (k==0) {
            addBtn.x = 20;
            [titleImgV setImage:[UIImage imageNamed:@"img2"] ];
            tLab2.text = @"¥ 108";

        }
        else if (k == 1){
            addBtn.x = (shopBgV.width -80)/ 3 + 40;
            [titleImgV setImage:[UIImage imageNamed:@"img3"] ];
            tLab2.text = @"¥ 118";

        }
        else if (k == 2){
            addBtn.x = (shopBgV.width - 80) * 2 / 3 + 60;
            [titleImgV setImage:[UIImage imageNamed:@"img4"] ];
            tLab2.text = @"¥ 328";

        }
        
        addBtn.layer.cornerRadius = 4.0;
        
        [addBtn setBackgroundColor:[UIColor whiteColor]];
        [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont fontWithName:@"STXinwei" size:17];
        
        [shopBgV addSubview:addBtn];
    }
    
}
- (void)DeTailShopClick
{
    
}
- (void)ClickDetail:(UIButton *)btn
{
    if (btn.tag == 500) {
        WebLoadViewController *webV = [WebLoadViewController new];
        webV.tag = 8;
        webV.title = @"售前咨询";
        [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:webV] animated:YES completion:^{
            
        }];
    }
    else  if (btn.tag == 501) {
        WebLoadViewController *webV = [WebLoadViewController new];
        webV.tag = 9;
        webV.title = @"售后咨询";
        [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:webV] animated:YES completion:^{
            
        }];
    }
    else if (btn.tag == 502) {
        [self presentViewController:[[NavCheckViewController alloc]initWithRootViewController:[BrandsDroganWdViewController new]] animated:YES completion:^{
            
        }];
    }
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
