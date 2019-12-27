//
//  BLEMidAutumnTests.m
//  BLEMidAutumnTests
//
//  Created by A$CE on 2018/1/11.
//  Copyright © 2018年 A$CE. All rights reserved.
//
#import "ZRModel.h"
#import "BLEZg.h"
#import "ZGBLEHelper.h"
#import <XCTest/XCTest.h>

@interface BLEMidAutumnTests : XCTestCase
{
    BLEZg *testZg;

}
@end

@implementation BLEMidAutumnTests

- (void)setUp {
    [super setUp];
    testZg = [[BLEZg alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetWeather {
    /*温度合理范围摄氏-50～50，无效值100；华氏-58～122*/
    NSDate *now = [NSDate date];
    WeatherType type = WeatherFine;
    for (int i = -50; i < 100; i ++) {
        NSInteger temperature = (NSInteger)i;
        NSString *dataStr = [ZGBLEHelper syscTime:now withWeather:type andTemperature:temperature];
        if (dataStr.length %2 == 0) {
            NSLog(@"Successful == >>%@",dataStr);
        }else {
            NSLog(@"Error == >>%@ ,length is error:%d",dataStr,(int)dataStr.length);
        }
    }
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
