//
//  AddGoodsView.m
//  麦家家
//
//  Created by dahan on 14/12/15.
//  Copyright (c) 2014年 dadaMarker. All rights reserved.
//

#import "AddGoodsView.h"

@implementation AddGoodsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setSelf];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)setSelf {
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
    [_deleteBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
    [_deleteBtn setImage:[UIImage imageNamed:@"44"] forState:UIControlStateNormal];
    [self addSubview:_deleteBtn];
    
    
    self.textfeild = [[UITextField alloc] initWithFrame:CGRectMake(_deleteBtn.width, 0, 31, 31)];
    [self.textfeild setBackgroundColor:[UIColor clearColor]];
    self.textfeild.keyboardType = UIKeyboardTypeNumberPad;
    [self.textfeild setTextAlignment:NSTextAlignmentCenter];
    [self.textfeild setReturnKeyType:UIReturnKeyDone];
    self.textfeild.delegate =self;
    [self.textfeild setBackground:[UIImage imageNamed:@"45"]];
    [self addSubview:self.textfeild];
    self.textfeild.inputAccessoryView = [[keyboardButtonView alloc] init];
    [(keyboardButtonView *)self.textfeild.inputAccessoryView setDelegaty:self];
    
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.textfeild.width + 31, 0, 31, 31)];
    [_addBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    [_addBtn setImage:[UIImage imageNamed:@"46"] forState:UIControlStateNormal];
    [_addBtn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_addBtn];
    // Drawing code
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}

- (void)textfeildRetuenKey
{
    if (![self.textfeild.text length]) {
        _numberStr = 0;
        self.textfeild.text = [[NSString alloc] initWithFormat:@"%ld",(long)_numberStr];
        [_addBtn setBackgroundColor:[UIColor clearColor]];
        
        [_deleteBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
    }
    NSMutableArray *arrays = [NSUserDefaults objectUserForKey:@"GWCDATAS"];
    [arrays[self.textfeild.tag] setValue:self.textfeild.text forKey:@"num"];
    [NSUserDefaults setUserObject:arrays forKey:@"GWCDATAS"];
    if ([ self.delegaty respondsToSelector:@selector(showFinalGoods)])
    {
        [self.delegaty showFinalGoods];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])//按会车可以改变
    {
        return YES;
    }
    if (string.length) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        
        if (self.textfeild == textField)//判断是否时我们想要限定的那个输入框
        {
            if ([toBeString intValue] >= 400) {
                if ([toBeString intValue] > 400) { //如果输入框内容大于20则弹出警告不能
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过400件商品" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                  
                }
                else
                {
                }
                _numberStr = 400;
                self.textfeild.text = [[NSString alloc] initWithFormat:@"%ld",(long)_numberStr];
                [_deleteBtn setBackgroundColor:[UIColor clearColor]];
                [_addBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
                return NO;

            }
            else if ([toBeString intValue] <= 0)
            {
                if ([toBeString intValue] < 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不能小于0" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                }
                [_addBtn setBackgroundColor:[UIColor clearColor]];

                [_deleteBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
                _numberStr = 0;
                self.textfeild.text = [[NSString alloc] initWithFormat:@"%ld",(long)_numberStr];
                return NO;
            }
        }
    
        _numberStr = [toBeString intValue];
    }
    [_deleteBtn setBackgroundColor:[UIColor clearColor]];
    [_addBtn setBackgroundColor:[UIColor clearColor]];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (void)showNumberStr:(NSInteger)data
{
    self.textfeild.text = [[NSString alloc] initWithFormat:@"%ld",(long)data];
    _numberStr = data;
    if (data == 1) {
        [_deleteBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
    }
}

- (void)btnAction:(UIButton *)btn
{
    if (btn == _deleteBtn)
    {
        _numberStr --;
        if (_numberStr <= 0) {
            if (_numberStr == 0) {
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不能小于0" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
            self.textfeild.text = @"0";
          
            _numberStr = 0;
            [_deleteBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
            [_addBtn setBackgroundColor:[UIColor clearColor]];

        }
        else
        {
            self.textfeild.text = [[NSString alloc] initWithFormat:@"%ld",(long)_numberStr];
//            [self.textfeild setBackgroundColor:[UIColor clearColor]];
            [_deleteBtn setBackgroundColor:[UIColor clearColor]];
            [_addBtn setBackgroundColor:[UIColor clearColor]];

        }
    }
    else if (btn == _addBtn)
    {
        _numberStr ++;
        if (_numberStr >= 400) {
            if (_numberStr == 400) {
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"至多400件商品" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
            self.textfeild.text = @"400";
            
            _numberStr = 400;
            [_addBtn setBackgroundColor:[UIColor colorWithRed:190./255. green:195./255. blue:200./255 alpha:1.]];
            [_deleteBtn setBackgroundColor:[UIColor clearColor]];

        }
        else
        {
            self.textfeild.text = [[NSString alloc] initWithFormat:@"%ld",(long)_numberStr];
            [_deleteBtn setBackgroundColor:[UIColor clearColor]];
            [_addBtn setBackgroundColor:[UIColor clearColor]];

        }
    }
    NSMutableArray *arrays = [NSUserDefaults objectUserForKey:@"GWCDATAS"];
    [arrays[self.textfeild.tag] setValue:self.textfeild.text forKey:@"num"];
    [NSUserDefaults setUserObject:arrays forKey:@"GWCDATAS"];
    if ([ self.delegaty respondsToSelector:@selector(showFinalGoods)])
    {
        [self.delegaty showFinalGoods];
    }
}
@end
