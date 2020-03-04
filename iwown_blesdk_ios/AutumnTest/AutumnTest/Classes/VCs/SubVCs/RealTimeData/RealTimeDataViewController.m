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

@property (nonatomic, strong)UILabel  *contentLabel;

@property (nonatomic, strong)NSDate   *startDate;
@property (nonatomic, strong)NSMutableArray  *ecgData;
@property (nonatomic, strong)NSMutableArray  *ppgData;

@property (nonatomic, assign)NSInteger  timeIntevel;

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
    [self.view addSubview:self.contentLabel];
}

#pragma mark - getter
- (UIButton *)startBtn {
    if (_startBtn) {
        return _startBtn;
    }
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(40, 70, 100, 50);
    _startBtn.backgroundColor = [UIColor orangeColor];
    [_startBtn setTitle:@"start" forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _startBtn;
}

- (UIButton *)stopBtn {
    if (_stopBtn) {
        return _stopBtn;
    }
    
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.frame = CGRectMake(240, 70, 100, 50);
    _stopBtn.backgroundColor = [UIColor orangeColor];
    [_stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [_stopBtn addTarget:self action:@selector(stopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _stopBtn;
}

- (UILabel *)contentLabel {
    if (_contentLabel) {
        return _contentLabel;
    }
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 500)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = [NSString stringWithFormat:@"content:--"];
    _contentLabel.textColor = [UIColor blackColor];
    
    return _contentLabel;
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

- (void)startBtnClick {
    [self.ecgData removeAllObjects];
    [self.ppgData removeAllObjects];
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
            self.contentLabel.text = [NSString stringWithFormat:@"ecg:error"];
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
            self.contentLabel.text = [NSString stringWithFormat:@"ecg:exception"];
        } @finally {
            
        }
    }
    
    if (self.ppgData.count > 100) {
        NSData *muData = [NSJSONSerialization dataWithJSONObject:self.ppgData options:0 error:&error];
        if (error) {
            self.contentLabel.text = [NSString stringWithFormat:@"ppg:error"];
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
            self.contentLabel.text = [NSString stringWithFormat:@"ppg:exception"];
        } @finally {
            
        }
    }
    
}

#pragma mark - BLEShareInstanceDelegate
- (void)receiveRealtimeData:(NSInteger)type Data:(NSArray *)data {
    if (type == RealTime_ECG) {
        [self.ecgData addObjectsFromArray:data];
    } else if (type == RealTime_PPG) {
        [self.ppgData addObjectsFromArray:data];
    }
    _timeIntevel++;
    __weak RealTimeDataViewController *__weak_self = self;
    if (_timeIntevel < 5) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak_self.contentLabel.text = [NSString stringWithFormat:@"type:%ld\ndata:%@", type, data];
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
