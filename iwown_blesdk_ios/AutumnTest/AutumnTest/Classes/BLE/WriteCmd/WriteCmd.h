//
//  WriteCmd.h
//  ZeronerHealthPro
//
//  Created by west on 2017/8/2.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteCmd : NSObject

+ (WriteCmd *)shareInstance;

- (void)writeCmdFile;

- (void)upload61CmdFileWithUid:(NSString *)uid Date:(NSDate *)date DataFrom:(NSString *)data_from;

-(void)upload62CmdFileWithUid:(NSString*)uid Date:(NSDate*)date DataFrom:(NSString*)data_from completion:( void (^)(id response, NSError *error))completion;

-(void)download62CmdFileWithUrl:(NSString*)url destinationUrl:(NSString*)desUrl completion:(void(^)())block;
@end
