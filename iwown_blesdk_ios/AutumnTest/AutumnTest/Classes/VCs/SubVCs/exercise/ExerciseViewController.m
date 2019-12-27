//
//  ExerciseViewController.m
//  AutumnTest
//
//  Created by west on 2018/5/9.
//  Copyright © 2018年 A$CE. All rights reserved.
//

#import "ExerciseViewController.h"
#import "BLEShareInstance.h"

@interface ExerciseViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataSecArr;
    NSArray *_dataSource;
    NSArray *_colorSource;
}

@end

@implementation ExerciseViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[BLEShareInstance shareInstance] closeStandardHR];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self drawUI];
}

- (void)loadData {
    [[BLEShareInstance shareInstance] openStandardHR];
    _dataSecArr = @[@"微教练", @"彩屏"];
    _dataSource = @[@[@"Start", @"Stop", @"Pause"], @[@"私教", @"户外跑", @"骑行", @"自由训练", @"Stop"]];
    _colorSource = @[@(0x31), @(0x07), @(0x88), @(0x33)];
}

- (void)drawUI {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma -mark - tableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _dataSecArr[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataSource count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[BLEShareInstance shareInstance] startExercise];
        } else if (indexPath.row == 1) {
            [[BLEShareInstance shareInstance] endExercise];
        } else {
            [[BLEShareInstance shareInstance] pauseExercise];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < [_colorSource count]) {
            sd_sportType type = [_colorSource[indexPath.row] integerValue];
            [[BLEShareInstance shareInstance] startExerciseWithSportType:type];
        } else {
            [[BLEShareInstance shareInstance] endExercise];
        }
    }
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
