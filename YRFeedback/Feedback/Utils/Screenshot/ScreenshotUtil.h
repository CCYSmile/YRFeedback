//
//  ScreenshotUtil.h
//  TestForFeedback
//
//  Created by Shane on 2019/9/4.
//  Copyright © 2019 Shane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenshotUtil : NSObject

+ (UIImage *)getScreenshotWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
