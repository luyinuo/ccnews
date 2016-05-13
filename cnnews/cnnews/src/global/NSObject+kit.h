//
//  NSObject+kit.h
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DispatchViewController;
@interface NSObject (Kit)

- (NSString *)k_cacheUrl;

- (UINavigationController *)k_rootController;

- (UIWindow *)k_mainWindow;

- (DispatchViewController *)k_currentController;

- (NSString *)k_md5:(NSString *)seed;

- (void)k_showLoginView;

@end
