//
//  GalleryViewController.m
//  NIMDemo
//
//  Created by ght on 15-2-3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "GalleryViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+HRMS.h"
#import "HRMS-Swift.h"
#import "UIView+Toast.h"

@implementation GalleryItem
@end


@interface GalleryViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *galleryImageView;
@property (nonatomic,strong)    GalleryItem *currentItem;
@end

@implementation GalleryViewController

- (instancetype)initWithItem:(GalleryItem *)item
{
    if (self = [super initWithNibName:@"GalleryViewController"
                               bundle:nil])
    {
        _currentItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _galleryImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *url = [NSURL URLWithString:_currentItem.imageURL];
    [_galleryImageView sd_setImageWithURL:url
                         placeholderImage:[UIImage imageWithContentsOfFile:_currentItem.thumbPath]
                                  options:SDWebImageRetryFailed];
    
    if ([_currentItem.name length])
    {
        self.navigationItem.title = _currentItem.name;
    }    
}


@end




@interface SingleSnapView : UIImageView

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,copy)   NIMCustomObject *messageObject;

- (instancetype)initWithFrame:(CGRect)frame messageObject:(NIMCustomObject *)object;

- (void)setProgress:(CGFloat)progress;

@end


@implementation  GalleryViewController(SingleView)

@end


@implementation SingleSnapView

- (instancetype)initWithFrame:(CGRect)frame messageObject:(NIMCustomObject *)object{
    self = [super initWithFrame:frame];
    if (self) {
        _messageObject = object;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        CGFloat width = 200.f * [UIScreen mainScreen].bounds.size.width / 320;
        _progressView.width = width;
        _progressView.hidden = YES;
        [self addSubview:_progressView];
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    [self.progressView setProgress:progress];
    [self.progressView setHidden:progress>0.99];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.progressView.centerY = self.height *.5;
    self.progressView.centerX = self.width  *.5;
}


@end
