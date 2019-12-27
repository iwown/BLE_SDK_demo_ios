//
//  StartSetViewController.m
//  AutumnTest
//
//  Created by A$CE on 2019/3/11.
//  Copyright © 2019年 A$CE. All rights reserved.
//

#import "StartSetViewController.h"
#import "BLEShareInstance.h"

@interface StartSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation StartSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    [_dataSource addObjectsFromArray:@[@"Set",@"Get"]];
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
            // 获取本地时区
            NSTimeZone *zone2 = [NSTimeZone localTimeZone];
            NSInteger interval = [zone2 secondsFromGMT] / 3600;
            
            ZRStartSetting *zrs = [[ZRStartSetting alloc] init];
            zrs.username_data = @"你好";
            zrs.utc_offset = interval;
            zrs.user_height = 160;
            zrs.user_gender = 1;
            zrs.bp_enable = YES;
            [[BLEShareInstance shareInstance].bleSolstice setStartSetting:zrs IsOld:NO];
        }
            break;
        case 1:
        {
            [[BLEShareInstance shareInstance].bleSolstice readStartSetting];
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
