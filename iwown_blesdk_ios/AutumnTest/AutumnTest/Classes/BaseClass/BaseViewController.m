//
//  BaseViewController.m
//  IW_BLESDK
//
//  Created by caike on 15/12/25.
//  Copyright © 2015年 iwown. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIButton *_logBtn;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initParam
{
    
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)drawNavMenu:(NSString *)title leftTitle:(NSString *)title1 leftActon:(SEL)action1 rightTitle:(NSString *)title2 rightActon:(SEL)action2
{
    self.title = title;
    if (title1 != nil) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title1 style:UIBarButtonItemStylePlain target:self action:action1];
    }
    if (title2 != nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title2 style:UIBarButtonItemStylePlain target:self action:action2];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark others
- (NSString *) displayString:(Byte)days
{
    //    NSLog(@"days char is: %02x",days);
    NSString *str = [NSString stringWithFormat:@""];
    
    if (days>>6 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Sat", nil)]];
    }
    
    if (days>>5 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Fri", nil)]];
    }
    
    if (days>>4 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Thurs", nil)]];
    }
    
    if (days>>3 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Wed", nil)]];
    }
    
    if (days>>2 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Tues", nil)]];
    }
    
    if (days>>1 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Mon", nil)]];
    }
    if (days>>0 &0x01) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",NSLocalizedString(@"Sun", nil)]];
    }

    if (days == 0) {
        str = NSLocalizedString(@"Not Set", nil);
    }
    
    if (days == 0xFF)
    {
        str = NSLocalizedString(@"Everyday", nil);
    }
    
    return str;
}

@end
