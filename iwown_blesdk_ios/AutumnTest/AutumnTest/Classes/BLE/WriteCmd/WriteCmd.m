//
//  WriteCmd.m
//  ZeronerHealthPro
//
//  Created by west on 2017/8/2.
//  Copyright © 2017年 iwown. All rights reserved.
//

#import "WriteCmd.h"
#import "F1SQLManager.h"
#import "NetWorkTool.h"


@interface WriteCmd()

@property(nonatomic, strong)NSMutableArray *update61Dates;
@property(nonatomic, strong)NSMutableArray *update62Dates;

@end


@implementation WriteCmd

static WriteCmd *_writeCmd = nil;

+ (WriteCmd *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _writeCmd = [[WriteCmd alloc] init];
    });
    return _writeCmd;
}

- (instancetype)init
{
    if (self = [super init]) {
        [Utils createDirWithPath:CmdFile_DIRECTORY Name:nil];
        _update61Dates = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)writeCmdFile {
    NSLog(@"writeCmdFile======writeCmdFile");
    NSString *uid = USER_UID;
    NSString *dataFrom = [[NSUserDefaults standardUserDefaults] objectForKey:kDEVICE_BIND_NAME];
    NSString *key = [NSString stringWithFormat:@"%@_%@_cmd_date", uid, dataFrom];
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (date) {
        date = [NSDate dateStartOneDay:date];
    }
    NSArray *cmdArr = [[F1SQLManager shareInstance] selectCmdWithUser:uid DataFrom:dataFrom Date:date];
    if ([cmdArr count] > 0) {
        NSDate *dateTmp = nil;
        NSString *fileNameTmp = nil;
        NSString *pathTmp = nil;
        for (NSDictionary *dic in cmdArr) {
            NSDate *aDate = [dic objectForKey:@"date"];
            NSString *cmd = [dic objectForKey:@"cmd"];
            NSString *dateStr = [aDate dateToStringWithFormatter:@"yyyyMMdd"];
            NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@_61_cmd.txt", uid, dataFrom, dateStr];
            NSString *path = [NSString stringWithFormat:@"%@/%@",CmdFile_DIRECTORY, fileName];
            if (!dateTmp || ![aDate isSameDay:dateTmp]) {
                NSLog(@"writeCmdFile========path:%@", path);
                [self createCmdFileWithPath:path];
                [self writeCmd:[NSString stringWithFormat:@"%@", cmd] Path:path];
                if (pathTmp.length > 0) {
                    [self uploadCmdFileWithFileName:fileNameTmp Path:pathTmp];
                }
            } else {
                [self writeCmd:[NSString stringWithFormat:@"\n%@", cmd] Path:path];
            }
            dateTmp = aDate;
            fileNameTmp = fileName;
            pathTmp = path;
        }
        
        if (pathTmp.length > 0) {
            [self uploadCmdFileWithFileName:fileNameTmp Path:pathTmp];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:dateTmp forKey:key];
    }
}

- (void)upload61CmdFileWithUid:(NSString *)uid Date:(NSDate *)date DataFrom:(NSString *)data_from {
    NSArray *cmdArr = [[F1SQLManager shareInstance] selectADayCmdWithUser:uid DataFrom:data_from Date:date];
    NSString *dateStr = [date dateToStringWithFormatter:@"yyyyMMdd"];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@_61_cmd.txt", uid, data_from, dateStr];
    NSString *path = [NSString stringWithFormat:@"%@/%@",CmdFile_DIRECTORY, fileName];
    [self createCmdFileWithPath:path];
    for (int i = 0; i < [cmdArr count]; i++) {
        NSString *cmd = [cmdArr[i] objectForKey:@"cmd"];
        if (i == 0) {
            [self writeCmd:[NSString stringWithFormat:@"%@", cmd] Path:path];
        } else {
            [self writeCmd:[NSString stringWithFormat:@"\n%@", cmd] Path:path];
        }
    }
    [_update61Dates addObject:date];
    BOOL isToday = NO;
    BOOL isYestoday = NO;
    for (NSDate *aDate in _update61Dates) {
        if ([aDate isToday]) {
            isToday = YES;
        }
        if ([aDate isYesterday]) {
            isYestoday = YES;
        }
    }
    [self uploadCmd61FileWithFileName:fileName Path:path completion:^(id response, NSError *error) {
        NSLog(@"uploadCmd61FileWithFileName==========responseObject：%@", response);
        NSLog(@"uploadCmd61FileWithFileName==========error：%@", error);
        if (isToday && isYestoday) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNOTICE_SYNC_TWODAYSDATAEND object:@(YES)];
            });
        }
    }];
}

