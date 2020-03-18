//
//  UIView+ConvertToImage.h
//  TestForFeedback
//
//  Created by Shane on 2019/9/4.
//  Copyright © 2019 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ConvertToImage)

//使用该方法不会模糊，根据屏幕密度计算
- (UIImage *)convertViewToImage;

@end

NS_ASSUME_NONNULL_END
