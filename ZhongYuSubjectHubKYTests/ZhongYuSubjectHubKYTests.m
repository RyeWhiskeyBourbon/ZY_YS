//
//  ZhongYuSubjectHubKYTests.m
//  ZhongYuSubjectHubKYTests
//
//  Created by zhongyu on 16/5/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWRequsetManager+UserLogin.h"
#import "RWDeployManager.h"
#import "RWDataBaseManager.h"
#import <AFNetworking.h>

#define WAIT do {\\
                [self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\\
                [self waitForExpectationsWithTimeout:30 handler:nil];\\
                } while (0)

#define NOTIFY \\
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil]

@interface ZhongYuSubjectHubKYTests : XCTestCase

<
    RWRequsetDelegate
>

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSArray *subjectSuperClass;

@property (nonatomic,assign)int conut;

@property (nonatomic,assign)int times;

@end

@implementation ZhongYuSubjectHubKYTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testRequestreset
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *body = @{@"username":@"17606397807",@"password":@"17606397807"};
    
    [session POST:REPLACE_PASSWORD_URL parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",Json);
        NSLog(@"%d",(int)[[Json objectForKey:@"resultcode"] integerValue]);
        
        XCTAssertNotEqual([[Json objectForKey:@"resultcode"] integerValue], 0);
        
        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
        CFRunLoopStop(runLoopRef);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
        CFRunLoopStop(runLoopRef);
    }];
    
    CFRunLoopRun();
}

//- (void)testNetworkState
//{
//    [[[RWRequsetManager alloc] init] networkStatus:^(AFNetworkReachabilityStatus status) {
//       
//        XCTAssertNotEqual(status, AFNetworkReachabilityStatusUnknown);
//        
//        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
//        CFRunLoopStop(runLoopRef);
//    }];
//    
//    CFRunLoopRun();
//}

- (void)testRequestIntoBase
{
    RWRequsetManager *requestManager = [[RWRequsetManager alloc] init];
    
    requestManager.delegate = self;
    
//    [requestManager obtainBanners:^(NSArray *banners) {
//       
//        XCTAssertNotNil(banners);
//        
//        XCTAssertEqual(banners.count, 4);
//        
//        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
//        CFRunLoopStop(runLoopRef);
//        
//    }];
    
    CFRunLoopRun();
    
    [requestManager obtainServersInformation];
    
    CFRunLoopRun();
    
}

- (void)subjectHubDownLoadDidFinish:(NSArray *)subjectHubs
{
    XCTAssertNotNil(subjectHubs);
    
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    CFRunLoopStop(runLoopRef);
}

- (void)testSubjectHubs
{
    RWDataBaseManager *database = [RWDataBaseManager defaultManager];
    
    NSArray *subjectHubs = [database obtainHubClassNames];
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    for (int i = 0;  i < subjectHubs.count; i ++) {
        
        XCTAssertNotNil([database obtainHubNamesWithTitle:[subjectHubs[i] valueForKey:@"title"]]);
        
        [mArr addObject:[database obtainHubNamesWithTitle:[subjectHubs[i] valueForKey:@"title"]]];
    }
    
    XCTAssertEqual(subjectHubs.count, mArr.count);
    
//    _times = 0;
//    _conut = 0;
//    
//    for (int i = 0; i < mArr.count; i++)
//    {
//        _conut += [mArr[i] count];
//    }
//    
//    RWRequsetManager *requestManager = [[RWRequsetManager alloc] init];
//    
//    requestManager.delegate = self;
//    
//    for (int i = 0; i < subjectHubs.count; i++)
//    {
//        for (int j = 0; j < [mArr[i] count]; j++)
//        {
//            _title = [mArr[i][j] valueForKey:@"title"];
//            
//            [requestManager obtainBaseWith:[mArr[i][j] valueForKey:@"formalDBURL"] AndHub: _title DownLoadFinish:^(BOOL declassify) {
//                
//                XCTAssertTrue(declassify);
//            }];
//        }
//    }
}

- (void)subjectBaseDeployDidFinish:(NSArray *)subjectHubs
{
    XCTAssertNotNil(subjectHubs);
    
    _times ++;
    
    for (int i = 0; i < subjectHubs.count; i++)
    {
         NSArray *subjects = [[RWDataBaseManager defaultManager] obtainSubjectsWithIndexName:subjectHubs[i] AndHubName:_title];
        
        XCTAssertNotNil(subjects);
        
        XCTAssertEqual([subjects[i] class],[RWSubjectsModel class]);
    }
    
    if (_conut == _times)
    {
        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
        CFRunLoopStop(runLoopRef);
    }
}

- (void)classListDownloadDidFinish:(NSMutableArray *)classListSource
{
    XCTAssertNotNil(classListSource);
    
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    CFRunLoopStop(runLoopRef);
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    XCTAssertNil(error);
    
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    CFRunLoopStop(runLoopRef);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
//    [self testNetworkState];
    
    [self testRequestIntoBase];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self testRequestIntoBase];
    }];
}

@end
