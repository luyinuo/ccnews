//
//  CNMainViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNMainViewController.h"
#import "CNScrollView.h"
#import "CNNavViewController.h"
#import "PanPushAnimationNavLeft.h"
#import "CNIndexViewController.h"
#import "CNSelectViewController.h"
#import "SgrGCD.h"
#import "CNDataModel.h"

@interface CNMainViewController ()


@property (nonatomic,strong) CNScrollView *scrollView;

@property (nonatomic,strong) CNNavViewController *navCtrl;

@property (nonatomic, strong) PanPushAnimationNavLeft *panpushAnimation;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) CNButton *button1;
@property (nonatomic,strong) CNButton *button2;

@property (nonatomic,strong) CNButton *addButton;

@property (nonatomic,strong) CNIndexViewController *index1;
@property (nonatomic,strong) CNIndexViewController *index2;

@property (nonnull,strong) UIView *p1;
@property (nonnull,strong) UIView *p2;

@end

@implementation CNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigator:nil];
    self.scrollView=[[CNScrollView alloc] init];
    self.scrollView.frame=CGRectMake(0, self.navagator.bottom, GlobleWidth, GlobleHeight-self.navagator.height);
    self.scrollView.contentSize=CGSizeMake(GlobleWidth*2, self.scrollView.height);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.bounces=NO;
    [self.view addSubview:self.scrollView];
    
    self.scrollView.backgroundColor=[UIColor whiteColor];
    
    
    CNIndexViewController *index1=[[CNIndexViewController alloc] init];
    index1.category=@"video";
    index1.view.frame=CGRectMake(0, 0, GlobleWidth, self.scrollView.height);
    [self.scrollView addSubview:index1.view];
    [self addChildViewController:index1];
    _scrollView.scrollsToTop=NO;
    index1.tableView.scrollsToTop=YES;
    
    self.index1=index1;
    
    CNIndexViewController *index2=[[CNIndexViewController alloc] init];
    index2.category=@"live";
    index2.view.frame=CGRectMake(GlobleWidth, 0, GlobleWidth, self.scrollView.height);
    [self.scrollView addSubview:index2.view];
    [self addChildViewController:index2];
    index2.tableView.scrollsToTop=NO;
    self.index2=index2;

    
    
    [self addNavagatorView];
    
    self.addButton=[CNButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame=CGRectMake(GlobleWidth-IFScreenFit2(80,80), GlobleHeight-IFScreenFit2(86,86), IFScreenFit2(60,60), IFScreenFit2(60,60));
    [self.addButton setImage:[UIImage imageNamed:@"未选中状态悬浮.png"] forState:UIControlStateNormal];
    //[self.addButton setImage:[UIImage imageNamed:@"悬浮选中状态.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.addButton];
    
    __weak typeof(self) me=self;
    [self.addButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        CNSelectViewController *select=[CNSelectViewController new];
        select.startButton=sender;
        select.view.frame=me.view.bounds;
        [me.view addSubview:select.view];
        [me addChildViewController:select];
        [((CNButton *)sender) nonClickButton];
        
        
       // [[CNDataModel sharedInstance] saveLocalUploadWithId:@"w123534" title:@"3232" cover:nil pics:3 videos:3];
    }];
    
    if(!self.panpushAnimation){
        self.panpushAnimation=[PanPushAnimationNavLeft sharedInstance];
        //self.panpushAnimation.linkType=@"navLeft";// settings
        // self.panpushAnimation.animationType=Dispatch_AnimationType_presentFromLeftNav;
        // self.panpushAnimation.pathName=@"navLeft";// navLeft
        // self.panpushAnimation.backTarget=self;
        CNNavViewController *nav=[CNNavViewController alloc];
        [self.panpushAnimation addNextControllerByType:nav];
    }
    
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(doPanGesture:)];

    
   // self.navCtrl=[CNNavViewController new];
    
    
