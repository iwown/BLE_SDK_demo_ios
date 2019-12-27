//
//  SleepViewController.h
//  AutumnTest
//
//  Created by A$CE on 2019/3/11.
//  Copyright © 2019年 A$CE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SleepViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/*
 1.睡眠算法包是用来处理采用新数据协议的设备计算睡眠时使用的，如P1手表和Dong2手表。支持两者数据格式的内容，一种是无后缀名的简单文本，将获取的二进制数据逐行写入文本即可，P1手表采用此方法；另一种是json格式数据，将得到的数据按协议json格式写入文件，Dong2使用此协议。
 2.算法会输出IV_SA_SleepBufInfo的结构体，睡眠的开始时间，结束时间以及每一小段睡眠的开始结束时间点和状态。
 3.睡眠状态，1-开始，2-结束，3-深睡，4-浅睡，5-放置，6-清醒；请查看枚举iv_sa_sleepState。
 
 1. The sleep lib is used to process sleep calculations using devices using the new data protocol, such as P1 watches and Dong2 watches. Support the content of the two data formats, one is a simple text without a suffix name, the binary data obtained can be written to the text line by line, the P1 watch adopts this method; the other is the json format data, the obtained data is pressed The protocol json format is written to the file, and Dong2 uses this protocol.
 2. The algorithm will output the structure of IV_SA_SleepBufInfo, the start time of sleep, the end time, and the start time and state of each small sleep.
 3. Sleep state, 1-start, 2-end, 3-deep sleep, 4-light sleep, 5-place, 6-awake; check the enumeration iv_sa_sleepState.
 */

/**Dong2_Sleep_lib_input Json_file_1.3.md
 
 ### Dong2睡眠Json字段说明
 
 ##### 更新日志
 * 2018-12月 去掉HRV 1.3 曹凯
 * 2018-11月 增加SEQ 1.2 曹凯
 * 2018-10月 修改时间格式 1.1 曹凯
 * 2018-8月 初稿 1.0 曹凯
 
 ##### 结构
 
 ```
 [//分钟数据数组*
 {
 "Q":1573,//SEQ
 "T":[],//时分数组，为此处只有Hour和minute。
 "E":{},//数据分类
 "P":{
     "s":"",//分类信息详情
     "a":""
     }
 }
 ]
 ```
 ##### 字典中key值说明
 *  分钟数据字典
 - Q         Sequence Number
 - T            Time
 - E            Sleep
 - P            Pedo
 - H            HeartRate
 *     数据分类:Sequence Number
 - 整数
 *     数据分类:Time
 - [hour, minute] //此处为了节约空间，将日期写在文件名里
 *      数据分类:Sleep
 - a            Array
 - s            shutdown
 - c            charge
 *  数据分类:Pedo
 - s            Step
 - d            Distance
 - c            Calorie
 - t            Type
 - a            State
 *     数据分类:HeartRate
 - x            MaxBpm
 - n            MinBpm
 - a            AvgBpm
 
 ##### 数据示例(Demo)
 
 ```
 [{
 "E": {
     "a": [30, 70, 55, 0, 10]
     },
 "P": {
     "d": 115,
     "a": 0,
     "s": 18,
     "t": 1,
     "c": 5
     }
 },  {
 "E": {
     "a": [4, 16, 8, 0, 140]
     }
 }]
 ```
 */
