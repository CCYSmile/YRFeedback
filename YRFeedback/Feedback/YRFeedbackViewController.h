//
//  YRFeedbackViewController.h
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YRFeedbackViewController : UIViewController<QMUIModalPresentationContentViewControllerProtocol>
- (instancetype)initWithScreenshotImage:(UIImage *)screenshotImage;
@end

NS_ASSUME_NONNULL_END
