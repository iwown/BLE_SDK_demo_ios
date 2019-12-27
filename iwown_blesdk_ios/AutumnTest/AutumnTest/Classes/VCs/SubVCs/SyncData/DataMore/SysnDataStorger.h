//
//  SysnDataStorger.h
//  AutumnTest
//
//  Created by A$CE on 2019/5/15.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SysnDataStorger : NSObject

+ (instancetype)shareStorger;

- (void)addData:(id)obj;
- (NSArray *)getData;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
