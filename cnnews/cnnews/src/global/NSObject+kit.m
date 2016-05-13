//
//  NSObject+kit.m
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "NSObject+kit.h"
#import "SgrSandbox.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "CNLoginViewController.h"
#import "CLNavigationController.h"


@implementation NSObject (Kit)

- (NSString *)k_cacheUrl{
    return [SgrSandbox libCachePath];
}

- (UINavigationController *)k_rootController{
    return (UINavigationController *)(((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController);
}

- (UIWindow *)k_mainWindow{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
}

- (DispatchViewController *)k_currentController{
    return (DispatchViewController *)[self k_rootController].topViewController;
}

- (NSString *)k_md5:(NSString *)seed{
    if (_isStrNULL(seed)) return @"null";
    const char *str = [seed UTF8String];
    if(!str) return @"null";
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return md5String;
}

- (void)k_showLoginView{
    CNLoginViewController *ln=[CNLoginViewController new];
    ln.view.frame=[self k_mainWindow].bounds;
    [[self k_mainWindow] addSubview:ln.view];
    [((CLNavigationController *)[self k_rootController]).mainController addChildViewController:ln];
}



@end
