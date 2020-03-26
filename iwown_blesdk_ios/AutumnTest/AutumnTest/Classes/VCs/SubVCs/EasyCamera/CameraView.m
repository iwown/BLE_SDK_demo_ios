//
//  CameraView.m
//  ZeronerHealthPro
//
//  Created by CY on 2017/5/10.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import "CameraView.h"

#import "BLEShareInstance.h"

@interface CameraView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *thunbnaiImage;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (strong ,nonatomic) UIImage *lastPicture;
@end

@implementation CameraView

+ (instancetype)cameraView {
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"CameraView"owner:self options:nil];
    CameraView *cv = [nibView objectAtIndex:0];
    cv.thunbnaiImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:cv action:@selector(thunbnaiImageClick:)];
    [cv.thunbnaiImage addGestureRecognizer:tapGesture];
    cv.thunbnaiImage.hidden = YES;
    return cv;
}

- (void)layoutSubviews {
//    self.bottomView.backgroundColor = Global_BackgroundColor_deep;
    self.thunbnaiImage.contentMode = UIViewContentModeScaleAspectFill;
    self.thunbnaiImage.layer.cornerRadius = 3;
    self.thunbnaiImage.layer.masksToBounds = YES;
}

- (void)setPicker:(UIImagePickerController *)picker {
    _picker = picker;
    _picker.delegate = self;
    [[[BLEShareInstance shareInstance] bleSolstice] setKeyNotify:1];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takePicture:) name:@"TakePictureNotify" object:nil];
}

- (IBAction)takePicture:(id)sender {
    if (self.picker) {
        [self.picker takePicture];
    }
}

- (IBAction)cancelTakePicture:(id)sender {
    if (self.picker) {
        [[[BLEShareInstance shareInstance] bleSolstice] setKeyNotify:0];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TakePictureNotify" object:nil];
        [self.picker dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (IBAction)cameraSelect:(id)sender{
    if (self.picker) {
        if (self.picker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }else{
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    }
}

#pragma mark ImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(original, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    self.lastPicture = image;
    [self.thunbnaiImage setImage:image];
    if (self.thunbnaiImage.hidden) {
        self.thunbnaiImage.hidden = NO;
        self.thunbnaiImage.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.thunbnaiImage.alpha = 1;
        }];
    }
}

- (void)thunbnaiImageClick:(UITapGestureRecognizer *)gesture {
    CGFloat SCREEN_WIDTH = [[UIScreen mainScreen] bounds].size.width;
    CGFloat SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(18, SCREEN_HEIGHT -127.5, 55, 55)];
    vi.backgroundColor = [UIColor blackColor];
    vi.clipsToBounds = YES;
    CGSize size = self.lastPicture.size;
    CGFloat sizeY = (SCREEN_WIDTH /size.width)*size.height;
    UIImageView *bImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sizeY)];
    bImgView.image = self.lastPicture;
    bImgView.userInteractionEnabled = YES;
    [vi addSubview:bImgView];
    [bImgView setCenter:CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT *0.5)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [vi addGestureRecognizer:tap];
    [self addSubview:vi];
    [UIView animateWithDuration:0.5 animations:^{
        vi.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    CGFloat SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    
    UIView *vi = tap.view;
    [UIView animateWithDuration:0.5 animations:^{
        vi.frame = CGRectMake(18, SCREEN_HEIGHT -127.5, 55, 55);
    } completion:^(BOOL finished) {
        [vi removeFromSuperview];
    }];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
