//
//  DFUViewController.h
//  AutumnTest
//
//  Created by A$CE on 2019/3/11.
//  Copyright © 2019年 A$CE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface DFUViewController : UIViewController

@property (strong, nonatomic) CBCentralManager *bluetoothManager;


- (void)handleUrlString:(NSString *)urlString;

@end

/**
 1.通过AirDrop发送升级文件到AutumnTest，注意使用正确的升级包
 2.进入DFU界面，AutumnTest会发送命令让设备进入DFU状态
 3.请选择正确的设备和文件用于升级
 
 1. Send the upgrade file to AutumnTest via AirDrop, pay attention to the correct upgrade package.
 2. Enter the DFU interface, and AutumnTest will send a command to let the device enter the DFU state.
 3. Please select the correct device and file for upgrading
 */

NS_ASSUME_NONNULL_END
