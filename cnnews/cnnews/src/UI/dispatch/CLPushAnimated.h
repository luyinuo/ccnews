//
//  CLPushAnimated.h
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Dispatch_distance_x1 0.25f
#define Dispatch_distance_x2 0.75f
#define Dispatch_navScaleRate 0.95f
#define DispatchPopMaskAlpha 0.2f

#define IFDPSAnimationDistance IFFitFloat(50)
#define IFDPSAnimationDistanceNav IFFitFloat(50)
#define IFDPSPanPushAnimationFromRightDistance IFFitFloat(100)

#define DispatchAnimationBase_animationTime 0.35f

#define DispatchAnimationBase_animationTimeNav 0.3f

typedef enum {
    Dispatch_Animation_status_ready,
    Dispatch_Animation_status_Move,
    Dispatch_Animation_status_decelerate
} CLPushAnimated_Animation_status;

@class DispatchViewController;
@interface CLPushAnimated : NSObject


@property (nonatomic,unsafe_unretained) CLPushAnimated_Animation_status moveStatus;

SGR_SINGLETION(CLPushAnimated)

- (DispatchViewController *)topViewController;

- (void)doNavigationPuhs:(DispatchViewController *)ctrl;

- (void)doNavigationPop;

- (void)pushController:(DispatchViewController *)controller;

- (void)pop;

- (void)doPan:(UIPanGestureRecognizer *)recognizer;

- (UINavigationController *)preparePush:(DispatchViewController *)controller;

- (void)clearPush:(DispatchViewController *)controller;

- (float)timeLeft:(float)dis;

@end
