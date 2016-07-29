//
//  RWPassWordBaseViewController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/7/4.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    TypeRegisterPassWord=0,
    
    TypeForgetPassWord
    
}TypePassWord;

@interface RWPassWordBaseViewController : UIViewController

@property (nonatomic,assign)TypePassWord typePassWord;


@end