//    if(_isStrNotNull([CNUser sharedInstance].userID)){
//        __weak typeof(self) me=self;
//        [[SgrGCD sharedInstance] enMain:^{
//            [me reloadData];
//        }];
//        
//        
//    }
    
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:CNUserLoginsuccess object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(reloadData) name:CNUserLoginsuccess object:nil];
}


- (void)reloadData{
    [self.index1 setFetchUser];
    [self.index2 setFetchUser];
    
    [self performSelector:@selector(doReloadData) withObject:nil afterDelay:0.3];
}

- (void)doReloadData{
    __weak typeof(self) me=self;
    [me.index1 reloadData];
    [me.index2 reloadData];
//    [self.index1 reloadData:^{
//        [me.index2 reloadData:nil];
//    }];

}



- (void)viewDidAppear:(BOOL)animated{
    if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft||
       [UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight){
        [CNGlobal didChangeToInterfaceOrientationPortrait];
    }
}

- (BOOL)__shouldAutorotate{
    return ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft||
            [UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight);
}

- (NSUInteger)__supportedInterfaceOrientations{

        return UIInterfaceOrientationMaskPortrait;

}


- (void)addNavagatorView{
    
    CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
    [button setImageEdgeInsets:UIEdgeInsetsMake(IFScreenFit2(10.f ,10.f), IFScreenFit2(10.f ,10.f), IFScreenFit2(10.f ,10.f), IFScreenFit2(10.f ,10.f))];
    button.frame=CGRectMake(IFScreenFit2(14,14), (CCTopHeight-20-IFScreenFit2(33,33))/2.f+20, IFScreenFit2(39,39), IFScreenFit2(33,33));
    [button setImage:[UIImage imageNamed:@"导航按钮.png"] forState:UIControlStateNormal];
    [self.navagator addSubview:button];
    
    [self setNavigatorTitle:@"我的视频"];
    
    
    UIView *p1=[UIView new];
    p1.frame=CGRectMake((GlobleWidth-IFScreenFit2s(11))/2.f, self.navagator.height-IFScreenFit2s(10),IFScreenFit2s(4) , IFScreenFit2s(4));
    p1.layer.cornerRadius=IFScreenFit2s(2);
    p1.backgroundColor=RGB(247, 162, 0);
    [self.navagator addSubview:p1];
    self.p1=p1;
    
    
    UIView *p2=[UIView new];
    p2.frame=CGRectMake(p1.right+IFScreenFit2s(3.f), self.navagator.height-IFScreenFit2s(10),IFScreenFit2s(4) , IFScreenFit2s(4));
    p2.layer.cornerRadius=IFScreenFit2s(2);
    p2.backgroundColor=RGB(169, 170, 171);
    [self.navagator addSubview:p2];
    self.p2=p2;
    
    
    __weak typeof(self) me=self;
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.panpushAnimation pushDirectly];
    }];
