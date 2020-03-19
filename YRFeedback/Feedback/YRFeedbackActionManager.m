//
//  YRFeedbackActionManager.m
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import "YRFeedbackActionManager.h"
#import "Qiniu/QiniuSDK.h"
#import "QMUIKit.h"
#import "AFNetworking.h"
#import <sys/utsname.h>//要导入头文件
@implementation YRFeedbackTapd
@end
@implementation YRFeedbackTracpUp
@end

@interface YRFeedbackModel()
@property (nonatomic,strong) NSString *imgUrl;
@end
@implementation YRFeedbackModel
@end

@interface YRFeedbackNetWork : NSObject

@end

@implementation YRFeedbackNetWork

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(nullable void (^)(id _Nullable responseObject))success
    failure:(nullable void (^)(NSError *error))failure{
      NSURL *url = [NSURL URLWithString:URLString];
      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
      request.HTTPMethod = @"GET";
      NSURLSession *session = [NSURLSession sharedSession];
      NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (error == nil) {
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
              success(dict);
          }else {
              failure(error);
          }
      }];
      [dataTask resume];
}
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
      header:(nullable void (^)(AFHTTPSessionManager *))headerBlock
     success:(nullable void (^)(id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *error))failure{
    
    
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
           
           manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    !headerBlock?:headerBlock(manager);
          [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               if (success) {
                   if (responseObject) {
                       success(responseObject);
                   }
                   else {
                       success(nil);
                   }
               }
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               if (failure) {
               
               }
                   failure(error);
           }];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(nullable void (^)(id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *error))failure{
    [self POST:URLString parameters:parameters header:nil success:success failure:failure];
}

@end

@interface YRFeedbackRequestManager : NSObject
// tapd反馈地址
@property (strong,nonatomic) NSString *tapdHomeUrl_bugs;
// tracup反馈地址
@property (strong,nonatomic) NSString *tracupHomeUrl_createIssue;
// 图片上传地址
@property (strong,nonatomic) NSString *uploadImageHomeUrl;
@end

@implementation YRFeedbackRequestManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tracupHomeUrl_createIssue = @"http://www.tracup.com/apiv1/issue/create";
        _uploadImageHomeUrl = @"http://b2c.121.soft1024.com/api";
        _tapdHomeUrl_bugs = @"https://api.tapd.cn/bugs";
    }
    return self;
}

- (void)sendTapdRequest{
    
}

- (void)uploadImage:(UIImage *)image token:(NSString *)token success:(void(^)(NSString *key))successCallback{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putData:UIImagePNGRepresentation(image) key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        NSLog(@"info ===== %@", info);
//        NSLog(@"resp ===== %@", resp);
        successCallback(resp[@"key"]);
    }
                option:uploadOption];
}

- (void)requestUploadImage:(UIImage *)image success:(void(^)(NSString *imgUrl))successCallback{
    NSMutableDictionary *dic = @{}.mutableCopy;
       dic[@"api_name"] = @"V1.system.system.qiniuConfig";
       [[YRFeedbackNetWork new] POST:self.uploadImageHomeUrl parameters:dic success:^(id  _Nullable responseObject) {
           NSNumber *code = responseObject[@"code"];
           NSDictionary *data = responseObject[@"data"];
           if (code.intValue == 0) {
               [self uploadImage:image token:data[@"token"] success:^(NSString *key) {
                   NSString *result = [NSString stringWithFormat:@"%@%@",data[@"domain"],key];
                   !successCallback?:successCallback(result);
               }];
           }
       } failure:^(NSError *error) {
           
       }];
}

