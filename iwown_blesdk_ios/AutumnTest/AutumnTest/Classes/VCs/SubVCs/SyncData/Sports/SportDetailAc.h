//
//  SportDetailAc.h
//  AutumnTest
//
//  Created by A$CE on 2019/4/3.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZRData61Model;
@interface SportMinute : NSObject

@property (nonatomic, strong)NSDate *date;
@property (nonatomic, assign)NSInteger sport_type;  //10进制
@property (nonatomic, assign)NSInteger step;
@property (nonatomic, assign)float     distance;    //单位：米
@property (nonatomic, assign)float     calorie;     //单位：千卡
@property (nonatomic, assign)NSInteger state_type;
@property (nonatomic, assign)NSInteger pre_minute;

+ (NSArray <SportMinute *>*)sportMinutesByZRSports:(NSArray <ZRData61Model *>*)sports;

@end


@interface IVSportsModel : NSObject

@property (nonatomic ,strong) NSDate *start_time;
@property (nonatomic ,strong) NSDate *end_time;
@property (nonatomic ,assign) NSInteger sport_type;
@property (nonatomic ,assign) NSInteger activity; //时长   unit s 秒
@property (nonatomic ,assign) NSInteger steps;  //步数
@property (nonatomic ,assign) NSInteger count;  //个数
@property (nonatomic ,assign) CGFloat distance; //距离 unit is meter
@property (nonatomic ,assign) CGFloat calorie; //（kCal）

- (NSString *)cellViewText;

@end


@interface SportDetailAc : NSObject


+ (NSArray *)sportArithmetic:(NSArray <SportMinute *>*)data;

@end

NS_ASSUME_NONNULL_END
