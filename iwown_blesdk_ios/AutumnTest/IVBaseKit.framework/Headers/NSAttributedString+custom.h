//
//  NSAttributedString+custom.h
//  ZeronerHealthPro
//
//  Created by 曹凯 on 2017/7/6.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (custom)

+ (NSAttributedString *)stringToAttributeString:(NSString *)valueStr
font:(UIFont *)fonta
                                            and:(NSString *)unitStr
                                        andfont:(UIFont *)fontb;

+ (NSAttributedString *)stringToAttributeString:(NSString *)valueStr
                                          color:(UIColor *)colora
                                            and:(NSString *)unitStr
                                       andColor:(UIColor *)colorb;

+ (NSAttributedString *)stringToAttributeString:(NSString *)valueStr
                                          color:(UIColor *)colora
                                           font:(UIFont *)fonta
                                            and:(NSString *)unitStr
                                       andColor:(UIColor *)colorb
                                        andfont:(UIFont *)fontb;

+ (NSAttributedString *)stringToAttributeString:(NSArray <NSString *>*)string
                                        andFont:(NSArray <UIFont *>*)font
                                       andColor:(NSArray <UIColor *>*)color;
@end
