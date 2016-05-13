//
//  CNGlobal.m
//  ccnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNGlobal.h"
#import <UIkit/UIKit.h>

@implementation CNGlobal

SGR_DEF_SINGLETION(CNGlobal)

+ (BOOL)systemVersionAtLeastIOS8
{
    BOOL iOS8 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0?YES:NO;
    return iOS8;
}

+ (void)didChangeToInterfaceOrientationPortrait
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



@end
