//
//  MTKDataHandle.m
//  ZeronerHealthPro
//
//  Created by west on 2017/11/28.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import "MTKDataHandle.h"

@implementation MTKDataHandle


+ (void)handleTable6XRawDataData:(Table6XRawData *)rawData {
    [[F1SQLManager shareInstance] insertIndexTableRawData:rawData];
    NSDate *date = [NSDate dateWithString:rawData.date formatString:@"yyyy-MM-dd HH:mm:ss"];
    if (rawData.dataType == Table61RawData) {
        Data61Model *start_model = [[F1SQLManager shareInstance] select61DataWithUser:rawData.uid DataFrom:rawData.data_from Date:date Seq:rawData.startSeq];
        NSInteger endSeq = rawData.endSeq;
        if (endSeq - 4096 > 0) {
            endSeq = endSeq - 4096;
        }
        Data61Model *end_model = [[F1SQLManager shareInstance] select61DataWithUser:rawData.uid DataFrom:rawData.data_from Date:date Seq:endSeq-1];
        if (start_model && end_model) {
            rawData.isSync = YES;
        }
    } else if (rawData.dataType == Table62RawData) {
        Data62Model *start_model = [[F1SQLManager shareInstance] select62DataWithUser:rawData.uid DataFrom:rawData.data_from Date:date Seq:rawData.startSeq];
        NSInteger endSeq = rawData.endSeq;
        if (endSeq - 2048 > 0) {
            endSeq = endSeq - 2048;
        }
        Data62Model *end_model = [[F1SQLManager shareInstance] select62DataWithUser:rawData.uid DataFrom:rawData.data_from Date:date Seq:endSeq-1];
        if (start_model && end_model) {
            rawData.isSync = YES;
        }
    }
    [[F1SQLManager shareInstance] updateSyncStateWithRawData:rawData];
}

+ (void)handleIndexTableData:(NSDictionary *)dict Type:(Table6XRawDataType)type {
    NSString *data_from = [dict objectForKey:@"data_from"];
    [[F1SQLManager shareInstance] deleteAllDataInTableRawDataWithType:type Uid:USER_UID DataFrom:data_from];
    ZRDataInfo *dataInfo = [dict objectForKey:@"data_info"];
    NSArray *dataArr = dataInfo.ddInfos;
    if ([dataArr count] > 0) {
        for (DDInfo *dInfo in dataArr) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [dateFormatter stringFromDate:dInfo.date];
            NSDictionary *dic = @{@"startSeq":@(dInfo.seqStart),@"endSeq":@(dInfo.seqEnd),@"date":dateStr};
            Table6XRawData *rawData = [[Table6XRawData alloc] init];
            [rawData setValuesForKeysWithDictionary:dic];
            NSDate *aData = [NSDate dateWithString:rawData.date formatString:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [NSDate date];
            NSInteger agoDays = [date daysFrom:aData];
            if(agoDays > 30) {
                continue;
            }
            if (rawData.startSeq == rawData.endSeq) {
                continue;
            }
            rawData.uid = USER_UID;
            rawData.dataType = type;
            rawData.data_from = data_from;
            [self handleTable6XRawDataData:rawData];
        }
    }
}

/**
 //按天归类
 //    {
 //        data =     (
 //                    "<Table6XRawData: 0x1c1060cc0>",
 //                    "<Table6XRawData: 0x1c066a5c0>"
 //                    );
 //        date = "2017-09-29";
 //    },
 
 @param dataArr <#dataArr description#>
 @return <#return value description#>
 */
+ (NSArray *)handleTable6xRawDataWithArray:(NSArray *)dataArr {
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
    Table6XRawData *tmpRawData = nil;
    
    for (int i = 0; i < dataArr.count; i++) {
        Table6XRawData *rawData = dataArr[i];
        if (tmpRawData != nil) {
            if (rawData.date == nil) {
                continue;
            }
            if (![[rawData.date substringToIndex:10] isEqualToString:[tmpRawData.date substringToIndex:10]]) {
                NSArray *arr = [NSArray arrayWithArray:tmpArr];
                NSDictionary *dic = @{@"date":[tmpRawData.date substringToIndex:10], @"data":arr};
                [tmpArr removeAllObjects];
                [muArr addObject:dic];
            }
        }
        
        if (i == [dataArr count] - 1) {
            if (tmpRawData != nil) {
                if (rawData.date) {
                    if (![[rawData.date substringToIndex:10] isEqualToString:[tmpRawData.date substringToIndex:10]]) {
                        NSArray *arr2 = @[rawData];
                        NSDictionary *dic2 = @{@"date":[rawData.date substringToIndex:10], @"data":arr2};
                        [muArr addObject:dic2];
                    } else {
                        NSArray *arr = @[tmpRawData, rawData];
                        NSDictionary *dic = @{@"date":[rawData.date substringToIndex:10], @"data":arr};
                        [muArr addObject:dic];
                    }
                }
            } else {
                NSArray *arr = @[rawData];
                NSDictionary *dic = @{@"date":[rawData.date substringToIndex:10], @"data":arr};
                [muArr addObject:dic];
            }
        }
        tmpRawData = rawData;
        [tmpArr addObject:rawData];
    }
    
    return muArr;
}

@end
