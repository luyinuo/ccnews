//
//  CLPushAnimated.m
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "CLPushAnimated.h"
#import "DispatchViewController.h"
#import "CLNavigationController.h"
#import "NSObject+kit.h"

@implementation CLPushAnimated

SGR_DEF_SINGLETION(CLPushAnimated)


- (DispatchViewController *)topViewController{
    return (DispatchViewController *)[self k_rootController].topViewController;
}

- (void)doNavigationPuhs:(DispatchViewController *)ctrl{
    
    UINavigationController *root=[self k_rootController];
    ctrl.dispatchObj=self;
    [root pushViewController:ctrl animated:NO];
}

- (void)doNavigationPop{
    UINavigationController *root=[self k_rootController];
    UIViewController *top=root.topViewController;
    if([top respondsToSelector:@selector(willPop)]){
        [top performSelector:@selector(willPop)];
    }
    [root popViewControllerAnimated:NO];
}

- (void)pushController:(DispatchViewController *)controller{
    ((CLNavigationController *)[self k_rootController]).isDispatchLock=YES;
}

- (void)pop{
    ((CLNavigationController *)[self k_rootController]).isDispatchLock=YES;
}

- (void)doPan:(UIPanGestureRecognizer *)recognizer{
    
}

- (UINavigationController *)preparePush:(DispatchViewController *)controller{
 
    return nil;

}

- (void)clearPush:(DispatchViewController *)controller{
    [controller.preSnapShot removeFromSuperview];
}

- (float)timeLeft:(float)dis{
    if(dis>GlobleWidth) return DispatchAnimationBase_animationTime;
    return (DispatchAnimationBase_animationTime*(dis/GlobleWidth));
}

@end
