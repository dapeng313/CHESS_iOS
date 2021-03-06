//
//  ChartletAttachment.h
//  NIM
//
//  Created by chris on 15/7/10.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "ChartletAttachment.h"
#import "UIImage+HRMS.h"
#import "HRMS-Swift.h"

@implementation ChartletAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeChartlet),
                           CMData : @{ CMCatalog : self.chartletCatalog? self.chartletCatalog : @"",
                                       CMChartlet : self.chartletId?self.chartletId : @""
                                    }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (NSString *)cellContent:(NIMMessage *)message{
    return @"SessionChartletContentView";
}

- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width{
    if (!self.showCoverImage) {
        UIImage *image = [UIImage fetchChartlet:self.chartletId chartletId:self.chartletCatalog];
        self.showCoverImage = image;
    }
    return self.showCoverImage.size;
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    CGFloat bubblePaddingForImage    = 3.f;
    CGFloat bubbleArrowWidthForImage = 5.f;
    if (message.isOutgoingMsg) {
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage);
    }else{
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage, bubblePaddingForImage,bubblePaddingForImage);
    }
}

@end
