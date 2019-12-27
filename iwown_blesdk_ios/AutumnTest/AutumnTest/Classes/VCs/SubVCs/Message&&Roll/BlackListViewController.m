//
//  BlackListViewController.m
//  AutumnTest
//
//  Created by A$CE on 2018/2/8.
//  Copyright © 2018年 A$CE. All rights reserved.
//
#import "BLEShareInstance.h"
#import "BlackListViewController.h"

@interface BlackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *dataSource;
@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initParam {
    _dataSource = @[@"Add Roll",@"Read Roll",@"Clear Roll",@"Remove Roll"];
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
            
            /*"com.tencent.mqq"
             "com.tencent.xin"
             "com.sina.weibo"
             "com.facebook"
             "jp.naver.line"
             "com.burbn.instagram"
             "com.iwilab.KakaoTalk"
             "com.google.Gmail"
             "com.atebits.Tweetie"
             "com.linkedin"
             "net.whatsapp"
             "com.skype.skype"
             "com.apple.MobileSMS"
             @"com.apple.mobilephone"*/
            NSArray *arr = @[@"net.whatsapp",
                             @"com.google.Gmail"];
            NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < arr.count; i ++) {
                ZRRoll *zRoll = [[ZRRoll alloc] init];
                zRoll.rId = 100 + i;
                zRoll.rollName = arr[i];
                [mArr addObject:zRoll];
            }
            [[BLEShareInstance shareInstance].bleSolstice addSpecialList:mArr];
        }
            break;
        case 1:
        {
            [[BLEShareInstance shareInstance].bleSolstice readAllList];
        }
            break;
        case 2:
        {
            [[BLEShareInstance shareInstance].bleSolstice clearAllLists];
        }
            break;
        case 3:
        {
            NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < 3; i +=2) {
                ZRRoll *zRoll = [[ZRRoll alloc] init];
                zRoll.rId = 101 + i;
                [mArr addObject:zRoll];
            }
            [[BLEShareInstance shareInstance].bleSolstice removeSpecialList:mArr];
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