-(void)upload62CmdFileWithUid:(NSString*)uid Date:(NSDate*)date DataFrom:(NSString*)data_from completion:( void (^)(id response, NSError *error))completion
{
    NSArray *cmdArr = [[F1SQLManager shareInstance] selectADay62CmdWithUser:uid DataFrom:data_from Date:date];
    NSString *dateStr = [date dateToStringWithFormatter:@"yyyyMMdd"];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@_62_cmd.txt", uid, data_from, dateStr];
    NSString *path = [NSString stringWithFormat:@"%@/%@",CmdFile_DIRECTORY, fileName];
    [self createCmdFileWithPath:path];
    for (int i = 0; i < [cmdArr count]; i++) {
        NSString *cmd = [cmdArr[i] objectForKey:@"cmd"];
        if (i == 0) {
            [self writeCmd:[NSString stringWithFormat:@"%@", cmd] Path:path];
        } else {
            [self writeCmd:[NSString stringWithFormat:@"\n%@", cmd] Path:path];
        }
    }
    [self uploadCmd62FileWithFileName:fileName Path:path completion:completion];
}


- (void)createCmdFileWithPath:(NSString *)path {
    [Utils deleteFileByPath:path];
    [Utils createFileWithPath:path];
}


- (void)writeCmd:(NSString *)cmd Path:(NSString *)path{
    [Utils writeFile:cmd toPath:path];
}

- (void)uploadCmd61FileWithFileName:(NSString *)fileName Path:(NSString *)path completion:( void (^)(id response, NSError *error))completion {
    [[NetWorkTool shareInstance] send61DataFileUploadRequestWithFileName:fileName path:path dictionary:nil completion:completion];
}
- (void)uploadCmd62FileWithFileName:(NSString *)fileName Path:(NSString *)path completion:( void (^)(id response, NSError *error))completion {
    [[NetWorkTool shareInstance] send62DataFileUploadRequestWithFileName:fileName path:path dictionary:nil completion:completion];
}

- (void)uploadCmdFileWithFileName:(NSString *)fileName Path:(NSString *)path {
    [[NetWorkTool shareInstance] send61DataFileUploadRequestWithFileName:fileName path:path dictionary:nil completion:^(id responseObject, NSError *error) {
        NSLog(@"uploadCmdFileWithFileName==========responseObject：%@", responseObject);
        NSLog(@"uploadCmdFileWithFileName==========error：%@", error);
    }];
}

-(void)download62CmdFileWithUrl:(NSString*)url destinationUrl:(NSString*)desUrl completion:(void(^)())block
{
        AFHTTPSessionManager* sessionManager=[AFHTTPSessionManager manager];
        NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLSessionDownloadTask* task=[sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:desUrl];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if(error)
            {
                block();
            }
            else
            {
                //解析62 cmd文件到 database
                [self parse62CmdFileWithUrl:desUrl completion:block];
            }
            
        }];
    [task resume];
}

