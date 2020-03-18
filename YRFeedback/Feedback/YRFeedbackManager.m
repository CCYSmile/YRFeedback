//
//  YRFeedback.m
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import "YRFeedbackManager.h"
#import "YRFeedbackViewController.h"
#import "ScreenshotUtil.h"
#import <QMUIKit.h>
#import <NerdyUI.h>
#import "YRFeedbackActionManager.h"
@interface YRFeedbackManager()

@end

@implementation YRFeedbackManager
#pragma mark
+ (YRFeedbackManager *)sharedManager{
    static YRFeedbackManager *_feedback = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         _feedback = [[super allocWithZone:NULL] init];
         
     });
     return _feedback;
    
}
// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YRFeedbackManager sharedManager];
}
- (void)startTapdManagerWithWorkspackID:(NSString *)workspace_id{
    YRFeedbackActionManager *manager = [YRFeedbackActionManager sharedManager];
    manager.tapd.workspace_id = workspace_id;
}
- (void)startTracupManagerWithuKey:(NSString *)uKey ApiKey:(NSString *)_api_key pKey:(NSString *)pKey{
    YRFeedbackActionManager *manager = [YRFeedbackActionManager sharedManager];
    manager.tracUp.uKey = uKey;
    manager.tracUp._api_key = _api_key;
    manager.tracUp.pKey = pKey;
}
- (void)showFeedbackView{
    if ([YRFeedbackActionManager sharedManager].modalViewController) {
        return;
    }
    
    UIImage *screenshotImage = [ScreenshotUtil getScreenshotWithView:[UIApplication sharedApplication].keyWindow];
    
    YRFeedbackViewController *contentViewController = [[YRFeedbackViewController alloc] initWithScreenshotImage:screenshotImage];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentViewController = contentViewController;
    [modalViewController setLayoutBlock:^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentViewController.view.qmui_frameApplyTransform = CGRectMake(0, 0, Screen.width, Screen.height);
    }];
    [modalViewController showWithAnimated:YES completion:nil];
    [YRFeedbackActionManager sharedManager].modalViewController = modalViewController;
}
@end
