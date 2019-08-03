//
//  StreamManager.m
//  WeChat
//
//  Created by ma qianli on 2018/7/26.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import "StreamManager.h"

@interface StreamManager ()<XMPPStreamDelegate, XMPPReconnectDelegate, XMPPAutoPingDelegate, XMPPRosterDelegate, XMPPMessageArchiveManagementDelegate>

@property (nonatomic, copy) NSString *pwd;//用来authenticateWithPassword

@end

@implementation StreamManager

+ (instancetype)sharedManager{
    static StreamManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [StreamManager new];
    });
    return manager;
}

- (XMPPStream *)xmppStream{
    if (_xmppStream == nil) {
        //创建对象
        _xmppStream = [XMPPStream new];
        //配置属性
        _xmppStream.hostName = @"127.0.0.1";
        _xmppStream.hostPort = 5222;
        //设置代理（此处是多波代理，及可以有多个代理对象）
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

-(void)loginWithJid:(XMPPJID*)jid withPwd:(NSString*)pwd{
    self.xmppStream.myJID = jid;
    self.pwd = pwd;
    
    NSError *error;
    NSLog(@"连接kaishi");
    if ([self.xmppStream connectWithTimeout:-1 error:&error]) {
        NSLog(@"连接成功");
        //激活
        [self activate];
    }else{
        NSLog(@"连接失败");
    }
}

- (XMPPReconnect *)reconnect{
    if (_reconnect == nil) {
        //创建对象
        _reconnect = [[XMPPReconnect alloc]init];
        
        //配置对象
        _reconnect.reconnectTimerInterval = 2;
        
        //设置对象代理
       [_reconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _reconnect;
}

- (XMPPAutoPing *)autoPing{
    if (_autoPing == nil) {
        //创建对象
        _autoPing = [[XMPPAutoPing alloc]init];
        
        //配置对象
        _autoPing.pingInterval = 10;
        
        //设置对象代理
        [_autoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _autoPing;
}

- (XMPPRoster *)roster{
    if (_roster == nil) {
        
        _roster = [[XMPPRoster alloc]initWithRosterStorage:[XMPPRosterCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        //是否自动获取新的好友数据
        _roster.autoFetchRoster = YES;
        
        //是否自动删除用户存储的数据，不需要
        _roster.autoClearAllUsersAndResources = NO;
        
        //是否自动接受好友请求
        _roster.autoAcceptKnownPresenceSubscriptionRequests = NO;
        
        //设置代理
        [_roster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        
    }
    return _roster;
}

- (XMPPMessageArchiving *)messageArchiving{
    if (_messageArchiving == nil) {
        _messageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:[XMPPMessageArchivingCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        
        [_messageArchiving addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    return _messageArchiving;
}

- (XMPPvCardTempModule *)vCardTempModule{
    if (_vCardTempModule == nil) {
        //创建对象
        _vCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        //设置参数
        
        //设置代理，去需要监控的控制器添加
    }
    return _vCardTempModule;
}

- (XMPPvCardAvatarModule *)vCardAvatarModule{
    if (_vCardAvatarModule == nil) {
        _vCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.vCardTempModule dispatchQueue:dispatch_get_global_queue(0, 0)];
    }
    return _vCardAvatarModule;
}

/**
 激活模块
 */
-(void)activate{
    if([self.reconnect activate:self.xmppStream]){
        NSLog(@"成功激活重连");
    }else{
        NSLog(@"激活重连失败");
    }
    
    if([self.autoPing activate:self.xmppStream]){
        NSLog(@"成功激活心跳");
    }else{
        NSLog(@"激活心跳失败");
    }
    
    if ([self.roster activate:self.xmppStream]) {
        NSLog(@"成功激活好友");
    }else{
        NSLog(@"激活好友失败");
    }
    
    if ([self.messageArchiving activate:self.xmppStream]) {
        NSLog(@"成功激活消息归档");
    }else{
        NSLog(@"激活消息归档失败");
    }
    
    if ([self.vCardTempModule activate:self.xmppStream]) {
        NSLog(@"成功激活自己个人资料");
    }else{
        NSLog(@"激活自己个人资料失败");
    }
    
    if ([self.vCardAvatarModule activate:self.xmppStream]) {
        NSLog(@"成功激活别人个人资料");
    }else{
        NSLog(@"激活自己别人资料失败");
    }
    
}

#pragma mark -- XMPPStreamDelegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    [self.xmppStream authenticateWithPassword:self.pwd error:nil];
    
    NSLog(@"%s", __func__);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //认证成功后，出席
    XMPPPresence *presence = [XMPPPresence presence];
    
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"chat"]];
    
    [self.xmppStream sendElement:presence];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"密码验证失败:%@", error);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    if (message.body.length > 0) {
        NSLog(@"收到消息:%@", message.body);
        //本地通知
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = message.body;
        notification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }
}

#pragma mark -- XMPPReconnectDelegate

#if MAC_OS_X_VERSION_MIN_REQUIRED <= MAC_OS_X_VERSION_10_5

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags{
    NSLog(@"%s", __func__);
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags{
    return YES;
}

#else

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags{
    NSLog(@"%s", __func__);
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags{
    return YES;
}

#endif

#pragma mark -- XMPPPingDelegate
- (void)xmppPing:(XMPPPing *)sender didReceivePong:(XMPPIQ *)pong withRTT:(NSTimeInterval)rtt{
    NSLog(@"收到服务端的Pong, rtt = %f", rtt);
}

- (void)xmppPing:(XMPPPing *)sender didNotReceivePong:(NSString *)pingID dueToTimeout:(NSTimeInterval)timeout{
    NSLog(@"没有收到服务端的Pong, pingID = %@, rtt = %f", pingID, timeout);
}

- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender{
    NSLog(@"向服务端发送Ping");
}
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender{
    NSLog(@"收到服务端的Pong");
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender{
    NSLog(@"向服务端发送Ping时超时");
}

#pragma mark -- XMPPRosterDelegate


#pragma mark -- XMPPMessageArchiveManagementDelegate















@end
