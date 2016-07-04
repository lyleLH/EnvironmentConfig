//
//  ViewController.m
//  EnvironmentConfig
//
//  Created by lyleKP on 16/7/4.
//  Copyright © 2016年 lyleKP. All rights reserved.
//

#import "ViewController.h"
#import "LHEnvManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}




- (IBAction)actionChange:(id)sender {
    
    [[LHEnvManager shareManager] showSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
