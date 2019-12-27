//
//  ecgDemoViewController.m
//  AutumnTest
//
//  Created by ChenWu on 2018/3/19.
//  Copyright © 2018年 A$CE. All rights reserved.
//

#import "ecgDemoViewController.h"
#import "BLEShareInstance.h"
@interface ecgDemoViewController ()

@end

@implementation ecgDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton* clearLog=[UIButton buttonWithType:UIButtonTypeCustom];
    [clearLog addTarget:self action:@selector(clearEcgFile:) forControlEvents:UIControlEventTouchUpInside];
    [clearLog setTitle:@"重置文件内容" forState:UIControlStateNormal];
    [clearLog setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:clearLog];
    clearLog.frame=CGRectMake(100, 80, 80, 40);
    [clearLog sizeToFit];
    
    
    UIButton* testEcg=[UIButton buttonWithType:UIButtonTypeCustom];
    [testEcg addTarget:self action:@selector(testEcg:) forControlEvents:UIControlEventTouchUpInside];
    [testEcg setTitle:@"ECG 测试" forState:UIControlStateNormal];
    [testEcg setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:testEcg];
    testEcg.frame=CGRectMake(100, 140, 80, 40);

}
-(void)clearEcgFile:(id)sender
{

    NSString* homepath=NSHomeDirectory();
    NSString* docPath=[homepath stringByAppendingPathComponent:@"Documents"];
    NSString* filePath=[docPath stringByAppendingPathComponent:@"ECG"];
    NSFileManager* fileMan=[NSFileManager defaultManager];
    
    
   NSString*  ecgPath=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",@"Ecg_ecg"]];
   NSString*  ppgPath=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",@"Ecg_ppg"]];
    if ([fileMan fileExistsAtPath:ecgPath]) {
        [fileMan removeItemAtPath:ecgPath error:nil];
    }
    if ([fileMan fileExistsAtPath:ppgPath]) {
        [fileMan removeItemAtPath:ppgPath error:nil];
    }

}
-(void)testEcg:(id)sender
{
       [[BLEShareInstance shareInstance] testZGECGAuto];
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
