//
//  CustomAttachmentDecoder.m
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "CustomAttachmentDecoder.h"
#import "CustomAttachmentDefines.h"
//#import "JanKenPonAttachment.h"
//#import "SnapchatAttachment.h"
#import "ChartletAttachment.h"
#import "WhiteboardAttachment.h"
#import "NSDictionary+Json.h"
#import "HRMS-Swift.h"

@implementation CustomAttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;

    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:CMType];
            NSDictionary *data = [dict jsonDict:CMData];
            switch (type) {
//                case CustomMessageTypeJanKenPon:
//                {
//                    attachment = [[JanKenPonAttachment alloc] init];
//                    ((JanKenPonAttachment *)attachment).value = [data jsonInteger:CMValue];
//                }
//                    break;
//                case CustomMessageTypeSnapchat:
//                {
//                    attachment = [[SnapchatAttachment alloc] init];
//                    ((SnapchatAttachment *)attachment).md5 = [data jsonString:CMMD5];
//                    ((SnapchatAttachment *)attachment).url = [data jsonString:CMURL];
//                    ((SnapchatAttachment *)attachment).isFired = [data jsonBool:CMFIRE];
//                }
//                    break;
                case CustomMessageTypeChartlet:
                {
                    attachment = [[ChartletAttachment alloc] init];
                    ((ChartletAttachment *)attachment).chartletCatalog = [data jsonString:CMCatalog];
                    ((ChartletAttachment *)attachment).chartletId      = [data jsonString:CMChartlet];
                }
                    break;
                case CustomMessageTypeWhiteboard:
                {
                    attachment = [[WhiteboardAttachment alloc] init];
                    ((WhiteboardAttachment *)attachment).flag = [data jsonInteger:CMFlag];
                }
                    break;
                default:
                    break;
            }
            attachment = [self checkAttachment:attachment] ? attachment : nil;
        }
    }
    return attachment;
}


- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment{
    BOOL check = NO;
//    if ([attachment isKindOfClass:[JanKenPonAttachment class]]) {
//        NSInteger value = [((JanKenPonAttachment *)attachment) value];
//        check = (value>=CustomJanKenPonValueKen && value<=CustomJanKenPonValuePon) ? YES : NO;
//    }
//    else if ([attachment isKindOfClass:[SnapchatAttachment class]]) {
//        check = YES;
//    }
//    else
    if ([attachment isKindOfClass:[ChartletAttachment class]]) {
        NSString *chartletCatalog = ((ChartletAttachment *)attachment).chartletCatalog;
        NSString *chartletId      =((ChartletAttachment *)attachment).chartletId;
        check = chartletCatalog.length&&chartletId.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[WhiteboardAttachment class]]) {
        NSInteger flag = [((WhiteboardAttachment *)attachment) flag];
        check = ((flag >= CustomWhiteboardFlagInvite) && (flag <= CustomWhiteboardFlagClose)) ? YES : NO;
    }
    return check;
}
@end
