//
//  CNSelectViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/24.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNSelectViewController.h"
#import "CNLive1ViewController.h"
#import "update1ViewController.h"
#import "SgrGCD.h"
#import "CNFinishUploadViewController.h"
#import "CNBreakoffViewController.h"
@interface CNSelectViewController ()

@property (nonatomic,strong) CNButton *btn1;
@property (nonatomic,strong) CNButton *btn2;
@property (nonatomic,strong) CNButton *btn3;

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;

@property (nonatomic,strong) UILabel *t1;
@property (nonatomic,strong) UILabel *t2;
@property (nonatomic,strong) UILabel *t3;

@property (nonatomic,strong) UIButton *cancel;

@property (nonatomic,strong) CALayer *aniLayer;

@end

@implementation CNSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *anilayer=[CALayer layer];
    anilayer.frame=CGRectMake(GlobleWidth-IFScreenFit2(80,80), GlobleHeight-IFScreenFit2(86,86), IFScreenFit2(60,60), IFScreenFit2(60,60));
    anilayer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    anilayer.cornerRadius=IFScreenFit2s(30);
    
    [self.view.layer addSublayer:anilayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration	= 0.35;
   // animation.delegate	= self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    
    
    animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.f,1.f,1.f)];
    animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(30.f,30.f,1.f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [anilayer addAnimation:animation forKey:@"startscale"];
    
    self.aniLayer=anilayer;
    self.startButton.hidden=YES;
    UIButton *cancel = [CNButton buttonWithType:UIButtonTypeCustom];
    float marge=IFScreenFitF(7.5,7.5,7.5,7.5);
    [cancel setContentEdgeInsets:UIEdgeInsetsMake(marge, marge, marge, marge)];
    [cancel setImage:[UIImage imageNamed:@"浮动-号.png"] forState:UIControlStateNormal];
    //    cancel.frame=CGRectMake((GlobleWidth-IFScreenFit2s(49+40-15)), (GlobleHeight-IFScreenFit2s(99+33.5)), IFScreenFit2(49,49), IFScreenFit2(33.5,33.5));
    cancel.frame=self.startButton.frame;
    [self.view addSubview:cancel];
    
    
    __weak typeof(self) me=self;
    [cancel handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me doPop];
        [((CNButton *)sender) nonClickButton];
    }];
    self.cancel=cancel;

     [self setUI2];
    /*
    UIVisualEffectView *effectview=[[UIVisualEffectView alloc]
                                    initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    effectview.frame=self.view.bounds;
    [self.view addSubview:effectview];
    
    effectview.alpha=0.f;
    UIView *panne= [self setUI];
    [UIView animateWithDuration:0.45 animations:^{
        effectview.alpha=1.f;
        panne.top=(GlobleHeight-IFScreenFit2(68,68))/2.f;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.45 animations:^{
            self.t1.alpha=self.t2.alpha=self.t3.alpha=1;
        }];
        
        
    }];*/
}

- (void)doPop{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration	= 0.35;
     animation.delegate	= self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    
    
    animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeScale(30.f,30.f,30.f)];
    animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.f,1.f,1.f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.aniLayer addAnimation:animation forKey:@"startscale"];
    [self.btn1 removeFromSuperview];
    [self.btn2 removeFromSuperview];
    [self.btn3 removeFromSuperview];
    [_label1 removeFromSuperview];
    [_label2 removeFromSuperview];
    [_label3 removeFromSuperview];

}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    self.startButton.hidden=NO;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
   
}

