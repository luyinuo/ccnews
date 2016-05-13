//
//  DispatchViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "DispatchViewController.h"

@interface DispatchViewController ()

@end

@implementation DispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)__shouldAutorotate{
    return NO;
}

- (NSUInteger)__supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)showPopAction{
    return NO;
}

@end
