//
//  CHOptionController.m
//  BLE3Framework
//
//  Created by A$CE on 2017/7/27.
//  Copyright © 2017年 Iwown. All rights reserved.
//

#import "CHOptionController.h"
#import "Header.h"
#import "BLEShareInstance.h"

@interface CHOptionController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray     *_arr;
    NSMutableArray     *_dataArr;
}
@end

@implementation CHOptionController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
}

- (void)initParam
{
    _arr = @[@"FIND PHONE",@"WRIST DELICACY",@"READ SLEEP DATA"];
    _dataArr = [NSMutableArray arrayWithArray:@[@YES,@1,@YES]];
}

- (void)initUI
{
    [super initUI];
    [self drawTableView];
}

- (void)drawTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, SCREEN_HEIGHT -120) style:UITableViewStylePlain];
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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",[_dataArr[indexPath.row] longValue]];
            break;
        case 2:
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
    
    if (indexPath.row == 0) {
        BOOL result = [_dataArr[indexPath.row] boolValue];
        result = !result;
        [_dataArr replaceObjectAtIndex:indexPath.row withObject:@(result)];
    }else if(indexPath.row == 1){
        int result = [_dataArr[indexPath.row] intValue];
        result++;
        result%=3;
        [_dataArr replaceObjectAtIndex:indexPath.row withObject:@(result)];
    } if (indexPath.row == 2) {
        BOOL result = [_dataArr[indexPath.row] boolValue];
        result = !result;
        [_dataArr replaceObjectAtIndex:indexPath.row withObject:@(result)];
    }
    [self setHwOption:(int)indexPath.row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });
}

- (void)setHwOption:(int)row {
    ZRCOption *hwOption = [[ZRCOption alloc]init];
    if (row == 0) {
        hwOption.findPhoneSwitch = [_dataArr[row] boolValue];
    }else if (row == 1){
        hwOption.wristDelicacy = [_dataArr[row] integerValue];
    }else if (row == 2){
        hwOption.readSleepData = [_dataArr[row] integerValue];
    }
    NSLog(@"设置定制功能 %@",hwOption);
    [[BLEShareInstance shareInstance] setCustomOptions:hwOption];
}

- (void)readFO {
    [[BLEShareInstance shareInstance] readCustomOptions];
}


@end
