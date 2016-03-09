//
//  RCTEaseMob.m
//  RCTEaseMob
//
//  Created by 5173 on 16/3/8.
//  Copyright © 2016年 William-Miao. All rights reserved.
//

#import "RCTEaseMob.h"
#import "IChatManagerLogin.h"
#import "EMError.h"
#import "EMCallSession.h"

@interface RCTEaseMob() {
    EMCallSession *_callSession;
}
@end

@implementation RCTEaseMob

RCT_EXPORT_MODULE()

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
        [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

//初始化SDK
RCT_EXPORT_METHOD(registerSDK:(NSString *)anAppKey
                  apnsCertName:(NSString *)anAPNSCertName
                  otherConfig:(NSDictionary *)anOtherConfig:(RCTResponseSenderBlock)callback)
{
    EMError *res = [[EaseMob sharedInstance] registerSDKWithAppKey:anAppKey apnsCertName:anAPNSCertName otherConfig:anOtherConfig];
    callback(@[res]);
}

//使用用户名密码登录聊天服务器
RCT_EXPORT_METHOD(Login:(NSString *)username
                  password:(NSString *)password
                  :(RCTResponseSenderBlock)callback)
{
    NSString *res;
    NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:username password:password error:nil];
    if (loginInfo != nil) {
        res = @"Login success!";
    } else {
        res = @"Login error!";
    };
    callback(@[res]);
}

//注销当前登录用户
RCT_EXPORT_METHOD(Logout)
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
}

#warning 同一个user的sessionId不是固定值，需每次重新获取。
//TODO: - 处理实时通话时的一些回调操作
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    _callSession = callSession;
}

//进行实时语音
RCT_EXPORT_METHOD(Call:(NSString *)chatter
                  timeout:(NSUInteger)timeout
                  :(RCTResponseSenderBlock)callback)
{
    EMCallSession *callSesion = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:timeout error:nil];
    callback(@[callSesion.sessionId]);
}

//接收方同意语音通话的请求
RCT_EXPORT_METHOD(Answer:(RCTResponseSenderBlock)callback)
{
    NSString *res;
    EMError *err = [[EaseMob sharedInstance].callManager asyncAnswerCall:_callSession.sessionId];
    if (err == nil) {
        res = @"Answer success!";
    } else {
        res = @"Answer error!";
    }
    callback(@[res]);
}

//发起方或接收方结束通话
RCT_EXPORT_METHOD(endCall)
{
    [[EaseMob sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReasonHangup];
}

//将实时语音静音
RCT_EXPORT_METHOD(silenceAction:(NSString *)sessionId)
{
    [[EaseMob sharedInstance].callManager markCallSession:sessionId asSilence:YES];
}

//发送文字消息
RCT_EXPORT_METHOD(sendText:(NSString *)textMessage
                  toUsername:(NSString *)username)
{
    EMChatText *text = [[EMChatText alloc] initWithText:textMessage];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
}

//发送图片消息
RCT_EXPORT_METHOD(sendImage)
{
    
}

//发送位置消息
RCT_EXPORT_METHOD(sendLocationMessage)
{
    
}

@end
