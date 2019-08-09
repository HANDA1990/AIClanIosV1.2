//
//  NotificationAlert.h
//  TeaByGame
//
//  Created by hd on 2017/9/13.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationAlert : UIView
{
    NSTimer *timer;
    NSArray *reciveArr;
    int addk;
}

- (void)showGradeDialog;
@end
