//
//  UIWindow+YRFeedbackShake.m
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import "UIWindow+YRFeedbackShake.h"

#import <UIKit/UIKit.h>
#import "YRFeedbackManager.h"

@implementation UIWindow (YRFeedbackShake)
- (BOOL)canBecomeFirstResponder {//默认是NO，所以得重写此方法，设成YES
     return YES;
}

//然后实现下列方法://很像TouchEvent事件
 
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}
 
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [[YRFeedbackManager sharedManager] showFeedbackView];
}
 
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}
@end
