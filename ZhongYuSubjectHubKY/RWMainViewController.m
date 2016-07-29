//
//  RWMainViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainViewController.h"
#import "RWDataBaseManager.h"
#import "RWChooseSubViewController.h"
#import <SVProgressHUD.h>
#import "RWWelcomeController.h"
#import "RWMainViewController+Drawer.h"
#import "RWMainViewController+CountDownView.h"
#import "RWCustomizeToolBar.h"

@interface RWMainViewController ()

<
    UIAlertViewDelegate,
    WKNavigationDelegate,
    WKUIDelegate,
    RWCustomizeWebToolBarDelegate
>

@end

@implementation RWMainViewController

- (void)initBar
{
    
    self.navigationItem.title = NAV_TITLE;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
 
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *barButton =
                [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"admin_gg"]
                                                style:UIBarButtonItemStyleDone
                                               target:self
                                               action:@selector(drawerSwitch)];
    
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)toWelcomeView
{
    RWWelcomeController *welcomeView = [[RWWelcomeController alloc] init];
    
    [self presentViewController:welcomeView animated:NO completion:nil];
}

- (void)initManagersAndDatas
{
    _requestManager = [[RWRequsetManager alloc] init];
    
    _deployManager = [RWDeployManager defaultManager];
}

- (void)initInformationView
{
    _informationView = [[WKWebView alloc] init];
    
    _informationView.UIDelegate = self;
    _informationView.navigationDelegate = self;
    
    [self.view addSubview:_informationView];
    
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    if ([webView.URL.absoluteString isEqualToString:MAIN_INDEX.absoluteString])
    {
        [self removeWebToolBar];
    }
    else
    {
        [self addWebToolBar];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_informationView.isLoading)
        {
            [SVProgressHUD dismiss];
        }
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self Title:@"网络连接失败，请检查网络" Click:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)addWebToolBar
{
    if ([self.tabBarController.tabBar viewWithTag:160701])
    {
        return;
    }
    
    CGFloat w = self.tabBarController.tabBar.frame.size.width;
    CGFloat h = self.tabBarController.tabBar.frame.size.height;
    CGRect frame = CGRectMake(0, 0, w, h);
    
    RWCustomizeWebToolBar *bar = [RWCustomizeWebToolBar webBarWithFrame:frame];
    bar.delegate = self;
    bar.tag = 160701;
    
    [self.tabBarController.tabBar addSubview:bar];
}

- (void)removeWebToolBar
{
    UIView *view = [self.tabBarController.tabBar viewWithTag:160701];
    
    if (view)
    {
        [view removeFromSuperview];
    }
}

- (void)webToolBar:(RWCustomizeWebToolBar *)webToolBar didClickWithType:(RWWebToolBarType)type
{
    switch (type)
    {
        case RWWebToolBarTypeOfPrevious:
        {
            [_informationView goBack];
            
            break;
        }
        case RWWebToolBarTypeOfIndex:
        {
            NSURLRequest *requset = [NSURLRequest requestWithURL:MAIN_INDEX];
            
            [_informationView loadRequest:requset];
            
            break;
        }
        case RWWebToolBarTypeOfShared:
            
            break;
            
        default:
            break;
    }
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAIN_NAV
    
    [RWRequsetManager obtainExperienceTimes];
    
    [self initManagersAndDatas];
    
    [self initBar];
    
    [self initInformationView];
    
    [self compositionDrawer];
    
    [self examineWhetherShowTestCountDownView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabBarController.view.window insertSubview:_drawerView atIndex:0];
    
    _drawerCenter = _drawerView.center;
    
    if ([[_deployManager deployValueForKey:FIRST_OPEN_APPILCATION] boolValue])
    {
        [self toWelcomeView];
        
        return;
    }
    
    NSURLRequest *requset = [NSURLRequest requestWithURL:MAIN_INDEX];
    
    [_informationView loadRequest:requset];
    
    if (_countDown)
    {
        [_countDown rollTestNameAndDays];
    }
}

#pragma mark - RWRequsetDelegate

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task {
    
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self Title:@"服务器连接失败" Click:nil];
}

#pragma mark +CountDown

- (void)countDownView:(RWCountDownView *)countDown DidClickCloseButton:(UIImageView *)closeButton
{
    [self removeCountDownView];
}

@end
