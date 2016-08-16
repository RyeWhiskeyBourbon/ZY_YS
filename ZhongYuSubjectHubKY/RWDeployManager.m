//
//  RWDeployManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDeployManager.h"
#import "RWDeployManager+DateProcess.h"
#import "NSData+Base64.h"
#import "AppDelegate.h"

@interface RWDeployManager ()

@property (nonatomic,weak)AppDelegate *sharedDelegate;

@end

@implementation RWDeployManager

@synthesize sharedDelegate;

+ (RWDeployManager *)defaultManager
{
    static RWDeployManager *_Only = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _Only = [super allocWithZone:NULL];
    });
    
    return _Only;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWDeployManager defaultManager];
}

- (void)obtainAppDelegate
{
     sharedDelegate = [[UIApplication sharedApplication] delegate];
}

- (BOOL)setDeployValue:(id)value forKey:(NSString *)key
{
    [self obtainAppDelegate];

    [sharedDelegate.deployInformation setValue:value forKey:key];
    
    BOOL isDerectory = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isFileExist = [fileManager fileExistsAtPath:DEPLOY_PLIST isDirectory:&isDerectory];
    
    if (!isFileExist)
    {
        NSMutableDictionary *deploy = [[NSMutableDictionary alloc] init];
        
        [deploy setObject:[NSNumber numberWithBool:YES] forKey:FIRST_OPEN_APPILCATION];
        
        if ([value isKindOfClass:[NSString class]])
        {
            [deploy setObject:[self encryptionString:value] forKey:key];
        }
        else
        {
            [deploy setObject:value forKey:key];
        }
        
        return [deploy writeToFile:DEPLOY_PLIST atomically:YES];
    }
    else
    {
        NSMutableDictionary *deploy =
        [[NSMutableDictionary dictionaryWithContentsOfFile:DEPLOY_PLIST] mutableCopy];
        
        if ([value isKindOfClass:[NSString class]])
        {
            [deploy setObject:[self encryptionString:value] forKey:key];
        }
        else
        {
            [deploy setObject:value forKey:key];
        }
        
        return [deploy writeToFile:DEPLOY_PLIST atomically:YES];
    }
    
    return NO;
}

- (id)deployValueForKey:(NSString *)key
{
    NSDictionary *deploy = [NSDictionary dictionaryWithContentsOfFile:DEPLOY_PLIST];
    
    if ([[deploy objectForKey:key] isKindOfClass:[NSString class]])
    {
        return [self declassifyString:[deploy objectForKey:key]];
    }
    
    return [deploy objectForKey:key];
}

- (BOOL)removeDeployValueForKey:(NSString *)key
{
    NSMutableDictionary *deploy =
    [[NSMutableDictionary dictionaryWithContentsOfFile:DEPLOY_PLIST] mutableCopy];
    
    [deploy removeObjectForKey:key];
    
    return [deploy writeToFile:DEPLOY_PLIST atomically:YES];
}

- (void)changeLoginStatusWithStatus:(NSString *)status Username:(NSString *)username Password:(NSString *)password termOfEndearment:(NSString *)name
{
    if ([status isEqualToString:DID_LOGIN])
    {
        [self setDeployValue:DID_LOGIN forKey:LOGIN];
        [self setDeployValue:username forKey:USERNAME];
        [self setDeployValue:password forKey:PASSWORD];
        [self setDeployValue:name forKey:NAME];
    }
    else if ([status isEqualToString:UNLINK_LOGIN])
    {
        [self setDeployValue:UNLINK_LOGIN forKey:LOGIN];
    }
    else if ([status isEqualToString:NOT_LOGIN])
    {
        [self setDeployValue:[NSNull null] forKey:USERNAME];
        [self setDeployValue:[NSNull null] forKey:PASSWORD];
        [self setDeployValue:[NSNull null] forKey:NAME];
        [self setDeployValue:NOT_LOGIN forKey:LOGIN];
    }
}

- (NSMutableDictionary *)obtainDeployInformation
{
    BOOL isDerectory = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isFileExist = [fileManager fileExistsAtPath:DEPLOY_PLIST isDirectory:&isDerectory];
    
    if (isFileExist)
    {
        NSDictionary *deploy =
            [[NSDictionary dictionaryWithContentsOfFile:DEPLOY_PLIST] mutableCopy];

        NSArray *keys = deploy.allKeys;
        
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < keys.count; i++)
        {
            [mDic setObject:[self deployValueForKey:keys[i]] forKey:keys[i]];
        }
        
        return mDic;
    }
    
    return [[NSMutableDictionary alloc] init];
}

