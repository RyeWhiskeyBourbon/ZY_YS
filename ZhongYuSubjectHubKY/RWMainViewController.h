//
//  RWMainViewController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWDrawerView.h"
#import "RWRequsetManager.h"
#import "RWWebViewController.h"
#import "RWCountDownView.h"
#import <WebKit/WebKit.h>

@interface RWMainViewController : UIViewController

<
    RWRequsetDelegate,
    RWCountDownViewDelegate
>

@property (nonatomic,strong)WKWebView *informationView;

@property (nonatomic,strong)RWDeployManager *deployManager;

@property (nonatomic,strong)RWRequsetManager *requestManager;

@property (nonatomic,strong)RWDrawerView *drawerView;

@property (nonatomic,assign)CGPoint viewCenter;

@property (nonatomic,assign)CGPoint drawerCenter;

@property (nonatomic,strong)UIView *maskLayer;

@property (nonatomic,assign)CGPoint startingTouches;

@property (nonatomic,assign)BOOL reloadData;

@property (nonatomic,strong)RWCountDownView *countDown;

@property (nonatomic,strong)UIView *coverLayer;

@end
