//
//  SedentaryViewController.m
//  IW_BLESDK
//
//  Created by caike on 15/12/28.
//  Copyright © 2015年 iwown. All rights reserved.
//
#import "Header.h"
#import "BLEShareInstance.h"
#import "SedentaryViewController.h"

#define Weekdays @[ @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat",@"Sun"]
@interface SedentaryViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger _start;
    NSInteger _end;
    NSInteger _repeat;
    UITextField     *_idTf;
    UIPickerView    *_timePicker;
}

@end

@implementation SedentaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
}

- (void)initParam
{
    
}

- (void)initUI
{
    [super initUI];
    [self drawTimePicker];
    [self drawWeekSelect];
    [self drawSaveBtn];
}

- (void)drawTimePicker
{
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.40)];
    [self.view addSubview:timeView];
    
    UILabel *timeTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 180, 28)];
    timeTitle.text = @"Time Setting";
    timeTitle.font = [UIFont systemFontOfSize:17];
    [timeView addSubview:timeTitle];
    
    _timePicker = [[UIPickerView alloc]init];
    [timeView addSubview:_timePicker];
    [_timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(timeView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.7, 156));
    }];
    _timePicker.delegate = self;
    _timePicker.dataSource = self;
    
    [_timePicker setShowsSelectionIndicator:YES];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_timePicker addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->_timePicker);
        make.size.mas_equalTo(CGSizeMake(10, 40));
    }];
    label1.font = [UIFont boldSystemFontOfSize:21];
    label1.text = @"One";
    label1.textAlignment = NSTextAlignmentCenter;
    
    UIView *line = [[UIView alloc]init];
    [timeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(timeView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1.5));
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

- (void)drawWeekSelect
{
    UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.4, SCREEN_WIDTH, SCREEN_HEIGHT*0.25)];
    CGFloat h = SCREEN_HEIGHT*0.25;
    [self.view addSubview:weekView];
    
    UILabel *weekTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 180, 28)];
    weekTitle.text = @"重复设置(Repeat Setting)";
    weekTitle.font = [UIFont systemFontOfSize:17];
    [weekView addSubview:weekTitle];
    
    for (int i = 0; i <7; i++) {
        int row = i/4;
        int column = i%4;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((SCREEN_WIDTH-240)/2.0+60*column, (h-120)/2.0+30+50*row, 35, 35)];
        [btn setTitle:Weekdays[i] forState:UIControlStateNormal];
        [btn setTitle:Weekdays[i] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [weekView addSubview:btn];
        btn.tag = 1006-i;
        [btn addTarget:self action:@selector(weekSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *line = [[UIView alloc]init];
    [weekView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weekView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2));
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}


- (void)drawSaveBtn
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.65, SCREEN_WIDTH, SCREEN_HEIGHT*0.15)];
    [self.view addSubview:btnView];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnView).offset(-80);
        make.top.equalTo(btnView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT*0.15));
    }];
    [leftBtn setTitle:@"设置(Setting)" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnView).offset(80);
        make.top.equalTo(leftBtn);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT*0.15));
    }];
    [rightBtn setTitle:@"读取(Read)" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(readSedentaryMotion) forControlEvents:UIControlEventTouchUpInside];
}


#pragma btnActions

- (void)weekSelectAction:(id)sender
{
    UIButton *btn  = (UIButton *)sender;
    NSInteger i = btn.tag-1000;
    if (_repeat == 0) {
        _repeat = 128;
    }
    if (btn.selected) {
        btn.selected = NO;
        _repeat -= 1 << i;
    }else {
        btn.selected = YES;
        _repeat += 1 << i;
    }
    NSLog(@"%ld   %@",(long)_repeat,[self displayString:_repeat]);
}

- (void)setBtnAction:(id)sender
{
    ZRSedentary *sd = [[ZRSedentary alloc]init];
    sd.startHour = _start;
    sd.endHour = _end;
    sd.switchStatus = YES;
    sd.weekRepeat = _repeat;
    sd.noDisturbing = YES;
    [[BLEShareInstance shareInstance] setAlertMotionReminder:sd];
}

#pragma mark pickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 24;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return  40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH*0.35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view == nil) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.35, 40)];
        label.text = [NSString stringWithFormat:@"%02ld:00",(long)row];
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textAlignment = NSTextAlignmentCenter;
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.35, 40)];
        [view addSubview:label];
    }
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _start = row;
    }else {
        _end = row;
    }
}

- (void)readSedentaryMotion {
    [[BLEShareInstance shareInstance] readSedentaryMotion];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
