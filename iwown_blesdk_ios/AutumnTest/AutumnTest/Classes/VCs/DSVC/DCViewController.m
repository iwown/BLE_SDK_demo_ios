//
//  DCViewController.m
//  ZLYIwown
//
//  Created by 曹凯 on 15/11/16.
//  Copyright © 2015年 Iwown. All rights reserved.
//
typedef enum{
    ScanStateScaning = 0,
    ScanStateScaned ,
    ScanStateNull   ,
}ScanState;
#import "Header.h"
#import <BLEMidAutumn/BLEMidAutumn.h>
#import "BLEShareInstance.h"
#import "DCViewController.h"

@interface DCViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_scanState;
    UIImageView *_deviceView;
    UIView *_displayView;
    UIView *_menuBar;
}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UIButton *rescan;

@property (nonatomic ,strong) CBCentralManager *centralManager;

@end

@implementation DCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidConnected:) name:@"DEVICEDIDCONNECTED" object:nil];
    
    [self initParam];
    [self initUI];
    [self scanDevice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initParam {
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawDisplayView];
    [self drawScanStateView];
}

- (void)drawScanStateView {
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwiceForReScan:)];
    tapTwice.numberOfTapsRequired = 2;
    _scanState = [[UILabel alloc] initWithFrame:CGRectMake(0, FONT(60), SCREEN_WIDTH, FONT(60))];
    [_scanState setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_scanState];
    [_scanState addGestureRecognizer:tapTwice];
    [self setScanState:ScanStateScaning];
}

- (void)drawDisplayView {
    _displayView = [[UIView alloc] initWithFrame:CGRectMake(0, FONT(140), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - FONT(200))];
    [self.view addSubview:_displayView];
  
    [self drawTableView];
    [self drawRescanButton];
}

- (void)drawTableView {
    //tableView的初始化
    self.tableView = [[UITableView alloc]initWithFrame:_displayView.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
//    _tableView.separatorColor = [UIColor whiteColor];
    [_displayView addSubview:self.tableView];
    [self.tableView setHidden:YES];
}

- (void)drawRescanButton {
    _rescan = [UIButton buttonWithType:UIButtonTypeCustom];
    [_displayView addSubview:_rescan];
    [_rescan setTitle:NSLocalizedString(@"Rescan", nil) forState:UIControlStateNormal];
    [_rescan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rescan addTarget:self action:@selector(reScan) forControlEvents:UIControlEventTouchUpInside];
    _rescan.frame = CGRectMake(FONT(40), FONT(10), SCREEN_WIDTH -FONT(80), FONT(30));
    [_rescan setHidden:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    ZRBlePeripheral *device = _dataSource[indexPath.row];
    cell.textLabel.text = device.deviceName;
    cell.detailTextLabel.text = NSLocalizedString(@"unconnect", nil);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FONT(38);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRBlePeripheral *device = _dataSource[indexPath.row];
    [[BLEShareInstance shareInstance] connectDevice:device];
}

#pragma -mark Actions
- (void)returnButtonClicked:(UIButton *)button {
    [[BLEShareInstance shareInstance] stopScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -private
- (void)tapTwiceForReScan:(id)gesture {
    [self reScan];
}

- (void)setScanState:(ScanState)state {
    [_scanState setUserInteractionEnabled:NO];
    switch (state) {
        case ScanStateScaning:
        {
            [_scanState setText:NSLocalizedString(@"Scaning", nil)];
            [self scanAnimation];
            [_rescan setHidden:YES];
            [_textView setHidden:NO];
        }
            break;
        case ScanStateScaned:
        {
            [_scanState setUserInteractionEnabled:YES];
            [_scanState setText:NSLocalizedString(@"Double click to Rescan", nil)];
            [_textView setHidden:YES];
            [_tableView setHidden:NO];
            [self showTableViewAnimation];
            [_tableView reloadData];

        }
            break;
        case ScanStateNull:
        {
            [_scanState setText:NSLocalizedString(@"None device found", nil)];
            [_textView setHidden:YES];
            [_tableView setHidden:YES];
            [_rescan setHidden:NO];
        }
            break;
        default:
            break;
    }
}

- (void)reScan {
    [[BLEShareInstance shareInstance] stopScan];
    [self scanDevice];
    [self setScanState:ScanStateScaning];
}

#pragma mark -animation
- (void)showTableViewAnimation {
    CGFloat width = _tableView.bounds.size.width;
    CGFloat height = _tableView.bounds.size.height;
    
    [_tableView setFrame:CGRectMake(0, height, width, height)];
    [UIView animateWithDuration:0.5 animations:^{
        [self->_tableView setFrame:CGRectMake(0, 0, width, height)];
    }];
}

- (void)scanAnimation {
    __block int timeNum=0;
    __block UILabel *__safe_scan = _scanState;
    __block DCViewController *__safe_self = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.5*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeNum >10) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [__safe_self scanStop];
            });
        }else{
            NSString *str = @"・";
            for (int i = 0; i < timeNum%3; i ++) {
                str = [str stringByAppendingString:@"・"];
            }
            timeNum ++;
            dispatch_async(dispatch_get_main_queue(), ^{
                [__safe_scan setText:[NSLocalizedString(@"Scaning", nil) stringByAppendingString:str]];
            });
        }
    });
    dispatch_resume(_timer);
}
#pragma mark -BLEaction
- (void)scanDevice {
    [[BLEShareInstance shareInstance] scanDevice];
}

- (void)scanStop {
    [[BLEShareInstance shareInstance] stopScan];
    [_dataSource removeAllObjects];
    NSArray *dataArray = [NSArray arrayWithArray:[[[BLEShareInstance shareInstance] getDevices] copy]];

    [_dataSource addObjectsFromArray:dataArray];

    if (_dataSource.count != 0) {
        [self setScanState:ScanStateScaned];
    }else{
        [self setScanState:ScanStateNull];
    }
}

- (void)deviceDidConnected:(id)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