-(void)parse62CmdFileWithUrl:(NSString*)url completion:(void(^)())block
{
     NSError *error;
    NSString* fileContent=[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:url] encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSArray* cmd62Ary=[fileContent componentsSeparatedByString:@"\n"];
        for (int i=0; i<cmd62Ary.count; ++i) {
            NSString* tmp62Cmd=cmd62Ary[i];
            if ([self check62CmdCtl1:tmp62Cmd]) {
                NSDictionary* dict= [self parseGNSS62Data:[tmp62Cmd substringFromIndex:8]];
                if ([[dict objectForKey:@"date"] length] > 0) {
                    Data62Model *model = [[Data62Model alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    model.uid = USER_UID;
                     [[F1SQLManager shareInstance] insert62Data:model];
                }
            }
            
        }
        block();//解析完成
    }
    else
    {
        block();
    }
}

-(BOOL)check62CmdCtl1:(NSString*)cmd
{
    NSString* prefix62=[cmd substringToIndex:6];
    if(![prefix62 isEqualToString:@"23ff62"])
    {
        return false;
    }
    NSInteger length=strtoul([[cmd substringWithRange:NSMakeRange(6, 2)] UTF8String],0,16);
    NSString* dataBody=[cmd substringFromIndex:8];
    if ((length*2)!=[dataBody lengthOfBytesUsingEncoding:NSASCIIStringEncoding]) {
        return  false;
    }
    return true;
}
- (NSDictionary *)parseGNSS62Data:(NSString *)str {
    NSInteger ctrlNum = strtoul([[str substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    NSDictionary *dic;
    if (ctrlNum == 0) {
        dic =nil;
    } else {
        dic = [self parseGNSS62DetailData:[str substringFromIndex:2]];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dict setObject:@(ctrlNum) forKey:@"ctrl"];
    return dict;
}
- (NSInteger)uint16StrToInteger:(NSString *)str
{
    // 0x00c8
    NSString *lowByte =     [str substringWithRange:NSMakeRange(0, 2)];
    NSString *highByte =    [str substringWithRange:NSMakeRange(2, 2)];
    
    NSString *newStr = [NSString stringWithFormat:@"%@%@",highByte, lowByte];
    
    NSInteger newNum = strtoul([newStr UTF8String],0,16);
    
    return newNum;
}
- (NSDictionary *)parseGNSS62DetailData:(NSString *)str {
    if (str.length < 14) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSInteger seq = [self uint16StrToInteger:[str substringWithRange:NSMakeRange(0, 4)]];
    [dict setObject:@(seq) forKey:@"seq"];
    [dict setObject:[USERDEFAULT objectForKey:kBIND_DATA_FROM] forKey:@"data_from"];
    
    NSString *dtStr = [str substringWithRange:NSMakeRange(4, 10)];
    if ([dtStr isEqualToString:@"ffffffffff"]) {
        return dict;
    }
    
    if (str.length < 18) {
        return nil;
    }
    NSInteger year = strtoul([[str substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16)+2000;
    NSInteger month = strtoul([[str substringWithRange:NSMakeRange(6, 2)] UTF8String],0,16)+1;
    NSInteger day = strtoul([[str substringWithRange:NSMakeRange(8, 2)] UTF8String],0,16)+1;
    NSInteger hours = strtoul([[str substringWithRange:NSMakeRange(10, 2)] UTF8String],0,16);
    NSInteger minutes = strtoul([[str substringWithRange:NSMakeRange(12, 2)] UTF8String],0,16);
    NSInteger freq = strtoul([[str substringWithRange:NSMakeRange(14, 2)] UTF8String],0,16);
    NSInteger num = strtoul([[str substringWithRange:NSMakeRange(16, 2)] UTF8String],0,16);
    
    [dict setObject:[NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:00",(long)year,(long)month,(long)day,(long)hours,(long)minutes] forKey:@"date"];
    [dict setObject:@(freq) forKey:@"freq"];
    
    if (str.length < 18 + num * 28) {
        return nil;
    }
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < num; i++) {
        NSDictionary *dic = [self getGNSSData:[str substringWithRange:NSMakeRange(18 + i * 28, 28)]];
        [dataArr addObject:dic];
    }
    [dict setObject:@(num) forKey:@"num"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArr options:0 error:&error];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [dict setObject:dataStr forKey:@"data"];
    return dict;
}
- (NSDictionary *)getGNSSData:(NSString *)str {
    if (str.length < 28) {
        return nil;
    }
    NSInteger longitudeDegree = strtoul([[str substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    NSInteger longitudeMinute = strtoul([[str substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    NSInteger longitudeSecond = strtoul([[str substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    NSInteger longitudePrec = strtoul([[str substringWithRange:NSMakeRange(6, 2)] UTF8String],0,16);
    NSInteger longitudeDirection = strtoul([[str substringWithRange:NSMakeRange(8, 2)] UTF8String],0,16);
    NSInteger latitudeDegree = strtoul([[str substringWithRange:NSMakeRange(10, 2)] UTF8String],0,16);
    NSInteger latitudeMinute = strtoul([[str substringWithRange:NSMakeRange(12, 2)] UTF8String],0,16);
    NSInteger latitudeSecond = strtoul([[str substringWithRange:NSMakeRange(14, 2)] UTF8String],0,16);
    NSInteger latitudePrec = strtoul([[str substringWithRange:NSMakeRange(16, 2)] UTF8String],0,16);
    NSInteger latitudeDirection = strtoul([[str substringWithRange:NSMakeRange(18, 2)] UTF8String],0,16);
    NSInteger gpsSpeed = [self uint16StrToInteger:[str substringWithRange:NSMakeRange(20, 4)]];
    NSInteger altitude = [self uint16StrToInteger:[str substringWithRange:NSMakeRange(24, 4)]];
    
    if (longitudeDirection == 0){ // 0为东经
        longitudeDirection = 1;
    }else {
        longitudeDirection = -1;
    }
    if (latitudeDirection == 0){ //0 为北纬
        latitudeDirection = 1;
    }else {
        latitudeDirection = -1;
    }
    CGFloat longitude = longitudeDirection * (longitudeDegree + longitudeMinute/60.0 + (longitudeSecond + longitudePrec/100)/3600.0);
    CGFloat latitude = latitudeDirection * (latitudeDegree + latitudeMinute/60.0 + (latitudeSecond + latitudePrec/100)/3600.0);
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDict setObject:@(longitude) forKey:@"longitude"];
    [mDict setObject:@(latitude) forKey:@"latitude"];
    [mDict setObject:@(altitude) forKey:@"altitude"];
    [mDict setObject:@(gpsSpeed) forKey:@"gps_speed"];
    return mDict;
}

@end
