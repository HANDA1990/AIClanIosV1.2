//
//  ConnectSocket.h
//  SocketClient
//
//  Created by hd on 2017/11/7.
//  Copyright © 2017年 hd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol ConnectSocketdelegate <NSObject>
- (void)didReturnConnectInfo:(NSString *)info;

@end

@interface ConnectSocket : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;    
}

@property (nonatomic, assign)id<ConnectSocketdelegate> delegate;

- (void)initConnectSoket:(NSString *)url portstr:(NSString *)portstr account:(NSString *)account password:(NSString *)password;

- (void)SendCode:(NSString *)account password:(NSString *)password;

- (BOOL)closeEquipRd:(NSString *)account;

+ (NSString *)ssid;

+ (NSString *)bssid;
@end
