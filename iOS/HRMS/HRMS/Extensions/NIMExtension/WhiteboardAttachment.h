//
//  WhiteboardAttachment.h
//  NIM
//
//  Created by 高峰 on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSDK.h"
#import "CustomAttachmentDefines.h"

typedef NS_ENUM(NSInteger, CustomWhiteboardFlag) {
    CustomWhiteboardFlagInvite  = 0,//邀请
    CustomWhiteboardFlagClose   = 1,//关闭
};

@interface WhiteboardAttachment : NSObject<NIMCustomAttachment, CustomAttachmentInfo>

@property (nonatomic,assign) CustomWhiteboardFlag flag;

@end
