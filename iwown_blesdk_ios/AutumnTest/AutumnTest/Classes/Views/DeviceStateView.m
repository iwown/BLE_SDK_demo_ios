//
//  DeviceStateView.m
//  IW_BLESDK
//
//  Created by caike on 15/12/25.
//  Copyright © 2015年 iwown. All rights reserved.
//

#import "DeviceStateView.h"

@implementation DeviceStateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameL = [[UILabel alloc] init];
        _stateL = [[UILabel alloc] init];
        _batteryL = [[UILabel alloc] init];
        _versionL = [[UILabel alloc] init];
        _timeL = [[UILabel alloc] init];
        _modelL = [[UILabel alloc] init];
        
        [_nameL setFont:[UIFont systemFontOfSize:15]];
        [_stateL setFont:[UIFont systemFontOfSize:15]];
        [_batteryL setFont:[UIFont systemFontOfSize:15]];
        [_versionL setFont:[UIFont systemFontOfSize:15]];
        [_timeL setFont:[UIFont systemFontOfSize:15]];
        [_modelL setFont:[UIFont systemFontOfSize:15]];

        [_batteryL setTextAlignment:NSTextAlignmentRight];
        [_batteryL setTextColor:[UIColor lightGrayColor]];
        [_versionL setTextAlignment:NSTextAlignmentRight];
        [_modelL setTextColor:[UIColor greenColor]];
        [_timeL setTextColor:[UIColor blueColor]];
        [_versionL setTextColor:[UIColor darkGrayColor]];

        [self addSubview:_nameL];
        [self addSubview:_stateL];
        [self addSubview:_batteryL];
        [self addSubview:_versionL];
        [self addSubview:_timeL];
        [self addSubview:_modelL];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        [self setStateLText:2];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.delegate deviceStateViewDidClicked];
}

- (void)drawRect:(CGRect)rect {
    _nameL.frame = CGRectMake(20, 0, 120, 30);
    _modelL.frame = CGRectMake(160, 0, 80, 30);
    _batteryL.frame = CGRectMake(260, 0, 80, 30);
    _stateL.frame = CGRectMake(20, 30, 100, 30);
    _timeL.frame = CGRectMake(160, 30, 80, 30);
    _versionL.frame = CGRectMake(220, 30, 120, 30);
}

- (void)setNameLText:(NSString *)name {
    _nameL.text = name;
}

- (void)setStateLText:(NSInteger )state {
    if (state == 1) {
        _stateL.text = @"Connected";
        _stateL.textColor = [UIColor orangeColor];
    }
    if (state == 0) {
        _stateL.text = @"Unconnected";
        _stateL.textColor = [UIColor blackColor];
    }
    if (state == 2 ) {
        _stateL.text = @"Start to Scan";
        _stateL.textColor = [UIColor redColor];
    }
}

- (void)setTimeLText:(NSString *)time {
    _timeL.text = time;
}

- (void)setBatteryLText:(NSInteger)battery {
    _batteryL.text = [NSString stringWithFormat:@"P:%ld%%",(long)battery];
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"HH:mm"];
    NSString *dateStr = [dateF stringFromDate:[NSDate date]];
    [self setTimeLText:dateStr];
}

- (void)setversionLText:(NSString *)version {
    _versionL.text = version;
}

- (void)setModelLText:(NSString *)model {
    _modelL.text = model;
}

- (void)clearView {
    _batteryL.text = @"";
    _versionL.text = @"";
    _timeL.text = @"";
    _modelL.text = @"";
    _nameL.text = @"";
    [self setStateLText:2];
}

@end
