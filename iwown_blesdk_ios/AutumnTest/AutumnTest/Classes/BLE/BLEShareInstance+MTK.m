//
//  BLEShareInstance+MTK.m
//  linyi
//
//  Created by west on 2017/11/25.
//  Copyright © 2017年 com.kunekt.healthy. All rights reserved.
//

#import "BLEShareInstance+MTK.h"

@implementation BLEShareInstance (MTK)

- (void)startSyn6xData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DDInfo *syscObject;
        SD_TYPE type;
        if (self.dInfo61Arr.count > 0) { //61未同步完
            type = SD_TYPE_DATA_NORMAL;
            NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = (int)self.dInfo61Arr.count;i > 0;i--) {
                DDInfo *obj = self.dInfo61Arr[i-1];
                if (i == self.dInfo61Arr.count) {
                    syscObject = obj;
                }else {
                    [mArr addObject:obj];
                }
            }
            self.dInfo61Arr = mArr;
        }else if (self.dInfo62Arr.count > 0) { //62未同步完
            type = SD_TYPE_GNSS_SEGMENT;
            NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = (int)self.dInfo62Arr.count;i > 0;i--) {
                DDInfo *obj = self.dInfo62Arr[i-1];
                if (i == self.dInfo62Arr.count) {
                    syscObject = obj;
                }else {
                    [mArr addObject:obj];
                }
            }
            self.dInfo62Arr = mArr;
        }else if (self.dInfo64Arr.count > 0) { //62未同步完
            type = SD_TYPE_ECG;
            NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = (int)self.dInfo64Arr.count;i > 0;i--) {
                DDInfo *obj = self.dInfo64Arr[i-1];
                if (i == self.dInfo64Arr.count) {
                    syscObject = obj;
                }else {
                    [mArr addObject:obj];
                }
            }
            self.dInfo64Arr = mArr;
        }else {
            [self syncFinishedFor6X];
            return;
        }
        [[BLEShareInstance bleSolstice] startSpecialData:type withDate:syscObject.date startSeq:syscObject.seqStart endSeq:syscObject.seqEnd];
    });
}

- (void)syns60Data {
    [[BLEShareInstance bleSolstice] startSpecialData:SD_TYPE_DATA_SUMMARY];
}

#pragma mark - BLE Delegate
/**! seqA is less|early than seqB, return YES.
 * if seqA=4000, seqB = 100; return YES;
 */
- (BOOL)seqCompare:(NSInteger)seqA andLaterOne:(NSInteger)seqB {
    if ((seqA > seqB) || ((seqA + 2000) < seqB)) {
        return NO;
    }
    return YES;
}

- (void)responseOfHealth61IndexTable:(ZRDataInfo *)dInfo andDataFrom:(NSString *)data_from {
    [self startSyn6xData];
}

- (void)responseOfHealth61Data:(NSDictionary *)dict andDataFrom:(NSString *)data_from {
    [self startSyn6xData];
}

- (void)responseOfGNSS62IndexTable:(ZRDataInfo *)dInfo andDataFrom:(NSString *)data_from {
    [self startSyn6xData];
}

- (void)responseOfGNSS62Data:(NSDictionary *)dict andDataFrom:(NSString *)data_from {
    NSLog(@"GNSS62Data======seq========%@", [dict objectForKey:@"seq"]);
    [self startSyn6xData];
}

- (void)responseOfECGIndexTable:(ZRDataInfo *)dInfo andDataFrom:(NSString *)data_from {
    [self startSyn6xData];
}

- (void)responseOfECGData:(NSDictionary *)dict andDataFrom:(NSString *)data_from {
    NSLog(@"ECG64Data======seq========%@", [dict objectForKey:@"seq"]);
    [self startSyn6xData];
}

- (void)syncFinishedFor6X{
}

- (void)responseOfExercise:(NSString *)string {
    
}

@end
