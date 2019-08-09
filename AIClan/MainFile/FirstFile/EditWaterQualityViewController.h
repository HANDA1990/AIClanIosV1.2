//
//  EditWaterQualityViewController.h
//  AIClan
//
//  Created by hd on 2018/10/26.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "BaseViewController.h"


@protocol NewEditedelegate <NSObject>
- (void)didRereshEidteQuality:(NSString *)acccardtype_id acccardStr:(NSString *)acccardStr;

@end

@interface EditWaterQualityViewController : BaseViewController
@property (nonatomic, strong) id<NewEditedelegate>delegate;

@property (nonatomic, strong) NSString *acccardtype_id;
@property (nonatomic, strong) NSString *acccardStr;

@end
