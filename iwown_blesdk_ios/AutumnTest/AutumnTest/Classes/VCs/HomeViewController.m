//
//  HomeViewController.m
//  IW_BLESDK
//
//  Created by caike on 15/12/25.
//  Copyright © 2015年 iwown. All rights reserved.
//
typedef enum {
    TableSectionDeviceInfo = 0,
    TableSectionHwOption,
    TableSectionSetAndRead,
    TableSectionDataSync,
    TableSectionMessage,
    TableSectionECG
    
} TableSection;
#import "BLEShareInstance.h"
#import "DCViewController.h"
#import "Header.h"
#import "DeviceStateView.h"
#import "DConfigViewController.h"
#import "HWOptionController.h"
#import "CHOptionController.h"
#import "ClockViewController.h"
#import "DataViewController.h"
#import "BlackListViewController.h"
#import "MoreViewController.h"
#import "SedentaryViewController.h"
#import "WeatherViewController.h"
#import "StartSetViewController.h"
#import "SleepViewController.h"
#import "SportsViewController.h"
#import "DFUViewController.h"

#import "HomeViewController.h"
#import "ecgDemoViewController.h"

#import "ExerciseViewController.h"
#import "BlackListForColorViewController.h"
#import "DNDViewController.h"

#import "NSDate+DateTools.h"


#define CEP_URL @"https://search.iwown.com/cep/1513^cep_pak_3days/cep_pak.bin"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,DeviceStateViewDelegate>
{
    NSArray             *_arr;
    NSArray             *_arrS;
    UITableView         *_tableView;
    UIButton            *_logBtn;
    DeviceStateView     *_dsView;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDeviceInfo:) name:@"GetDeviceInfo" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDeviceState:) name:@"DEVICEDIDCONNECTED" object:nil];

    [self initParam];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initParam {
    
    self.navigationItem.title = @"IVBLEDemo";
    
    _arrS = @[@"DEVICE CONFIG",@"HWOption",@"SET&READ",@"DATA SYNC",@"MESSAGE",@"ECG",@"微教练", @"GPS", @"血压"];
    _arr =  @[@[@"DEVICE CONFIG", @"Dev tmp", @"DND", @"ZRStart", @"File-Update", @"DFU(固件升级)"],
              @[@"HWOption",@"Schedule&Clock",@"Custom Option",@"Sedentary"],
              @[@"Date Time",@"More",@"Weather",@"Target",@"Motor"],
              @[@"Summary Data",@"Sysc More",@"Sleep Lib",@"Sport AC"],
              @[@"Push String",@"Black List",@"BlackListForColor"],
              @[@"ECG Test"],
              @[@"微教练Test"],
              @[@"Color GPS", @"Color GPS Detail", @"开启辅助定位", @"结束辅助定位", @"获取手环的gps状态", @"检查今天是否更新", @"检查是否打开AGPS", @"AGPS包长度下发"],
              @[@"彩屏获取血压数据"]
              ];
    [BLEShareInstance shareInstance];
}

- (void)initUI {
    SEL action = @selector(reConnectAction);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ReConnect" style:UIBarButtonItemStylePlain target:self action:action];
    [self drawTableView];
    [self drawDeviceView];
}

- (void)drawTableView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)drawDeviceView {
    _dsView = [[DeviceStateView alloc] init];
    _dsView.backgroundColor = [UIColor whiteColor];
    _dsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    _dsView.delegate = self;
    _tableView.tableHeaderView = _dsView;
}

#pragma -mark - tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrS.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr[section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _arrS[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _arr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == TableSectionDeviceInfo) {
        [self selectCellAtOne:indexPath.row];
    }
    else if (indexPath.section == TableSectionHwOption) {
        [self selectCellAtTwo:indexPath.row];
    }
    else if (indexPath.section == TableSectionSetAndRead) {
        [self selectCellAtThree:indexPath.row];
    }
    else if (indexPath.section == TableSectionDataSync) {
        [self selectCellAtFour:indexPath.row];
    }
    else if (indexPath.section == TableSectionMessage) {
        [self selectCellAtFive:indexPath.row];
    }
    else if (indexPath.section == TableSectionECG) {
        [self selectCellAtSix:indexPath.row];
    }
    else if (indexPath.section == 6){
        [self selectAtSeven:indexPath.row];
    }
    else if (indexPath.section == 7){
        [self selectAtEight:indexPath.row];
    }
    else {
        [self selectAtNine:indexPath.row];
    }
}

