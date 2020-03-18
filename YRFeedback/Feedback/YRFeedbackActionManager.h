//
//  YRFeedbackActionManager.h
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN
// http://www.tracup.com/doc/api#createIssue
@interface YRFeedbackTracpUp : NSObject
// 用户Key，从TrackUp网站上获取。
@property (strong,nonatomic) NSString *uKey;
// 用来识别API调用者的身份，从TrackUp网站上获取。
@property (strong,nonatomic) NSString *_api_key;
// 项目的 pKey
@property (strong,nonatomic) NSString *pKey;
@end

//https://www.tapd.cn/help/view#1120003271001002376
@interface YRFeedbackTapd : NSObject
// Api账号：
@property (strong,nonatomic) NSString *api_user;
// Api口令：
@property (strong,nonatomic) NSString *api_password;
// 项目ID
@property (strong,nonatomic) NSString *workspace_id;
@end

@interface YRFeedbackModel : NSObject;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) UIImage *screenshot;
@end

@interface YRFeedbackActionManager : NSObject
@property (weak,nonatomic) QMUIModalPresentationViewController*modalViewController;
@property (strong,nonatomic) YRFeedbackTracpUp *tracUp;
@property (strong,nonatomic) YRFeedbackTapd *tapd;

+ (YRFeedbackActionManager *)sharedManager;

- (void)dismissFeedbackView;

- (void)sendFeedBack:(YRFeedbackModel *)info;
@end

NS_ASSUME_NONNULL_END
