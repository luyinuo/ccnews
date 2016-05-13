//
//  CNCoverView.m
//  cnnews
//
//  Created by Ryan on 16/5/12.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNCoverView.h"

@implementation CNCoverView

- (instancetype)init{
    self=[super init];
    if(self){
        [self setUP];
    }
    
    return self;
    
}

- (void)setUP{
    self.backgroundColor=RGB(10.f, 12.f, 33.f);
    
    
    
    UIImageView *bgView=[[UIImageView alloc] init];
    bgView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
    bgView.contentMode=UIViewContentModeScaleAspectFill;
    bgView.image=[UIImage imageNamed:@"登录背景.png"];
    [self addSubview:bgView];
    
    UIImageView *logo=[[UIImageView alloc] init];
    //    logo.width=0.6*GlobleWidth;
    //    float h=(127.f/278.f)*logo.width;
    //
    //    logo.height=h;
    //    logo.center=self.bgView.center;
//    logo.frame=CGRectMake((GlobleWidth-IFScreenFit2s(79.5*0.8))/2.f, IFFitFloat6(200-80-22.5), IFScreenFit2s(79.5*0.8), IFScreenFit2s(67*0.8));
    
    logo.frame=CGRectMake(0, 0, 268.7, 174.2);
    logo.center=bgView.center;
    
    logo.contentMode=UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"小楼.png"];
    [bgView addSubview:logo];
    self.logo=logo;
    
    UIImageView *text=[[UIImageView alloc] init];
    text.alpha=0;
    text.image=[UIImage imageNamed:@"央视新闻+.png"];
    text.frame=CGRectMake((GlobleWidth-IFScreenFit2s(90.5*0.8))/2.f, logo.bottom, IFFitFloat6(90.5*0.8), IFFitFloat6(22.5*0.8));
    
    [bgView addSubview:text];
    self.text=text;
    
    UILabel *label1=[[UILabel alloc] init];
    // _label1.backgroundColor=RGB(245, 245, 245);
    label1.font=[UIFont systemFontOfSize:12.f];
    label1.textColor=[UIColor whiteColor];
  
    label1.frame=CGRectMake(0, 0, 240.f, 21.f);
    label1.center=CGPointMake(bgView.center.x, bgView.center.y*1.9);

    label1.textAlignment=NSTextAlignmentCenter;
    label1.text=@"Copyright © 2016 央视新闻 保留所有权利";
    [bgView addSubview:label1];


}

- (void)doAnimation{
    
    [UIView animateWithDuration:1.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.logo.frame=CGRectMake((GlobleWidth-IFScreenFit2s(79.5*0.8))/2.f, IFFitFloat6(200-80-22.5), IFScreenFit2s(79.5*0.8), IFScreenFit2s(67*0.8));
    } completion:^(BOOL finished) {
        self.text.alpha=1;
        [self removeFromSuperview];
    }];
    
    
 
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    if(newWindow){
        if(self.animationed==NO){
            [self doAnimation];
            self.animationed=YES;
        }
    }
}


@end
