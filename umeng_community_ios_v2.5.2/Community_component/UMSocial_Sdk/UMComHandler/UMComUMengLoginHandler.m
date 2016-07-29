//
//  UMengLoginHandler.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComUMengLoginHandler.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMComNavigationController.h"
#import "RWRegisterViewController.h"
@interface UMComUMengLoginHandler()<UMSocialUIDelegate>


@end

@implementation UMComUMengLoginHandler

static UMComUMengLoginHandler *_instance = nil;
+ (UMComUMengLoginHandler *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)setAppKey:(NSString *)appKey
{
    [UMSocialData setAppKey:appKey];
    
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(void (^)(id, NSError *))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{

    RWRegisterViewController *registerView = [[RWRegisterViewController alloc]init];
    [viewController presentViewController:registerView animated:YES completion:^{
        }];
        
     });
}

@end
