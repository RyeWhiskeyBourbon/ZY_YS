//
//  RWRequsetManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager.h"
#import "FMDB.h"
#import "RWDataBaseManager.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWTabBarViewController.h"
#import "RWRegisterViewController.h"
#import "AppDelegate.h"

@interface RWRequsetManager ()

<
    RWRequsetDelegate
>

@property (nonatomic,strong)RWDataBaseManager *baseManager;

@end

@implementation RWRequsetManager

@synthesize manager;
@synthesize baseManager;

- (void)addNetworkStatusObserver
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    
    [statusManager startMonitoring];
    
    [statusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        _reachabilityStatus = status;
        
        RWDeployManager *deployManager = [RWDeployManager defaultManager];
        
        if (_reachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN ||
            _reachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            if ([[deployManager deployValueForKey:LOGIN] isEqualToString:UNLINK_LOGIN])
            {
                NSString *username = [deployManager deployValueForKey:USERNAME];
                NSString *password = [deployManager deployValueForKey:PASSWORD];
                
                _delegate = self;
                
                [self userinfoWithUsername:username AndPassword:password];
            }
        }
        else
        {
            if ([[deployManager deployValueForKey:LOGIN] isEqualToString:DID_LOGIN])
            {
                [deployManager setDeployValue:UNLINK_LOGIN forKey:LOGIN];
                
                RWTabBarViewController *tabBarController = (RWTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                
                [RWRequsetManager warningToViewController:tabBarController
                                                    Title:@"网络状态异常，请检查网络"
                                                    Click:nil];
            }
        }
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter postNotificationName:REACHABILITY_STATUS_MESSAGE
                                          object:[NSNumber numberWithInteger:status]];
    }];
}

- (void)userLoginResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    if (!isSuccessed)
    {
        RWTabBarViewController *tabBarController = (RWTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        
        NSString *header, *message, *responcedTitle, *cancelTitle;
        
        header = @"友情提示";
        message=@"自动登录失败\n\n点击确定进入登录界面\n继续请点击取消";
        responcedTitle = @"登录";
        cancelTitle = @"取消";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *registerAction = [UIAlertAction actionWithTitle:responcedTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [tabBarController toRootViewController];
            
            RWRegisterViewController *registerView =
                                                [[RWRegisterViewController alloc]init];
            
            [tabBarController presentViewController:registerView
                                           animated:YES
                                         completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alert addAction:registerAction];
        
        [alert addAction:cancelAction];
        
        [tabBarController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    RWTabBarViewController *tabBarController = (RWTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    
    [RWRequsetManager warningToViewController:tabBarController
                                        Title:@"网络连接失败"
                                        Click:nil];
}

#if 0

- (void)obtainServersInformation {
    
    [manager GET:SERVERS_INDEX parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [baseManager replaceDatabase];
        
        NSDictionary *baseList = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[baseList valueForKey:@"resultCode"] integerValue] == 0) {
            
            [self writeHubListToDatabaseWithList:baseList];
        
            [self.delegate subjectHubDownLoadDidFinish:[baseManager obtainHubClassNames]];
        }
        else
        {
            [self.delegate requestError:nil Task:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestError:error Task:task];
        
    }];
}

- (void)writeHubListToDatabaseWithList:(NSDictionary *)baseList
{
    NSLog(@"%@",baseList);
    
    NSArray *hubs = [[baseList objectForKey:@"result"] objectForKey:@"content"];
    
    NSString *title = [[baseList objectForKey:@"result"] valueForKey:@"title"];
    
    RWSubjectHubClassModel *hubClass = [[RWSubjectHubClassModel alloc]init];
    
    hubClass.uploaddate = [self obtainSystemDate];
    
    hubClass.title = title;
    
    [baseManager insertEntity:hubClass];
    
    for (int i = 0; i < hubs.count; i++) {
        
        RWSubjectHubModel *hub = [[RWSubjectHubModel alloc] init];
        
        hub.testDBURL = nil;
        
        hub.testDBSize = nil;
        
        hub.formalDBURL = [hubs[i] valueForKey:@"formalDBURL"];
        
        hub.formalDBSize = [hubs[i] valueForKey:@"formalDBSize"];
        
        hub.title = [hubs[i] valueForKey:@"title"];
        
        hub.hubClass = title;
        
        [baseManager insertEntity:hub];
    }
}

#elif 1

#pragma mark - array

- (void)obtainServersInformation
{    
    [manager GET:SERVERS_INDEX parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [baseManager replaceDatabase];
        
        NSDictionary *baseList = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[baseList valueForKey:@"resultCode"] integerValue] == 0) {
            
            NSArray *hubs = [baseList objectForKey:@"result"];
            
            for (int i = 0; i < hubs.count; i++) {
                
                NSString *title = [hubs[i] valueForKey:@"title"];
                
                RWSubjectHubClassModel *hubClass = [[RWSubjectHubClassModel alloc]init];
                
                hubClass.uploaddate = [self obtainSystemDate];
                
                hubClass.title = title;
                
                [baseManager insertEntity:hubClass];
                
                NSArray *content = [hubs[i] valueForKey:@"content"];
                
                for (int j = 0; j < content.count; j++) {
                    
                    RWSubjectHubModel *hub = [[RWSubjectHubModel alloc] init];
                    
                    hub.testDBURL = nil;
                    
                    hub.testDBSize = nil;
                    
                    hub.formalDBURL = [content[j] valueForKey:@"formalDBURL"];
                    
                    hub.formalDBSize = [content[j] valueForKey:@"formalDBSize"];
                    
                    hub.title = [content[j] valueForKey:@"title"];
                    
                    hub.hubClass = title;
                    
                    [baseManager insertEntity:hub];
                }
            }
            
            [self.delegate subjectHubDownLoadDidFinish:[baseManager obtainHubClassNames]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestError:error Task:task];
        
    }];

}

