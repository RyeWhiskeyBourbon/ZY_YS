//
//  RWMoreViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMoreViewController.h"
#import "RWErrorSubjectsController.h"
#import "RWAlarmClockController.h"
#import "RWDataBaseManager.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWRegisterViewController.h"
#import "RWLoginTableViewCell.h"
#import "RWWebViewController.h"
#import "RWFeedbackViewController.h"
#import "RWRecommendController.h"
#import "UMComSession.h"
#import "UMComUser.h"

@interface RWMoreViewController ()

<

    UITableViewDelegate,
    UITableViewDataSource,
    RWCollectSubjectDelegate,
    RWButtonCellDelegate,
    RWRequsetDelegate

>

@property (nonatomic,strong) UITableView *viewList;

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,strong) UILabel *username;

@end

static NSString *const viewListCell = @"viewListCell";

static NSString *const viewListTitle = @"title";

static NSString *const viewListImage = @"icon";

static NSString *const viewListButton = @"viewListButton";

@implementation RWMoreViewController

@synthesize viewList;
@synthesize dataSource;
@synthesize username;

- (void)initUsernameLabel
{
    username = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, self.view.frame.size.width - 100, 50)];
    
    username.textColor = [UIColor whiteColor];
    
    username.textAlignment = NSTextAlignmentCenter;
    
    username.backgroundColor = [UIColor clearColor];
    
    username.font = [UIFont fontWithName:@"Helvetica-Bold"size:22];
}

- (void)initBar
{
    self.navigationItem.title = @"个人中心";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initDatas
{
    dataSource = @[@{@"title"     :@"我的收藏",
                     @"icon" : @"MySave"},
                   @{@"title"     :@"更新数据库",
                     @"icon" : @"Updata"},
                   @{@"title"     :@"每日答题提醒",
                     @"icon" : @"remind"},
                   @{@"title"     :@"题库推荐",
                     @"icon" : @"recommend"},
                   @{@"title"     :@"意见建议",
                     @"icon" : @"Advise"},
                   @{@"title"     :@"关于我们",
                     @"icon" : @"AboutUs"}];
}

- (void)initViewList
{
    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:viewList];
    
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    viewList.showsVerticalScrollIndicator = NO;
    viewList.showsHorizontalScrollIndicator = NO;

    viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    viewList.delegate = self;
    viewList.dataSource = self;
    
    [viewList registerClass:[RWButtonCell class] forCellReuseIdentifier:viewListButton];
    
    [viewList registerClass:[UITableViewCell class] forCellReuseIdentifier:viewListCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 120;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == dataSource.count)
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:viewListButton forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        
        if (![[[RWDeployManager defaultManager]
                                deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
        {
            cell.title = @"退出登录";
        }
        else
        {
            cell.title = @"立即登录";
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:viewListCell forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[dataSource[indexPath.section] objectForKey:viewListImage]];
    
    cell.textLabel.text = [dataSource[indexPath.section] objectForKey:viewListTitle];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    [self exitLogin];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            [self toCollectView];
        }
            break;
        case 1:
        {
            [self updateDatabase];
        }
            break;
        case 2:
        {
            [self toAlarmClockView];
        }
            break;
        case 3:
        {
            [self toRecommendViewController];
        }
            break;
        case 4:
        {
            [self toCommentsAndSuggestionsView];
        }
            break;
        case 5:
        {
            [self toAboutUsViewController];
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0)
    {
        return nil;
    }
    
    RWDeployManager *deploy = [RWDeployManager defaultManager];
    
    UIView *view = [[UIView alloc] init];
        
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
        
    imageView.image = [UIImage imageNamed:@"banner-lqzlbg"];
        
    [view addSubview:imageView];
    
    [self initUsernameLabel];
        
    UIView *backView = [[UIView alloc]initWithFrame:username.frame];
        
    backView.backgroundColor = [UIColor blackColor];
        
    backView.alpha = 0.4;
        
    backView.layer.cornerRadius = 10;
        
    [imageView addSubview:backView];
        
    [imageView addSubview:username];
    
    if (section == 0 && ![[deploy deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
    {
        UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
        
        username.text = loginUser.name;
    }
    else
    {
        username.text = @"未登录";
    }
 
    return view;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAIN_NAV
    
    [self initBar];
    
    [self initDatas];
    
    [self initViewList];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [viewList reloadData];
}

-(void)exitLogin
{
    NSString *header, *message, *responcedTitle, *cancelTitle;
    
    if (![[[RWDeployManager defaultManager] deployValueForKey:LOGIN]
                                                            isEqualToString:NOT_LOGIN])
    {
        header = @"确认退出";
        message=@"退出登录将无法继续使用题库\n\n确定退出，请单击退出登录\n继续使用，请点击取消按钮";
        responcedTitle = @"退出登录";
        cancelTitle = @"取消";
    }
    else
    {
        header = @"登录";
        message=@"立即登录免费获取全部题库\n\n继续体验，请点击取消按钮";
        responcedTitle = @"立即登录";
        cancelTitle = @"取消";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:responcedTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                           RWDeployManager *deploy = [RWDeployManager defaultManager];

                           [deploy changeLoginStatusWithStatus:NOT_LOGIN
                                                      Username:nil
                                                      Password:nil
                                              termOfEndearment:nil];
        });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:registerAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)toCollectView
{
    RWErrorSubjectsController *collectView = [[RWErrorSubjectsController alloc]init];
    
    collectView.delegate = self;
    
    [self.navigationController pushViewController:collectView animated:YES];
}

- (RWDisplayType)CollectSubject
{
    return RWDisplayTypeCollect;
}

-(void)toAlarmClockView
{
    RWAlarmClockController *alarmClock = [[RWAlarmClockController alloc] init];
    
    [self.navigationController pushViewController:alarmClock animated:YES];
}

-(void)toCommentsAndSuggestionsView
{
    RWFeedbackViewController *feedBack = [[RWFeedbackViewController alloc] init];
    
    [self.navigationController pushViewController:feedBack animated:YES];
}

-(void)toAboutUsViewController
{
    RWWebViewController *webViewController = [[RWWebViewController alloc] init];
    
    webViewController.url = @"http://www.zhongyuedu.com/api/tk_aboutUs.htm";
    
    webViewController.title = @"关于我们";
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)toRecommendViewController
{
    RWRecommendController *recommendController = [[RWRecommendController alloc]init];
    
    [self.navigationController pushViewController:recommendController animated:YES];
}

- (void)updateDatabase
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"更新数据库后答题记录将被重置,是否更新?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        
        [SVProgressHUD showWithStatus:@"正在更新..."];
        
        RWRequsetManager *requset = [[RWRequsetManager alloc] init];
        
        requset.delegate = self;
        
        [requset obtainServersInformation];
        
    }];
    
    [alert addAction:registerAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)subjectHubDownLoadDidFinish:(NSArray *)subjectHubs
{
    [SVProgressHUD dismiss];
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self
                                        Title:@"网络连接失败,请检查网络"
                                        Click:nil];
}

@end
