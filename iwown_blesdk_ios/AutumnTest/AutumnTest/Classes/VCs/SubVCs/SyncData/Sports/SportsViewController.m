//
//  SportsViewController.m
//  AutumnTest
//
//  Created by A$CE on 2019/4/3.
//  Copyright © 2019 A$CE. All rights reserved.
//

#import "SportsViewController.h"
#import "SportDetailAc.h"
#import "SysnDataStorger.h"

@interface SportsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;

@property (nonatomic ,assign) NSInteger totolSteps;

@end

@implementation SportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
   
//    NSArray *minutArr = [self getTestArr];
    NSArray *raData = [[SysnDataStorger shareStorger] getData];
    NSArray *minutArr = [SportMinute sportMinutesByZRSports:raData];
    NSArray *arr = [SportDetailAc sportArithmetic:minutArr];
    
    for (IVSportsModel *sm in arr) {
        if (sm.sport_type > 0) {
            [_dataSource addObject:sm];
        }
        self.totolSteps += sm.steps;
    }
}

- (void)initUI {
    [self drawTableView];
}

- (void)drawTableView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableHeaderView];
    [self.view addSubview:_tableView];
}

- (UIView *)tableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    stepLabel.text = [NSString stringWithFormat:@"%ld",(long)self.totolSteps];
    stepLabel.textColor = [UIColor greenColor];
    [view addSubview:stepLabel];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] cellViewText]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray <SportMinute *>*)getTestArr {
    NSMutableArray *minutArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-60*100];
    int state_type = 1;
    int sport_type = 1;
    for (int i = 0; i < 20; i ++) {
        SportMinute *sm = [[SportMinute alloc] init];
        sm.date = [date dateByAddingTimeInterval:i * 60];
        sm.sport_type = sport_type;
        if (state_type == 1) {
            sm.state_type = 1;
            state_type = 4;
        }else {
            if (i%10 == 0) {
                sm.state_type = 2;
                state_type = 1;
                sport_type = (sport_type == 1)? 7:1;
            }
        }
        int step = arc4random() % 300;
        sm.step = step;
        sm.distance = step * 0.8;
        sm.calorie = step * 0.049;
        [minutArr addObject:sm];
    }
    return minutArr;
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
