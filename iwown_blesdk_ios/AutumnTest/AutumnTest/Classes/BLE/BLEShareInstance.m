//
//  BLEShareInstance.m
//  BLETest
//
//  Created by A$CE on 2017/10/12.
//  Copyright © 2017年 A$CE. All rights reserved.
//

#import "BLEShareInstance.h"





@interface BLEShareInstance()<BleDiscoverDelegate,BleConnectDelegate,BLEquinox>
{
   NSMutableArray *_deviceArray;
}

@property (nonatomic ,strong)BLEAutumn *bleAutumn;

@end

@implementation BLEShareInstance
static BLEShareInstance *shareBLEInstance = nil;

+ (BLEShareInstance *) shareInstance {
    @synchronized(shareBLEInstance)
    {
        if (!shareBLEInstance)
        {
            shareBLEInstance = [[BLEShareInstance alloc]init];
        }
    }
    
    return shareBLEInstance;
}

+ (id<BLESolstice>)bleSolstice {
    return [[BLEShareInstance shareInstance] bleSolstice];
}

- (id)init {
    self = [super init];
    if (self) {
        _deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.bleAutumn = [BLEAutumn midAutumn:BLEProtocol_Any];
        self.bleAutumn.discoverDelegate = self;
        self.bleAutumn.connectDelegate = self;
        [self recoverConnectIfNeed];
        [self.bleAutumn isBound];
    }
    return self;
}

- (void)recoverConnectIfNeed {
    NSError *error = [self.bleAutumn reConnectDevice];
    if (error) {
        NSLog(@"%@",error);
    }
}

- (void)syscTimeAtOnce {
    [self.bleSolstice syscTimeAtOnce];
}

- (void)readDeviceInfo {
    [self.bleSolstice readDeviceInfo];
    [self.bleSolstice readDeviceBattery];
}

- (void)readConnectState {
    [self.bleSolstice getConnectionStatus];
}

#pragma mark -device&&state
- (void)scanDevice{
    [_deviceArray removeAllObjects];
    [self.bleAutumn startScan];
}
- (void)stopScan{
    [self.bleAutumn stopScan];
}
- (NSArray *)getDevices{
    return _deviceArray;
}
- (void)connectDevice:(ZRBlePeripheral *)device{
    [self.bleAutumn bindDevice:device];
}
- (void)reConnectDevice {
    NSError *error = [self.bleAutumn reConnectDevice];
    if (error) {
        NSLog(@"%s :%@",__func__,error);
    }
}
- (void)unConnectDevice {
    [self.bleAutumn unbind];
    self.bleSolstice = nil;
}

- (void)deviceFWUpdate {
    [self.bleSolstice deviceUpgrade];
}

#pragma mark- Device&config
- (void)setFirmwareOption:(ZRHWOption *)hwOption{
    [self.bleSolstice setDeviceOption:hwOption];
}
- (void)readFirmwareOption {
    [self.bleSolstice readDeviceOption];
}

- (void)setCustomOptions:(ZRCOption *)zrcOption {
    [self.bleSolstice setCustomOptions:zrcOption];
}
- (void)readCustomOptions {
    [self.bleSolstice readCustomOptions];
}

- (void)readSedentaryMotion {
    [self.bleSolstice readSedentary];
}
- (void)setAlertMotionReminder:(ZRSedentary *)sds {
    [self.bleSolstice setSedentary:sds];
}

- (void)setSportTargetBy:(ZRSportLists *)zrST {
    [self.bleSolstice setSportLists:zrST];
}

- (void)readV3Target {
    [self.bleSolstice readSportLists];
}

- (void)setSchedule:(NSArray *)schedules andClocks:(NSArray *)clocks {
    [self.bleSolstice setAlarmClocks:clocks andSchedules:schedules];
}

- (void)readSchedule {
    [self.bleSolstice readEHRWParam];
}

- (void)readClocks {
    [self.bleSolstice readAlarmClocks:^(NSArray *arr) {
        NSLog(@"%@", arr);
    }];
}

#pragma mark- discover&ConnectDelegate
- (void)solsticeStopScan {
    
}

- (void)solsticeDidDiscoverDeviceWithMAC:(ZRBlePeripheral *)iwDevice {
    [_deviceArray addObject:iwDevice];
}

- (void)solsticeDidConnectDevice:(ZRBlePeripheral *)device {
    self.bleSolstice = [self.bleAutumn solstice];
    NSLog(@"solsticeDidConnectDevice::%@",self.bleSolstice);
    [self.bleAutumn registerSolsticeEquinox:self];
     dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DEVICEDIDCONNECTED" object:device.deviceName];
    });
}

- (void)solsticeDidDisConnectWithDevice:(ZRBlePeripheral *)device andError:(NSError *)error {
    NSLog(@"%s %@ == %@",__func__,device,error);
}
#pragma mark- BLEquinox Delegate
- (void)readRequiredInfoAfterConnect {
    [self readDeviceInfo];
}

-(void)testZGECGAuto
{
    [self.bleSolstice testECGModel];
}

- (NSString *)bleLogPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *foldPath = [documentDirectory stringByAppendingFormat:@"/ble"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [formatter setDateFormat:@"yyyy-MM-dd"]; //每天保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [foldPath stringByAppendingFormat:@"/BLE_%@.txt",dateStr];
    return logFilePath;
}

#pragma mark- 微教练Test
- (void)startExercise {
    [self.bleSolstice startExercise];
}

- (void)startExerciseWithSportType:(sd_sportType)sportType {
    [self.bleSolstice startExerciseWithType:sportType];
}

- (void)endExercise {
    [self.bleSolstice endExercise];
}
- (void)pauseExercise {
    [self.bleSolstice pauseExercise];
}

- (void)openStandardHR {
    [self.bleSolstice switchStandardHeartRate:YES];
}

- (void)closeStandardHR {
    [self.bleSolstice switchStandardHeartRate:NO];
}


#pragma mark -
- (NSMutableArray *)ecgArr {
    if (!_ecgArr) {
        _ecgArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _ecgArr;
}


@end
