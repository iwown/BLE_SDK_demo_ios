//
//  DNDViewController.m
//  AutumnTest
//
//  Created by west on 2018/5/25.
//  Copyright © 2018年 A$CE. All rights reserved.
//

#import "DNDViewController.h"
#import "BLEShareInstance.h"

@interface DNDViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView    *tableView;
@property (nonatomic ,strong)NSArray        *dataSource;

@end

@implementation DNDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParam];
    [self initUI];
}


- (void)initParam {
    _dataSource = @[@"Read", @"Write"];
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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self getDNDModel];
    } else if (indexPath.row == 1) {
        [self setDNDModel];
    }
}



- (void)setDNDModel {
    ZRDNDModel *model = [[ZRDNDModel alloc] init];
    model.dndType = 1;
    model.startHour = 1;
    model.endHour = 23;
    [[[BLEShareInstance shareInstance] bleSolstice] setDNDMode:model];
}

- (void)getDNDModel {
    [[[BLEShareInstance shareInstance] bleSolstice] readDNDModeInfo];
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
