//
//  MoreViewController.m
//  AutumnTest
//
//  Created by A$CE on 2018/2/8.
//  Copyright © 2018年 A$CE. All rights reserved.
//
#import "BLEShareInstance.h"
#import "MoreViewController.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *dataSource;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initParam {
    _dataSource = @[@"User Info",@"Sport Goal",@"GNSS"];
}

- (void)initUI {
    [super initUI];
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
            ZRPersonal *zrp = [ZRPersonal defaultModel];
            [[BLEShareInstance shareInstance].bleSolstice setPersonalInfo:zrp];
        }
            break;
        case 1:
        {
            ZRSportLists *zrS = [ZRSportLists defaultModel];
            SportModel *sm = [[SportModel alloc]init];
            [sm setType:SD_SPORT_TYPE_BASKETBALL];
            [sm setTargetNum:8000];
            [zrS addSportModel:sm];
            zrS.day = 2;
            [[BLEShareInstance shareInstance].bleSolstice setSportLists:zrS];
        }
            break;
        case 2:
        {
            ZRGnssParam *gp = [[ZRGnssParam alloc] init];
            gp.timeZone = 8;
            gp.latitude = 22.452314;
            gp.longitude = 114.823632;
            gp.altitude = 60;
            [[BLEShareInstance shareInstance].bleSolstice setGNSSParameter:gp];
        }
            break;
        default:
            break;
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
