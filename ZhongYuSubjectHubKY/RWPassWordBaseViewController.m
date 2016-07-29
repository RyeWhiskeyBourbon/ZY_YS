//
//  RWPassWordBaseViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/7/4.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWPassWordBaseViewController.h"
#import "RWLoginTableViewCell.h"
#import "RWRequsetManager+UserLogin.h"

@interface RWPassWordBaseViewController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWButtonCellDelegate,
    RWRequsetDelegate,
    RWTextFiledCellDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@property (weak ,nonatomic)NSTimer *timer;

@property (nonatomic ,strong)NSString *facePlaceHolder;

@property (weak, nonatomic)UIButton *clickBtn;

@property (assign ,nonatomic)NSInteger countDown;

@property (nonatomic,strong)RWRequsetManager *requestManager;

@property (nonatomic,assign)CGFloat *height;

@end

static NSString *const textFileCell = @"textFileCell";

static NSString *const buttonCell = @"buttonCell";

static NSString *const verCell = @"verCell";

@implementation RWPassWordBaseViewController

@synthesize viewList;
@synthesize facePlaceHolder;
@synthesize clickBtn;
@synthesize countDown;
@synthesize height;

- (void)initItemHeight
{
    CGFloat item1,item2,item3,item4;
    
    if (_typePassWord == TypeRegisterPassWord)
    {
        item1 = self.view.frame.size.height / 2.5 - 55 * 3 + 90;
        item2 = item1 + 53;
        item3 = item2 + 70;
        item4 = item3 + 53;
    }
    else
    {
        item1 = self.view.frame.size.height / 2.5 - 55 * 3 + 90;
        item2 = item1 + 53;
        item3 = item2 + 53;
        item4 = item3 + 70;
    }
    
    CGFloat *items = (CGFloat *)malloc(sizeof(CGFloat) * 4);
    
    items[0] = item1;
    items[1] = item2;
    items[2] = item3;
    items[3] = item4;
    
    height = items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    _requestManager = [[RWRequsetManager alloc] init];
    
    [self registerForKeyboardNotifications];
    
    [self initViewList];
    
    [self addTapGesture];
    
    [self initItemHeight];
}
#pragma mark AutoSize Keyboard


/**
 *  获取键盘通知
 */
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat residue = self.view.frame.size.height - keyboardSize.height;
    
    int item;
    
    if (_typePassWord == TypeRegisterPassWord)
    {
        item = [facePlaceHolder isEqualToString:@"请输入手机号"]?0:item;
        item = [facePlaceHolder isEqualToString:@"请输入密码"]?1:item;
        item = [facePlaceHolder isEqualToString:@"请再次输入密码"]?2:item;
        item = !facePlaceHolder?3:item;
    }
    else
    {
        item = [facePlaceHolder isEqualToString:@"请输入手机号"]?0:item;
        item = [facePlaceHolder isEqualToString:@"请输入密码"]?2:item;
        item = [facePlaceHolder isEqualToString:@"请再次输入密码"]?3:item;
        item = !facePlaceHolder?1:item;
    }
    
    if (residue - height[item] < 0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGPoint offset = viewList.contentOffset;
            offset.y -= (residue - height[item]);
            
            viewList.contentOffset = offset;
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 animations:^{
        
        viewList.contentOffset = CGPointMake(0, -20);
    }];
}