#endif

- (void)obtainBaseWith:(NSString *)url AndHub:(NSString *)hub DownLoadFinish:(void(^)(BOOL declassify))finish
{
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@",SANDBOX_PATH,[[url componentsSeparatedByString:@"/"] lastObject]];
        
        [responseObject writeToFile:dbPath atomically:YES];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:dbPath]) {
            
            FMDatabase *base = [FMDatabase databaseWithPath:dbPath];
            
            [base open];
            
            static NSString *const password = @"WCXLYHGYQLWWYLSWP2016";
            
            BOOL sec = [base setKey:password];
            
            if (!sec)
            {
                finish(NO);
                
                [self obtainBaseWith:url AndHub:hub DownLoadFinish:nil];
                
                return ;
            }
            
            finish(YES);

            [self analysisBase:base AndHubName:hub];
            
            BOOL remove = [fileManager removeItemAtPath:dbPath error:nil];
            
            if (!remove)
            {
                NSLog(@"删除失败");
            }
            

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestError:error Task:task];
    }];
    
}

- (void)analysisBase:(FMDatabase *)base AndHubName:(NSString *)name {
    
    [base open];
    
    NSString *sql = @"select * from tableNames";
    
    FMResultSet *tableNames = [base executeQuery:sql];
    
    while ([tableNames next]) {
        
        [baseManager deleteSubjectClassWithClassName:[tableNames stringForColumn:@"chineseName"]];
        
        RWSubjectClassModel *subjectClass = [[RWSubjectClassModel alloc] init];
        
        subjectClass.hub = name;
        
        subjectClass.subjectclass = [tableNames stringForColumn:@"chineseName"];
        
        subjectClass.uploaddate = [self obtainSystemDate];
        
        [baseManager insertEntity:subjectClass];
        
        NSString *selectSql = [NSString stringWithFormat:@"select * from %@",[tableNames stringForColumn:@"englishName"]];
        
        FMResultSet *entityAll = [base executeQuery:selectSql];
        
        while ([entityAll next]) {
            
            RWSubjectsModel *model = [self writeSubjectToDatabaseWithEntity:entityAll];

            model.subjectclass     = [tableNames stringForColumn:@"chineseName"];
            
            model.hub              = name;
            
            [baseManager insertEntity:model];
        }
    }
    
    [self.delegate subjectBaseDeployDidFinish:[baseManager obtainIndexNameWithHub:name]];
}

- (RWSubjectsModel *)writeSubjectToDatabaseWithEntity:(FMResultSet *)entityAll
{
    RWSubjectsModel *model = [[RWSubjectsModel alloc] init];
    
    model.subject          = [entityAll stringForColumn:@"题干"];
    
    model.analysis         = [entityAll stringForColumn:@"解析"];
    
    model.answer           = [entityAll stringForColumn:@"答案"];
    
    model.a                = [entityAll stringForColumn:@"A"];
    
    model.b                = [entityAll stringForColumn:@"B"];
    
    model.c                = [entityAll stringForColumn:@"C"];
    
    model.d                = [entityAll stringForColumn:@"D"];
    
    model.e                = [entityAll stringForColumn:@"E"];
    
    model.subjectnumber    = [NSNumber numberWithInt:[entityAll intForColumn:@"id"]];
    
    model.answerstate      = [NSNumber numberWithInteger:RWAnswerStateNone];
    
    return model;
}

