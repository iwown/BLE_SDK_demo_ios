//
//  BaseViewController.h
//  IW_BLESDK
//
//  Created by caike on 15/12/25.
//  Copyright © 2015年 iwown. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController<UITextFieldDelegate>
- (void)initUI;
- (void)initParam;
- (void)drawNavMenu:(NSString *)title leftTitle:(NSString *)title1 leftActon:(SEL)action1 rightTitle:(NSString *)title2 rightActon:(SEL)action2;

- (NSString *)displayString:(Byte)days;

@end
