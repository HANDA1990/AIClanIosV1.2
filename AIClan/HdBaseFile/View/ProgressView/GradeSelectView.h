//
//  GradeSelectView.h
//  TeaByGame
//
//  Created by hd on 2017/9/7.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocoldelegate.h"

@interface GradeSelectView : UIView
@property (nonatomic, assign) id<Protocoldelegate>delegaty;

- (void)addSubViewLayer;

- (void)showGradSelectView;

- (void)hiddeGradSelectView;
    
@end
