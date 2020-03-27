//
//  CameraView.h
//  ZeronerHealthPro
//
//  Created by CY on 2017/5/10.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView
@property (nonatomic,weak)UIImagePickerController *picker;

+ (instancetype)cameraView;

@end