-(void)initViewList{
    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    viewList.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textBack"]];
    
    [self.view addSubview:viewList];
    
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(70);
    }];
    
    viewList.showsVerticalScrollIndicator = NO;
    viewList.showsHorizontalScrollIndicator = NO;
    
    viewList.allowsSelection = NO;
    viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    viewList.delegate = self;
    viewList.dataSource = self;

    [viewList registerClass:[RWTextFiledCell class]
     forCellReuseIdentifier:textFileCell];
    
    [viewList registerClass:[RWButtonCell class]
     forCellReuseIdentifier:buttonCell];
    
    [viewList registerClass:[RWVerificationCodeCell class]
     forCellReuseIdentifier:verCell];
    
}
#pragma mark tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 2;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typePassWord == 0)
    {
        if (indexPath.section == 0)
        {
            RWTextFiledCell * cell=[tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
            
            cell.delegate = self;
            
            cell.textFiled.keyboardType=UIKeyboardTypeDecimalPad;
            cell.headerImage=[UIImage imageNamed:@"Loginw"];
            cell.placeholder=@"请输入手机号";
                
            return cell;
        }
        else if (indexPath.section == 1)
        {
            RWTextFiledCell * cell=[tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
            
            cell.delegate = self;
            
            cell.textFiled.secureTextEntry=YES;
            cell.headerImage=[UIImage imageNamed:@"PassWordw"];
            cell.placeholder=@"请输入密码";
                
            return cell;

        }
        else if(indexPath.section == 2)
        {
            RWTextFiledCell * cell=[tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
            
            cell.delegate = self;
            
            cell.headerImage=[UIImage imageNamed:@"PassWordw"];
            cell.placeholder=@"请再次输入密码";
            cell.textFiled.secureTextEntry=YES;
                
            return cell;
        }
        else if(indexPath.section == 3)
        {
            RWVerificationCodeCell * cell=[tableView dequeueReusableCellWithIdentifier:verCell forIndexPath:indexPath];
            
            cell.delegate = self;
                
            cell.textFiled.keyboardType=UIKeyboardTypeDecimalPad;
                
            UIButton * button=[UIButton buttonWithType:(UIButtonTypeCustom)];

            button.frame=CGRectMake(self.view.bounds.size.width-85, 11, 70, 28);
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
            [button addTarget:self action:@selector(buttonClickwithIdentify:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 10;
            [cell addSubview:button];
                
            return cell;
        }
        else
        {
            RWButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
            cell.delegate = self;
            
            if(indexPath.row==0)
            {
                cell.title=@"上一步";
                cell.button.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.4];
                cell.button.tag=1000;
            }else
            {
                cell.title=@"完成注册";
                cell.button.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.4];
                cell.button.tag=1001;
            }
            
            return cell;
        }
        
    }
    else
    {
        if (indexPath.section == 0)
        {
            RWTextFiledCell * cell=[tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
            
            cell.delegate = self;
                
            cell.textFiled.keyboardType=UIKeyboardTypeDecimalPad;
            cell.headerImage=[UIImage imageNamed:@"Loginw"];
            cell.placeholder=@"请输入手机号";
                
            return cell;
        }
        else if (indexPath.section == 1)
        {
                
            RWVerificationCodeCell * cell=[tableView dequeueReusableCellWithIdentifier:verCell forIndexPath:indexPath];
            
            cell.delegate = self;
                
            cell.textFiled.keyboardType=UIKeyboardTypeDecimalPad;
                
            UIButton * button=[UIButton buttonWithType:(UIButtonTypeCustom)];
                
            button.frame=CGRectMake(self.view.bounds.size.width-85, 11, 70, 28);
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
            [button addTarget:self action:@selector(buttonClickwithIdentify:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 10;
            [cell addSubview:button];
                
            return cell;
        }
        else if (indexPath.section == 2)
        {
            RWTextFiledCell * cell=[tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
            
            cell.delegate = self;
                
            cell.headerImage=[UIImage imageNamed:@"PassWordw"];
            cell.placeholder=@"请输入密码";
            cell.textFiled.secureTextEntry=YES;
                
            return cell;
        }
        else if (indexPath.section == 3)
        {
            RWTextFiledCell * cell=[tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
            cell.delegate = self;
            
            
            cell.textFiled.secureTextEntry=YES;
            cell.headerImage=[UIImage imageNamed:@"PassWordw"];
            cell.placeholder=@"请再次输入密码";
            return cell;
        }
        else
        {
            RWButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
            cell.delegate = self;
            
            if(indexPath.row==0)
            {
                cell.title=@"上一步";
                cell.button.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.4];
                cell.button.tag=1002;
            }
            else
            {
                cell.title=@"提交修改";
                cell.button.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.4];
                cell.button.tag=1003;
            }
            
            return cell;
        }
    }
}
#pragma mark   点击下方两个按钮要实现的方法
-(void)button:(UIButton *)button ClickWithTitle:(NSString *)title{
    
    switch (button.tag)
    {
        case 1000:
        case 1002:[self.navigationController popViewControllerAnimated:YES];break;
        case 1001:[self isRegister:YES];break;
        case 1003:[self isRegister:NO];break;
        default:break;
    }
}

- (void)isRegister:(BOOL)isRegister
{
    RWTextFiledCell *index0 = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    RWTextFiledCell *index1 = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    RWTextFiledCell *index2 = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    RWTextFiledCell *index3 = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    NSString *username = index0.textFiled.text;
    NSString *password = isRegister?index1.textFiled.text:index2.textFiled.text;
    NSString *verPasswd = isRegister?index2.textFiled.text:index3.textFiled.text;
    NSString *verification = isRegister?index3.textFiled.text:index1.textFiled.text;
    
    if (![_requestManager verificationPhoneNumber:username])
    {
        [RWRequsetManager warningToViewController:self Title:@"手机号输入有误，请重新输入" Click:^{
            
            index0.textFiled.text = nil;
            [index0.textFiled becomeFirstResponder];
        }];
        
        return;
    }
    
    if (![password isEqualToString:verPasswd])
    {
        [RWRequsetManager warningToViewController:self Title:@"密码输入不一致，请重新输入" Click:^{
            
            UITextField *passwd = isRegister?index1.textFiled:index2.textFiled;
            UITextField *repasswd = isRegister?index2.textFiled:index3.textFiled;
            
            passwd.text = nil; repasswd.text = nil;
            
            [passwd becomeFirstResponder];
            [repasswd becomeFirstResponder];
        }];
        
        return;
    }
    
    _requestManager.delegate = self;
    
    if (isRegister)
    {
        [_requestManager registerWithUsername:username
                                  AndPassword:password
                             verificationCode:verification];
    }
    else
    {
        [_requestManager replacePasswordWithUsername:username
                                         AndPassword:password
                                    verificationCode:verification];
    }

}

- (void)registerResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    if (isSuccessed)
    {
        [RWRequsetManager warningToViewController:self Title:@"注册成功" Click:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [RWRequsetManager warningToViewController:self Title:reason Click:nil];
    }
}

- (void)replacePasswordResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    if (isSuccessed)
    {
        [RWRequsetManager warningToViewController:self Title:@"密码重置成功" Click:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [RWRequsetManager warningToViewController:self Title:reason Click:nil];
    }
}

#pragma mark 点击获取验证码实现的方法
-(void)buttonClickwithIdentify:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"获取验证码"] ||
        [button.titleLabel.text isEqualToString:@"重新验证码"])
    {
        countDown= 60;
        
        [self timerStart];
        
        RWTextFiledCell *userName = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (![_requestManager verificationPhoneNumber:userName.textFiled.text])
        {
            [RWRequsetManager warningToViewController:self Title:@"手机号输入有误，请重新输入" Click:^{
               //13791836315
                userName.textFiled.text = nil;
                [userName.textFiled becomeFirstResponder];
            }];
            
            return;
        }
        
        clickBtn=button;
        
        _requestManager.delegate = self;
        
        [_requestManager obtainVerificationWithPhoneNunber:userName.textFiled.text result:^(BOOL succeed, NSString *reason)
         {
             if (!succeed)
             {
                [RWRequsetManager warningToViewController:self Title:reason Click:^{
                    
                    [clickBtn setTitle:@"重新验证码" forState:(UIControlStateNormal)];
                }];
             }
        }];
    }
}

/**
 *  计时器
 */

- (void)timerStart
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(renovateSecond) userInfo:nil repeats:YES];
}
/**
 *  计时器启动时的方法
 */
