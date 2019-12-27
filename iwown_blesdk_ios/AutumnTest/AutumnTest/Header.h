//
//  Header.h
//  BLEMidAutumn
//
//  Created by A$CE on 2017/10/12.
//  Copyright © 2017年 A$CE. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
#define IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define FONT(no) ((iPhone4S||iPhone5)?(no):((iPhone6)?no*1.17:((iPhone6plus)?no*1.29:no *1)))

#define DocumentDirPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DirectoryPath [NSString stringWithFormat:@"%@/firmware", DocumentDirPath]

#endif /* Header_h */
