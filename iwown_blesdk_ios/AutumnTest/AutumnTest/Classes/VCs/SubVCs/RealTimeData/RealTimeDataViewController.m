//
//  RealTimeDataViewController.m
//  AutumnTest
//
//  Created by west on 2019/12/19.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import "RealTimeDataViewController.h"

#import "BLEShareInstance.h"

#import "NSDate+DateTools.h"

@interface RealTimeDataViewController ()<BLEShareInstanceDelegate>

@property (nonatomic, strong)UIButton *startBtn;
@property (nonatomic, strong)UIButton *stopBtn;

@property (nonatomic, strong)UILabel  *rawDataLabel;

@property (nonatomic, strong)UILabel  *didFilterLabel;

@property (nonatomic, strong)NSDate   *startDate;
@property (nonatomic, strong)NSMutableArray  *ecgData;
@property (nonatomic, strong)NSMutableArray  *ppgData;

@property (nonatomic, strong)NSMutableArray  *didFilterEcgData;

@property (nonatomic, assign)NSInteger  timeIntevel;

@property (nonatomic, strong)ECGFilter  *ecgFilter;

@end

@implementation RealTimeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawUI];
    
    [BLEShareInstance shareInstance].bkDataDeleagte = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    NSArray *arr = @[@(RealTime_ECG), @(RealTime_PPG)];
    [[BLEShareInstance shareInstance].bleSolstice stopReadRealTimeDataWithTypes:arr];
    [BLEShareInstance shareInstance].bkDataDeleagte = nil;
}

- (void)drawUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.stopBtn];
    [self.view addSubview:self.rawDataLabel];
    [self.view addSubview:self.didFilterLabel];
}

#pragma mark - getter
- (UIButton *)startBtn {
    if (_startBtn) {
        return _startBtn;
    }
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(40, 90, 100, 50);
    _startBtn.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:128.0/255.0 blue:149.0/255.0 alpha:1.0];
    [_startBtn setTitle:@"start" forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _startBtn;
}

- (UIButton *)stopBtn {
    if (_stopBtn) {
        return _stopBtn;
    }
    
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.frame = CGRectMake(240, 90, 100, 50);
    _stopBtn.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:128.0/255.0 blue:149.0/255.0 alpha:1.0];
    [_stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [_stopBtn addTarget:self action:@selector(stopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _stopBtn;
}

- (UILabel *)rawDataLabel {
    if (_rawDataLabel) {
        return _rawDataLabel;
    }
    
    _rawDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, [[UIScreen mainScreen] bounds].size.width - 20, 250)];
    _rawDataLabel.numberOfLines = 0;
    _rawDataLabel.text = [NSString stringWithFormat:@"raw data:--"];
    _rawDataLabel.textColor = [UIColor blackColor];
    _rawDataLabel.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:128.0/255.0 blue:149.0/255.0 alpha:1.0];
    
    return _rawDataLabel;
}

- (UILabel *)didFilterLabel {
    if (_didFilterLabel) {
        return _didFilterLabel;
    }
    
    _didFilterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 420, [[UIScreen mainScreen] bounds].size.width - 20, 200)];
    _didFilterLabel.numberOfLines = 0;
    _didFilterLabel.text = [NSString stringWithFormat:@"ecg filter data:--"];
    _didFilterLabel.textColor = [UIColor blackColor];
    _didFilterLabel.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:128.0/255.0 blue:149.0/255.0 alpha:1.0];
    
    return _didFilterLabel;
}

