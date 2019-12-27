//
//  BLEShareInstance+MTK.h
//  linyi
//
//  Created by west on 2017/11/25.
//  Copyright © 2017年 com.kunekt.healthy. All rights reserved.
//

#import "BLEShareInstance.h"

@interface BLEShareInstance (MTK)

- (void)syncFinishedFor6X;

- (void)responseOfHealth61IndexTable:(ZRDataInfo *)dInfo andDataFrom:(NSString *)data_from;
- (void)responseOfHealth61Data:(NSDictionary *)dict andDataFrom:(NSString *)data_from;
- (void)responseOfGNSS62IndexTable:(ZRDataInfo *)dInfo andDataFrom:(NSString *)data_from;
- (void)responseOfGNSS62Data:(NSDictionary *)dict andDataFrom:(NSString *)data_from;
- (void)responseOfECGIndexTable:(ZRDataInfo *)dInfo andDataFrom:(NSString *)data_from;
- (void)responseOfECGData:(NSDictionary *)dict andDataFrom:(NSString *)data_from;

@end
