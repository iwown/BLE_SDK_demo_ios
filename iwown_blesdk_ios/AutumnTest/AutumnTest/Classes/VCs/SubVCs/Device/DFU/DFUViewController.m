//
//  DFUViewController.m
//  AutumnTest
//
//  Created by A$CE on 2019/3/11.
//  Copyright © 2019年 A$CE. All rights reserved.
//
#import "Header.h"
#import "DFUViewController.h"
#import "DeviceConectController.h"
#import "FirmwareListController.h"
#import "BLEShareInstance.h"
#import "PercentView.h"
@import iOSDFULibrary;


@interface DFUViewController ()<FirmwareListControllerDelegate, DeviceConectControllerDelegate>
{
    UILabel             *_nameLabel;
    UILabel             *_sizeLabel;
    UILabel             *_typeLabel;
    UILabel             *_deviceLabel;
    UIButton            *_upgradeBtn;
    PercentView         *_percentView;
    
    NSString            *_selectUrlString;
    NSURL               *_zipUrl;
    
    NSInteger           _canDFUType;
    
    CBPeripheral        *_peripheral;
}
@end

@implementation DFUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BLEShareInstance shareInstance] deviceFWUpdate];
    [self drawUI];
    // Do any additional setup after loading the view.
}

- (void)drawUI {
    self.title = @"DFU";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *firmwareView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, SCREEN_WIDTH - 80, 200)];
    firmwareView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    firmwareView.userInteractionEnabled = YES;
    [self.view addSubview:firmwareView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 100, 30)];
    _nameLabel.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    _nameLabel.text = @"Name:";
    [firmwareView addSubview:_nameLabel];
    
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH - 100, 30)];
    _sizeLabel.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    _sizeLabel.text  =@"Size:";
    [firmwareView addSubview:_sizeLabel];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, SCREEN_WIDTH - 100, 30)];
    _typeLabel.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    _typeLabel.text = @"Type:";
    [firmwareView addSubview:_typeLabel];
    
    _deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, SCREEN_WIDTH - 100, 50)];
    _deviceLabel.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    _deviceLabel.text = @"Device:";
    [firmwareView addSubview:_deviceLabel];
    
    UIButton *selectFirmwareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectFirmwareBtn.frame = CGRectMake((SCREEN_WIDTH - 140) / 2, SCREEN_HEIGHT - 230, 140, 30);
    selectFirmwareBtn.backgroundColor = [UIColor whiteColor];
    [selectFirmwareBtn setTitle:@"Select Files" forState:UIControlStateNormal];
    [selectFirmwareBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [selectFirmwareBtn addTarget:self action:@selector(selectFirmWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectFirmwareBtn];
    
    UIButton *selectDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectDeviceBtn.frame = CGRectMake((SCREEN_WIDTH - 140) / 2, SCREEN_HEIGHT - 170, 140, 30);
    selectDeviceBtn.backgroundColor = [UIColor whiteColor];
    [selectDeviceBtn setTitle:@"Scan Device" forState:UIControlStateNormal];
    [selectDeviceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [selectDeviceBtn addTarget:self action:@selector(selectDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectDeviceBtn];
    
    UIButton *upgradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upgradeBtn.frame = CGRectMake((SCREEN_WIDTH - 140) / 2, SCREEN_HEIGHT - 110, 140, 30);
    upgradeBtn.backgroundColor = [UIColor whiteColor];
    [upgradeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];
    [upgradeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [upgradeBtn addTarget:self action:@selector(upgradeDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upgradeBtn];
    _upgradeBtn = upgradeBtn;
}


- (void)selectFirmWare {
    FirmwareListController *con = [[FirmwareListController alloc] init];
    con.delegate = self;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)selectDevice {
    DeviceConectController *con = [[DeviceConectController alloc] init];
    con.delegate = self;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)upgradeDevice {
    if ([_selectUrlString length] <= 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please choose a firmware files" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (!_canDFUType) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please connect the DFU device" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (_canDFUType == 1) {
//        [_dfuOperations performDFUOnFile:[NSURL fileURLWithPath:_selectUrlString] firmwareType:_dfuFWType];
    }
    else if (_canDFUType == 2) {
//        [_dfuOperations performDFUOnFileWithMetaData:_dfuHelper.applicationURL firmwareMetaDataURL:_dfuHelper.applicationMetaDataURL firmwareType:_dfuFWType];
    }
}

- (void)selectFirmware:(NSString *)path {
    [self handleUrlString:path];
}

- (void)handleUrlString:(NSString *)urlString {
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    _nameLabel.text = [NSString stringWithFormat:@"Name: %@", array.lastObject];
    array = [urlString componentsSeparatedByString:@"."];
    _typeLabel.text = [NSString stringWithFormat:@"Type: %@", array.lastObject];
    float size = [FileManager fileSizeAtPath:urlString];
    _sizeLabel.text = [NSString stringWithFormat:@"Size: %.2f", size];
    _selectUrlString = urlString;
    [self onFileSelected:[NSURL URLWithString:urlString]];
}

- (void)onFileSelected:(NSURL *)url {
    _zipUrl = url;
}

- (void)startDfuWithPeripheral:(CBPeripheral *)peril {
    NSURL *url = _zipUrl;
    if (!url) {
        [self updateUIFail];
        return;
    }
    //create a DFUFirmware object using a NSURL to a Distribution Packer(ZIP)
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:url];// or
    //Use the DFUServiceInitializer to initialize the DFU process.
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager:self.bluetoothManager target:peril];
    DFUServiceInitiator *seInitiator = [initiator withFirmware:selectedFirmware];
    // Optional:
    // initiator.forceDfu = YES/NO; // default NO
    // initiator.packetReceiptNotificationParameter = N; // default is 12
    initiator.logger = self; // - to get log info
    initiator.delegate = self; // - to be informed about current state and errors
    initiator.progressDelegate = self; // - to show progress bar
    // initiator.peripheralSelector = ... // the default selector is used
    
    DFUServiceController *controller = [initiator start];
    NSLog(@"%@ === %@",seInitiator,controller);
}

- (void)updateUIPercent:(NSInteger)percentage {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_percentView.percent = percentage;
    });
}

- (void)updateUIStart {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawPercentView];
    });
}

