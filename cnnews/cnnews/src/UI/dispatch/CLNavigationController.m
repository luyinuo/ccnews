//
//  CLNavigationController.m
//  chanlin
//
//  Created by Ryan on 14-10-31.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "CLNavigationController.h"
#import "DispatchViewController.h"
#import "CLPushAnimatedRight.h"
#import "CLPopPanAction.h"

@interface CLNavigationController()


@property (nonatomic,assign) Protocol *basePop;

@end

@implementation CLNavigationController

- (instancetype)init{
    self=[super init];
    if(self){
        [self setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self=[super initWithRootViewController:rootViewController];
    if(self){
        [self setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad{

    self.basePop=NSProtocolFromString(@"CLPopPanAction");

    self.delegate=self;
    self.panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:self.panGesture];
    self.panGesture.delegate=self;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer{
    
    [((DispatchViewController *)self.topViewController).dispatchObj doPan:recognizer];
//    if(((DispatchViewController *)self.topViewController).pushType==1){
//        [[CLPushAnimatedRight sharedInstance] doPan:recognizer];
//    }else if(((DispatchViewController *)self.topViewController).pushType==2){
//        
//    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint p=[gestureRecognizer velocityInView:self.view];
    
    return fabsf(p.y/p.x)<0.5;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  
    
    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UISwitch class]]) {
        return NO;
    }
      return [self.topViewController isKindOfClass:[DispatchViewController class]]&&
    [((DispatchViewController *)self.topViewController) showPopAction] && (![touch.view isKindOfClass:[UISlider class]]);
        
}

- (BOOL)shouldAutorotate{
   // return NO;
    return [((DispatchViewController *)self.topViewController) __shouldAutorotate];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
   // return UIInterfaceOrientationMaskPortrait;
    return [((DispatchViewController *)self.topViewController) __supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


@end
