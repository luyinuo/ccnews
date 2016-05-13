//
//  DispatchViewController.h
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPushAnimated.h"

@interface DispatchViewController : UIViewController

@property (nonatomic,strong) UIView *preSnapShot;

@property (nonatomic,strong)CLPushAnimated *dispatchObj;


- (BOOL)__shouldAutorotate;

- (NSUInteger)__supportedInterfaceOrientations;

- (BOOL)showPopAction;

@end