- (void)obtainTasteSubject
{
    if ([baseManager isExistHubWithHubName:@"体验答题"])
    {
        return;
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"taste" ofType:@"json"]];
    
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    for (int i = 0; i < arr.count; i++)
    {
        RWSubjectsModel *taste = [[RWSubjectsModel alloc]init];
        
        taste.subjectclass     = @"体验答题";
        
        taste.hub              = @"体验答题";
        
        taste.subject          = [arr[i] valueForKey:@"subject"];
        
        taste.analysis         = [arr[i] valueForKey:@"analysis"];
        
        taste.answer           = [arr[i] valueForKey:@"answer"];
        
        taste.a                = [arr[i] valueForKey:@"A"];
        
        taste.b                = [arr[i] valueForKey:@"B"];
        
        taste.c                = [arr[i] valueForKey:@"C"];
        
        taste.d                = [arr[i] valueForKey:@"D"];
        
        taste.e                = [arr[i] valueForKey:@"E"];
        
        taste.subjectnumber    = [NSNumber numberWithInt:i + 1];
        
        taste.answerstate      = [NSNumber numberWithInteger:RWAnswerStateNone];
        
        [baseManager insertEntity:taste];
    }
}

- (void)bannerObjectsProcessingWith:(NSDictionary *)object complete:(void(^)(void))complete
{
    RWBannersModel *banners = [[RWBannersModel alloc] init];
    
    banners.imageurl = [object valueForKey:@"imageURL"];
    
    banners.title = [object valueForKey:@"title"];
    
    banners.contenturl = [object valueForKey:@"contentURL"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:banners.imageurl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            banners.image = imageData;
            
            [baseManager insertBanners:banners];
            
            complete();
        });
    });
}

- (void)obtainClassList
{
    [manager GET:YY_INDEX parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[Json objectForKey:@"resultcode"] integerValue] == 0)
        {
            [self.delegate classListDownloadDidFinish:
                      [self analysisClassListResponse:
                                                [Json objectForKey:@"list"]]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestError:error Task:task];
    }];
}

- (NSMutableArray *)analysisClassListResponse:(NSArray *)responseObject
{
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < responseObject.count; i++)
    {
        RWClassListModel *classList = [[RWClassListModel alloc]init];
        
        NSArray *keys = [baseManager obtainAllKeysWithModel:[classList class]];
        
        for (int j = 0; j < keys.count; j++)
        {
            [classList setValue:[responseObject[i] valueForKey:keys[j]] forKey:keys[j]];
        }
        
        [mArr addObject:classList];
    }
    
    return mArr;
}

- (void)obtainRecommendListSource
{
    
    [manager GET:RECOMMEND parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self.delegate recommendListSourceDownloadFinish:[Json objectForKey:@"contents"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [self.delegate requestError:error Task:task];
    }];
}

- (void)postUserName:(NSString *)userName Complete:(void(^)(BOOL isSucceed,NSString *reason,NSError *error))complete
{
    
    [manager POST:UPDATE_USERNAME parameters:userName progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[Json objectForKey:@"resultCode"] integerValue] == 0)
        {
            complete(YES,nil,nil);
        }
        else
        {
            complete(NO,[Json objectForKey:@"result"],nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        complete(NO,nil,error);
    }];
}

- (void)receivePushMessageOfHTML:(void(^)(NSString *html,NSError *error))complete
{
    
    [manager GET:RECEIVE_PUSH parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        complete([Json objectForKey:@"url"],nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        complete(nil,error);
    }];
}


#pragma mark - sharedSelf

+ (instancetype)sharedRequestManager
{
    static RWRequsetManager *_SharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _SharedManager = [super allocWithZone:NULL];
        [_SharedManager addNetworkStatusObserver];
    });
    
    return _SharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWRequsetManager sharedRequestManager];
}

#pragma mark - init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        baseManager = [RWDataBaseManager defaultManager];
        
        _errorDescription = @{@"200":@"操作成功",
                              @"201":@"客户端版本不对，需升级sdk",
                              @"301":@"被封禁",
                              @"302":@"用户名或密码错误",
                              @"315":@"IP限制",
                              @"403":@"非法操作或没有权限",
                              @"404":@"对象不存在",
                              @"405":@"参数长度过长",
                              @"406":@"对象只读",
                              @"408":@"客户端请求超时",
                              @"413":@"验证失败(短信服务)",
                              @"414":@"参数错误",
                              @"415":@"客户端网络问题",
                              @"416":@"频率控制",
                              @"417":@"重复操作",
                              @"418":@"通道不可用(短信服务)",
                              @"419":@"数量超过上限",
                              @"422":@"账号被禁用",
                              @"431":@"HTTP重复请求"};
    }
    
    return self;
}

- (void)dealloc
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    
    [statusManager stopMonitoring];
}

- (NSDate *)obtainSystemDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss (EEEE)"];
    
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return [dateFormatter dateFromString:dateStr];
}

+ (void)warningToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title Click:(void(^)(void))click
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (click)
        {
            click();
        }
    }];
    
    [alert addAction:registerAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)obtainExperienceTimes
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [session POST:EXPERIENCE_TIMES_URL parameters:@{@"yz":@(2802)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[Json objectForKey:@"resultcode"] integerValue] == 0)
        {
            NSString *limit = [NSString stringWithFormat:@"%@",
                                                    [Json objectForKey:@"limit"]];
            
            [[RWDeployManager defaultManager] setDeployValue:limit
                                                      forKey:TIMES_BUFFER];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