- (void)requestTapd:(YRFeedbackModel *)info{
    NSMutableDictionary *dic = @{}.mutableCopy;
    YRFeedbackTapd *tapd = [YRFeedbackActionManager sharedManager].tapd;
    dic[@"workspace_id"] = tapd.workspace_id;
    dic[@"title"] = @"Tapd-iOS-客户反馈";
    dic[@"reporter"] = @"客户";
    
    NSMutableString *desc = [NSString stringWithFormat:@"客户描述：%@",info.content].mutableCopy;
    if (info.imgUrl) {
        [desc appendString:[NSString stringWithFormat:@"\n描述图片：%@",info.imgUrl]];
    }
    dic[@"platform"] = [self uploadSystemInfo];
    dic[@"description"] = desc;
    NSString *token = [NSString stringWithFormat:@"%@:%@",tapd.api_user,tapd.api_password];
    NSString *stringBase64 = [[token dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]; // base64格式的字符串
    [[YRFeedbackNetWork new] POST:self.tapdHomeUrl_bugs parameters:dic header:^(AFHTTPSessionManager *manager) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",stringBase64] forHTTPHeaderField:@"Authorization"];
    } success:^(id  _Nullable responseObject) {
        NSLog(@"YRFeedbackNetWork %@",responseObject);
        } failure:^(NSError *error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"error--%@",serializedData);
        }];
}


- (void)requestTracup:(YRFeedbackModel *)info{
    NSMutableDictionary *dic = @{}.mutableCopy;
    YRFeedbackTracpUp *tracup = [YRFeedbackActionManager sharedManager].tracUp;
    dic[@"uKey"] = tracup.uKey;
    dic[@"_api_key"] = tracup._api_key;
    dic[@"pKey"] = tracup.pKey;
    dic[@"issueTitle"] = @"Tracup-iOS-客户反馈";
    dic[@"issueType"] = @"Bug";
    
    NSMutableString *desc = [NSString stringWithFormat:@"客户描述：%@",info.content].mutableCopy;
    if (info.imgUrl) {
        [desc appendString:[NSString stringWithFormat:@"\n描述图片：%@",info.imgUrl]];
    }
    [desc appendString:[self uploadSystemInfo]];
    dic[@"issueDescription"] = desc;
    [[YRFeedbackNetWork new] POST:self.tracupHomeUrl_createIssue parameters:dic success:^(id  _Nullable responseObject) {
     } failure:^(NSError *error) {
     }];
}
- (NSString *)uploadSystemInfo{
    NSString *info = @"";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       CFShow(CFBridgingRetain(infoDictionary));
    // Version版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    //系统名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //手机型号
    NSString* phoneModel = [self getCurrentDeviceModel];
    //地方型号（国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    info = [NSString stringWithFormat:@"\nVersion版本: %@\nbuild版本: %@\n系统名称: %@\n手机系统版本: %@\n手机型号: %@\n国际化区域名称: %@",app_Version,app_build,deviceName,phoneVersion,phoneModel,localPhoneModel];
    return info;
}

- (NSString *)getCurrentDeviceModel{
   struct utsname systemInfo;
   uname(&systemInfo);
   
   NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
   
   
if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
// 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";

if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";

if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}
@end

@interface YRFeedbackActionManager()
@property (strong,nonatomic) YRFeedbackRequestManager *request;
@end


@implementation YRFeedbackActionManager
+ (YRFeedbackActionManager *)sharedManager{
    static YRFeedbackActionManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
    });
    return _instance;
}

- (void)dismissFeedbackView{
    QMUIModalPresentationViewController *modalViewController = self.modalViewController;
    [modalViewController hideWithAnimated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)sendFeedBack:(YRFeedbackModel *)info{
    
    id tracup = _tracUp;
    id tapd = _tapd;
   
    void(^requestBlock)(void) = ^(void) {
     if (tracup) {
         [self.request requestTracup:info];
     }
     if (tapd) {
         [self.request requestTapd:info];
     }
    };
    
    if (info.screenshot) {
        [self.request requestUploadImage:info.screenshot success:^(NSString *imgUrl) {
            info.imgUrl = imgUrl;
            requestBlock();
        }];
    }else{
        requestBlock();
    }

    
}
- (YRFeedbackTapd *)tapd{
    if (!_tapd) {
        _tapd = [YRFeedbackTapd new];
        _tapd.api_user = @"nRaq$M=_";
        _tapd.api_password = @"128A189F-BB4B-D2C9-6879-B2E6E3E76BE7";
    }
    return _tapd;
}

- (YRFeedbackTracpUp *)tracUp{
    if (!_tracUp) {
        _tracUp = [YRFeedbackTracpUp new];
    }
    return _tracUp;
}
- (YRFeedbackRequestManager *)request{
    if (!_request) {
        _request = [YRFeedbackRequestManager new];
    }
    return _request;
}
@end
