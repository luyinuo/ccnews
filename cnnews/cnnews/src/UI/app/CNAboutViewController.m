//
//  CNAboutViewController.m
//  cnnews
//
//  Created by Ryan on 16/5/2.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNAboutViewController.h"

@interface CNAboutViewController ()

@end

@implementation CNAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigator:nil];
    [self addBackButton];
    [self setNavigatorTitle:@"关于"];
    
    
    self.view.backgroundColor=RGB(245, 245, 245);
    
    UIView *bg=[[UIView alloc] init];
    bg.frame=CGRectMake(0, IFScreenFit2s(50.f)+self.navagator.height, GlobleWidth, IFScreenFit2s(223));
    bg.backgroundColor=RGB(0xdd, 0xe3, 0xee);
    [self.view addSubview:bg];
    bg.layer.borderColor=RGB(0xd7, 0xd7, 0xd7).CGColor;
    bg.layer.borderWidth=0.5;
    
    UIImageView *logo=[UIImageView new];
    logo.frame=CGRectMake((GlobleWidth-IFScreenFit2s(139.f))/2.f, IFScreenFit2s(66), IFScreenFit2s(139.f), IFScreenFit2s(63.5));
    logo.image=[UIImage imageNamed:@"logo字.png"];
    [bg addSubview:logo];
    
    UILabel *label=[UILabel new];
    label.font=CNBold(14);
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"VGC发布";
    label.frame=CGRectMake((GlobleWidth-75.f)/2.f, logo.bottom+IFScreenFit2s(22.f), 75.f, 15.f);
    [bg addSubview:label];
    
    NSString *v=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *label2=[UILabel new];
    label2.font=CNBold(11);
    label2.textColor=RGB(47, 83, 155);
    label2.textAlignment=NSTextAlignmentCenter;
    label2.text=v;
    label2.frame=CGRectMake((GlobleWidth-75.f)/2.f, label.bottom+IFScreenFit2s(9.f), 75.f, 15.f);
    [bg addSubview:label2];


    
}

- (BOOL)showPopAction{
    return YES;
}




@end
