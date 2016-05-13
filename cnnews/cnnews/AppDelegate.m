//
//  AppDelegate.m
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "AppDelegate.h"
#import "CNMainViewController.h"
#import "CLNavigationController.h"
#import "CLDataModel.h"
#import "CNDataModel.h"
#import "CNUser.h"
#import "CNLoginViewController.h"
#import "CNGlobal.h"
#import "CNCoverView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   
   [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    CNMainViewController *main=[CNMainViewController new];
    CLNavigationController *navi=[[CLNavigationController alloc] initWithRootViewController:main];
    navi.mainController=main;
    UIWindow *mainwindow=[[UIWindow alloc] init];
    mainwindow.frame=[UIScreen mainScreen].bounds;
    self.window=mainwindow;
    self.window.rootViewController=navi;
    
    [self.window makeKeyAndVisible];
    
   
    
    
    if(_isStrNULL([CNUser sharedInstance].userID) ||
       _isStrNULL([CNUser sharedInstance].password) ||
       _isStrNULL([CNUser sharedInstance].sessionId)){
        [CNUser sharedInstance].userID=nil;
        [self k_showLoginView];

        CNCoverView *cover=[[CNCoverView alloc] init];
        cover.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        [[self k_mainWindow] addSubview:cover];
    }

    [CNGlobal sharedInstance].reachability =[JiHReachability reachabilityWithHostName:@"www.apple.com"];
    [[CNGlobal sharedInstance].reachability startNotifier];
    
    return YES;
}

- (void)test{
    NSLog(@"本地网络");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[CNGlobal sharedInstance].reachability stopNotifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:time forKey:@"EnterBackgroundTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if(_isStrNotNull([CNUser sharedInstance].userID)){
        double backTime=[[NSUserDefaults standardUserDefaults] doubleForKey:@"EnterBackgroundTime"];
        NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
        if(fabs(time-backTime)>30*60){
            [[CNDataModel sharedInstance] relogin];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [[CNGlobal sharedInstance].reachability startNotifier];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
