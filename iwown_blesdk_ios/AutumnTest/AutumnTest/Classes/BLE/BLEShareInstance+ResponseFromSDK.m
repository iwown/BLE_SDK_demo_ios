//
//  BLEShareInstance+ResponseFromSDK.m
//  linyi
//
//  Created by CY on 2017/11/2.
//  Copyright © 2017年 com.kunekt.healthy. All rights reserved.
//
#import "BLEShareInstance+ResponseFromSDK.h"
#import <AVFoundation/AVFoundation.h>
#import <IVBaseKit/IVBaseKit.h>
#import "BLEShareInstance.h"

@implementation BLEShareInstance (ResponseFromSDK)


#pragma mark- 手环向app传输数据，回调方法
- (void)updateDataDate:(ZRDataInfo *)zrDInfo {
    NSMutableArray *dateArr = [[NSMutableArray alloc]initWithCapacity:10];
    NSDate *currentDate = [NSDate date];
    for(int i=0;i<zrDInfo.ddInfos.count;i++){
        NSDate *date = [zrDInfo.ddInfos[i] date];
        if ([date daysBeforeDate:currentDate] >30) { //1个月前的数据视为无效，不作处理
            continue;
        }
        if (![dateArr containsObject:date]) {
            [dateArr addObject:date];
        }
    }

    [dateArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = obj1;
        NSDate *date2 = obj2;
        return [date1 isEarlierThanDate:date2];
    }];

    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    NSDate *local_first_date = [self local_first_date];
    for (NSDate *date in dateArr) {
        if ([date isLaterThanDate:local_first_date]) {
            [mArr addObject:date];
        }
    }
    self.dateArr = mArr;
}
/**! This method is obtained in the data part of the date on the date of the synchronization data needs to be used here to do some processing these dates, for example, to give up 1 month ago and recently synchronized data,
    It is assumed here that the last synchronization was 5 days ago.
 */
- (NSDate *)local_first_date {
    return [NSDate dateWithDaysFromNow:-7];
}

- (id)parseDataMdictIfNeed:(ZRHealthData *)zrhData{
    if ([zrhData.data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:zrhData.data];
        [mDict setObject:ZRHealthData.dataFrom forKey:@"data_from"];
        zrhData.data = mDict;
    }else if ([zrhData.data isKindOfClass:[NSArray class]]) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in zrhData.data) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [mDict setObject:ZRHealthData.dataFrom forKey:@"data_from"];
            [mArr addObject:mDict];
        }
        zrhData.data = mArr;
    }
    return zrhData.data;
}

- (void)updateNormalHealthDataInfo:(ZRDataInfo *)zrDInfo {
    NSLog(@"%s,zrDInfo = %@",__FUNCTION__,zrDInfo);
    if (zrDInfo.dataType == ZRDITypeNormalHealth) {
        self.dInfo61Arr = zrDInfo.ddInfos;
    } else if (zrDInfo.dataType == ZRDITypeGNSSData) {
        self.dInfo62Arr = zrDInfo.ddInfos;
    } else if(zrDInfo.dataType == ZRDITypeHbridHealth ||
             zrDInfo.dataType == ZRDITypeNormalData){
        [self updateDataDate:zrDInfo];
    } else if (zrDInfo.dataType == ZRDITypeECGHealth) {
        self.dInfo64Arr = zrDInfo.ddInfos;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BLE_SYSCDATA_GETDATASCORE object:nil];
    });
}

- (void)updateDataProgress:(NSInteger)progress {
    NSLog(@"%s ====>>>> %ld",__func__,(long)progress);
}

