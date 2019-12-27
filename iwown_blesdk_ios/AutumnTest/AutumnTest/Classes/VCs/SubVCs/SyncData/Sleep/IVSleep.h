//
//  IVSleep.h
//  IVSleep
//
//  Created by A$CE on 2017/9/22.
//  Copyright © 2017年 A$CE. All rights reserved.
//

typedef enum
{
    IV_SA_STATE_SLEEP_NN = 0,
    IV_SA_STATE_SLEEP_IN,//入睡
    IV_SA_STATE_SLEEP_OUT,//起床
    IV_SA_STATE_SLEEP_DEEP_SLEEP,//深睡
    IV_SA_STATE_SLEEP_SHALLOW_SLEEP,//浅睡
    IV_SA_STATE_SLEEP_LAY_UP,//放置
    IV_SA_STATE_SLEEP_WAKE_UP//清醒
}iv_sa_sleepState;

/*time*/
typedef struct IV_SA_TimeInfo
{
    int year;
    int month;
    int day;
    int hour;
    int minute;
}IV_SA_TimeInfo;

typedef struct IV_SA_SleepDataInfo
{
    //单组睡眠的开始时间
    IV_SA_TimeInfo startTime;
    //单组睡眠的结束时间
    IV_SA_TimeInfo stopTime;
    //该组的睡眠状态
    iv_sa_sleepState type;
}IV_SA_SleepDataInfo;

typedef struct IV_SA_SleepBufInfo
{
    //睡眠组数
    int total;
    //多组睡眠详细数据
    IV_SA_SleepDataInfo *data;
    //入睡时间
    IV_SA_TimeInfo inSleepTime;
    //起床时间
    IV_SA_TimeInfo outSleepTime;
}IV_SA_SleepBufInfo;


#import <Foundation/Foundation.h>

@interface IVSleep : NSObject

/**
 通过文件路径，文件参数获取计算后的睡眠数据。文件名与参数紧密相关，文件名fomatter{uid_dName_date_cmd.txt}

 @param sleepPath 文件路径
 @param uid The uid int file name
 @param date DateString ,formatter is yyyyMMdd, contain in file name
 @param dName Device_name ,contained in file name
 @param error Return nil means successful
 @return See the struct{IV_SA_SleepBufInfo}
 */
- (IV_SA_SleepBufInfo)ivSleepData:(NSString *)sleepPath andUid:(unsigned long long)uid andDate:(NSString *)date andDeviceName:(NSString *)dName andError:(NSError **)error;



- (IV_SA_SleepBufInfo)ivSleepDataFrom:(NSString *)yesterdayPath andTodayPath:(NSString *)todayPath andDate:(NSString *)date andError:(NSError **)error;







@end