- (void)selectCellAtOne:(NSInteger )row {
    switch (row) {
        case 0:
        {
            DConfigViewController *dcVC = [[DConfigViewController alloc] init];
            [self.navigationController pushViewController:dcVC animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            DNDViewController *dcVC = [[DNDViewController alloc] init];
            [self.navigationController pushViewController:dcVC animated:YES];
            
        }
            break;
        case 3:
        {
            StartSetViewController *ssVC = [[StartSetViewController alloc] init];
            [self.navigationController pushViewController:ssVC animated:YES];
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        { // 固件升级
        /** Here only supports Nordic's DFU upgrade, P1 watches are not listed here, want to solve more upgrade related issues, please see https://github.com/xuezou/DFUAssistant*/
            DFUViewController *dfuVC = [[DFUViewController alloc] init];
            [self.navigationController pushViewController:dfuVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)selectCellAtTwo:(NSInteger )row {
    switch (row) {
        case 0:
        {
            [[BLEShareInstance shareInstance].bleSolstice readUserInfo];
            HWOptionController *vc = [[HWOptionController alloc]init];
            vc.title = @"Beacelet Option";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ClockViewController *vc = [[ClockViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            CHOptionController *vc = [[CHOptionController alloc]init];
            vc.title = @"Custom Option";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            SedentaryViewController *sVC = [[SedentaryViewController alloc] init];
            [self.navigationController pushViewController:sVC animated:YES];
        }
        default:
            break;
    }
    
}

- (void)selectCellAtThree:(NSInteger )row {
    switch (row) {
        case 0:
        {
            [[BLEShareInstance shareInstance].bleSolstice syscTime:[NSDate date]];
        }
            break;
        case 1:
        {
            MoreViewController *dcVC = [[MoreViewController alloc] init];
            [self.navigationController pushViewController:dcVC animated:YES];
        }
            break;
        case 2:
        {
            WeatherViewController *wVC = [[WeatherViewController alloc] init];
            [self.navigationController pushViewController:wVC animated:YES];
        }
            break;
        case 3:
        {
            ZRTargetOnceDay *target = [[ZRTargetOnceDay alloc] init];
            target.stepOnceDay = 8000;
            target.calorieOnceDay = 100;
            [[BLEShareInstance shareInstance].bleSolstice setTargetOnceDay:target];
        }
            break;
        case 4:
        {
            [[BLEShareInstance shareInstance].bleSolstice setMotors:[ZRMotor defaultMotors]];
        }
            break;
        default:
            break;
    }
}

- (void)selectCellAtFour:(NSInteger )row {
    switch (row) {
        case 0:
        {
            [[BLEShareInstance shareInstance].bleSolstice startSpecialData:SD_TYPE_DATA_SUMMARY];
        }
            break;
        case 1:
        {
            DataViewController *dcVC = [[DataViewController alloc] init];
            [self.navigationController pushViewController:dcVC animated:YES];
        }
            break;
        case 2:
        {
            SleepViewController *sVC = [[SleepViewController alloc] init];
            [self.navigationController pushViewController:sVC animated:YES];
        }
            break;
        case 3:
        {
            SportsViewController *sVC = [[SportsViewController alloc] init];
            [self.navigationController pushViewController:sVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)selectCellAtFive:(NSInteger )row {
    switch (row) {
        case 0:
        {
            [[BLEShareInstance shareInstance].bleSolstice pushStr:@"Zeroner by right"];
        }
            break;
        case 1:
        {
            BlackListViewController *blVC = [[BlackListViewController alloc] init];
            [self.navigationController pushViewController:blVC animated:YES];
        }
            break;
        case 2:
        {
            BlackListForColorViewController *blVC = [[BlackListForColorViewController alloc] init];
            [self.navigationController pushViewController:blVC animated:YES];
        }
            break;
        default:
            break;
    }
}


//ECG
- (void)selectCellAtSix:(NSInteger)row {
    [self.navigationController pushViewController:[ecgDemoViewController new] animated:YES];

}

- (void)selectAtSeven:(NSInteger)row {
    [self.navigationController pushViewController:[ExerciseViewController new] animated:YES];
}

- (void)selectAtEight:(NSInteger)row {
    switch (row) {
        case 0:
        {
            [[BLEShareInstance shareInstance].bleSolstice syscGPSDataInfo];
        }
            break;
        case 1:
        {
            [[BLEShareInstance shareInstance].bleSolstice syscGPSDetailDataWithday:1];
        }
            break;
        case 2:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDate *date = [NSDate date];
                NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld", date.year, date.month, date.day];
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", dateString, @"cep.bin"]];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                if ([[fileManager contentsAtPath:fullPath] length] > 0) {
                    NSLog(@"文件已存在");
                    [[BLEShareInstance shareInstance].bleSolstice writeGPSCEPFile:fullPath];
                } else {
                    NSError *error = nil;
                    NSString *urlString = [CEP_URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
                    NSURL *cepUrl = [NSURL URLWithString:urlString];
                    NSData *data = [NSData dataWithContentsOfURL:cepUrl options:NSDataReadingUncached error:&error];
                    if (error) {
                        NSLog(@"%@",error);
                    }
                    if (data.length > 10) {
                        @try {
                            [fileManager createFileAtPath:fullPath contents:data attributes:nil];
                        } @catch (NSException *exception) {
                            NSLog(@"NSException: %@",exception);
                        } @finally {
                            
                        }
                        
                        if ([[fileManager contentsAtPath:fullPath] length] == 0) {
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notice" message:@"文件下载失败" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleCancel handler:nil];
                            [alertController addAction:cancelAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        } else {
                            NSLog(@"文件下载完成");
                            [[BLEShareInstance shareInstance].bleSolstice writeGPSCEPFile:fullPath];
                        }
                    }
                }
            });
        }
            break;
        case 3:
        {
            [[BLEShareInstance shareInstance].bleSolstice endAGPS];
        }
            break;
        case 4:
        {
            [[BLEShareInstance shareInstance].bleSolstice checkGPSInBandIsOpen];
        }
            break;
        case 5:
        {
            [[BLEShareInstance shareInstance].bleSolstice checkAGPSIsUpdateToday];
        }
            break;
        case 6: {
            [[BLEShareInstance shareInstance].bleSolstice checkAGPSIsOpen];
        }
            break;
        case 7: {
            [[BLEShareInstance shareInstance].bleSolstice sendAGPSFileLenth:13];
        }
            break;
        default:
            break;
    }
}

- (void)selectAtNine:(NSInteger)row {
    [[BLEShareInstance shareInstance].bleSolstice syscBloodPressureData];
}

#pragma mark- StateViewDelegate
- (void)reConnectAction {
    [[BLEShareInstance shareInstance] reConnectDevice];
}

- (void)deviceStateViewDidClicked {
    [[BLEShareInstance shareInstance] unConnectDevice];
    [_dsView clearView];
    DCViewController *dcVc = [[DCViewController alloc]init];
    [self.navigationController pushViewController:dcVc animated:YES];
}

- (void)refreshDeviceState:(NSNotification *)notice {
    NSString *name = notice.object;
    [_dsView setStateLText:1];
    [_dsView setNameLText:name];
}
- (void)refreshDeviceInfo:(NSNotification *)notice {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZRDeviceInfo *info = (ZRDeviceInfo *)notice.object;
        [self->_dsView setModelLText:info.model];
     /*   NSInteger state = [[BLEShareInstance shareInstance]currentState];
        if (state == kBLEstateDidConnected) {
            self.navigationItem.leftBarButtonItem.title = @"已绑定(binded)";
            //        self.navigationItem.leftBarButtonItem.enabled = NO;
        }else {
            self.navigationItem.leftBarButtonItem.title = @"Connect Device";
            //        self.navigationItem.leftBarButtonItem.enabled = YES;
        }
        [_dsView setStateLText:state];*/
        [self->_dsView setversionLText:info.version];
        [self->_dsView setBatteryLText:info.batLevel];
    });
}

@end
