
//
//  ConnectSocket.m
//  SocketClient
//
//  Created by hd on 2017/11/7.
//  Copyright © 2017年 hd. All rights reserved.
//

#import "ConnectSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "AppDelegate.h"
#import<SystemConfiguration/CaptiveNetwork.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

#define USE_SECURE_CONNECTION 1
#define ENABLE_BACKGROUNDING  0


@interface ConnectSocket ()
{
    NSData   *startdata;
    NSData   *enddata;
    NSData   *fianlpreData;
    
    NSString *host;
    uint16_t port;
    
    NSString *accuntstr;
    NSString *passwordstr;
    
    BOOL overCon;
    NSString *resStr;;
}
@end

@implementation ConnectSocket

- (id)init
{
    if ((self = [super init]))
    {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
    return self;
}

- (void)initConnectSoket:(NSString *)url portstr:(NSString *)portstr account:(NSString *)account password:(NSString *)password{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (!asyncSocket)
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
   
    host = url;
    port = [portstr integerValue];

    NSError *error = nil;
    
    accuntstr = account;
    passwordstr = password;

    if (![asyncSocket isDisconnected])
    {
        [asyncSocket disconnect];
    }
    [SVProgressHUD show];

    BOOL isConnect =[asyncSocket connectToHost:host onPort:port withTimeout:5 error:&error];
    

    if (error != nil) {
        //当有错误的时候抛出异常错误信息
        @throw [NSException exceptionWithName:@"GCDAsyncSocket" reason:[error localizedDescription] userInfo:nil];
    }
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [sock performBlock:^{
        if ([sock enableBackgroundingOnSocket])
            DDLogInfo(@"Enabled backgrounding on socket");
        else
            DDLogWarn(@"Enabling backgrounding failed!");
    }];
    [self SendCode:accuntstr password:passwordstr];
    [SVProgressHUD dismiss];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    DDLogInfo(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //接受数据
    NSString *hexStr = [self hexStringFromData:data];//转16进制
    
    
    resStr = [self stringFromHexString:hexStr];//转字符串

    if (resStr.length > 0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered) userInfo:nil repeats:NO];
    }
    NSLog(@"接受数据%@",resStr);
}
-(void)Timered{
    [NSUserDefaults setString:resStr forKey:EQUIPID];
    overCon = [self closeEquipRd:@"11"];
    // [sock disconnect];
    
    if ([self.delegate respondsToSelector:@selector(didReturnConnectInfo:)] && overCon) {
        [self.delegate didReturnConnectInfo:resStr];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    BOOL state = [sock isConnected];
    if (state) {
        NSLog(@"已经是连接状态");
        return;
    }
   
    [SVProgressHUD dismiss];

    if (err.code == 3 && !overCon) {
        if (![asyncSocket isDisconnected])
        {
            [asyncSocket disconnect];
        }
        [asyncSocket connectToHost:host onPort:port error:nil];
        if ([self.delegate respondsToSelector:@selector(didReturnConnectInfo:)]) {
            [self.delegate didReturnConnectInfo:@"0"];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(didReturnConnectInfo:)]) {
            [self.delegate didReturnConnectInfo:@"1"];
        }
    }
    DDLogInfo(@"socketDidDisconnect:%p withError: %@", sock, err);
}

- (BOOL)closeEquipRd:(NSString *)account{
    NSString *finalStr = @"";
    NSMutableArray *jyArr = [NSMutableArray new];

    for (int k = 0; k < account.length; k ++) {
        int asciiCode = [account characterAtIndex:k];
        [jyArr addObject:[NSNumber numberWithInteger:asciiCode]];
        finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self getHexByDecimal:asciiCode]]];

    }
    int i,sum=0;
    for (i=0;i<jyArr.count;i++)
        sum += [jyArr[i] intValue];//将每个数相加
    //取余
    int fianlY = sum % 256;
    NSString *final16 = [self getHexByDecimal:fianlY];
    finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",final16]];

    NSData *sendd = [self convertHexStrToData2:finalStr];
    NSLog(@"发送指令关闭热点:%@",sendd);

    [asyncSocket writeData:sendd  withTimeout:-1 tag:2];
   // [asyncSocket readDataWithTimeout:30 tag:2];
    return  YES;
}

