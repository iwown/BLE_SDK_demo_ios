//
//  DSViewController.h
//  AutumnTest
//
//  Created by A$CE on 2017/10/23.
//  Copyright © 2017年 A$CE. All rights reserved.
//
typedef enum {
    DSViewTypeNum = 0,
    DSViewTypeFirst = 1,
    DSViewTypeBLESign = DSViewTypeFirst,
    DSViewTypeTime,
    DSViewTypeUserInfo,
    DSViewTypeClock,
    DSViewTypeSendtary,
    
    DSViewTypeSportTarget = 6,
    DSViewTypeDndModel,
    DSViewTypeGnssParams,
    DSViewTypeCustomOption,
    
    DSViewTypeLast = 0x80,
} DSViewType;

#import <UIKit/UIKit.h>

@interface DSViewController : UIViewController

@property (nonatomic ,assign)DSViewType sdType;
@end
