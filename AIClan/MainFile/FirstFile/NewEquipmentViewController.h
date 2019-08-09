//
//  NewEquipmentViewController.h
//  AIClan
//
//  Created by hd on 2018/11/1.
//  Copyright © 2018年 hd. All rights reserved.
//

#import "BaseViewController.h"

@protocol NewEquipmentAdddelegate <NSObject>
- (void)didRereshNewEquipment;

@end

@interface NewEquipmentViewController : BaseViewController

@property (nonatomic, strong)NSString *acccardtype_id;

@property (nonatomic, strong) id<NewEquipmentAdddelegate>delegate;

@end