- ( void)setUI2{
//    UIView *bgview=[[UIView alloc] initWithFrame:self.view.bounds];
//    bgview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
//    [self.view addSubview:bgview];
    __weak typeof(self) me=self;
    UIButton *cancel=self.cancel;
   
   
    
    self.btn1 = [CNButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 setImage:[UIImage imageNamed:@"播放器未选中.png"] forState:UIControlStateNormal];
    [self.btn1 setImage:[UIImage imageNamed:@"播放器选中.png"] forState:UIControlStateHighlighted];
    self.btn1.frame=CGRectMake(cancel.left+IFScreenFit2s(2), cancel.top-IFScreenFit2s(80),IFScreenFit2(55,55), IFScreenFit2(55,55));
    [self.view addSubview:self.btn1];
    
    self.label1=[[UILabel alloc] init];
   // _label1.backgroundColor=RGB(245, 245, 245);
    _label1.font=CNBold( IFScreenFit2(11.f,11.f));
    _label1.textColor=[UIColor whiteColor];
    _label1.layer.cornerRadius=6.f;
    _label1.frame=CGRectMake(self.btn1.left-IFScreenFit2s(58.f+10.f), 0, IFScreenFit2s(58.f), IFScreenFit2s(23.f));
    _label1.centerY=self.btn1.centerY;
    _label1.textAlignment=NSTextAlignmentCenter;
    _label1.text=@"创建直播";
    [self.view addSubview:_label1];
    
//    [self.btn1 handleControlEvent:UIControlEventTouchDown withBlock:^(id sender) {
//        me.label1.textColor=RGB(0x33, 0x33, 0x3);
//    }];
//    [self.btn1 handleControlEvent:UIControlEventTouchDragOutside withBlock:^(id sender) {
//        me.label1.textColor=RGB(0xaa, 0xaa, 0xaa);
//    }];
    
    [self.btn1 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        me.startButton.hidden=NO;
        [me.view removeFromSuperview];
        [me removeFromParentViewController];
        [me performSelector:@selector(startLive) withObject:nil afterDelay:0.1];
        [((CNButton *)sender) nonClickButton];
        
    }];
    
    self.btn2 = [CNButton buttonWithType:UIButtonTypeCustom];
    [self.btn2 setImage:[UIImage imageNamed:@"本地未选中.png"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"本地.png"] forState:UIControlStateHighlighted];
    self.btn2.frame=CGRectMake(cancel.left+IFScreenFit2s(2), _btn1.top-IFScreenFit2s(55+36),IFScreenFit2(55,55), IFScreenFit2(55,55));
    [self.view addSubview:self.btn2];
    
    self.btn3 = [CNButton buttonWithType:UIButtonTypeCustom];
    [self.btn3 setImage:[UIImage imageNamed:@"录制.png"] forState:UIControlStateNormal];
    [self.btn3 setImage:[UIImage imageNamed:@"录制选中后.png"] forState:UIControlStateHighlighted];
    self.btn3.frame=CGRectMake(cancel.left+IFScreenFit2s(2), _btn2.top-IFScreenFit2s(55+36),IFScreenFit2(55,55), IFScreenFit2(55,55));
    [self.view addSubview:self.btn3];
    
    
    self.label2=[[UILabel alloc] init];
   // _label2.backgroundColor=RGB(245, 245, 245);
    _label2.font=CNBold( IFScreenFit2(11.f,11.f));
    _label2.textColor=[UIColor whiteColor];
    _label2.layer.cornerRadius=6.f;
    _label2.frame=CGRectMake(self.btn2.left-IFScreenFit2s(58.f+10.f), 0, IFScreenFit2s(58.f), IFScreenFit2s(23.f));
    _label2.centerY=self.btn2.centerY;
    _label2.textAlignment=NSTextAlignmentCenter;
    _label2.text=@"本地上传";
    [self.view addSubview:_label2];
    

    [self.btn2 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //me.label2.textColor=RGB(0xaa, 0xaa, 0xaa);
        me.startButton.hidden=NO;
        [me.view removeFromSuperview];
        [me removeFromParentViewController];
        [me performSelector:@selector(localUpload) withObject:nil afterDelay:0.1];
        [((CNButton *)sender) nonClickButton];
    }];
    
    
    [self.btn3 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //me.label2.textColor=RGB(0xaa, 0xaa, 0xaa);
        me.startButton.hidden=NO;
        [me.view removeFromSuperview];
        [me removeFromParentViewController];
        [me performSelector:@selector(usingCamera) withObject:nil afterDelay:0.1];
        [((CNButton *)sender) nonClickButton];
    }];
    
    
    self.label3=[[UILabel alloc] init];
   // _label3.backgroundColor=RGB(245, 245, 245);
    _label3.font=CNBold( IFScreenFit2(11.f,11.f));
    _label3.textColor=[UIColor whiteColor];
    _label3.layer.cornerRadius=6.f;
    _label3.frame=CGRectMake(self.btn3.left-IFScreenFit2s(58.f+10.f), 0, IFScreenFit2s(58.f), IFScreenFit2s(23.f));
    _label3.centerY=self.btn3.centerY;
    _label3.textAlignment=NSTextAlignmentCenter;
    _label3.text=@"启用相机";
    [self.view addSubview:_label3];
    
//    [self.btn3 handleControlEvent:UIControlEventTouchDown withBlock:^(id sender) {
//        me.label3.textColor=RGB(0x33, 0x33, 0x3);
//    }];
//    [self.btn3 handleControlEvent:UIControlEventTouchDragOutside withBlock:^(id sender) {
//        me.label3.textColor=RGB(0xaa, 0xaa, 0xaa);
//    }];

    

    
    
 
    
}



