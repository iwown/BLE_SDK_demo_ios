//
//  NSObject+JsonData.h
//  ZLYIwown
//
//  Created by CY on 2016/12/6.
//  Copyright © 2016年 Iwown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonData)
/**
 * 描述：将NSArray或者NSDictionary转化为NSData
 * 参数：
 * 返回值：转化后的NSData
 *
 */
-(NSData*)JSONData;

/**
 * 描述：将NSArray或者NSDictionary转化为NSString
 * 参数：
 * 返回值：转化后的NSString
 *
 */
-(NSString*)JSONString;
@end
