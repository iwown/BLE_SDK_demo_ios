//
//  BlackListForColorViewController.m
//  AutumnTest
//
//  Created by west on 2018/5/11.
//  Copyright © 2018年 A$CE. All rights reserved.
//

#import "BlackListForColorViewController.h"
#import "BLEShareInstance.h"
@interface BlackListForColorViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView    *tableView;
@property (nonatomic ,strong)NSArray        *dataSource;
@property (nonatomic ,strong)NSArray        *sectionArr;
@property (nonatomic ,strong)NSMutableArray *selectArr;

@end

@implementation BlackListForColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParam];
    [self initUI];
}

- (void)initParam {
    _sectionArr = @[@"Read", @"Write"];
    _dataSource = @[@"ZRRollMsgForMoblieEmail",
                    @"ZRRollMsgForMobileSMS",
                    @"ZRRollMsgForSkype",
                    @"ZRRollMsgForWhatsapp",
                    @"ZRRollMsgForLinkin",
                    @"ZRRollMsgForTwitter",
                    @"ZRRollMsgForGmail",
                    @"ZRRollMsgForKakaoTalk",
                    @"ZRRollMsgForInstagram",
                    @"ZRRollMsgForLine",
                    @"ZRRollMsgForFacebook",
                    @"ZRRollMsgForSina",
                    @"ZRRollMsgForWechat",
                    @"ZRRollMsgForQQ"];
    NSArray *arr = @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0];
    _selectArr = [[NSMutableArray alloc] initWithArray:arr];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionArr[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"读取彩屏手环的UserInfo";
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
        
        BOOL isSelect = [_selectArr[indexPath.row] boolValue];
        if (isSelect) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        BOOL isSelect = [_selectArr[indexPath.row] boolValue];
        NSNumber *num = [NSNumber numberWithBool:!isSelect];
        [_selectArr replaceObjectAtIndex:indexPath.row withObject:num];
        [tableView reloadData];
        
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [_selectArr count]; i++) {
            BOOL isSelect = [_selectArr[i] boolValue];
            if (isSelect) {
                ZRRollMsgType type = 1<<(i+2);
                [muArr addObject:[NSNumber numberWithInteger:type]];
            }
        }
        
//        ZRMesgPush *zrmp = [ZRMesgPush defaultModel];
//        zrmp.rollMsgList = muArr;
        
        ZRMesgPush *zrmp = [[ZRMesgPush alloc] init];
        zrmp.comingCallEnable = YES;
        zrmp.comingCallStart = 0;
        zrmp.comingCallEnd = 24;
        zrmp.messageEnable = YES;
        zrmp.messageStart = 0;
        zrmp.messageEnd = 24;
        zrmp.rollMsgList = @[];
        [[[BLEShareInstance shareInstance] bleSolstice] setMessagePush:zrmp];
    } else {
        
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
