//
//  CLPushAnimatedRight.m
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "CLPushAnimatedRight.h"
#import "DispatchViewController.h"
#import "NSObject+kit.h"
#import "CNUIUtil.h"


@implementation CLPushAnimatedRight

SGR_DEF_SINGLETION(CLPushAnimatedRight)

- (UINavigationController *)preparePush:(DispatchViewController *)controller{
    DispatchViewController *top=[self topViewController];
    UINavigationController *root=[self k_rootController];
    controller.preSnapShot=[top.view snapshotViewAfterScreenUpdates:NO];
    controller.preSnapShot.frame=root.view.bounds;
    [root.view.superview insertSubview:controller.preSnapShot belowSubview:root.view];
    CGRect frame=root.view.frame;
    frame.origin.x=frame.size.width;
    root.view.frame=frame;
    [self doNavigationPuhs:controller];
    return root;
    
}

- (void)pushController:(DispatchViewController *)controller{
    [super pushController:controller];
    self.moveStatus=Dispatch_Animation_status_decelerate;
    //controller.pushType=1;
    UINavigationController *root= [self preparePush:controller];
    [UIView animateWithDuration:DispatchAnimationBase_animationTime
                     animations:^{
                         CGRect frame1=root.view.frame;
                         frame1.origin.x=0;
                         root.view.frame=frame1;
                         frame1.origin.x=-frame1.size.width*Dispatch_distance_x2;
                         controller.preSnapShot.frame=frame1;
                         
                     }
                     completion:^(BOOL finished) {
                         [self clearPush:controller];
                         self.moveStatus=Dispatch_Animation_status_ready;
                     }];
    
}

- (void)pop{
    [super pop];
    self.moveStatus=Dispatch_Animation_status_decelerate;
    [self prepare];
    [self doPop:DispatchAnimationBase_animationTime];
}

- (void)prepare{
    DispatchViewController *top=[self topViewController];
    UINavigationController *root=[self k_rootController];
    
    CGRect currentFrame=root.view.frame;
    float f3_4=currentFrame.size.width*Dispatch_distance_x2;
    currentFrame.origin.x-=f3_4;
    top.preSnapShot.frame=currentFrame;
    [root.view.superview insertSubview:top.preSnapShot belowSubview:root.view];
    
}

- (void)doPop:(float)duration{
    [UIView animateWithDuration:duration
                     animations:^{
                         [self moveViewWithX:GlobleWidth];
                     }
                     completion:^(BOOL finished) {
                         [[self topViewController].preSnapShot removeFromSuperview];
                         UINavigationController *root=[self k_rootController];
                         [self doNavigationPop];
                         CGRect frame = root.view.frame;
                         frame.origin.x = 0;
                         root.view.frame = frame;

                         self.moveStatus=Dispatch_Animation_status_ready;
                         [[CNUIUtil sharedInstance] cleanAnimationLock];
                     }];
}

- (void)moveViewWithX:(float)x{
    
    x = x>GlobleWidth?GlobleWidth:x;
    x = x<0?0:x;
    UIView *naviView=[self k_rootController].view;
    CGRect frame = naviView.frame;
    
    float w=frame.size.width;
    frame.origin.x = x;
    naviView.frame = frame;
    DispatchViewController *top=[self topViewController];
    frame =top.preSnapShot.frame;
    frame.origin.x=-(Dispatch_distance_x2+Dispatch_distance_x1*(x/GlobleWidth))*w+x;
    top.preSnapShot.frame=frame;
}

- (void)cancle:(float)duration{
    [UIView animateWithDuration:duration
                     animations:^{
                         [self moveViewWithX:0];
                     }
                     completion:^(BOOL finished) {
                         [[self topViewController].preSnapShot removeFromSuperview];
                         self.moveStatus=Dispatch_Animation_status_ready;
                         [[CNUIUtil sharedInstance] cleanAnimationLock];
                     }];
}

- (void)doPan:(UIPanGestureRecognizer *)recognizer{
    CGPoint touchPoint=[recognizer locationInView:[self k_mainWindow]];
    if(recognizer.state == UIGestureRecognizerStateBegan){
        
        self.startPoint=touchPoint;
        
        CGPoint v=[recognizer velocityInView:[self k_mainWindow]];
        if(self.moveStatus==Dispatch_Animation_status_ready &&
           v.x>0 &&
           fabsf(v.y/v.x)<0.5f&&
           [[CNUIUtil sharedInstance] checkAnimationLock:self]){
            [self prepare];
            self.moveStatus=Dispatch_Animation_status_Move;
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded ){
        if(self.moveStatus==Dispatch_Animation_status_Move){
            if (touchPoint.x - self.startPoint.x > IFDPSAnimationDistance){
                float dis=fabsf(touchPoint.x - self.startPoint.x);
                
                [self doPop:dis>GlobleWidth?0.1f:((GlobleWidth-dis)/GlobleWidth)*DispatchAnimationBase_animationTime];
            }else{
          
                [self cancle:DispatchAnimationBase_animationTime/2];
            }
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
        
        
        
    } else if(recognizer.state==UIGestureRecognizerStateCancelled ){
        if(self.moveStatus==Dispatch_Animation_status_Move){
            [self cancle:DispatchAnimationBase_animationTime/2];
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
        
        
    }
    
    if(self.moveStatus==Dispatch_Animation_status_Move){
        
        [self moveViewWithX:touchPoint.x-self.startPoint.x];
    }
}

@end
