//
//  SportDetailAc.m
//  AutumnTest
//
//  Created by A$CE on 2019/4/3.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import "SportDetailAc.h"
#import <IVBaseKit/IVBaseKit.h>
#import <BLEMidAutumn/BLEMidAutumn.h>


@implementation SportMinute

//@property (nonatomic, strong)NSDate *date;
//@property (nonatomic, assign)NSInteger sport_type;  //10进制
//@property (nonatomic, assign)NSInteger step;
//@property (nonatomic, assign)float     distance;    //单位：米
//@property (nonatomic, assign)float     calorie;     //单位：千卡
//@property (nonatomic, assign)NSInteger state_type;
//@property (nonatomic, assign)NSInteger pre_minute;
- (NSString *)description {
    return [NSString stringWithFormat:@"Date:%@; SportType:%ld; Step:%ld", _date, (long)_sport_type, (long)_step];
}

+ (NSArray <SportMinute *>*)sportMinutesByZRSports:(NSArray <ZRData61Model *>*)sports {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (ZRData61Model *model61 in sports) {
        SportMinute *s = [[SportMinute alloc] init];
        s.date = model61.recordDate;
        s.sport_type = model61.sport_type;
        s.step = model61.step;
        s.distance = model61.distance;
        s.calorie = model61.calorie;
        s.state_type = model61.state_type;
        s.pre_minute = model61.pre_minute;
        [mArr addObject:s];
    }
    return mArr;
}

@end

@implementation IVSportsModel

- (NSString *)description {
    return [NSString stringWithFormat:@"StartTime:%@; EndTime:%@; SportType:%ld; Step:%ld; Activity:%ld", _start_time, _end_time, (long)_sport_type, (long)_steps, (long)_activity];
}

- (NSString *)cellViewText {
    return [NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld; Type:%ld; Step:%ld; Activity:%ld", (long)_start_time.hour,(long)_start_time.minute, (long)_end_time.hour,(long)_end_time.minute, (long)_sport_type, (long)_steps, (long)_activity];
}

@end

@implementation SportDetailAc

+ (NSArray *)sportArithmetic:(NSArray <SportMinute *>*)data {
    NSMutableArray<IVSportsModel*> *tmp28SportAry = @[].mutableCopy;
    //运动类型相同 运动时间间隔在1min 为 28 数据（一次类型的运动）
    NSInteger i = 0;
    NSInteger j = 0;
    NSInteger __sportType = 0;
    for (i = 0; i < data.count; ) {
        SportMinute *tmp61II = data[i];
        NSDate *tmp61IIDate = tmp61II.date;
        IVSportsModel *sModel = [[IVSportsModel alloc] init];
        sModel.start_time = tmp61IIDate;
        sModel.sport_type = tmp61II.sport_type;
        sModel.steps = tmp61II.step;
        sModel.calorie = tmp61II.calorie;
        sModel.distance = tmp61II.distance;
        
        if (__sportType == 0) {
            __sportType = tmp61II.sport_type;
        }
        
        SportMinute *tmpPreModel = nil;
        
        if (i < data.count - 1) {
            for (j = i + 1; j < data.count; ++j) {
                SportMinute *tmp61JJ = data[j];
                
                if (__sportType != tmp61JJ.sport_type) {
                    sModel.end_time = tmp61JJ.date;
                    sModel.activity = (j-i)*60;
                    [tmp28SportAry addObject:sModel];
                    __sportType = 0;
                    break;
                }
                
                if (tmp61JJ.sport_type != SD_SPORT_TYPE_WALKING) {
                    //自动识别的运动
                    tmpPreModel = tmp61JJ;
                }
                
                SportMinute *tmp61JJBefore = data[j-1];
                BOOL isInFive = NO;
                //和上一条数据比较，时间在5分钟以内
                if ([tmp61JJ.date timeIntervalSinceDate:tmp61JJBefore.date] < 300) {
                    isInFive = YES;
                }

                if (isInFive) {
                    sModel.steps+=tmp61JJ.step;
                    sModel.calorie+=tmp61JJ.calorie;
                    sModel.distance+=tmp61JJ.distance;
                    
                    if (j==data.count-1) {//最后一条需要合并
                        sModel.end_time = tmp61JJ.date;
                        sModel.activity = (j-i)*60;
                        [SportDetailAc subtractingPreMinuteSport:sModel withPreModel:tmpPreModel];
                        [tmp28SportAry addObject:sModel];
                        ++j;
                        break;
                    }
                } else {
                    //不能合并
                    [SportDetailAc subtractingPreMinuteSport:sModel withPreModel:tmpPreModel];
                    if (j==i+1) {
                        //没有要合并的数据
                        sModel.end_time = tmp61IIDate;
                        sModel.activity = (j-i)*60;
                        [tmp28SportAry addObject:sModel];
                        break;
                    } else {
                        //合并完的数据
                        SportMinute *tmp61JJLast = data[j-1];//合并的最后一组数据
                        NSDate* tmp61JJLastDate = tmp61JJLast.date;
                        sModel.end_time = tmp61JJLastDate;
                        sModel.activity = (j-i)*60;
                        [tmp28SportAry addObject:sModel];
                        break;
                    }
                }
            }
            i = j;
        } else {
            //最后一条
            sModel.activity = 60;
            sModel.end_time = tmp61IIDate;
            [tmp28SportAry addObject:sModel];
            i++;
        }
    }
    return tmp28SportAry;
}

+ (IVSportsModel *)subtractingPreMinuteSport:(IVSportsModel *)sportModel withPreModel:(SportMinute *)tmpPreModel {
    if (tmpPreModel) {
        sportModel.steps-=(tmpPreModel.step*2);
        sportModel.calorie-=(tmpPreModel.calorie*2);
        sportModel.distance-=(tmpPreModel.distance*2);
        sportModel.activity-=(tmpPreModel.pre_minute);
    }
    return sportModel;
}

@end
