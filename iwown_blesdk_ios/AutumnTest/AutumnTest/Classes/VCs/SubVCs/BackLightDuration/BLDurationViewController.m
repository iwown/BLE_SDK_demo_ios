//
//  BLDurationViewController.m
//  AutumnTest
//
//  Created by west on 2019/12/19.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import "BLDurationViewController.h"

#import "BLEShareInstance.h"

@interface BLDurationViewController ()<BLEShareInstanceDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)UIButton *readBtn;
@property (nonatomic, strong)UIPickerView *pinckView;
@property (nonatomic, strong)UILabel  *contentLabel;

@end

@implementation BLDurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawUI];
    
    [BLEShareInstance shareInstance].bkDataDeleagte = self;
    [[[BLEShareInstance shareInstance] bleSolstice] readDeviceOption];
}

- (void)viewWillDisappear:(BOOL)animated {
    [BLEShareInstance shareInstance].bkDataDeleagte = nil;
}

- (void)drawUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentLabel];
//    [self.view addSubview:self.readBtn];
    [self.view addSubview:self.pinckView];
}

#pragma mark - getter
- (UIButton *)readBtn {
    if (_readBtn) {
        return _readBtn;
    }
    
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _readBtn.frame = CGRectMake(0, 0, 200, 50);
    _readBtn.center = CGPointMake(self.view.center.x, 200);
    _readBtn.backgroundColor = [UIColor orangeColor];
    [_readBtn setTitle:@"read" forState:UIControlStateNormal];
    [_readBtn addTarget:self action:@selector(readBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _readBtn;
}

- (UILabel *)contentLabel {
    if (_contentLabel) {
        return _contentLabel;
    }
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    _contentLabel.center = CGPointMake(self.view.center.x, 100);
    _contentLabel.text = [NSString stringWithFormat:@"back light duration: -- s"];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.numberOfLines = 0;
    return _contentLabel;
}

- (UIPickerView *)pinckView {
    if (_pinckView) {
        return _pinckView;
    }
    _pinckView = [[UIPickerView alloc]init];
    [self.view addSubview:_pinckView];
    [_pinckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(@250);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    _pinckView.delegate = self;
    _pinckView.dataSource = self;
    return _pinckView;
}

- (void)readBtnClick {
    [[[BLEShareInstance shareInstance] bleSolstice] readDeviceOption];
}


#pragma mark - BLEShareInstanceDelegate
- (void)updateDeviceOption:(ZRHWOption *)option {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentLabel.text = [NSString stringWithFormat:@"back light duration: %ld s", option.bsDuration];
    });
    
}

#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return  40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    label.text = [NSString stringWithFormat:@"%ld", row];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ZRHWOption *opt = [ZRHWOption defaultModel];
    opt.bsDuration = row;
    [[BLEShareInstance shareInstance].bleSolstice setDeviceOption:opt];
    self.contentLabel.text = [NSString stringWithFormat:@"back light duration: %ld s", opt.bsDuration];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
