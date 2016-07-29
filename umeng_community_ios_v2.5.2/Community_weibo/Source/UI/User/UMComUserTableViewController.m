//
//  UMComUserTableViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 3/22/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComUserTableViewController.h"
#import "UMComUser.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComClickActionDelegate.h"
#import "UMComPushRequest.h"
#import "UMComLoginManager.h"
#import "UMComShowToast.h"
#import "UMComBarButtonItem.h"
#import "UIViewController+UMComAddition.h"
#import "UMComUserOperationFinishDelegate.h"

#import "UMComUserTableViewCell.h"

#define UMComUserCellHeightWithDistance 61
#define UMComUserCellHeight 49

static NSString *UMComUserTableViewCellIdentifier = @"UMComUserTableViewCellIdentifier";

@interface UMComUserTableViewController ()
<UMComClickActionDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation UMComUserTableViewController

- (id)initWithCompletion:(void (^)(UIViewController *viewController))completion
{
    self = [super init];
    if (self) {
        self.completion = completion;
        UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:UMComLocalizedString(@"FinishStep",@"完成") target:self action:@selector(onClickNext)];
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
    return self;
}

- (void)onClickNext
{
    if (self.completion) {
        self.completion(self);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = _showDistance ? 67 : 54;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.userList) {
        self.dataArray = self.userList;
        [self.tableView reloadData];
    }
    
    if (self.title) {
        [self setForumUITitle:self.title];
    }else{
        [self setForumUITitle:UMComLocalizedString(@"userList", @"用户列表")];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComUserTableViewCell" bundle:nil] forCellReuseIdentifier:UMComUserTableViewCellIdentifier];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showDistance) {
        return UMComUserCellHeightWithDistance;
    }
    else {
        return UMComUserCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMComUserTableViewCellIdentifier];
    cell.delegate = self;
    if (indexPath.row < self.dataArray.count) {
        UMComUser *user = self.dataArray[indexPath.row];
        cell.showDistance = _showDistance;
        [cell reloadCellWithUser:user];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComUser *user = self.dataArray[indexPath.row];
    if (_callbackBlock) {
        _callbackBlock(self, UMComUserTableViewCallBackEventUser, user);
    }
}

- (void)customObj:(id)obj clickOnFollowUser:(UMComUser *)user
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            BOOL isFollow = !([user.relation integerValue] == 1 || [user.relation integerValue] == 3);
            [UMComPushRequest followerWithUser:user isFollow:isFollow completion:^(NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                }
                [weakSelf.tableView reloadData];
                if (weakSelf.userOperationFinishDelegate && [self.userOperationFinishDelegate respondsToSelector:@selector(focusedUserOperationFinish:)]) {
                    [weakSelf.userOperationFinishDelegate focusedUserOperationFinish:user];
                }
            }];
        }
    }];
}

- (void)insertUserToTableView:(UMComUser *)user
{
    if (!user) {
        return;
    }
    if ([user isKindOfClass:[UMComUser class]]) {
        NSMutableArray *userList = nil;
        if (self.dataArray.count > 0) {
            userList = [NSMutableArray arrayWithArray:self.dataArray];
            if (![userList containsObject:user]) {
                [userList insertObject:user atIndex:0];
            }
        }else{
            userList = [NSMutableArray arrayWithObject:user];
        }
        self.dataArray = userList;
        [self insertCellAtRow:0 section:0];
    }
}

- (void)deleteUserFromTableView:(UMComUser *)deleteUser
{
    if (!deleteUser) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([deleteUser isKindOfClass:[UMComUser class]]) {
        NSMutableArray *userList = [NSMutableArray arrayWithArray:self.dataArray];
        [userList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UMComUser *user = (UMComUser *)obj;
            if ([user.uid isEqualToString:deleteUser.uid]) {
                *stop = YES;
                [userList removeObject:user];
                weakSelf.dataArray = userList;
                [weakSelf deleteCellAtRow:idx section:0];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
