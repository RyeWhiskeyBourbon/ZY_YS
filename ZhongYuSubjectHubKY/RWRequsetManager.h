//
//  RWRequsetManager.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "RWClassListModel.h"
#import "RWInformationModel.h"
#import "RWRequestIndex.h"

@protocol RWRequsetDelegate <NSObject>

@required

/**
 *  一般网络连接失败会回调此方法
 *
 *  @param error 错误信息
 *  @param task  会话信息
 */
- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task;

@optional
/**
 *  注册返回信息
 *
 *  @param isSuccessed 是否注册成功
 *  @param reason      失败原因
 */
- (void)registerResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason;
/**
 *  登录返回信息
 *
 *  @param isSuccessed 是否注册成功
 *  @param reason      失败原因
 */
- (void)userLoginResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason;
/**
 *  重置密码返回信息
 *
 *  @param isSuccessed 是否重置成功
 *  @param reason      失败原因
 */
- (void)replacePasswordResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason;

- (void)subjectHubDownLoadDidFinish:(NSArray *)subjectHubs;

- (void)subjectBaseDeployDidFinish:(NSArray *)subjectHubs;

- (void)classListDownloadDidFinish:(NSMutableArray *)classListSource;

- (void)recommendListSourceDownloadFinish:(NSArray *)recommendListSource;

@end

@interface RWRequsetManager : NSObject

+ (instancetype)sharedRequestManager;

@property (nonatomic,assign)id <RWRequsetDelegate> delegate;

@property (nonatomic,strong)AFHTTPSessionManager *manager;

@property (nonatomic,assign,readonly)AFNetworkReachabilityStatus reachabilityStatus;

@property (nonatomic,strong,readonly)NSDictionary *errorDescription;

- (void)obtainServersInformation;

- (void)obtainTasteSubject;

- (void)obtainBaseWith:(NSString *)url AndHub:(NSString *)hub DownLoadFinish:(void(^)(BOOL declassify))finish;

- (void)obtainClassList;

- (void)obtainRecommendListSource;

- (void)postUserName:(NSString *)userName Complete:(void(^)(BOOL isSucceed,NSString *reason,NSError *error))complete;

- (void)receivePushMessageOfHTML:(void(^)(NSString *html,NSError *error))complete;

+ (void)warningToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title Click:(void(^)(void))click;

+ (void)obtainExperienceTimes;

@end
