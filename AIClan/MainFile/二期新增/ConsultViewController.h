//
//  ConsultViewController.h
//  AIClan
//
//  Created by hd on 2019/5/13.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "BaseViewController.h"


typedef enum _TTGState {
    Alpro  = 0,
    Alfree,
    Alconnect
} TTGState;

@interface ConsultViewController : BaseViewController

- (void)ListdataRefresh:(TTGState)stateType;
@end
