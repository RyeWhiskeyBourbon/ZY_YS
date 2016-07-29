//
//  RWRequsetManager+UserLogin.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager+UserLogin.h"
#import "UMComPushRequest.h"
#import "UMComUserAccount.h"

@implementation RWRequsetManager (UserLogin)

- (void)registerWithUsername:(NSString *)username AndPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
    
    UMComUserAccount *userAccount = [[UMComUserAccount alloc] init];
    
    userAccount.usid = username;
    userAccount.name = username;
    
    [UMComPushRequest loginWithCustomAccountForUser:userAccount completion:^(id responseObject, NSError *error) {
        
        if(!error)
        {
            NSDictionary *body = @{@"username":username,
                                   @"password":password,
                                   @"yzm":verificationCode};
            
            [self.manager POST:REGISTER_URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
                {
                    [[RWDeployManager defaultManager]
                                        changeLoginStatusWithStatus:DID_LOGIN
                                                           Username:username
                                                           Password:password
                                                   termOfEndearment:username];
                    
                    [self.delegate registerResponds:YES
                                        ErrorReason:nil];
                }
                else
                {
                    if ([Json objectForKey:@"result"])
                    {
                        [self.delegate registerResponds:NO
                                            ErrorReason:[Json objectForKey:@"result"]];
                    }
                    else
                    {
                        [self.delegate registerResponds:NO
                                            ErrorReason:@"注册失败"];
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self.delegate registerResponds:NO
                                    ErrorReason:error.description];
            }];
        }
        else
        {
            
            [self.delegate registerResponds:NO
                                ErrorReason:error.description];
        }
    }];
}

- (void)userinfoWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    RWDeployManager *deploy = [RWDeployManager defaultManager];
    
    UMComUserAccount *userAccount = [[UMComUserAccount alloc] init];
    
    userAccount.usid = username;
    userAccount.name = username;
    
    [UMComPushRequest loginWithCustomAccountForUser:userAccount completion:^(id responseObject, NSError *error) {
        
        NSLog(@"res = %@",responseObject);
        
        if(!error)
        {
            NSDictionary *body = @{@"username":username,@"password":password};
            
            [self.manager POST:LOGIN_URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
                {
                    
                    
                    [deploy changeLoginStatusWithStatus:DID_LOGIN
                                               Username:username
                                               Password:password
                                       termOfEndearment:userAccount.name];
                    
                    [self.delegate userLoginResponds:YES ErrorReason:nil];
                }
                else
                {
                    [self.delegate userLoginResponds:NO
                                         ErrorReason:[Json objectForKey:@"result"]];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                
                [self.delegate requestError:error Task:task];
            }];
        }
        else
        {
            [self.delegate userLoginResponds:NO
                                 ErrorReason:error.description];
        }
    }];
}

- (void)replacePasswordWithUsername:(NSString *)username AndPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
    NSDictionary *body = @{@"username":username,
                           @"password":password,
                           @"yzm":verificationCode,
                           @"yz":@"2802"};
    
    [self.manager POST:REPLACE_PASSWORD_URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
        {
            [self.delegate replacePasswordResponds:YES ErrorReason:nil];
        }
        else
        {
            [self.delegate replacePasswordResponds:NO ErrorReason:
                                                        [Json objectForKey:@"result"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestError:error Task:task];
    }];
}

- (void)obtainVerificationWithPhoneNunber:(NSString *)phoneNumber result:(void(^)(BOOL succeed,NSString *reason))result
{
    NSString *UUID =  [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSDictionary *body = @{@"username":phoneNumber,@"did":UUID};
    
    [self.manager POST:VERIFICATION_PHONENUMBER parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[Json objectForKey:@"code"] integerValue] == 200)
        {
            result(YES,nil);
        }
        else
        {
            NSString *errorCode =
                        [NSString stringWithFormat:@"%@",[Json objectForKey:@"code"]];
            
            NSString *description = [self.errorDescription objectForKey:errorCode];
            
            if (description)
            {
                result(NO,description);
            }
            else
            {
                result(NO,@"验证码获取失败");
            }
        }
        
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         result(NO,error.description);
     }];
}

- (BOOL)verificationPhoneNumber:(NSString *)phoneNumber
{
    NSString *mobile = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    
    NSPredicate *regexTestMobile =
                        [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    
    return [regexTestMobile evaluateWithObject:phoneNumber];
}

- (BOOL)verificationPassword:(NSString *)password
{
    return password.length >= 6 && password.length <= 18 ? YES : NO;
}

- (BOOL)verificationEmail:(NSString *)Email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:Email];
}

@end
