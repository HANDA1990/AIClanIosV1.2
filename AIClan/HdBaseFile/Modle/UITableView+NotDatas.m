//
//  UITableView+NotDatas.m
//  Pods
//
//  Created by hd on 15/10/31.
//
//

#import "UITableView+NotDatas.h"

@implementation UITableView (NotDatas)


- (void) ShowNotDatadPromptView:(NSString *)Promptstring dataCount:(NSInteger)dataCount
{
    [[self viewWithTag:2015] removeFromSuperview];
    [[self viewWithTag:20151] removeFromSuperview];
    self.hidden = YES;
    
    if (dataCount) {
        self.hidden = YES;
        
    }
    else
    {
        self.hidden = NO;
        
        UIImageView *bgimageV = [UIImageView new];
        [bgimageV setFrame:CGRectMake(self.frame.size.width / 2 - 75, self.frame.size.height / 2 - 35 -  self.frame.origin.y, 150, 70.0)];
        bgimageV.tag = 2015;
        [bgimageV setImage:[UIImage imageNamed:@"ic_network_error"]];
        [self addSubview:bgimageV];
        
        UILabel *promotLab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 44.0, bgimageV.frame.origin.y + bgimageV.frame.size.height, 128.0, 60)];
        promotLab.tag = 20151;
        promotLab.textColor =[UIColor darkGrayColor];
        promotLab.font = [UIFont systemFontOfSize:18];
        promotLab.textAlignment = NSTextAlignmentCenter;
        promotLab.text = Promptstring;
        [self addSubview:promotLab];
    }
}

+ (void) ShowNotDatadPromptView:(UIView *)superView Promptstring:(NSString *)Promptstring dataCount:(NSInteger)dataCount
{
    [[superView viewWithTag:2015] removeFromSuperview];
    [[superView viewWithTag:20151] removeFromSuperview];
    
    if (dataCount) {
        
    }
    else
    {
        UIImageView *bgimageV = [UIImageView new];
        [bgimageV setFrame:CGRectMake(superView.frame.size.width / 2 - 75, superView.frame.size.height / 2 - 35 - 64, 150, 70)];
        bgimageV.tag = 2015;
        [bgimageV setImage:[UIImage imageNamed:@"pl_empty"]];
        [superView addSubview:bgimageV];
        
        UILabel *promotLab = [[UILabel alloc] initWithFrame:CGRectMake(superView.frame.size.width / 2 - 64.0, bgimageV.frame.origin.y + bgimageV.frame.size.height, 128.0, 40)];
        promotLab.tag = 20151;
        promotLab.textColor =[UIColor darkGrayColor];
        promotLab.numberOfLines = 0;
        promotLab.font = [UIFont systemFontOfSize:18];
        promotLab.textAlignment = NSTextAlignmentCenter;
        promotLab.text = Promptstring;
        [superView addSubview:promotLab];
    }
}

+ (void) ShowWordListNotDatadPromptView:(UIView *)superView Promptstring:(NSString *)Promptstring dataCount:(NSInteger)dataCount
{
    [[superView viewWithTag:2015] removeFromSuperview];
    [[superView viewWithTag:20151] removeFromSuperview];
    
    if (dataCount) {
        
    }
    else
    {
        UIImageView *bgimageV = [UIImageView new];
        [bgimageV setFrame:CGRectMake(superView.frame.size.width / 2 - 75, superView.frame.size.height / 2 - 35 - 113 + 49, 150, 70)];
        bgimageV.tag = 2015;
        [bgimageV setImage:[UIImage imageNamed:@"ic_network_error"]];
        [superView addSubview:bgimageV];
        
        UILabel *promotLab = [[UILabel alloc] initWithFrame:CGRectMake(superView.frame.size.width / 2 - 64.0, bgimageV.frame.origin.y + bgimageV.frame.size.height, 128.0, 40)];
        promotLab.tag = 20151;
        promotLab.textColor =[UIColor darkGrayColor];
        promotLab.numberOfLines = 0;
        promotLab.font = [UIFont systemFontOfSize:18];
        promotLab.textAlignment = NSTextAlignmentCenter;
        
        Promptstring = @"暂无数据";
        promotLab.text = Promptstring;
        [superView addSubview:promotLab];
    }
}

+ (void) ShowCommentDatadView:(UIView *)superView Promptstring:(NSString *)Promptstring dataCount:(NSInteger)dataCount
{
    [[superView viewWithTag:2015] removeFromSuperview];
    [[superView viewWithTag:20151] removeFromSuperview];
    
    if (dataCount) {
        
    }
    else
    {
        UIImageView *bgimageV = [UIImageView new];
        [bgimageV setFrame:CGRectMake(superView.frame.size.width / 2 - 151/2, superView.frame.size.height / 2 - 34 - 153 + 49, 151, 153)];
        bgimageV.tag = 2015;
        [bgimageV setImage:[UIImage imageNamed:@"pl_empty"]];
        [superView addSubview:bgimageV];
        
        UILabel *promotLab = [[UILabel alloc] initWithFrame:CGRectMake(0, bgimageV.frame.origin.y + bgimageV.frame.size.height + 10, superView.frame.size.width, 40)];
        promotLab.tag = 20151;
        promotLab.textColor =[UIColor blackColor];
        promotLab.font = [UIFont systemFontOfSize:14];
        promotLab.textAlignment = NSTextAlignmentCenter;
        promotLab.text = Promptstring;
        [superView addSubview:promotLab];
    }
}

@end
