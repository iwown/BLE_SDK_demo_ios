//
//  BLEShareInstance.h
//  BLETest
//
//  Created by A$CE on 2017/10/12.
//  Copyright © 2017年 A$CE. All rights reserved.
//
#import <BLEMidAutumn/BLEMidAutumn.h>
#import <Foundation/Foundation.h>


#define BLE_SYSCDATA_GETDATASCORE @"BLE_SYSCDATA_GETDATASCORE"

@protocol BKDataDeleagte <NSObject>

- (void)updateBleSyscData:(id)data;

@end

@interface BLEShareInstance : NSObject
@property (nonatomic ,weak)id<BLESolstice> bleSolstice;
/**! Date lists of execise and health data in device*/
@property (nonatomic ,strong) NSArray *dateArr;
@property (nonatomic ,strong) NSArray *dInfo61Arr;
@property (nonatomic ,strong) NSArray *dInfo62Arr;
@property (nonatomic ,strong) NSArray *dInfo64Arr;

@property (nonatomic ,weak) id<BKDataDeleagte> dataDelegate;

+ (BLEShareInstance *)shareInstance;
+ (id<BLESolstice>)bleSolstice;

- (void)scanDevice;
- (void)stopScan;
- (NSArray *)getDevices;

- (void)deviceFWUpdate;

- (void)connectDevice:(ZRBlePeripheral *)device;
- (void)unConnectDevice;
- (void)reConnectDevice;

- (void)syscTimeAtOnce;
- (void)readDeviceInfo;

- (void)readConnectState;

- (void)setFirmwareOption:(ZRHWOption *)hwOption;
- (void)readFirmwareOption;
- (void)setCustomOptions:(ZRCOption *)zrcOption;
- (void)readCustomOptions;

- (void)readSedentaryMotion;
- (void)setAlertMotionReminder:(ZRSedentary *)sds;

- (void)setSportTargetBy:(ZRSportLists *)zrST;
- (void)readV3Target;

- (void)setSchedule:(NSArray *)schedules andClocks:(NSArray *)clocks;
- (void)readSchedule;
- (void)readClocks;

-(void)testZGECGAuto;

#pragma mark- 微教练Test
- (void)startExercise;
- (void)startExerciseWithSportType:(sd_sportType)sportType;
- (void)endExercise;
- (void)pauseExercise;

- (void)openStandardHR;
- (void)closeStandardHR;


@end
