//
//  NSBundle+YRFeedback.m
//  YRUI
//
//  Created by 崔昌云 on 2020/3/13.
//  Copyright © 2020 CCY. All rights reserved.
//

#import "NSBundle+YRFeedback.h"

#import <UIKit/UIKit.h>


@implementation NSBundle (YRFeedback)
+ (instancetype)yr_feedbackBundle{
    static NSBundle *refreshBundle = nil;
       if (refreshBundle == nil) {
           // 这里不使用mainBundle是为了适配pod 1.x和0.x
           refreshBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YRFeedback" ofType:@"bundle"]];
       }
       return refreshBundle;
}
+ (UIImage *)yr_feedbackimageWithName:(NSString *)imageName{
    UIImage *arrowImage = nil;
    arrowImage = [UIImage imageWithContentsOfFile:[[self yr_feedbackBundle] pathForResource:imageName ofType:@"png"]];
    return arrowImage;
}
@end
