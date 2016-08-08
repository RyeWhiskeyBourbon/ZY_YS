//
//  RWRequestIndex.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#ifndef RWRequestIndex_h
#define RWRequestIndex_h

#define APP_ID @"1090634268"

#define APP_STORE_URL @"http://itunes.apple.com/cn/lookup?id="APP_ID
#define TO_APP_STORE @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="APP_ID

#define UMengCommunityAppkey @"570f5b55e0f55a7a47001d6f"
#define UMengCommunityAppSecret @"7258ff0a1c61cd0dacb052519e4eff8d"

#define SMSSDK_APPKEY @"fc8d2793f524"
#define SMSSDK_SECRET @"11ce824fe9b3cae301da29eef858222e"

#define MOB_CLICK @"570f5b55e0f55a7a47001d6f"

#define NAV_TITLE @"医师资讯"

#define MAIN_INDEX [NSURL URLWithString:@"http://yx.zhongyuedu.com/list.php?fid=202"]
//>> 资讯
#define SERVERS_INDEX @"http://api.zhongyuedu.com/tik/yx/examType.php"
//>> 题库目录
#define YY_INDEX @"http://www.zhongyuedu.com/api/tk/yx/yy_yx_new_list.php"
//>> 预约列表
#define RECOMMEND @"http://www.zhongyuedu.com/api/tuijian.php"
//>> 推荐列表
#define UPDATE_USERNAME @"http://www.zhongyuedu.com/api/yy_yx_post.php"
//>> 上传
#define EXPERIENCE_TIMES_URL @"http://api.zhongyuedu.com/tik/yx/yx_limit.php"
//>> 天王盖地虎
#define RECEIVE_PUSH @"http://api.zhongyuedu.com/tik/yx/url.php"
//>> push
#define LOGIN_URL @"http://api.zhongyuedu.com/tik/yx/login.php"
//>> 登录
#define REGISTER_URL @"http://api.zhongyuedu.com/tik/yx/register.php"
//>> 注册
#define REPLACE_PASSWORD_URL @"http://api.zhongyuedu.com/tik/yx/change_pwd.php"
//>> 重置密码
#define ABOUT_US @"http://www.zhongyuedu.com/api/tk_aboutUs.htm"
//>> 关于我们
#define README @"http://www.zhongyuedu.com/app/tk_yx/tk_ios_usage.htm"
//>> 使用说明

#define VERIFICATION_PHONENUMBER @"http://api.zhongyuedu.com/comm/code.php"

#endif /* RWRequestIndex_h */
