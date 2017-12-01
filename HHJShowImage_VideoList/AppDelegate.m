//
//  AppDelegate.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/27.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import "BHService_HHJShowImage_VideoList.h"
#import "BHTimeProfiler.h"
#import <mach-o/dyld.h>
#import "BHModuleManager.h"
#import "BHServiceManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [BHContext shareInstance].application = application;
    [BHContext shareInstance].launchOptions = launchOptions;
//    [BHContext shareInstance].moduleConfigName = @"BeeHive.bundle/BeeHive";//可选，默认为BeeHive.bundle/BeeHive.plist
//    [BHContext shareInstance].serviceConfigName = @"BeeHive.bundle/BHService";
    
    [BeeHive shareInstance].enableException = YES;
    [[BeeHive shareInstance] setContext:[BHContext shareInstance]];
    [[BHTimeProfiler sharedTimeProfiler] recordEventTime:@"BeeHive::super start launch"];
    
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[RootViewController new]];
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
