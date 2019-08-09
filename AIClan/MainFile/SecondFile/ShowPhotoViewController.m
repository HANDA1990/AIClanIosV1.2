//
//  ShowPhotoViewController.m
//  AIClan
//
//  Created by hd on 2018/11/5.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import <MWPhotoBrowser.h>

@interface ShowPhotoViewController ()<MWPhotoBrowserDelegate>
{
     NSMutableArray *photos;
}
@property (nonatomic,retain) NSMutableArray *thumbArray;

@end

@implementation ShowPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Create array of MWPhoto objects
    photos = [NSMutableArray array];
    
 
    for (int i = 0; i < self.vediodataArr.count; i ++) {
        NSURL *vedioUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,self.vediodataArr[i]]];
        MWPhoto *video = [MWPhoto new];
        video.videoURL = vedioUrl;
        [photos addObject: video];
    }
    for (int i = 0; i < self.imgdataArr.count; i ++) {
        NSURL *photUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,self.imgdataArr[i]]];
        [photos addObject: [MWPhoto photoWithURL:photUrl]];
    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:self.currentTag];
    
    // Present
    [self addChildViewController:browser];
    [self.view addSubview:browser.view];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count) {
        return [photos objectAtIndex:index];
    }
    return nil;
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
