//
//  CNLoadingView.m
//  cnnews
//
//  Created by Ryan on 16/5/2.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNLoadingView.h"

@implementation CNLoadingView

- (void)setUp:(NSString *)title{
    self.backgroundColor=RGB(245, 246, 247);
    self.layer.cornerRadius=4.f;
    self.frame=CGRectMake(0, 0, IFScreenFit2s(250.f), IFScreenFit2s(70.f));
    self.layer1=[CALayer layer];
    self.layer1.frame=CGRectMake(IFScreenFit2s(250-(36+44))/2.f, 15, IFScreenFit2s(12), IFScreenFit2s(12));
    [self.layer addSublayer:self.layer1];
    
    self.layer2=[CALayer layer];
    self.layer2.frame=CGRectMake(self.layer1.frame.origin.x+IFScreenFit2s(34.f), 15, IFScreenFit2s(12), IFScreenFit2s(12));
    [self.layer addSublayer:self.layer2];
    
    self.layer3=[CALayer layer];
    self.layer3.frame=CGRectMake(self.layer2.frame.origin.x+IFScreenFit2s(34.f), 15, IFScreenFit2s(12), IFScreenFit2s(12));
    [self.layer addSublayer:self.layer3];
    
    
    NSArray *valuesArray = [NSArray arrayWithObjects:
                            (id)[UIImage imageNamed:@"橙色加号.png"].CGImage,
                            (id)[UIImage imageNamed:@"灰色加.png"].CGImage,
                            (id)[UIImage imageNamed:@"灰色加.png"].CGImage,nil];
    NSArray *keyTimesArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.15],
                              [NSNumber numberWithFloat:0.3],
                             [NSNumber numberWithFloat:0.45],nil];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    // animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 0.45;
    animation.values = valuesArray;
    animation.keyTimes = keyTimesArray;

    animation.repeatCount=HUGE_VALF;
    animation.autoreverses = YES;
    [self.layer1 addAnimation:animation forKey:@"animation"];
    
    
    NSArray *valuesArray2 = [NSArray arrayWithObjects:
                            (id)[UIImage imageNamed:@"灰色加.png"].CGImage,
                            (id)[UIImage imageNamed:@"橙色加号.png"].CGImage,
                            (id)[UIImage imageNamed:@"灰色加.png"].CGImage,nil];
    NSArray *keyTimesArray2 = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.15],
                              [NSNumber numberWithFloat:0.3],
                              [NSNumber numberWithFloat:0.45],nil];
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    // animation.calculationMode = kCAAnimationDiscrete;
    animation2.duration = 0.45;
    animation2.values = valuesArray2;
    animation2.keyTimes = keyTimesArray2;
    
    animation2.repeatCount=HUGE_VALF;
    animation2.autoreverses = YES;
    [self.layer2 addAnimation:animation2 forKey:@"animation"];

    
    
    NSArray *valuesArray3 = [NSArray arrayWithObjects:
                            (id)[UIImage imageNamed:@"灰色加.png"].CGImage,
                            (id)[UIImage imageNamed:@"灰色加.png"].CGImage,
                            (id)[UIImage imageNamed:@"橙色加号.png"].CGImage,nil];
    NSArray *keyTimesArray3 = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.15],
                              [NSNumber numberWithFloat:0.3],
                              [NSNumber numberWithFloat:0.45],nil];
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    // animation.calculationMode = kCAAnimationDiscrete;
    animation3.duration = 0.45;
    animation3.values = valuesArray3;
    animation3.keyTimes = keyTimesArray3;
    
    animation3.repeatCount=HUGE_VALF;
    animation3.autoreverses = YES;
    [self.layer3 addAnimation:animation3 forKey:@"animation"];

    
    UILabel *titlelabel=[[UILabel alloc] init];
    titlelabel.font=CNFont(15.f);
    titlelabel.textColor=[UIColor blackColor];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    titlelabel.frame=CGRectMake(0
                           ,self.height-30.f,self.width, 16.f);
    titlelabel.text=title;
    [self addSubview:titlelabel];

    
    
    
}

@end
