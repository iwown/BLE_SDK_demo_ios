//
//  DeviceStateView.h
//  IW_BLESDK
//
//  Created by caike on 15/12/25.
//  Copyright © 2015年 iwown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceStateViewDelegate

- (void)deviceStateViewDidClicked;

@end

@interface DeviceStateView : UIView
@property (strong, nonatomic) UILabel *nameL;
@property (strong, nonatomic) UILabel *stateL;
@property (strong, nonatomic) UILabel *batteryL;
@property (strong, nonatomic) UILabel *timeL;
@property (strong, nonatomic) UILabel *versionL;
@property (strong, nonatomic) UILabel *modelL;

@property (nonatomic ,weak) id<DeviceStateViewDelegate> delegate;

- (void)setStateLText:(NSInteger )state;
- (void)setNameLText:(NSString *)name;
- (void)setTimeLText:(NSString *)time;
- (void)setBatteryLText:(NSInteger)battery;
- (void)setversionLText:(NSString *)version;
- (void)setModelLText:(NSString *)model;

- (void)clearView;
@end
