//
//  DataViewController.m
//  AutumnTest
//
//  Created by A$CE on 2018/2/8.
//  Copyright © 2018年 A$CE. All rights reserved.
//
#import "Header.h"
#import "BLEShareInstance.h"
#import "SysnDataStorger.h"
#import "DataViewController.h"

@interface DataViewController ()<UITableViewDelegate,UITableViewDataSource,BKDataDeleagte>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDateStoreGet) name:BLE_SYSCDATA_GETDATASCORE object:nil];
    [self initParam];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initParam {
    _dataSource = [NSMutableArray arrayWithArray:@[@[],@[],@[],@[]]];
    [[BLEShareInstance shareInstance].bleSolstice getDataStoreDate];
    [BLEShareInstance shareInstance].dataDelegate = self;
}

- (void)initUI {
    [super initUI];
    [self drawTableView];
}

- (void)loadData {
    if ([[BLEShareInstance shareInstance] dateArr].count > 0) {
        [_dataSource replaceObjectAtIndex:0 withObject:[[BLEShareInstance shareInstance] dateArr]];
    }
    if ([[BLEShareInstance shareInstance] dInfo61Arr].count > 0) {
        [_dataSource replaceObjectAtIndex:1 withObject:[[BLEShareInstance shareInstance] dInfo61Arr]];
    }
    if ([[BLEShareInstance shareInstance] dInfo62Arr].count > 0) {
        [_dataSource replaceObjectAtIndex:2 withObject:[[BLEShareInstance shareInstance] dInfo62Arr]];
    }
    if ([[BLEShareInstance shareInstance] dInfo64Arr].count > 0) {
        [_dataSource replaceObjectAtIndex:3 withObject:[[BLEShareInstance shareInstance] dInfo64Arr]];
    }
}

- (void)drawTableView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FONT(40))];
    [lab setFont:[UIFont systemFontOfSize:17]];
    lab.backgroundColor = [UIColor lightGrayColor];
    NSArray *arr = @[@"Hbrid Health",@"61 Normal Health",@"GNSS Data",@"ECG Data"];
    lab.text = arr[section];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FONT(40);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    id obj = _dataSource[indexPath.section][indexPath.row];
    if ([obj isKindOfClass:[NSDate class]]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",obj];
    }else if ([obj isKindOfClass:[DDInfo class]]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:[(DDInfo *)obj date]];
        cell.textLabel.text = dateStr;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = _dataSource[indexPath.section][indexPath.row];
    if ([obj isKindOfClass:[NSDate class]]) {
//        [[BLEShareInstance shareInstance].bleSolstice startSpecialData:SD_TYPE_DATA_NORMAL withDate:obj];
        [[BLEShareInstance shareInstance].bleSolstice startSpecialData:SD_TYPE_DATA_NORMAL withDate:obj];
    }else if ([obj isKindOfClass:[DDInfo class]]){
        DDInfo *dInfo = (DDInfo *)obj;
        SD_TYPE type = SD_TYPE_GNSS_SEGMENT;
        if (indexPath.section == 1) {
            type = SD_TYPE_DATA_NORMAL;
        }else if (indexPath.section == 2) {
            type = SD_TYPE_GNSS_SEGMENT;
        }else if (indexPath.section == 3) {
            type = SD_TYPE_ECG;
        }
        [[SysnDataStorger shareStorger] clear];
        [[BLEShareInstance shareInstance].bleSolstice startSpecialData:type withDate:dInfo.date startSeq:dInfo.seqStart endSeq:dInfo.seqEnd];
    }
}

- (void)dataDateStoreGet {
    [self loadData];
    [self.tableView reloadData];
}

#pragma mark - BKDataDeleagte
- (void)updateBleSyscData:(id)data {
    [[SysnDataStorger shareStorger] addData:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
