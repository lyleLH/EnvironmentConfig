# EnvironmentConfig


	点击按钮后，会弹出选择当前app的API接口环境的actionsheet选择，选择后重启app即可生效，使得请求的接口地址变更到选择的环境
	
![image](https://github.com/lyleLH/EnvironmentConfig/blob/master/demo.gif)

	
## 应用场景

### 外部需求
	 测试人员有时候进行功能测试时想要快速查看当前环境，切换多个测试环境
###  内部需求
	常见的做法时将接口环境用宏定义好，变更的时候更改宏的定义新增宏的定义，这样每次都要重新编译或者更改
	有时候跑起来会忘记切换到了哪里，这个做法可以方便查看

	
		
## 原理或者过程
- ### 程序开始运行会检查并读取本地存储的地址文件,第一次运行，本地没有存储指定的接口环境

	```
		- (NSString *)currentServicePrefix;
	```

- ### 会将可能的接口地址(代码中制定的地址列表)存在内存的数组中，之后会选择数组中的第一个环境作为之后的运行环境

	```
		- (NSArray *)localServicePrefixs{
	    return @[
	             @"xxxx.xxxx.xxxx.65:8000(开发环境)",
	             @"xxxx.xxxx.xxxx.4:8090(测试环境)",
	             @"api-3.online.com(预发布环境)",
	             @"api-5.online.com(线上环境)",
	             ];
		}
	```

- ### 将运行的接口环境存储到本地
	
	```
	- (void)saveServicePrefix:(NSString*)prefix {
	    [[NSUserDefaults standardUserDefaults] setObject:prefix forKey:kCachedServicePrefix];
	    [[NSUserDefaults standardUserDefaults] synchronize];
	}

	```

- ### 环境列表出来后会将选择的环境地址存储到本地，并且退出程序

	```
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
	                                    NSString *prefix = prefixs[buttonIndex-1];
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

	```
- ### 下一次启动会从本地文件中读出上次退出时存储的环境