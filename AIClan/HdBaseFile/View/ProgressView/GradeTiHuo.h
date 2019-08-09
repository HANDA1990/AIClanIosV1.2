//
//  GradeTiHuo.h
//  TeaByGame
//
//  Created by hd on 2017/9/16.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocoldelegate.h"

@interface GradeTiHuo : UIView
@property (nonatomic, weak) id<Protocoldelegate>delegaty;

+ (instancetype)sharedManager;


- (void)addSubViewLayer;

- (void)showGradSelectView:(NSString *)message;

- (void)hiddeGradSelectView;
@end