//
//    
//    UIView *scroll=[[UIView alloc] init];
////    scroll.scrollsToTop=NO;
////    scroll.pagingEnabled=YES;
////    scroll.bounces=NO;
//    scroll.frame=CGRectMake((GlobleWidth-IFScreenFit2(150.f,150.f))/2.f, 20.f, IFScreenFit2(190.f,190.f), self.navagator.height-20.f);
//  
//    CNButton *button1=[CNButton buttonWithType:UIButtonTypeCustom];
//    button1.frame=CGRectMake(0, 0, IFScreenFit2(80.f,80.f), scroll.height);
//    button1.titleLabel.font=CNFont(IFScreenFit2(14.f,14.f));
//    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    button1.titleLabel.textAlignment=NSTextAlignmentLeft;
//    [button1 setTitle:@"VGC视频" forState:UIControlStateNormal];
//    [scroll addSubview:button1];
//    self.button1=button1;
//    
//    CNButton *button2=[CNButton buttonWithType:UIButtonTypeCustom];
//    
//  
//    button2.frame=CGRectMake(0, 0, IFScreenFit2(80.f,80.f), scroll.height);
//    button2.titleLabel.font=CNFont(IFScreenFit2(14.f,14.f));
//    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button2.titleLabel.textAlignment=NSTextAlignmentRight;
//    [button2 setTitle:@"VGC直播" forState:UIControlStateNormal];
//    button2.left=IFScreenFit2(80.f,80.f);
//    button2.alpha=0.5;
//    self.button2=button2;
//    [scroll addSubview:button2];
//    
//  //  scroll.delegate=self;
//    [self.navagator addSubview:scroll];
//    
//    self.line=[UIView new];
//    self.line.frame=CGRectMake(IFScreenFit2(10.f,10.f), button2.height-IFScreenFit2(4.f,4.f), IFScreenFit2(60.f,60.f), IFScreenFit2(4.f,4.f));
//    self.line.backgroundColor=RGB(29, 130, 192);
//    [scroll addSubview:self.line];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(!decelerate){
        CGRect rect;
        if(scrollView.contentOffset.x>=GlobleWidth){
            rect=CGRectMake(IFScreenFit2(90.f,90.f), self.navagator.height-20.f-IFScreenFit2(4.f,4.f), IFScreenFit2(60.f,60.f), IFScreenFit2(4.f,4.f));
            self.button1.alpha=0.5;
            self.button2.alpha=1;
            self.index1.tableView.scrollsToTop=NO;
            self.index2.tableView.scrollsToTop=YES;
            [self setNavigatorTitle:@"我的直播"];
            _p2.backgroundColor=RGB(247, 162, 0);
            _p1.backgroundColor=RGB(169, 170, 171);

        }else{
            rect=CGRectMake(IFScreenFit2(10.f,10.f), self.navagator.height-20.f-IFScreenFit2(4.f,4.f), IFScreenFit2(60.f,60.f), IFScreenFit2(4.f,4.f));
            self.button1.alpha=1;
            self.button2.alpha=0.5;
            self.index1.tableView.scrollsToTop=YES;
            self.index2.tableView.scrollsToTop=NO;
            [self setNavigatorTitle:@"我的视频"];
            _p1.backgroundColor=RGB(247, 162, 0);
            _p2.backgroundColor=RGB(169, 170, 171);
        }
        //self.line.frame=rect;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect rect;
    if(scrollView.contentOffset.x>=GlobleWidth){
        rect=CGRectMake(IFScreenFit2(90.f,90.f), self.navagator.height-20.f-IFScreenFit2(4.f,4.f), IFScreenFit2(60.f,60.f), IFScreenFit2(4.f,4.f));
        self.button1.alpha=0.5;
        self.button2.alpha=1;
        self.index1.tableView.scrollsToTop=NO;
        self.index2.tableView.scrollsToTop=YES;
        [self setNavigatorTitle:@"我的直播"];
        _p2.backgroundColor=RGB(247, 162, 0);
        _p1.backgroundColor=RGB(169, 170, 171);
        
    }else{
        rect=CGRectMake(IFScreenFit2(10.f,10.f), self.navagator.height-20.f-IFScreenFit2(4.f,4.f), IFScreenFit2(60.f,60.f), IFScreenFit2(4.f,4.f));
        self.button1.alpha=1;
        self.button2.alpha=0.5;
        self.index1.tableView.scrollsToTop=YES;
        self.index2.tableView.scrollsToTop=NO;
        [self setNavigatorTitle:@"我的视频"];
        _p1.backgroundColor=RGB(247, 162, 0);
        _p2.backgroundColor=RGB(169, 170, 171);
        
    }
  //  self.line.frame=rect;

}



- (void)doPanGesture:(UIPanGestureRecognizer *)recognizer {
    
    
    if (_scrollView.contentOffset.x <= 0){
        // 拖出设置页
        [self.panpushAnimation doAnimation:recognizer];
        //[Globle shareInstance].willPopToSet = YES;
        
        
    }else{
        [self.panpushAnimation cancleImmdiatelay];
        
    }
}

@end
