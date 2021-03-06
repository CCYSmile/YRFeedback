//
//  PaintView.h
//  TestForFeedback
//
//  Created by Shane on 2019/9/4.
//  Copyright © 2019 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YRFeedBackPaintStateBegin,
    YRFeedBackPaintStateMove,
    YRFeedBackPaintStateCancel,
    YRFeedBackPaintStateEnd
} YRFeedBackPaintState;

@interface PaintView : UIView
@property (nonatomic,copy) void(^PaintViewPaintingBlock)(YRFeedBackPaintState state);
@property (nonatomic, strong) UIImage *screenshotImage;
- (void)changeColor:(UIColor *)color;
- (void)revoke;
- (void)revokeAll;
@end

@interface UIView (ConvertToImage)

//使用该方法不会模糊，根据屏幕密度计算
- (UIImage *)convertViewToImage;

@end


NS_ASSUME_NONNULL_END
