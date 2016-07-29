//
//  UMCommunity.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/11.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMCommunity.h"
#import "UMComNavigationController.h"
#import "UMComSession.h"
#import "UMComHttpClient.h"
#import "UMComLoginManager.h"
#import "UMComMessageManager.h"
#import "UMComShareManager.h"
#import "UMUtils.h"
#import "UMComPushRequest.h"

@implementation UMCommunity


+ (void)setAppKey:(NSString *)appkey withAppSecret:(NSString *)appSecret
{
    //setData
    [[UMComSession sharedInstance] setAppkey:appkey withAppSecret:appSecret];
    [UMComLoginManager setAppKey:appkey];
    [UMComShareManager setAppKey:appkey];
    [UMComMessageManager setAppkey:appkey];
    
}
//
//+ (void)presentUMCommunity:(UIViewController *)viewController
//{
//    Class UMComHomeFeedViewController = NSClassFromString(@"UMComHomeFeedViewController");
//    UIViewController *feedsViewController = [[UMComHomeFeedViewController alloc] init];
//    UMComNavigationController *navigationControlller = [[UMComNavigationController alloc] initWithRootViewController:feedsViewController];
//    [viewController presentViewController:navigationControlller animated:YES completion:nil];
//}

+ (UINavigationController *)getFeedsModalViewController{
//    Class UMComHomeFeedViewController = NSClassFromString(@"UMComHomeFeedViewController");
//    UIViewController *feedsViewController = [[UMComHomeFeedViewController alloc] init];
    UIViewController *feedsViewController = [self currentViewController];
    UMComNavigationController *navigationControlller = [[UMComNavigationController alloc] initWithRootViewController:feedsViewController];
    return navigationControlller;
}


+ (UIViewController *)getFeedsViewController
{
//    Class UMComHomeFeedViewController = NSClassFromString(@"UMComHomeFeedViewController");
//    UIViewController *feedsViewController = [[UMComHomeFeedViewController alloc] init];
    UIViewController *feedsViewController = [self currentViewController];
    return feedsViewController;
}

//+ (UINavigationController *)getForumModalViewController{
//    Class UMComForumHomeViewController = NSClassFromString(@"UMComForumHomeViewController");
//    UIViewController *forumHomeViewController = [[UMComForumHomeViewController alloc] init];
//    UMComNavigationController *navigationControlller = [[UMComNavigationController alloc] initWithRootViewController:forumHomeViewController];
//    return navigationControlller;
//}

//+ (UIViewController *)getForumViewController
//{
//    Class UMComForumHomeViewController = NSClassFromString(@"UMComForumHomeViewController");
//    UIViewController *forumViewController = [[UMComForumHomeViewController alloc] init];
//    return forumViewController;
//}

+ (UIViewController *)currentViewController
{
    Class UMComCurrentViewController = nil;
    if (NSClassFromString(@"UMComHomeFeedViewController")) {
        UMComCurrentViewController = NSClassFromString(@"UMComHomeFeedViewController");
    }else if (NSClassFromString(@"UMComForumHomeViewController")){
        UMComCurrentViewController = NSClassFromString(@"UMComForumHomeViewController");
    }else{
        UMComCurrentViewController = NSClassFromString(@"UMComViewController");
    }
    UIViewController *currentViewController = [[UMComCurrentViewController alloc] init];
    return currentViewController;
}

+ (void)setShowTopicName:(BOOL)showTopic
{
    [UMComSession sharedInstance].isShowTopicName = showTopic;
}
@end