- (void)renovateSecond
{
    if (countDown <= 0)
    {
        [_timer setFireDate:[NSDate distantFuture]];
        
        [clickBtn setTitle:@"重新验证码" forState:(UIControlStateNormal)];
        
        return;
    }
    
    countDown --;
    
    [clickBtn setTitle:[NSString stringWithFormat:@"%dS",(int)countDown]
              forState:UIControlStateNormal];
    
}

- (void)textFiledCell:(RWTextFiledCell *)cell DidBeginEditing:(NSString *)placeholder
{
    viewList.contentOffset = CGPointMake(0, -20);
    
    facePlaceHolder = placeholder;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.view.frame.size.height / 2.5 - 55 * 3;
    }
    
    if (_typePassWord == TypeRegisterPassWord)
    {
        if (section == 3)
        {
            return 20;
        }
    }
    else
    {
        if (section == 2)
        {
            return 20;
        }
    }
    
    if (section == 4)
    {
        return  40;
    }
    
    return 3;
}
/**
 *  组透视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.view.frame.size.height == 480)
    {
        return nil;
    }
    
    if (section == 0)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        titleLabel.text = @"ZHONGYU · 中域";
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"STXingkai-SC-Bold"size:20];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(1, 1);
        titleLabel.shadowColor = [UIColor goldColor];
        
        [backView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(0);
            make.right.equalTo(backView.mas_right).offset(0);
            make.top.equalTo(backView.mas_top).offset(0);
            make.bottom.equalTo(backView.mas_bottom).offset(0);
        }];
        
        return backView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
/**
 *  添加一个点击手势
 */

-(void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;
    
    [viewList addGestureRecognizer:tap];
}

/**
 *  让输入框放弃第一响应
 */
- (void)releaseFirstResponder
{
    RWTextFiledCell *phoneFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (phoneFiled.textFiled.isFirstResponder)
    {
        [phoneFiled.textFiled resignFirstResponder];
    }
    
    RWTextFiledCell *wordFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (wordFiled.textFiled.isFirstResponder)
    {
        [wordFiled.textFiled resignFirstResponder];
    }
    RWTextFiledCell *passwordFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (passwordFiled.textFiled.isFirstResponder)
    {
        [passwordFiled.textFiled resignFirstResponder];
    }
    RWTextFiledCell *passwordagainFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    if (passwordagainFiled.textFiled.isFirstResponder)
    {
        [passwordagainFiled.textFiled resignFirstResponder];
    }
}

- (void)dealloc
{
    free(height);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    [RWRequsetManager warningToViewController:self Title:@"网络连接失败" Click:nil];
}

@end
