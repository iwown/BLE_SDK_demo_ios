//
//  SleepViewController.m
//  AutumnTest
//
//  Created by A$CE on 2019/3/11.
//  Copyright © 2019年 A$CE. All rights reserved.
//

#import "SleepViewController.h"
#import "IVSleep.h"

@interface SleepViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) NSString *dirSleep;
@property (nonatomic ,assign) NSInteger type; //0 - P1, 1 - D2

@property (nonatomic ,strong) NSString *sDate;
@property (nonatomic ,strong) NSString *wName;
@property (nonatomic ,assign) long long sUid;

@end

@implementation SleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    self.sUid = 114;
    self.sDate = @"20190426";
    self.wName = @"watch-12";
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    [_dataSource addObjectsFromArray:@[@"P1.txt",@"D2.json"]];
    
    [self createDirWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] Name:@"Sleep"];
    _dirSleep = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Sleep"];
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.sUid && self.sDate && self.wName) {
        NSError *error;
        IVSleep *sleep = [[IVSleep alloc] init];
        IV_SA_SleepBufInfo sInfo = [sleep ivSleepData:_dirSleep andUid:self.sUid andDate:self.sDate andDeviceName:self.wName andError:&error];
        NSLog(@"Total-%d ;Start-%d:%d ;End-%d:%d \nError- %@",sInfo.total,sInfo.data[0].startTime.hour,sInfo.data[0].startTime.minute,sInfo.outSleepTime.hour,sInfo.outSleepTime.minute,error);
        NSLog(@"%d",sInfo.data[1].type);
        return;
    }
    
    _type = indexPath.row;
    NSString *dateString;
    switch (indexPath.row) {
        case 0:
            dateString = @"20171012";
            break;
        case 1:
            dateString = @"20190306";
            break;
            
        default:
            break;
    }
    
    [self createDirWithPath:_dirSleep Name:dateString];
    [self createFileIfNotExist];
    IVSleep *sleep = [[IVSleep alloc] init];
    NSError *error;
    NSString *path = _dirSleep;
//    uid-149007565315087898-date-20171012-source-watch-P1-4054.txt
//    uid-142718124222561643-date-20190306-source-D2-0493.json
    long long uid = 149007565315087898;
    NSString *date = @"20171012";
    NSString *deviceName = @"watch-P1-4054";
    if (_type == 1) {
        uid = 142718124222561643;
        date = @"20190306";
        deviceName = @"D2-0493";
    }
    IV_SA_SleepBufInfo sInfo = [sleep ivSleepData:path andUid:uid andDate:date andDeviceName:deviceName andError:&error];
    NSLog(@"Total-%d ;Start-%d:%d ;End-%d:%d \nError- %@",sInfo.total,sInfo.data[0].startTime.hour,sInfo.data[0].startTime.minute,sInfo.outSleepTime.hour,sInfo.outSleepTime.minute,error);
    NSLog(@"%d",sInfo.data[1].type);
}

- (void)createFileIfNotExist {
    NSString *path = [_dirSleep stringByAppendingString:@"/20171012/uid-149007565315087898-date-20171012-source-watch-P1-4054"];
    NSString *pathB = [[NSBundle mainBundle] pathForResource:@"uid-149007565315087898-date-20171012-source-watch-P1-4054" ofType:@"txt"];
    if (_type == 1) {
        path = [_dirSleep stringByAppendingString:@"/20190306/uid-142718124222561643-date-20190306-source-D2-0493.json"];
        pathB = [[NSBundle mainBundle] pathForResource:@"uid-142718124222561643-date-20190306-source-D2-0493" ofType:@"json"];
    }
    BOOL file = [self createFileWithPath:path];
    NSLog(@"====>%d",file);
    if (file) {
        NSData *data = [NSData dataWithContentsOfFile:pathB];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        [fileHandle writeData:data]; //追加写入数据
    }
}

//创建文件
- (BOOL)createFileWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    } else {
        return [self createFile:path];
    }
}

//创建文件夹
- (BOOL)createDirWithPath:(NSString *)path Name:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [path stringByAppendingPathComponent:name];
    
    if ([fileManager fileExistsAtPath:testDirectory]) {
        return YES;
    } else {
        // 创建目录
        BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        }else
            NSLog(@"文件夹创建失败");
        
        return res;
    }
}

- (BOOL)createFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                           forKey:NSFileProtectionKey];
    BOOL res=[fileManager createFileAtPath:path contents:nil attributes:attributes];
    
    if (res) {
        NSLog(@"文件创建成功: %@",path);
    }else
        NSLog(@"文件创建失败");
    return res;
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
