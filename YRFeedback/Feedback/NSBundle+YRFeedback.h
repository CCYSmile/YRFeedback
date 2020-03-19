//
//  NSBundle+YRFeedback.h
//  YRUI
//
//  Created by 崔昌云 on 2020/3/13.
//  Copyright © 2020 CCY. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (YRFeedback)
+ (instancetype)yr_feedbackBundle;
+ (UIImage *)yr_feedbackimageWithName:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