- (UIView *)setUI{
    
    //(GlobleHeight-IFScreenFit2(68,68))/2.f
    UIView *pannelView=[UIView new];
    pannelView.frame=CGRectMake(0, GlobleHeight, GlobleWidth, GlobleHeight-(GlobleHeight-IFScreenFit2(68,68))/2.f);
    [self.view addSubview:pannelView];
    
    
    self.btn1 = [CNButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 setImage:[UIImage imageNamed:@"组-30.png"] forState:UIControlStateNormal];
    self.btn1.frame=CGRectMake(IFFitFloat6(45), 0, IFScreenFit2(68,68), IFScreenFit2(68,68));
    [pannelView addSubview:self.btn1];
    
    UILabel *title=[[UILabel alloc] init];
    title.font=CNFont(13.f);
    title.textColor=[UIColor whiteColor];
    title.textAlignment=NSTextAlignmentCenter;
    title.frame=CGRectMake(self.btn1.left,
                           self.btn1.bottom+19.f, self.btn1.width, 13.f);
    title.text=@"拍摄视频";
    title.alpha=0;
    [pannelView addSubview:title];
    self.t1=title;
    
    self.btn2 = [CNButton buttonWithType:UIButtonTypeCustom];
    [self.btn2 setImage:[UIImage imageNamed:@"本地.png"] forState:UIControlStateNormal];
    self.btn2.frame=
    CGRectMake(self.btn1.right+ (GlobleWidth-3*IFScreenFit2(68,68)-2*IFFitFloat6(45))/2.f, _btn1.top,
               IFScreenFit2(68,68), IFScreenFit2(68,68));
    [pannelView addSubview:self.btn2];
    
    title=[[UILabel alloc] init];
    title.font=CNFont(13.f);
    title.textColor=[UIColor whiteColor];
    title.frame=CGRectMake(self.btn2.left, self.btn2.bottom+19.f, self.btn2.width, 13.f);
    title.textAlignment=NSTextAlignmentCenter;
    title.text=@"本地选取";
    title.alpha=0;
    [pannelView addSubview:title];
    self.t2=title;
    
    self.btn3 = [CNButton buttonWithType:UIButtonTypeCustom];
    [self.btn3 setImage:[UIImage imageNamed:@"bofangqi.png"] forState:UIControlStateNormal];
    self.btn3.frame=
    CGRectMake((GlobleWidth-IFScreenFit2(68,68)-IFFitFloat6(45)), _btn1.top,
               IFScreenFit2(68,68), IFScreenFit2(68,68));
    [pannelView addSubview:self.btn3];
    
    title=[[UILabel alloc] init];
    title.font=CNFont(13.f);
    title.textColor=[UIColor whiteColor];
    title.textAlignment=NSTextAlignmentCenter;
    title.frame=CGRectMake(self.btn3.left, self.btn3.bottom+19.f, self.btn3.width, 13.f);
    title.text=@"拍摄视频";
    title.alpha=0;
    [pannelView addSubview:title];
    self.t3=title;
    __weak typeof(self) me=self;
    [self.btn3 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
     
        [me.view removeFromSuperview];
        [me removeFromParentViewController];
        [me performSelector:@selector(startLive) withObject:nil afterDelay:0.1];
        
        [((CNButton *)sender) nonClickButton];
        
    }];
    
    
    
    CNButton *btn=[CNButton buttonWithType:UIButtonTypeCustom];
    if(self.startButton){
    btn.frame=CGRectMake(0, pannelView.height-IFScreenFit2(45,45), GlobleWidth, IFScreenFit2(45,45));
    }else{
       // CGRect startFrame=[self.view convertRect:self.startButton.frame toView:<#(nullable UIView *)#>];
    }
    
    [btn setBackgroundColor:RGB(147, 146, 146)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [pannelView addSubview:btn];
    
    
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [UIView animateWithDuration:0.35 animations:^{
            me.view.alpha=0.f;
        } completion:^(BOOL finished) {
            [me.view removeFromSuperview];
            [me removeFromParentViewController];
            
        }];
        [((CNButton *)sender) nonClickButton];
    }];
    
    
    
    return pannelView;
    
}

- (void)startLive{
    [[SgrGCD sharedInstance] enMain:^{
        CNLive1ViewController *live=[[CNLive1ViewController alloc] init];
        [[CLPushAnimatedRight sharedInstance] pushController:live];
    }];

}

- (void) localUpload
{
    [[SgrGCD sharedInstance] enMain:^{
        update1ViewController* update = [[update1ViewController alloc] init];
        [[CLPushAnimatedRight sharedInstance] pushController:update];
    }];
}

- (void)usingCamera
{
    [[SgrGCD sharedInstance] enMain:^{
//        CNFinishUploadViewController* finish = [CNFinishUploadViewController alloc];
//        [[CLPushAnimatedRight sharedInstance] pushController:finish];
        
//        CNBreakoffViewController* breakoff = [[CNBreakoffViewController alloc] init];
//        [[CLPushAnimatedRight sharedInstance] pushController:breakoff];
        
        update1ViewController* update = [[update1ViewController alloc] init];
        update.comeFromCamera = YES;
        [[CLPushAnimatedRight sharedInstance] pushController:update];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
