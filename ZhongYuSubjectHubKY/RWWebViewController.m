//
//  RWWebViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/4.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWebViewController.h"
#import <WebKit/WebKit.h>
#import "RWRequsetManager+UserLogin.h"

@interface RWWebViewController ()

<
    WKUIDelegate,
    WKNavigationDelegate
>

@property (nonatomic,strong)WKWebView *web;

@property (nonatomic,assign)NSInteger pages;

@end

@implementation RWWebViewController

@synthesize web;

- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    
    self.navigationItem.title = _headerTitle;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HIDDEN_TABBAR
    
    web = [[WKWebView alloc] init];
    web.UIDelegate = self;
    web.navigationDelegate = self;
    
    [self.view addSubview:web];
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    HIDDEN_TABBAR
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    if (_url)
    {
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        
        [web loadRequest:requset];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (web.isLoading)
        {
            [SVProgressHUD dismiss];
        }
    });
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    if (self.view.window)
    {
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        
        [web loadRequest:requset];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SHOW_TABBAR
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
