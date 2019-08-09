//
//  AddGoodsView.h
//  麦家家
//
//  Created by dahan on 14/12/15.
//  Copyright (c) 2014年 dadaMarker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "keyboardButtonView.h"

@protocol AddGoodsdelegate <NSObject>

- (void)showFinalGoods;

@end

@interface AddGoodsView : UIView<UITextFieldDelegate,keyboarddelegate>

@property (nonatomic, strong) id<AddGoodsdelegate>delegaty;
@property (nonatomic, strong)UITextField *textfeild;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic) NSInteger numberStr;
- (void)showNumberStr:(NSInteger)data;
@end
