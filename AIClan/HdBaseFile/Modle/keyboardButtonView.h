//
//  keyboardButtonView.h
//  麦家家
//
//  Created by dahan on 14/12/15.
//  Copyright (c) 2014年 dadaMarker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keyboarddelegate <NSObject>

- (void)textfeildRetuenKey;

@end

@interface keyboardButtonView : UIToolbar

@property (nonatomic, assign) id<keyboarddelegate>delegaty;
@end
