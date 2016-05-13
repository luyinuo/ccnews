//
//  CLNavigationController.h
//  chanlin
//
//  Created by Ryan on 14-10-31.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DispatchViewController.h"
#import "CLPopPanAction.h"

@interface CLNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate,CLPopPanAction>

@property (nonatomic,strong) DispatchViewController *mainController;
@property (nonatomic,unsafe_unretained)BOOL isDispatchLock;
@property (nonatomic,strong)UIPanGestureRecognizer *panGesture;

@end
