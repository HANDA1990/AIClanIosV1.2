//
//  UITableView+NotDatas.h
//  Pods
//
//  Created by hd on 15/10/31.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (NotDatas)


+ (void) ShowNotDatadPromptView:(UIView *)superView Promptstring:(NSString *)Promptstring dataCount:(NSInteger)dataCount;

+ (void) ShowWordListNotDatadPromptView:(UIView *)superView Promptstring:(NSString *)Promptstring dataCount:(NSInteger)dataCount;

+ (void) ShowCommentDatadView:(UIView *)superView Promptstring:(NSString *)Promptstring dataCount:(NSInteger)dataCount;
@end
