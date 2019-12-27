//
//  DConfigViewController.m
//  AutumnTest
//
//  Created by A$CE on 2018/2/6.
//  Copyright © 2018年 A$CE. All rights reserved.
//
#import "BLEShareInstance.h"
#import "DConfigViewController.h"

@interface DConfigViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_arrS;
}
@end

@implementation DConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initParam {
    self.navigationItem.title = @"Device Config";
    _arrS = @[@"Device Info",@"Reboot",@"Unbind",@"ConnectState",@"ManuData",@"FactoryConf"];
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
    return [_arrS count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _arrS[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [[BLEShareInstance shareInstance] readDeviceInfo];
        }
            break;
        case 1:
        {
            [[BLEShareInstance shareInstance].bleSolstice rebootDevice];
        }
            break;
        case 2:
        {
            [[BLEShareInstance shareInstance] unConnectDevice];
        }
            break;
        case 3:
        {
            [[BLEShareInstance shareInstance] readConnectState];
        }
            break;
        case 4:
        {
            [[BLEShareInstance bleSolstice] readManufactureDate];
        }
            break;
        case 5:
        {
            [[BLEShareInstance bleSolstice] readFactoryConfiguration];
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
