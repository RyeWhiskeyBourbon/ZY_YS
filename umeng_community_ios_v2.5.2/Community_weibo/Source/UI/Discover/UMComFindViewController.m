//
//  UMComFindViewController.m
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComFindViewController.h"
#import "UMComUserCenterViewController.h"
#import "UMComSession.h"
#import "UMComNearbyFeedViewController.h"
#import "UMComTopicsTableViewController.h"
#import "UMComNoticeSystemViewController.h"
#import "UMComPullRequest.h"
#import "UMComFavouratesViewController.h"
#import "UMComPhotoAlbumViewController.h"
#import "UMComUserNearbyViewController.h"


@interface UMComFindViewController ()

@end

@implementation UMComFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



- (void)tranToCircleFriends
{
    UMComFeedTableViewController *friendViewController = [[UMComFeedTableViewController alloc]init];
    friendViewController.isAutoStartLoadData = YES;
    friendViewController.fetchRequest = [[UMComFriendFeedsRequest alloc]initWithCount:BatchSize];
    friendViewController.title = UMComLocalizedString(@"um_com_friend", @"好友圈");
    [self.navigationController pushViewController:friendViewController animated:YES];
}

- (void)tranToFollowedTopic
{
    UMComTopicsTableViewController *topicsViewController = [[UMComTopicsTableViewController alloc] init];
    topicsViewController.title = UMComLocalizedString(@"follow_topics", @"关注话题");
    topicsViewController.isAutoStartLoadData = YES;
    topicsViewController.fetchRequest = [[UMComUserTopicsRequest alloc]initWithUid:[UMComSession sharedInstance].loginUser.uid count:BatchSize];
    [self.navigationController pushViewController:topicsViewController animated:YES];
}

- (void)tranToAlbum
{
    UMComPhotoAlbumViewController *photoAlbumVc = [[UMComPhotoAlbumViewController alloc]init];
    photoAlbumVc.user = [UMComSession sharedInstance].loginUser;
    [self.navigationController pushViewController:photoAlbumVc animated:YES];
}

- (void)tranToNearby
{
    UMComNearbyFeedViewController *nearbyFeedController = [[UMComNearbyFeedViewController alloc]init];
    nearbyFeedController.isLoadLoacalData = NO;
    nearbyFeedController.title = UMComLocalizedString(@"um_com_nearbyRecommend", @"附近内容");
    [self.navigationController pushViewController:nearbyFeedController animated:YES];
}

- (void)tranToNearbyUsers
{
    UMComUserNearbyViewController *userViewController = [[UMComUserNearbyViewController alloc] init];
    userViewController.isAutoStartLoadData = YES;
    userViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
        vc.userOperationFinishDelegate = controller.userOperationFinishDelegate;
        [controller.navigationController pushViewController:vc animated:YES];
    };
    userViewController.title = UMComLocalizedString(@"user_recommend", @"附近用户");
    [self.navigationController  pushViewController:userViewController animated:YES];
}

- (void)tranToRealTimeFeeds
{
    UMComFeedTableViewController *realTimeFeedsViewController = [[UMComFeedTableViewController alloc] init];
    realTimeFeedsViewController.isLoadLoacalData = NO;
    realTimeFeedsViewController.isAutoStartLoadData = YES;
    realTimeFeedsViewController.fetchRequest = [[UMComAllNewFeedsRequest alloc]initWithCount:BatchSize];
    realTimeFeedsViewController.title = UMComLocalizedString(@"um_com_newcontent", @"实时内容");
    [self.navigationController  pushViewController:realTimeFeedsViewController animated:YES];
}

- (void)tranToRecommendUsers
{
    UMComUserTableViewController *userViewController = [[UMComUserTableViewController alloc] init];
    userViewController.fetchRequest = [[UMComRecommendUsersRequest alloc]initWithCount:BatchSize];
    userViewController.isAutoStartLoadData = YES;
    userViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
        vc.userOperationFinishDelegate = controller.userOperationFinishDelegate;
        [controller.navigationController pushViewController:vc animated:YES];
    };
    userViewController.title = UMComLocalizedString(@"user_recommend", @"用户推荐");
    [self.navigationController  pushViewController:userViewController animated:YES];
}

- (void)tranToRecommendTopics
{
    UMComTopicsTableViewController *topicsRecommendViewController = [[UMComTopicsTableViewController alloc] initWithFetchRequest:[[UMComRecommendTopicsRequest alloc]initWithCount:BatchSize]];
    topicsRecommendViewController.isAutoStartLoadData = YES;
    topicsRecommendViewController.title = UMComLocalizedString(@"um_com_user_topic_recommend", @"推荐话题");
    [self.navigationController  pushViewController:topicsRecommendViewController animated:YES];
}

- (void)tranToUsersFavourites
{
    UMComFavouratesViewController *favouratesViewController = [[UMComFavouratesViewController alloc] initWithFetchRequest:[[UMComUserFavouritesRequest alloc] init]];
    favouratesViewController.isAutoStartLoadData = YES;
    favouratesViewController.title = UMComLocalizedString(@"um_com_user_collection", @"我的收藏");
    [self.navigationController  pushViewController:favouratesViewController animated:YES];
}

- (void)tranToUsersNotice
{
    UMComNoticeSystemViewController *userNewaNoticeViewController = [[UMComNoticeSystemViewController alloc] init];
    [self.navigationController  pushViewController:userNewaNoticeViewController animated:YES];
}

- (void)tranToUserCenter
{
    UMComUserCenterViewController *userCenterViewController = [[UMComUserCenterViewController alloc] initWithUser:[UMComSession sharedInstance].loginUser];
    [self.navigationController pushViewController:userCenterViewController animated:YES];
}
@end
