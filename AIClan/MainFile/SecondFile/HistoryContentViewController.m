//
//  HistoryContentViewController.m
//  AIClan
//
//  Created by hd on 2018/11/4.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "HistoryContentViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ShowVedioViewController.h"
#import "LLImagePickerView.h"
#import "ShowPhotoViewController.h"

#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HistoryContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TPKeyboardAvoidingTableView *_Maintableview;
    NSArray *dataArr;
  
}


@end

@implementation HistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float hb = Height_NavBar;

    _Maintableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - hb - 30) style:UITableViewStyleGrouped];
    _Maintableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _Maintableview.separatorColor = [UIColor clearColor];
    _Maintableview.backgroundColor = [UIColor whiteColor];
    _Maintableview.delegate = self;
    _Maintableview.dataSource = self;
    [self.view addSubview:_Maintableview];
    [self reloadDatas];

}
- (void)viewWillAppear:(BOOL)animated
{
}
- (void)reloadDatas{
    [SVProgressHUD show];
    [AppRequest Request_Normalpost:@"wdyylb" json:@{@"status":self.yyStatus} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            dataArr = result[@"retRes"];
            [_Maintableview reloadData];
        }
        [SVProgressHUD dismiss];
    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
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
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV;
    UIView *btV;
    footV = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.view.width - 10, 50)];
    footV.backgroundColor = self.view.backgroundColor;
    footV.userInteractionEnabled = YES;
    
    btV = [[UIView alloc] initWithFrame:CGRectMake(5, 0, footV.width - 5, 40)];
    btV.tag = section;
    btV.backgroundColor = [UIColor whiteColor];
    btV.userInteractionEnabled = YES;
    [footV addSubview:btV];
    
    if (btV) {
        for (UIView *subV in btV.subviews) {
            if ([subV isKindOfClass:[UIButton class]]) {
                [subV removeFromSuperview];
            }
        }
    }
    NSArray *imgArr = dataArr[section][@"img_file_urls"];
    NSArray *vedioArr = dataArr[section][@"video_file_urls"];

    for (int i = 0; i < vedioArr.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + 35 * i, 5, 30, 30)];
        
        UIImage *thumbImg = [self getThumbnailImage:[NSString stringWithFormat:@"%@%@",IMGURL,vedioArr[i]]];
        
        [btn setImage:thumbImg forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(handleInfo:) forControlEvents:UIControlEventTouchUpInside];
        [btV addSubview:btn];
    }
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + 35 * (vedioArr.count + i), 5, 30, 30)];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,imgArr[i]]] forState:UIControlStateNormal placeholderImage:EMPTYIMG];
        btn.tag = vedioArr.count + i;
        [btn addTarget:self action:@selector(handleInfo:) forControlEvents:UIControlEventTouchUpInside];
        [btV addSubview:btn];
    }

    if ([self.yyStatus intValue] == 1) {
        UIButton *cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(footV.width - 80, 5, 60, 30)];
        cancelbtn.backgroundColor = XXColor(251, 154, 51, 1);
        cancelbtn.tag = section;
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(VEDIO:) forControlEvents:UIControlEventTouchUpInside];
        [btV addSubview:cancelbtn];
    }
   
    return footV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = self.view.backgroundColor;
        
        UILabel *yybhLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.width / 2, 40)];
        [yybhLab setFont:[UIFont fontWithName:FONTNAME size:14.0]];
        yybhLab.tag = 90;
        yybhLab.text = @"预约编号:sz10002";
        yybhLab.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:yybhLab];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(yybhLab.right, 0, self.view.width - yybhLab.right - 5, 40)];
        [timeLab setFont:[UIFont fontWithName:FONTNAME size:14.0]];
        timeLab.backgroundColor = [UIColor whiteColor];
        timeLab.text = @"2018-11-04 23:11";
        timeLab.tag = 91;
        [cell.contentView addSubview:timeLab];
        
        UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, yybhLab.bottom + 15, 80, 80)];
        [logoImgV setBackgroundColor:[UIColor whiteColor]];
        logoImgV.tag = 92;
        [cell.contentView addSubview:logoImgV];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(logoImgV.right + 5, yybhLab.bottom, self.view.width - logoImgV.right - 10, 100)];
        [infoLab setFont:[UIFont fontWithName:FONTNAME size:14.0]];
        infoLab.backgroundColor = self.view.backgroundColor;
        infoLab.text = @"预约专家:张三\n问题描述：的亟待解决的亟待解决的";
        infoLab.tag = 93;

        infoLab.numberOfLines = 0;
        [cell.contentView addSubview:infoLab];
    }
    
    [(UILabel *)[cell.contentView viewWithTag:90] setText:[NSString stringWithFormat:@"预约编号:%@",dataArr[indexPath.section][@"numbers"]]];
    [(UILabel *)[cell.contentView viewWithTag:91] setText:[NSString stringWithFormat:@"%@",[self getTimeFromTimesTamp:dataArr[indexPath.section][@"create_time"]]]];
    [(UIImageView *)[cell.contentView viewWithTag:92] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,dataArr[indexPath.section][@"yyzj_file_url"]]] placeholderImage:EMPTYIMG];
    [(UILabel *)[cell.contentView viewWithTag:93] setText:[NSString stringWithFormat:@"%@",dataArr[indexPath.section][@"contents"]]];

    return cell;
}

- (void)handleInfo:(UIButton *)btn
{
    UIView *bgV = (UIView *)btn.superview;
   
    ShowPhotoViewController *showVc = [ShowPhotoViewController new];
    showVc.currentTag = btn.tag;
    showVc.imgdataArr = dataArr[bgV.tag][@"img_file_urls"];
    showVc.vediodataArr = dataArr[bgV.tag][@"video_file_urls"];

    [self.navigationController pushViewController:showVc animated:YES];
}

- (void)VEDIO:(UIButton *)btn{
    [SVProgressHUD show];
    UIView *btBgV = (UIView *)btn.superview;
    
    NSString *idstr = [[NSString alloc] initWithFormat:@"%@", dataArr[btBgV.tag][@"id"]];
    [AppRequest Request_Normalpost:@"qxwdyy" json:@{@"id":idstr} controller:self completion:^(id result, NSInteger statues) {
        if (statues == 1) {
            [self.view showResult:@"你已取消此次预约"];
            [self reloadDatas];
        }
        else{
            [self.view showResult:result[@"retErr"]];
        }
        [_Maintableview reloadData];
        [SVProgressHUD dismiss];

    } failed:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (UIImage *)getThumbnailImage:(NSString *)videoPath {
    if (videoPath) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath: videoPath] options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(300, 169);
        CMTime time = CMTimeMakeWithSeconds(5.0, 10);
        //取第5秒，一秒钟600帧
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if (error) {
            UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
            return placeHoldImg;
            
        }
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        return thumb;
        
    }
    else {
        UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"]; return placeHoldImg;
    }
}

- (UIImage *)getThumbVedio:(NSString *)path
{
    MPMoviePlayerController *iosMPMovie = [[MPMoviePlayerController alloc]
                                             initWithContentURL:[NSURL fileURLWithPath:path]];
    UIImage *img = [iosMPMovie thumbnailImageAtTime:0.0
                                           timeOption:MPMovieTimeOptionNearestKeyFrame];
    return img;
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
