//
//  CLSystemPushAnimated.m
//  chanlin
//
//  Created by Ryan on 15-1-29.
//  Copyright (c) 2015年 chanlin. All rights reserved.
//

#import "CLSystemPushAnimated.h"
#import "DispatchViewController.h"

@implementation CLSystemPushAnimated

SGR_DEF_SINGLETION(CLSystemPushAnimated)

- (void)pushController:(DispatchViewController *)controller{
    UINavigationController *root=[self k_rootController];
    controller.dispatchObj=self;
    [root pushViewController:controller animated:YES];

}

- (void)pop{
    UINavigationController *root=[self k_rootController];
    UIViewController *top=root.topViewController;
    if([top respondsToSelector:@selector(willPop)]){
        [top performSelector:@selector(willPop)];
    }
    [root popViewControllerAnimated:YES];
}

@end
