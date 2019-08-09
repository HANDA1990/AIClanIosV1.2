//
//  keyboardButtonView.m
//  麦家家
//
//  Created by dahan on 14/12/15.
//  Copyright (c) 2014年 dadaMarker. All rights reserved.
//

#import "keyboardButtonView.h"

@implementation keyboardButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.barStyle = UIBarStyleBlack;
        
        self.translucent = YES;
        
        self.tintColor = nil;
        
        [self sizeToFit];
        
        
        UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                    
                                                                    style:UIBarButtonItemStyleDone target:self
                                    
                                                                   action:@selector(pickerDoneClicked:)];
        
        UIBarButtonItem *fixedLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        fixedLeft.width = 250;
        
        [self setItems:[NSArray arrayWithObjects: fixedLeft, doneBtn, nil] animated:YES];
        
    }
    return self;
}
- (void)pickerDoneClicked:(UIButton *)btn
{
    if ([self.delegaty respondsToSelector:@selector(textfeildRetuenKey)]) {
        [self.delegaty textfeildRetuenKey];

    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
