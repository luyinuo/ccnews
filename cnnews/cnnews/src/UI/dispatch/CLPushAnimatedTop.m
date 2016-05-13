//
//  CLPushAnimatedTop.m
//  chanlin
//
//  Created by Ryan on 14-11-9.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "CLPushAnimatedTop.h"
#import "NSObject+kit.h"
#import "DispatchViewController.h"


@implementation CLPushAnimatedTop

SGR_DEF_SINGLETION(CLPushAnimatedTop)

- (UINavigationController *)preparePush:(DispatchViewController *)controller{
    DispatchViewController *top=[self topViewController];
    UINavigationController *root=[self k_rootController];
    controller.preSnapShot=[top.view snapshotViewAfterScreenUpdates:NO];
    controller.preSnapShot.frame=root.view.bounds;
    [root.view.superview insertSubview:controller.preSnapShot belowSubview:root.view];
    CGRect frame=root.view.frame;
    frame.origin.y=-frame.size.height;
    root.view.frame=frame;
    [self doNavigationPuhs:controller];
    return root;
    
}

- (void)pushController:(DispatchViewController *)controller{
    [super pushController:controller];
    self.moveStatus=Dispatch_Animation_status_decelerate;
    UINavigationController *root=[self preparePush:controller];
    
    [UIView animateWithDuration:DispatchAnimationBase_animationTime animations:^{
        CGRect frame1=root.view.frame;
        frame1.origin.y=0.0f;
        root.view.frame=frame1;
    } completion:^(BOOL finished) {
        [self clearPush:controller];
        self.moveStatus=Dispatch_Animation_status_ready;
    }];
    
}

- (void)popTop{
    [super pop];
    self.moveStatus=Dispatch_Animation_status_decelerate;
    DispatchViewController *top=[self topViewController];
    UINavigationController *root=[self k_rootController];
    
    CGRect currentFrame=root.view.frame;
        currentFrame.origin.x=0;
    top.preSnapShot.frame=currentFrame;
    [root.view.superview insertSubview:top.preSnapShot belowSubview:root.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect currentFrame1=root.view.frame;
        currentFrame1.origin.y=-currentFrame.size.height;
        root.view.frame=currentFrame1;
    } completion:^(BOOL finished) {
        [self doNavigationPop];
        UIViewController *rootCtrl=root;
        CGRect frame = rootCtrl.view.frame;
        frame.origin.y = 0;
        rootCtrl.view.frame = frame;
        [top.preSnapShot removeFromSuperview];
        self.moveStatus=Dispatch_Animation_status_ready;
    }];

}

- (void)popTop:(void (^)(BOOL finish)) block before:(void (^)(void)) block2{
    [super pop];
    self.moveStatus=Dispatch_Animation_status_decelerate;
    DispatchViewController *top=[self topViewController];
    UINavigationController *root=[self k_rootController];
    
    CGRect currentFrame=root.view.frame;
    currentFrame.origin.x=0;
    top.preSnapShot.frame=currentFrame;
    [root.view.superview insertSubview:top.preSnapShot belowSubview:root.view];
    if(block2)block2();
    [UIView animateWithDuration:DispatchAnimationBase_animationTime animations:^{
        CGRect currentFrame1=root.view.frame;
        currentFrame1.origin.y=-currentFrame.size.height;
        root.view.frame=currentFrame1;
    } completion:^(BOOL finished) {
        [self doNavigationPop];
        UIViewController *rootCtrl=root;
        CGRect frame = rootCtrl.view.frame;
        frame.origin.y = 0;
        rootCtrl.view.frame = frame;
        [top.preSnapShot removeFromSuperview];
        if(block)block(finished);
        self.moveStatus=Dispatch_Animation_status_ready;
    }];
    
}

@end
