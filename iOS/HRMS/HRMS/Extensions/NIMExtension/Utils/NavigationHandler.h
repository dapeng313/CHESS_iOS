//
//  NavigationHandler.h
//  NIM
//
//  Created by chris on 16/1/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@interface NavigationHandler : NSObject<UINavigationControllerDelegate>

@property (nonatomic,strong,readonly) UIPanGestureRecognizer *recognizer;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