- (NSString *)encryptionString:(NSString *)string
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [stringData base64EncodedString];
}

- (NSString *)declassifyString:(NSString *)string
{
    NSData *stringData = [NSData dataFromBase64String:string];
    
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (void)addLocalNotificationWithClockString:(NSString *)clockString AndName:(NSString *)name
{
    RWClockAttribute attribute = [self clockAttributeWithString:clockString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *week = [dateFormatter stringFromDate:[NSDate date]];
    
    NSInteger afterDays;
    
    if (attribute.week == RWClockWeekOfNone)
    {
        BOOL isPast = [self isPastTime:attribute.hours minute:attribute.minute];
        
        if (isPast)
        {
            afterDays = 1;
        }
        else
        {
            afterDays = 0;
        }
    }
    else
    {
        afterDays =
                [self daysFromClockTimeWithClockWeek:attribute.week AndWeekString:week];
    }
    
    NSDate *clockDate = [self buildClockDateWithAfterDays:afterDays
                                                    Hours:attribute.hours
                                                AndMinute:attribute.minute];
    
    NSString *content = @"\n再不答题我们就老了 【中域教育】每周免费直播";
 
    [self addAlarmClockWithTime:clockDate
                          Cycle:attribute.cycleType
                      ClockName:name
                        Content:content];
}



- (void)addLocalNotificationToRWMoment:(RWMoment)moment AndName:(NSString *)name
{
    NSString *testDate = [sharedDelegate.deployInformation objectForKey:TEST_DATE];
    
    NSArray *testDates = [testDate componentsSeparatedByString:@"()"];
    
    if (testDates.count != 2)
    {
        return;
    }
    
    RWMoment testMoment = [self momentWithString:[testDates lastObject]];
    
    NSInteger distanceDays = [self distanceWithBeginMoments:moment
                                              AndEndMoments:testMoment];
    
    RWMoment faceMoment = [self momentWithDate:[NSDate date]];
    
    faceMoment.time = RWTimeMake(0,0,0);
    
    NSInteger daysGap = [self distanceWithBeginMoments:faceMoment
                                         AndEndMoments:moment];
    
    if (daysGap >= 0)
    {
        NSString *title = [NSString stringWithFormat:
                @"\n【考试提醒】距离 %@ 考试，还有%d天,加油哦！",name,(int)distanceDays];
        
        if (distanceDays == 0)
        {
            title = [NSString stringWithFormat:
                     @"\n【考试提醒】今天是 %@ 考试时间，加油哦！",name];
        }
        
        [self addAlarmClockWithTime:[self dateWithRWMoment:moment]
                              Cycle:RWClockCycleOnce
                          ClockName:TEST_CLOCK
                            Content:title];
        
        RWMoment nextMoment = moment;
        
        nextMoment.date.day--;
        
        [self addLocalNotificationToRWMoment:nextMoment AndName:name];
    }
}

- (void)addAlarmClockWithTime:(NSDate *)date Cycle:(RWClockCycle)cycle ClockName:(NSString *)name Content:(NSString *)content
{
    UIUserNotificationType types =  UIUserNotificationTypeBadge |
                                    UIUserNotificationTypeSound |
                                    UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
                [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    if (notification!=nil) {
        
        notification.fireDate = date;
        
        switch (cycle) {
                
            case RWClockCycleOnce:
                
                notification.repeatInterval = kCFCalendarUnitEra;
                
                break;
                
            case RWClockCycleEveryDay:
                
                notification.repeatInterval = kCFCalendarUnitDay;
                
                break;
                
            case RWClockCycleEveryWeek:
                
                notification.repeatInterval = kCFCalendarUnitWeekday;
                
                break;
                
            default:
                break;
        }
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        notification.alertBody = content;
        
        notification.applicationIconBadgeNumber = 0;
        
        notification.userInfo = @{CLOCK_NAMES:name};
        
        notification.soundName = @"ClockSound2.mp3";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)cancelLocalNotificationWithName:(NSString *)name
{
    NSArray *notifications =
            [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < notifications.count; i++)
    {
        if ([[[notifications[i] valueForKey:@"userInfo"]
                                objectForKey:CLOCK_NAMES] isEqualToString:name])
        {
            [[UIApplication sharedApplication]
                                        cancelLocalNotification:notifications[i]];
        }
    }
}

@end
