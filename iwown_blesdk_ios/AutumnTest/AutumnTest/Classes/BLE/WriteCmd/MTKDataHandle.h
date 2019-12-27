//
//  MTKDataHandle.h
//  ZeronerHealthPro
//
//  Created by west on 2017/11/28.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MTKDataHandle : NSObject


/**
 @param dict NSDictionary,  type Table6XRawDataType
 */
+ (void)handleIndexTableData:(NSDictionary *)dict Type:(Table6XRawDataType)type;

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
+ (NSArray *)handleTable6xRawDataWithArray:(NSArray *)dataArr;

@end
