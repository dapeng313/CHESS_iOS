//
//  SessionChartletContentView.m
//  NIM
//
//  Created by chris on 15/7/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionChartletContentView.h"
#import "UIView+HRMS.h"
#import "NIMSDK.h"
#import "ChartletAttachment.h"
#import "HRMS-Swift.h"

@interface SessionChartletContentView()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation SessionChartletContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bubbleImageView.hidden = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    id attachment = customObject.attachment;
    if ([attachment isKindOfClass:[ChartletAttachment class]]) {
        self.imageView.image = [attachment showCoverImage];
        [self.imageView sizeToFit];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentSize = self.model.contentSize;
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.imageView.frame  = imageViewFrame;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
}



@end
