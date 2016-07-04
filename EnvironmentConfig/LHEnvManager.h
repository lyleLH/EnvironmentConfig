//
//  LHEnvManager.h
//  EnvironmentConfig
//
//  Created by lyleKP on 16/7/4.
//  Copyright © 2016年 lyleKP. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用以下全局的服务器地址宏定义
 *
 *  @param LHEnvManager <#LHEnvManager description#>
 *
 *  @return <#return value description#>
 */
#define kURL_PREFIX [[LHEnvManager shareManager] currentServicePrefix]


#ifndef kOnlineEnvironment
//#define kOnlineEnvironment
#endif

#ifdef kOnlineEnvironment //线上环境

#define JPushEnv @"Production"
#define EaseMobServer      @"xxxx.xxxx.xxxx.xxxx"

#else //测试或者预发布环境

#define JPushEnv @"Development"
#define EaseMobServer       @"xxxx.xxxx.xxxx.xxxx"

#endif




@interface LHEnvManager : NSObject


+ (LHEnvManager *)shareManager;

- (NSString *)currentServicePrefix;

- (BOOL)isShowSwitchEnvironment;

- (void)showSwitch;


@end
