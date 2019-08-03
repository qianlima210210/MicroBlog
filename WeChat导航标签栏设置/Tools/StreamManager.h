//
//  StreamManager.h
//  WeChat
//
//  Created by ma qianli on 2018/7/26.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamManager : NSObject

@property (nonatomic, strong) XMPPStream *xmppStream;//具有写入、写出的功能，流想当于一根管子

//功能模块begin
@property (nonatomic, strong) XMPPReconnect *reconnect;     //自动重连连接模块
@property (nonatomic, strong) XMPPAutoPing *autoPing;       //心跳模块
@property (nonatomic, strong) XMPPRoster *roster;           //好友模块
@property (nonatomic, strong) XMPPMessageArchiving *messageArchiving;//收发消息、历史消息，最近联系人模块
@property (nonatomic, strong) XMPPvCardTempModule *vCardTempModule;//自己个人资料模块
@property (nonatomic, strong) XMPPvCardAvatarModule *vCardAvatarModule;//别人个人资料模块
@property (nonatomic, strong) XMPPMUC *xmppmuc; //多用户聊天模块
@property (nonatomic, strong) XMPPRoom *xmpproom;   //聊天室模块

//功能模块end

+(instancetype)sharedManager;

-(void)loginWithJid:(XMPPJID*)jid withPwd:(NSString*)pwd;


@end
