//
//  ShowVedioViewController.m
//  AIClan
//
//  Created by hd on 2018/11/5.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ShowVedioViewController.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ShowVedioViewController ()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

@property (nonatomic,strong) NSURL *movieUrl;//视频播放控制器

@end

@implementation ShowVedioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //    NSURL *url = [NSURL URLWithString:@"http://vf1.mtime.cn/Video/2012/04/23/mp4/120423212602431929.mp4"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //播放
    [self.moviePlayer play];
    
    
    //添加通知
    [self addNotification];
}

/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}
/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    
    NSString *urlStr = @"http://szx.yshdszx.com/upload/img/20181103/69f9131cc9ea73b0f7860f34aa8e1dec.mp4";
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    return url;
}
-(MPMoviePlayerController *)moviePlayer{
    
    if (!_moviePlayer) {
        
        NSURL *url = [self getNetworkUrl];
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame = self.view.bounds;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:_moviePlayer.view];
    }
    
    return _moviePlayer;
}


/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    
}


/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}


-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
