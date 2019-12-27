//
//  SportTargetViewController.m
//  IW_BLESDK
//
//  Created by caike on 15/12/28.
//  Copyright © 2015年 iwown. All rights reserved.
//
#import "Header.h"
#import "BLEShareInstance.h"
#import "SportTargetViewController.h"
#define Weekdays @[ @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat",@"Sun"]
@interface SportTargetViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_arr1;
    NSMutableArray *_arr3;
    NSInteger      _length;
    NSInteger      _index;
    NSInteger      _count;
    
    NSInteger      _weekDay;
    NSInteger      _sportCount;
    UIPickerView   *_pickerView;
    UILabel        *_countL;
    UIView         *_view1;
    UIButton       *_addBtn;
    
    ZRSportLists *_st;
}




@end

@implementation SportTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
}

- (void)initParam
{
    [super initParam];
    _st = [[ZRSportLists alloc]init];
//    NSDictionary *dic = [[BLEShareInstance shareInstance]getSupportSportsList];
//    _arr1 = dic[@"LIST"];
//    _arr3 = dic[@"UNIT"];
//    _length = [dic[@"LENGTH"] integerValue];
    [[BLEShareInstance shareInstance] readV3Target];
}

- (void)initUI
{
    [super initUI];
    [self drawDaySelect];
    [self drawPickerView];
    [self drawSaveBtn];
}

- (void)drawDaySelect
{
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.25)];
    CGFloat h = SCREEN_HEIGHT*0.25;
    [self.view addSubview:_view1];
    
    UILabel *weekTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 180, 28)];
    weekTitle.text = @"Weekday";
    weekTitle.font = [UIFont systemFontOfSize:17];
    [_view1 addSubview:weekTitle];
    
    for (int i = 0; i <7; i++) {
        int row = i/4;
        int column = i%4;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((SCREEN_WIDTH-240)/2.0+60*column, (h-120)/2.0+30+40*row, 35, 35)];
        [btn setTitle:Weekdays[i] forState:UIControlStateNormal];
        [btn setTitle:Weekdays[i] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_view1 addSubview:btn];
        btn.tag = 1006-i;
        [btn addTarget:self action:@selector(daySelectAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
        }
    }

    UIView *line = [[UIView alloc]init];
    [_view1 addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->_view1);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2));
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}


- (void)drawPickerView
{
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [_pickerView selectRow:0 inComponent:1 animated:YES];
    _index = 0;
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.25, SCREEN_WIDTH, SCREEN_HEIGHT*0.40)];
    [self.view addSubview:view2];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, 10, SCREEN_WIDTH*0.3, 28)];
    label1.text = @"运动类型(Type)";
    label1.font = [UIFont systemFontOfSize:17];
    label1.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, 10, SCREEN_WIDTH*0.3, 28)];
    label2.text = @"持续量(Amount of exercise)";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:17];
    [view2 addSubview:label2];
    
    _pickerView = [[UIPickerView alloc]init];
    [view2 addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view2);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.6, 156));
    }];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    _countL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.4-30, SCREEN_WIDTH*0.6, 30)];
    [view2 addSubview:_countL];
    _countL.font = [UIFont systemFontOfSize:14];
    _countL.text = @"星期一 运动个数:";
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_addBtn setTitle:@"保存(Save)" forState:UIControlStateNormal];
    [_addBtn setFrame:CGRectMake(SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.4-30, SCREEN_WIDTH*0.15,30)];
    [_addBtn addTarget:self action:@selector(saveSportAction:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:_addBtn];
    
    
    
    UIView *line = [[UIView alloc]init];
    [view2 addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view2);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1.5));
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

- (void)drawSaveBtn
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.65, SCREEN_WIDTH, SCREEN_HEIGHT*0.12)];
    [self.view addSubview:btnView];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnView.mas_centerX);
        make.top.equalTo(btnView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT*0.12));
    }];
    [leftBtn setTitle:@"设置(Setting)" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _arr1.count;
    }
    else{
        return 100;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return  40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH*0.3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.3, 40)];
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@", _arr1[row]];
        }
        else {
            NSInteger unit = [pickerView selectedRowInComponent:0];
            label.text = [NSString stringWithFormat:@"%ld %@",(long)(row*5),_arr3[unit]];
        }
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.3, 40)];
        [view addSubview:label];
    }
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _index = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (component == 1) {
        _count = row*5;
    }
}

#pragma mark action
- (void)saveSportAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10086) {
        [btn setTitle:@"添加(Add)" forState:UIControlStateNormal];
        btn.tag = 10010;
        _sportCount = 0;
        _countL.text = [NSString stringWithFormat:@"%@ Current %ld",Weekdays[_weekDay],(long)_sportCount];
        [_st.sportArr removeAllObjects];
    }
    else {
        if (_st.sportArr.count >= _length) {
            return;
        }
        _sportCount ++;
        SportModel *sm = [[SportModel alloc]init];
        [sm setType:(sd_sportType)[_arr1[_index] intValue]];
        [sm setTargetNum:_count];
        [_st addSportModel:sm];
        NSLog(@"添加%@运动 %@",Weekdays[_weekDay],sm);
        _countL.text = [NSString stringWithFormat:@"%@ Current %ld",Weekdays[_weekDay],(long)_sportCount];
        
        if (_sportCount == _length) {
            [btn setTitle:@"重置(Reset)" forState:UIControlStateNormal];
            btn.tag = 10086;
        }
    }
}

- (void)daySelectAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    _weekDay = 1006 - btn.tag;
    _sportCount = 0;
    _countL.text = [NSString stringWithFormat:@"%@ Current %ld",Weekdays[_weekDay],(long)_sportCount];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    _addBtn.tag = 10010;
    if (btn.selected) {
        
    }else {
        NSArray *subArr = [_view1 subviews];
        for (UIView *v in subArr) {
            if ([v isKindOfClass:[UIButton class]]) {
                ((UIButton *)v).selected = NO;
            }
        }
        btn.selected = YES;
        _st.day = _weekDay;
        [_st.sportArr removeAllObjects];;
    }
}

- (void)setBtnAction:(id)sender
{
    NSLog(@"设置运动目标 %@",_st);
    [[BLEShareInstance shareInstance]setSportTargetBy:_st];
}

@end
