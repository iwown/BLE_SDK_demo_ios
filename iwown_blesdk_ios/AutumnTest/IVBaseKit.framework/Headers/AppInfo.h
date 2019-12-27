//
//  AppInfo.h
//  ZeronerHealthPro
//
//  Created by CY on 2017/4/24.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 这个类用来获取跟app相关的一些信息
 */
@interface AppInfo : NSObject

//获取app的展示名
+ (NSString *)getDisplayName;
//获取app的主版本号，比如：5.0
+ (NSString *)getMajorVersion;
//获取app的build号，比如：2212
+ (NSString *)getBuildVersion;
//获取app的版本号，比如：5.0（2212）
+ (NSString *)getAppVersion;

@end
