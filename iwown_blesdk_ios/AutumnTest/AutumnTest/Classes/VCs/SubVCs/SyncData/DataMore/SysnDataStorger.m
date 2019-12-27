//
//  SysnDataStorger.m
//  AutumnTest
//
//  Created by A$CE on 2019/5/15.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import "SysnDataStorger.h"

@implementation SysnDataStorger
{
    NSMutableArray *__tmpDataArr;
}

static SysnDataStorger *__sds = nil;
+ (instancetype)shareStorger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sds = [[SysnDataStorger alloc] init];
    });
    return __sds;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        __tmpDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)addData:(id)obj {
    [__tmpDataArr addObject:obj];
}

- (NSArray *)getData {
    return __tmpDataArr;
}

- (void)clear {
    [__tmpDataArr removeAllObjects];
}

@end
