//
//  WeatherViewController.m
//  AutumnTest
//
//  Created by A$CE on 2019/3/11.
//  Copyright © 2019年 A$CE. All rights reserved.
//

#import "WeatherViewController.h"
#import "BLEShareInstance.h"

@interface WeatherViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    [_dataSource addObjectsFromArray:@[@"即时天气(Now)",@"24小时天气(Weather Forecast)",@"天气单位(℃/℉)"]];
}

- (void)initUI {
    [self drawTableView];
}

- (void)drawTableView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ZRWeather *weather = [[ZRWeather alloc] init];
            weather.temp = 30;
            weather.unit = Centigrade;
            [[BLEShareInstance shareInstance].bleSolstice setWeather:weather];
        }
            break;
        case 1:
        {
            NSMutableArray *m24Arr = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < 12; i ++) {
                ZRWeather *w = [[ZRWeather alloc] init];
                w.temp = 30 + i;
                w.unit = Centigrade;
                w.type = i;
                [m24Arr addObject:w];
            }
            
            NSMutableArray *m7DArr = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < 7; i ++) {
                ZRDayWeather *d = [[ZRDayWeather alloc]init];
                d.type = i;
                d.tempMax = 25 + i;
                d.tempMin = 25 - i;
                d.pm = 50 - i;
                [m7DArr addObject:d];
            }
            
            ZR24Weather *w24 = [[ZR24Weather alloc] init];
            w24.year = 2019;
            w24.month = 3;
            w24.day = 11;
            w24.hour = 12;
            w24.weather24Arrs = m24Arr;
            w24.weather7Arrs = m7DArr;
            [[BLEShareInstance shareInstance].bleSolstice set24Weathers:w24];
        }
            break;
        case 2:
        {
            [[BLEShareInstance shareInstance].bleSolstice setWeatherUnit:Fahrenheit];
        }
            break;
            
        default:
            break;
    }
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