- (void)updateUIComplete {
    NSLog(@"升级完成！！！！");
    _canDFUType = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removePercentView];
    });
}

- (void)updateUIFail {
    
}

- (void)drawPercentView {
    [self removePercentView];
    _percentView = [[PercentView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _percentView.backgroundColor = [UIColor colorWithRed:80 / 255.0 green:80 / 255.0 blue:80 / 255.0 alpha:0.4];
    [self.view addSubview:_percentView];
}

- (void)removePercentView {
    if (_percentView) {
        for (UIView *view in _percentView.subviews) {
            [view removeFromSuperview];
        }
        [_percentView removeFromSuperview];
        _percentView = nil;
    }
}

#pragma mark - DeviceConectControllerDelegate
- (void)centralManager:(CBCentralManager *)centralManager ConnectSuccessPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    _bluetoothManager = centralManager;
    _deviceLabel.text = [NSString stringWithFormat:@"Device: %@", _peripheral.name];
    if (_peripheral && _bluetoothManager) {
        [self startDfuWithPeripheral:_peripheral];
    }
}

#pragma mark- delegate
- (void)dfuProgressDidChangeFor:(NSInteger)part
                          outOf:(NSInteger)totalParts
                             to:(NSInteger)progress
     currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    NSLog(@"%s :%ld/%ld---progress: %ld",__FUNCTION__,(long)part,(long)totalParts,(long)progress);
    [self updateUIPercent:progress];
}

/*
 DFUStateConnecting = 0,
 DFUStateStarting = 1,
 DFUStateEnablingDfuMode = 2,
 DFUStateUploading = 3,
 DFUStateValidating = 4,
 DFUStateDisconnecting = 5,
 DFUStateCompleted = 6,
 DFUStateAborted = 7,*/
- (void)dfuStateDidChangeTo:(enum DFUState)state {
    NSLog(@"%s :%ld",__FUNCTION__,(long)state);
    switch (state) {
        case DFUStateConnecting:
        {
            [self updateUIStart];
        }
            break;
        case DFUStateEnablingDfuMode:
        {
            [self updateUIComplete];
        }
        case DFUStateCompleted:
        {
            [self updateUIComplete];
        }
        case DFUStateAborted:
        {
            [self updateUIFail];
        }
        default:
            break;
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString * _Nonnull)message {
    NSLog(@"%s: %ld , %@",__FUNCTION__,(long)error,message);
}

- (void)logWith:(enum LogLevel)level message:(NSString * _Nonnull)message {
    NSLog(@"%s,level:%ld ,%@",__FUNCTION__,(long)level,message);
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