- (NSMutableArray *)ecgData {
    if (!_ecgData) {
        _ecgData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _ecgData;
}

- (NSMutableArray *)ppgData {
    if (!_ppgData) {
        _ppgData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _ppgData;
}

- (NSMutableArray *)didFilterEcgData {
    if (!_didFilterEcgData) {
        _didFilterEcgData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _didFilterEcgData;
}

- (ECGFilter *)ecgFilter {
    if (!_ecgFilter) {
        _ecgFilter = [[ECGFilter alloc] init];
    }
    return _ecgFilter;
}

#pragma mark - action
- (void)startBtnClick {
    [self.ecgData removeAllObjects];
    [self.ppgData removeAllObjects];
    [self.ecgFilter resetECGFilter];
    _startDate = [NSDate date];
    _timeIntevel = 10;
    NSArray *arr = @[@(RealTime_ECG), @(RealTime_PPG)];
    [[BLEShareInstance shareInstance].bleSolstice startReadRealTimeDataWithTypes:arr];
}

- (void)stopBtnClick {
    NSArray *arr = @[@(RealTime_ECG), @(RealTime_PPG)];
    [[BLEShareInstance shareInstance].bleSolstice stopReadRealTimeDataWithTypes:arr];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld_%ld_%ld_%ld_%ld_%ld", _startDate.year, _startDate.month, _startDate.day, _startDate.hour, _startDate.minute, _startDate.second];
    NSString *ecgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", dateString, @"ecg.txt"]];
    NSString *ppgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", dateString, @"ppg.txt"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    if (self.ecgData.count > 100) {
        NSData *muData = [NSJSONSerialization dataWithJSONObject:self.ecgData options:0 error:&error];
        if (error) {
            self.rawDataLabel.text = [NSString stringWithFormat:@"ecg:error"];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:muData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"[" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"]" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        @try {
            [fileManager createFileAtPath:ecgPath contents:data attributes:nil];
        } @catch (NSException *exception) {
            NSLog(@"NSException: ecg %@",exception);
            self.rawDataLabel.text = [NSString stringWithFormat:@"ecg:exception"];
        } @finally {
            
        }
    }
    
    if (self.ppgData.count > 100) {
        NSData *muData = [NSJSONSerialization dataWithJSONObject:self.ppgData options:0 error:&error];
        if (error) {
            self.rawDataLabel.text = [NSString stringWithFormat:@"ppg:error"];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:muData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"[" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"]" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        @try {
            [fileManager createFileAtPath:ppgPath contents:data attributes:nil];
        } @catch (NSException *exception) {
            NSLog(@"NSException: ppg %@",exception);
            self.rawDataLabel.text = [NSString stringWithFormat:@"ppg:exception"];
        } @finally {
            
        }
    }
    
}

#pragma mark - BLEShareInstanceDelegate
- (void)receiveRealtimeData:(NSInteger)type Data:(NSArray *)data {
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    if (type == RealTime_ECG) {
        [self.ecgData addObjectsFromArray:data];
        
        for (int i = 0; i < [data count]; i++) {
            int ecg = [data[i] intValue];
            int fEcg = [self.ecgFilter filterECGValue:ecg];
            [muArr addObject:[NSNumber numberWithInt:fEcg]];
            [self.didFilterEcgData addObject:[NSNumber numberWithInt:fEcg]];
        }
        
    } else if (type == RealTime_PPG) {
        [self.ppgData addObjectsFromArray:data];
    }
    
    _timeIntevel++;
    __weak RealTimeDataViewController *__weak_self = self;
    if (_timeIntevel < 5) {
        return;
    }
    
    NSData *rawData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    NSString *rawDataString = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (type == RealTime_ECG) {
            __weak_self.rawDataLabel.text = [NSString stringWithFormat:@"ecg data:\n%@", rawDataString];
            if ([muArr count] > 0) {
                NSData *filterData = [NSJSONSerialization dataWithJSONObject:muArr options:0 error:nil];
                NSString *filterECG = [[NSString alloc] initWithData:filterData encoding:NSUTF8StringEncoding];
                __weak_self.didFilterLabel.text = [NSString stringWithFormat:@"ecg filter data:\n%@", filterECG];
            }
            
        } else if (type == RealTime_PPG) {
            __weak_self.rawDataLabel.text = [NSString stringWithFormat:@"ppg data:\n%@", rawDataString];
        }
        __weak_self.timeIntevel = 0;
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
