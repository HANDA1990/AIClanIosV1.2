//
//  Protocoldelegate.h
//  TeaByGame
//
//  Created by hd on 2017/9/6.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Protocoldelegate <NSObject>

@optional
- (void)normalViewJump;

- (void)normalViewJumpWithtag:(NSInteger)tag;


@end
