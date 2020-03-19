//
//  UIWindow+YRFeedbackShake.h
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

#define UIEventSubtypeMotionShakeNotification @"UIEventSubtypeMotionShakeNotification"
NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (YRFeedbackShake)
// @override
- (BOOL)canBecomeFirstResponder;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
