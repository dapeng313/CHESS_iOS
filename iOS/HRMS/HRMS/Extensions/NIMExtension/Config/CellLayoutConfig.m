//
//  CellLayoutConfig.m
//  NIM
//
//  Created by amao on 2016/11/22.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CellLayoutConfig.h"
#import "SessionCustomContentConfig.h"
#import "WhiteboardAttachment.h"

@interface CellLayoutConfig ()
@property (nonatomic,strong)    NSArray    *types;
@property (nonatomic,strong)    SessionCustomContentConfig  *sessionCustomconfig;
@end

@implementation CellLayoutConfig

- (instancetype)init
{
    if (self = [super init])
    {
        _types =  @[
                   @"JanKenPonAttachment",
                   @"SnapchatAttachment",
                   @"ChartletAttachment",
                   @"WhiteboardAttachment"
                   ];
        _sessionCustomconfig = [[SessionCustomContentConfig alloc] init];
    }
    return self;
}

#pragma mark - NIMCellLayoutConfig
- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width{
    
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedCustomMessage:message]) {
        return [_sessionCustomconfig contentSize:width message:message];
    }
    
    //如果没有特殊需求，就走默认处理流程
    return [super contentSize:model
                    cellWidth:width];

}

- (NSString *)cellContent:(NIMMessageModel *)model{
    
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedCustomMessage:message]) {
        return [_sessionCustomconfig cellContent:message];
    }
    
    //如果没有特殊需求，就走默认处理流程
    return [super cellContent:model];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model
{
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedCustomMessage:message]) {
        return [_sessionCustomconfig contentViewInsets:message];
    }
    
    //如果没有特殊需求，就走默认处理流程
    return [super contentViewInsets:model];
}

- (UIEdgeInsets)cellInsets:(NIMMessageModel *)model
{
    NIMMessage *message = model.message;
    
    //检查是不是聊天室消息
    if (message.session.sessionType == NIMSessionTypeChatroom) {
        return UIEdgeInsetsZero;
    }
    
    //如果没有特殊需求，就走默认处理流程
    return [super cellInsets:model];
}


#pragma mark - misc
- (BOOL)isSupportedCustomMessage:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    return [object isKindOfClass:[NIMCustomObject class]] &&
    [_types indexOfObject:NSStringFromClass([object.attachment class])] != NSNotFound;
    
}

- (BOOL)isWhiteboardCloseNotificationMessage:(NIMMessage *)message
{
    if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = message.messageObject;
        if ([object.attachment isKindOfClass:[WhiteboardAttachment class]]) {
            return [(WhiteboardAttachment *)object.attachment flag] == CustomWhiteboardFlagClose;
        }
    }
    return NO;
}
@end
