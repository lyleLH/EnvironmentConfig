//
//  LHEnvManager.m
//  EnvironmentConfig
//
//  Created by lyleKP on 16/7/4.
//  Copyright © 2016年 lyleKP. All rights reserved.
//

#import "LHEnvManager.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

static NSString *kCachedServicePrefix = @"kCacheServicePrefix";
@implementation LHEnvManager

+ (LHEnvManager *)shareManager {
    static LHEnvManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
    
}


- (void)showSwitch{
    NSMutableArray *prefixs = [self localServicePrefixs].mutableCopy;
    NSMutableArray *purePrefixs = [NSMutableArray array];
    for(NSString * str  in prefixs){
       NSRange range  = [str rangeOfString:@"("];
        [str substringToIndex:range.location];
        [purePrefixs addObject:str];
    }
    NSString *current = [self currentServicePrefix];
    for (NSString *prefix in purePrefixs) {
        if ([current rangeOfString:prefix].location != NSNotFound) {
            current = prefix;
            [prefixs removeObject:prefix];
            break;
        }
    }
    [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow
                    withTitle:@"请选择接口环境"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:[NSString stringWithFormat:@"当前环境:%@", current]
            otherButtonTitles:purePrefixs
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                    if (buttonIndex == actionSheet.destructiveButtonIndex || buttonIndex == actionSheet.cancelButtonIndex) {
                                        return ;
                                    }
                                    NSString *prefix = purePrefixs[buttonIndex-1];
                                    [[[UIAlertView alloc] lh_initWithTitle:@"切换环境"
                                                                   message:[NSString stringWithFormat:@"是否切换环境到%@，这需要重新启动应用，请退出应用",prefix]
                                                          cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        
                                    }]
                                                          otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
                                                                                [self saveServicePrefix:prefix];//保存选择的地址
                                                                                //这里需要加上清除应用中所有保存的信息的操作，因为切换了整体的环境
                                                                                //.......
                                                                                //退出程序
                                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                    exit(0);
                                                                                });
        
                                    }], nil] show];
   
                     }];
}


- (void)saveServicePrefix:(NSString*)prefix {
    [[NSUserDefaults standardUserDefaults] setObject:prefix forKey:kCachedServicePrefix];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)localServicePrefixs{
    return @[
             @"xxxx.xxxx.xxxx.65:8000(开发环境)",
             @"xxxx.xxxx.xxxx.4:8090(测试环境)",
             @"api-3.online.com(预发布环境)",
             @"api-5.online.com(线上环境)",
             ];
}

- (NSString *)currentServicePrefix{
#ifdef kOnlineEnvironment
    return @"http://api-5.kuparts.com/api/";
#endif
    NSString *prefix = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedServicePrefix];
    prefix = prefix.length > 0 ? prefix : [[self localServicePrefixs] firstObject];
    prefix = [NSString stringWithFormat:@"http://%@/api/", prefix];
    NSLog(@"%@",prefix);
    return prefix;
}


- (BOOL)isShowSwitchEnvironment{
#ifdef kOnlineEnvironment
    return NO;
#endif
    return YES;
}


@end