- (void)SendCode:(NSString *)account password:(NSString *)password{

    NSMutableArray *jyArr = [NSMutableArray new];
    NSString *finalStr = @"";
    [jyArr addObject:@48];
    finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self getHexByDecimal:48]]];
    for (int k = 0; k < account.length; k ++) {
        int asciiCode = [account characterAtIndex:k];
        [jyArr addObject:[NSNumber numberWithInteger:asciiCode]];
        finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self getHexByDecimal:asciiCode]]];

    }
    [jyArr addObject:@13];
    finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self getHexByDecimal:13]]];

    for (int k = 0; k < password.length; k ++) {
        int asciiCode = [password characterAtIndex:k];
        [jyArr addObject:[NSNumber numberWithInteger:asciiCode]];
        finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self getHexByDecimal:asciiCode]]];
    }
    [jyArr addObject:@13];
    finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self getHexByDecimal:13]]];
    int i,sum=0;
    for (i=0;i<jyArr.count;i++)
        sum += [jyArr[i] intValue];//将每个数相加
    //取余
    int fianlY = sum % 256;
    NSString *final16 = [self getHexByDecimal:fianlY];
    finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@",final16]];
    NSData *sendd = [self convertHexStrToData2:finalStr];
    NSLog(@"发送指令账号:%@",sendd);

    [asyncSocket writeData:sendd  withTimeout:-1 tag:1];
    [asyncSocket readDataWithTimeout:-1 tag:1];

}
//接收到的数据校验和处理
- (BOOL)checkDatasP:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    unsigned long hexHe = 0;
    for(int i=0;i<[myD length] - 1;i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexHe = strtoul([newHexStr UTF8String],0,16);
        
        else
        {
            unsigned long num1 = strtoul([newHexStr UTF8String],0,16);
            hexHe += num1;
        }
    
    }
    unsigned long hexyu = hexHe % 256;
    NSLog(@"hexyu = %@",hexyu);

    if (hexyu == bytes[[myD length] - 1]) {
        return YES;
    }
    
    return NO;
}


//字符串转16进制
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        ///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        
    }
    return hexStr;
}
// 十六进制转换为普通字符串的
- (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt]; myBuffer[i / 2] = (char)anInt;
        
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:1];
    unicodeString = [unicodeString substringToIndex:unicodeString.length-1];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
}
// 16进制转NSData
- (NSData *)convertHexStrToData2:(NSString *)str
{
    if (!str || [str length] == 0)
    {
        return nil;
        
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0)
    {
        range = NSMakeRange(0, 2);
        
    } else {
        range = NSMakeRange(0, 1);
        
    }
    for (NSInteger i = range.location; i < [str length]; i += 2)
    {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
        
    }
    return hexData;
    
}
//data转换为十六进制的string
- (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"hex = %@",hexStr);
    
    return hexStr;
}

- (NSString *)getBinaryByHex:(NSString *)hex
{
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++)
    {
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value)
        {
            binary = [binary stringByAppendingString:value];
            
        }
        
    }
    return binary;
    
}

- (NSString *)getHexByDecimal:(NSInteger)decimal {
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++)
    {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number)
        {
            case 10: letter =@"A";
            break;
            case 11:
            letter =@"B";
            break;
            case 12:
            letter =@"C";
            break;
            case 13:
            letter =@"D";
            break;
            case 14:
            letter =@"E";
            break;
            case 15:
            letter =@"F";
            break;
            default:
            letter = [NSString stringWithFormat:@"%ld", number];
    
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    if (hex.length == 1) {
        hex = [@"0" stringByAppendingString:hex];
    }
    return hex;
}
+ (NSString *)ssid

{
    
    NSString *ssid = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            ssid = [dict valueForKey:@"SSID"];
            
        }
        
    }
    
    return ssid;
    
}
+ (NSString *)bssid //获取macIP

{
    
    NSString *bssid = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            bssid = [dict valueForKey:@"BSSID"];
            
        }
        
    }
    
    return bssid;
    
}

@end
