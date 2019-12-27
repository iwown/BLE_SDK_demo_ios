//
//  HWOptionController.m
//  IW_BLESDK
//
//  Created by caike on 15/12/28.
//  Copyright © 2015年 iwown. All rights reserved.
//
#import "Header.h"
#import "BLEShareInstance.h"
#import "HWOptionController.h"

@interface HWOptionController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray     *_arr;
    NSMutableArray     *_dataArr;
}
@end

@implementation HWOptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
}

- (void)initParam {
    _arr = @[@"LED灯(Light)",@"翻腕手势(Turn Wrist)",@"计量单位(Measurement	Standard)",@"时间制式(Time format)",@"自动睡眠(Auto Sleep)",@"社区广播(Community Radio)",@"背景颜色(Backgroud Color)",@"语言切换(Language	Switch)",@"断连提醒(Unconnect Warning)",@"背景灯开启时间(Open Time Of Backlight)",@"背景灯关闭时间(End Time Of Backlight",@"惯用手(Strong Hand)",@"℃/℉",@"自动运动(Auto Sport)",@"自动心率(Auto HR)"];
    _dataArr = [NSMutableArray arrayWithArray:@[@YES,@YES,@YES,@YES,@NO,@YES,@YES,@YES,@YES,@18,@6,@YES,@YES,@YES,@YES]];
}

- (void)initUI {
    [super initUI];
    [self drawTableView];
}

- (void)drawTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, SCREEN_HEIGHT -60) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Read";
    }
    return @"Write";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:98/255.0 blue:1 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"读取硬件功能";
        return cell;
    }
    
    cell.textLabel.text = _arr[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.userInteractionEnabled = YES;
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            break;
        case 1:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            break;
        case 2:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"米(Meter)":@"英尺(Foot)";
            break;
        case 3:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"12小时(12Hours)":@"24小时(24Hours)";
            break;
        case 4:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            break;
        case 5:
        {
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = [UIColor grayColor];
        }
            break;
        case 6:
        {
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"白色(White)":@"黑色(Black)";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = [UIColor grayColor];
        }
            break;
        case 7:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"中文(Chinese)":@"英文(English)";
            break;
        case 8:
        {
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = [UIColor grayColor];
        }
            break;
        case 9:
        case 10:
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:00", (long)[_dataArr[indexPath.row] integerValue]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = [UIColor grayColor];
        }
            break;
        case 11:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"左手(Left)":@"右手(Right)";
            break;
        case 12:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"℃":@"℉";
            break;
        case 13:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            break;
        case 14:
            cell.detailTextLabel.text = [_dataArr[indexPath.row] boolValue]?@"开启(Turn On)":@"关闭(Turn Off)";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self readFO];
        
        return;
    }
    
    if (indexPath.row != 9 && indexPath.row != 10) {
        BOOL result = [_dataArr[indexPath.row] boolValue];
        [_dataArr replaceObjectAtIndex:indexPath.row withObject:@(!result)];
        [self setHwOption];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    }
    else {
        [self showAlert:indexPath.row];
    }
}

- (void)showAlert:(NSInteger)row
{
    NSString *str= nil;
    if (row == 9) {
        str = @"开启时间(Start)";
    }else {
        str = @"关闭时间(End)";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"开启时间(Start)" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入整点小时数,例如8(Entry an integer num as 8)";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定(OK)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger hour = [alert.textFields[0].text integerValue];
        if (hour>=0 && hour<=24) {
            self->_dataArr[row] = [NSNumber numberWithInteger:hour];
            [self->_tableView reloadData];
        }
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消(Cancel)" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setHwOption
{
    ZRHWOption *hwOption = [[ZRHWOption alloc]init];
    hwOption.ledSwitch = [_dataArr[0] boolValue];
    hwOption.wristSwitch = [_dataArr[1] boolValue];
    hwOption.unitType = [_dataArr[2]boolValue]?UnitTypeInternational:UnitTypeEnglish;
    hwOption.timeFlag = [_dataArr[3]boolValue]?TimeFlag12Hour:TimeFlag24Hour;
    hwOption.autoSleep = [_dataArr[4]boolValue];
    hwOption.language = [_dataArr[7]boolValue]?braceletLanguageSimpleChinese:braceletLanguageDefault;
    
//    hwOption.advertisementSwitch = [_dataArr[5]boolValue];
//    hwOption.backColor = [_dataArr[6]boolValue];
//    hwOption.disConnectTip = [_dataArr[8] boolValue];
//    hwOption.backlightStart = [_dataArr[9] integerValue];
//    hwOption.backlightEnd = [_dataArr[10] integerValue];
    hwOption.leftHand = [_dataArr[11] boolValue];
    hwOption.temperatureUnit = [_dataArr[12] boolValue];
    hwOption.autoSport = [_dataArr[13] boolValue];
    hwOption.autoHeartRate = [_dataArr[14] boolValue];

    NSLog(@"设置硬件功能 %@",hwOption);
    [[BLEShareInstance shareInstance] setFirmwareOption:hwOption];
}

- (void)readFO {
    [[BLEShareInstance shareInstance] readFirmwareOption];
}

@end