- (void)updateNormalHealthData:(ZRHealthData *)zrhData {
  
    HealthDataInfo hdInfo = zrhData.hdInfo;
    
    switch (hdInfo.hdType) {
        case HDTypeSummary:
        {
            ZRSummaryData *data = (ZRSummaryData *)zrhData;
            NSLog(@"Summary data :%@",data);
        }
            break;
        case HDTypeSport:
        {
            ZRSportData *data = (ZRSportData *)zrhData;
            NSLog(@"Sport data :%@",data);
        }
            break;
        case HDTypeSleep:
        {
            ZRSleepData *data = (ZRSleepData *)zrhData;
            NSLog(@"Sleep data :%@",data);
        }
            break;
        case HDTypeHrHours:
        {
            ZRHRateHoursData *data = (ZRHRateHoursData *)zrhData;
            NSLog(@"Heart rate hours data :%@",data);
        }
            break;
            //知格步数数据
        case HDTypeZGStep:{
            int totalStep = 0;
            for (NSNumber *stepNum in [(ZRStepData *)zrhData stepArr]) {
                totalStep += stepNum.integerValue;
            }
            NSLog(@"HDTypeZGStep ::: %ld",(long)totalStep);
//            id data = zrhData.data;
//            NSArray *arr = [self handlePracticeDataToSportDataWithStepData:data];
//            for (ZRSportModel *sport in arr) {
////                self.bkDataDeleagte updateSportData:<#(NSDictionary *)#>
//            }
        }
            break;
        case HDTypeHealthMinute:
        {
            [self.dataDelegate updateBleSyscData:zrhData];
        }
            break;
        case HDTypeGNSSMinute:
        {
           
        }
            break;
        case HDTypeGNSSNow:
        {
            
        }
            break;
        case HDTypeECG:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)responseOfGetDataTimeOutWithDataType:(NSInteger)type {
    switch (type) {
        case 0x04://SCQASCTypeSyncDataDateData = 0x04,
            break;
        default:
            break;
    }
}
- (void)responseHeartRateData:(NSInteger)hr {
    NSLog(@"blehshareinstance======hr:%ld", hr);
}

- (void)responseOfExerciseStatus:(NSInteger)status {
    NSLog(@"responseOfExerciseStatus===============status:%ld", status);
}

- (void)responseOfExerciseSport:(sd_sportType)sportType {
    NSLog(@"responseOfExerciseSport===============sportType:%ld", sportType);
}

- (void)syscDataFinishedStateChange:(KSyscDataState)ksdState {
    NSLog(@"syscDataFinishedStateChange============ksdState:%ld", ksdState);
}


#pragma mark - 设备设置回调

- (void)readResponseFromDevice:(ZRReadResponse *)response {
    switch (response.cmdResponse) {
        case CMD_RESPONSE_DEVICE_GET_INFORMATION:
        case CMD_RESPONSE_DEVICE_GET_BATTERY:
        {
            ZRDeviceInfo *deviceInfo = response.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"GetDeviceInfo" object:deviceInfo];
            });
        }
            break;
        case CMD_RESPONSE_DEVICE_DND_MODE:
        {
            
        }
            break;
        case CMD_RESPONSE_CONFIG_GET_HW_OPTION:
        {
            ZRHWOption *opt = response.data;
            NSLog(@"readResponseFromDevice======%@", opt);
            if (self.bkDataDeleagte && [self.bkDataDeleagte respondsToSelector:@selector(updateDeviceOption:)]) {
                [self.bkDataDeleagte updateDeviceOption:opt];
            }
        }
            break;
        case CMD_RESPONSE_CONFIG_GET_SPORT_LIST:
        {
            
        }
            break;
        case CMD_RESPONSE_CLOCK_AND_SCHEDULE:
        {
            
        }
            break;
        case CMD_RESPONSE_USERINFO_GET:
        {
        }
            break;
        case CMD_RESPONSE_DEVICE_MANUFACTURE_DATE:
        {
            NSLog(@"%@",response.data);
        }
            break;
        case CMD_RESPONSE_DEVICE_FACTORY_CONF:
        {
            NSLog(@"%@",response.data);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - notify 回调
- (void)responseKeyNotify:(BKeyNotify)bkn {
    switch (bkn) {
        case BKN_SET_SmartPhoto:
            [self notifyToTakePicture];
            break;
        case BKN_GET_SearchPhone:
            [self notifyToSearchPhone];
            break;
        default:
            break;
    }
}


#pragma mark -

- (void)notifyToTakePicture
{
    NSLog(@"%s",__func__);
}

- (void)notifyToSearchPhone
{
    NSLog(@"%s",__func__);
}


//- (void)responseOfConnectStatus:(BOOL)isReady {
//    NSLog(@"%s",__func__);
//    NSLog(@"responseOfConnectStatus=========%d", isReady);
//}

#pragma mark - 血压
- (void)responseOfBloodPressureData:(NSArray *)data {
    NSLog(@"==============responseOfBloodPressureData================%@", data);
}

#pragma mark - realtime sensor data response
- (void)responseOfRealTimeSensorData:(ZRSensorDataModel *)sData {
    if (self.bkDataDeleagte && [self.bkDataDeleagte respondsToSelector:@selector(receiveRealtimeData:Data:)]) {
        [self.bkDataDeleagte receiveRealtimeData:sData.sType Data:sData.detailData];
        return;
    }
    switch (sData.sType) {
        case RealTime_ECG:
        {
            for (int i = 0; i < sData.detailData.count; i++) {
                int tmp = [[sData.detailData objectAtIndex:i] intValue];
                int ecg = tmp*2000/5700;
                [self.ecgArr addObject:@(ecg)];
            }
        }
            break;
        case RealTime_PPG:
        {
            
        }
            break;
       
        default:
            break;
    }
}

- (void)filterECGData {
    if (self.ecgArr.count > 300) {
        [self.ecgArr removeObjectsInRange:NSMakeRange(0, 300)];
    }
    
    if (self.ecgArr.count > 300) {
        [self.ecgArr removeObjectsInRange:NSMakeRange(self.ecgArr.count - 300, 300)];
    }
    
    NSError *error;
    NSData *muData = [NSJSONSerialization dataWithJSONObject:self.ecgArr options:0 error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:muData encoding:NSUTF8StringEncoding];
        NSLog(@"=====muArr===jsonString:%@", jsonString);
    }
    
    NSArray *reArr = [ECGFilter filterEcgData:self.ecgArr];
    NSData *data = [NSJSONSerialization dataWithJSONObject:reArr options:0 error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"=====reArr===jsonString:%@", jsonString);
    }
}

@end
