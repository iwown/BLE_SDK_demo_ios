//
//  ClockViewController.m
//  IW_BLESDK
//
//  Created by caike on 15/12/28.
//  Copyright © 2015年 iwown. All rights reserved.
//
#import "Header.h"
#import "BLEShareInstance.h"
#import "ClockViewController.h"
#define Weekdays @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"]

@interface ClockViewController ()<UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField     *_idTf;
    UITextField     *_tipsTf;
    UIPickerView    *_timePicker;
    NSInteger       _hour;
    NSInteger       _minute;
    NSInteger       _repeat;
    NSInteger       _clockId;
}
@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParme];
    [self initUI];
}

#pragma mark - Param

- (void)initParme
{
    [[BLEShareInstance shareInstance] readSchedule];
//    for (int i = 0 ; i < 8; i ++) {
//        [[BLEShareInstance shareInstance] readAlarmClock:0];
//    }
//    [[BLELib3 shareInstance] clearAllSchedule];
}

#pragma mark - UI

- (void)initUI
{
    [super initUI];
    [self drawClockId];
    [self drawTimePicker];
    [self drawWeekSelect];
    [self drawSaveBtn];
}

- (void)drawClockId
{
    UIView *idView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.08)];
    [self.view addSubview:idView];
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 180, 28)];
    idLabel.text = @"Clock ID";
    idLabel.font = [UIFont systemFontOfSize:16];
    [idView addSubview:idLabel];
    
    _idTf = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.8-120, 10, 120, 28)];
    _idTf.placeholder = @"Id,0~7";
    _idTf.borderStyle = UITextBorderStyleRoundedRect;
    _idTf.keyboardType = UIKeyboardTypeNumberPad;
    _idTf.textAlignment = NSTextAlignmentCenter;
    _idTf.delegate = self;
    [idView addSubview:_idTf];
    
    UIView *line = [[UIView alloc]init];
    [idView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(idView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1.5));
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
}

- (void)drawTimePicker
{
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.08, SCREEN_WIDTH, SCREEN_HEIGHT*0.40)];
    [self.view addSubview:timeView];
    
    UILabel *timeTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 180, 28)];
    timeTitle.text = @"时间设置(Date Setting)";
    timeTitle.font = [UIFont systemFontOfSize:17];
    [timeView addSubview:timeTitle];
    
    _timePicker = [[UIPickerView alloc]init];
    [timeView addSubview:_timePicker];
    [_timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(timeView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.6, 156));
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
    label1.font = [UIFont boldSystemFontOfSize:30];
    label1.text = @":";
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
    UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.48, SCREEN_WIDTH, SCREEN_HEIGHT*0.25)];
    CGFloat h = SCREEN_HEIGHT*0.25;
    [self.view addSubview:weekView];
    
    UILabel *weekTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 180, 28)];
    weekTitle.text = @"重复设置(Repeat)";
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
        btn.tag = 1000 + i;
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
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.73, SCREEN_WIDTH, SCREEN_HEIGHT*0.08)];
    [self.view addSubview:btnView];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnView.mas_centerX);
        make.top.equalTo(btnView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT*0.08));
    }];
    [leftBtn setTitle:@"设置(Setting)" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma btnActions

- (void)weekSelectAction:(id)sender {
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

- (void)setBtnAction:(id)sender {
    ZRSchedule *schedule = [[ZRSchedule alloc] initWithTitile:@"日程" subTitle:@"日程" year:2017 month:7 day:11 hour:16 minute:30];
    
    ZRClock *clock = [[ZRClock alloc]init];
    clock.clockId = [_idTf.text integerValue];
    clock.weekRepeat = _repeat;
    clock.clockHour = _hour;
    clock.clockMinute = _minute;
    clock.clockTips = @"12345678901234567890";
    clock.clockRingSetting = 0x03;
    [[BLEShareInstance shareInstance] setSchedule:@[schedule] andClocks:@[clock]];
}

#pragma mark pickerView delegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.3, 40)];
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%02ld",(long)row%24];
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%02ld",(long)row%60];
        }
        label.font = [UIFont boldSystemFontOfSize:32.0];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.3, 40)];
        [view addSubview:label];
    }
    
    return view;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        return  24*21;
    }
    else //if (pickerView.tag == 102)
    {
        return  60*11;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH*0.3;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _hour = row%24;
    }else {
        _minute = row%60;
    }
}
@end

