//
//  RWRequsetManager+ExamineVersion.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/8/2.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager+ExamineVersion.h"

@implementation RWRequsetManager (ExamineVersion)

+ (void)examineVersionWithController:(__kindof UIViewController *)viewController
{
    NSArray *childView = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    
    for (id view in childView)
    {
        if ([view isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            if ([[view valueForKeyPath:@"dataNetworkType"] intValue] != 5)
            {
                return;
            }
            else
            {
                break;
            }
        }
    }
    
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [requestManager POST:APP_STORE_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultCount"] integerValue] > 0)
        {
            float AppStoreVersion = [Json[@"results"][0][@"version"] floatValue];
            
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
            float localVersion = [version floatValue];
            
            if (localVersion < AppStoreVersion)
            {
                [viewController presentViewController:[RWRequsetManager updateVersion]
                                             animated:YES
                                           completion:nil];
            }
        }
    } failure:nil];
}

+ (UIAlertController *)updateVersion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提醒" message:@"检测到有新的版本更新" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *update = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TO_APP_STORE]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后更新"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:update];
    [alert addAction:cancel];
    
    return alert;
}

@end
