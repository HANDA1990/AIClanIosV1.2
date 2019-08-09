//
//  ShareView.h
//  TeaByGame
//
//  Created by hd on 2017/9/28.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIButton
{
    NSDictionary *shareUrlStr;
    
    UIImage *shareImg;
}

- (void)hideBackView;

- (void)showBGview;

- (void)sendUrlinfo:(NSString *)urlStr;

- (void)sendimgCode:(UIImage *)imgCode;
@end
