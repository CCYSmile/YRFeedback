//
//  YRFeedback.h
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YRFeedbackManager : NSObject
/**
 *  初始化SDK
 *
 *  @return YRFeedback的单例对象
 */
+ (YRFeedbackManager *)sharedManager;
/**
 *  启动TapdSDK
 *  @param workspace_id 项目ID可以通过点击进入具体项目域名“tapd.cn”后的一串数字（即为项目ID）查看。
 */
- (void)startTapdManagerWithWorkspackID:(NSString *)workspace_id;
/**
 *  启动TrackUp反馈 http://www.tracup.com/doc/api#createIssue
 *  @param uKey 用户Key，从TrackUp网站上获取。
 *  @param _api_key 用来识别API调用者的身份，从TrackUp网站上获取。
 *  @param pKey 项目的 pKey
 */
- (void)startTracupManagerWithuKey:(NSString *)uKey
                            ApiKey:(NSString *)_api_key
                              pKey:(NSString *)pKey;

/**
 *  显示用户反馈界面
 */
- (void)showFeedbackView;
@end

NS_ASSUME_NONNULL_END
