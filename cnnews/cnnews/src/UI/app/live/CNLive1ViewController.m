//
//  CNLive1ViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/24.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNLive1ViewController.h"
#import "IFLocationManager.h"
#import "CNDataModel.h"
#include "TTLiveSDK.h"
#import "SgrGCD.h"
#import "SgrWeakTarget.h"
#import "CNLoadingView.h"
#import <CoreMotion/CoreMotion.h>

@interface CNLive1ViewController ()<TTLiveStreamerDelegate>

@property (nonatomic,strong)TTLiveStreamer * streamer;
//@property (nonatomic, assign) int               bitrate;
//@property (nonatomic, assign) int               fps;

@property (nonatomic,strong)UIView * canvasView;
@property (nonatomic,assign)LiveAudioSource audioSourceType;

@property (nonatomic,strong)UIView *optionsView;//操作面板

@property (nonatomic,assign)BOOL useAutoEstimateBitrate;//自动切换码率
@property (nonatomic,assign)BOOL useDebugMode;

@property (nonatomic,strong)NSString *pushUrl;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign) float liveTime;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,strong) NSString *liveCode;
@property (nonatomic,strong) UIView *codeView;
@property (nonatomic,strong) UIView *tools;
@property (nonatomic,strong) UIView *cover;
@property (nonatomic,assign) BOOL isInLive;
@property (nonatomic,strong) CNButton *liveBackButton;
@property (nonatomic,strong) UIView *errorView;

@property (nonatomic,strong) UIView *loadingModel;
@property (nonatomic,assign)BOOL istransform;
@property (nonatomic,assign)BOOL istransformError;
@property (nonatomic,strong) UIImageView *showTie;

@property (nonatomic,assign) int errorCountTime;

@property (nonatomic,assign) UIInterfaceOrientation orientationLast;
@property (nonatomic,assign) UIDeviceOrientation deviceOrenLast;

@property (nonatomic,strong)CMMotionManager *motionManager;

@property (nonatomic,assign) BOOL ignorOnce;

//@property (nonatomic,assign)
//------------------------------------------------

@property (nonatomic,strong)UIView *oneView;
@property (nonatomic,strong)UIView *twoView;

@property (nonatomic,strong) UIScrollView *firstView;

@property (nonatomic,strong) UITextField *filed1;
@property (nonatomic,strong) UITextField *filed2;
@property (nonatomic,strong) UIImageView *changeImg;
@property (nonatomic,strong) UILabel *field3;

@property (nonatomic,assign) int test;

@property (nonatomic,strong) IFLocationManager *location;

@property (nonatomic,strong) CNButton *comfirm;

@property (nonatomic,assign) BOOL isStop;



@end

@implementation CNLive1ViewController

- (void)dealloc{
   [self.loadingModel removeFromSuperview];
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.motionManager stopGyroUpdates];
    [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"idleTimerDisabled"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
 
    if(0== [[change sgrGetNumberForKey:@"new"] intValue]){
        [[SgrGCD sharedInstance] enMain:^{
        
           // [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew context:nil];
    
    if(_isStrNULL(self.pushUrl)){
    
        self.oneView=[UIView new];
        self.oneView.frame=self.view.bounds;
        [self.view addSubview:self.oneView];
    
        [self createNavigator:self.oneView];
        [self addBackButton];
        [self setNavigatorTitle:@"准备直播"];
        [self setLiveInfoUI];
    }else{
        self.isInLive=YES;
        [self showLoadingModel:@"正在连接直播信号中..." subTitle:@"您的直播正在准备继续，请稍候......"];
        
        [self setUPLiveUI];
    }
    
  //
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(orientationChanged:)
//     name:UIDeviceOrientationDidChangeNotification
//     object:[UIDevice currentDevice]];

    
    
}

- (void)setPushUrl:(NSString *)pushUrl andLiveCode:(NSString *)code{
    self.pushUrl=pushUrl;
    self.liveCode=code;
}

- (void)disKeyboard{
    [self.filed1 resignFirstResponder];
    [self.filed2 resignFirstResponder];
}

- (void)setLiveInfoUI{
    self.firstView=[UIScrollView new];
    self.firstView.showsVerticalScrollIndicator=NO;
    self.firstView.showsHorizontalScrollIndicator=NO;
    self.firstView.bounces=NO;
    self.firstView.backgroundColor=RGB(245, 245, 245);
    self.firstView.frame=CGRectMake(0, CCTopHeight, GlobleWidth, GlobleHeight-CCTopHeight);
    self.firstView.userInteractionEnabled=YES;
    [self.oneView addSubview:self.firstView];
    
    CNButton *bgButton=[CNButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame=self.firstView.bounds;
    [self.firstView addSubview:bgButton];
    __weak typeof(self) me=self;
    [bgButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.filed1 resignFirstResponder];
        [me.filed2 resignFirstResponder];
        [((CNButton *)sender) nonClickButton];
    }];
    
//    self.view.userInteractionEnabled=YES;
//    UITapGestureRecognizer *tap=[UITapGestureRecognizer alloc];
//    [tap addTarget:self action:@selector(disKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
//    UILabel *bitian=[UILabel new];
//    bitian.font=CNFont(IFScreenFit2(17,17));
//    bitian.textColor=RGB(49, 67, 118);
//    bitian.text=@"·必填·";
//    bitian.frame=CGRectMake(IFScreenFit2(25.f,25.f), IFScreenFit2(27.f,27.f), IFScreenFit2(80.f,80.f), IFScreenFit2(25.f,25.f));
//    [self.firstView addSubview:bitian];
    
    
    UIImageView *icon1=[[UIImageView alloc] init];
    icon1.image=[UIImage imageNamed:@"标题.png"];
    icon1.frame=CGRectMake(IFScreenFit2s(23.f), IFScreenFit2s(24.f), IFScreenFit2s(11.f), IFScreenFit2s(12.5));
    [self.firstView addSubview:icon1];
    
    UILabel *l1=[UILabel new];
    l1.frame=CGRectMake(icon1.right+IFScreenFit2s(15.f), icon1.top, IFScreenFit2(30.f,30.f), IFScreenFit2(15.f,15.f));
    l1.font=CNBold(IFScreenFit2(15.f,15.f));
    l1.textColor=RGB(144, 144, 144);
    l1.text=@"标题";
    [self.firstView addSubview:l1];
    
    UITextField *filed1=[[UITextField alloc] init];
    filed1.textColor=[UIColor blackColor];
   // filed1.keyboardType=UIKeyboardTypeASCIICapable;
    filed1.font=CNBold(IFScreenFit2(15.f,15.f));
    filed1.frame=
    CGRectMake(l1.right+IFScreenFit2s(15.f), icon1.top-IFScreenFit2s(7),
               GlobleWidth-(l1.right+IFScreenFit2s(15.f))-IFScreenFit2(10,10), IFScreenFit2(31.f,31.f));
    filed1.placeholder=@"16字以内，必填";
    filed1.delegate=self;
    [self.firstView addSubview:filed1];
    self.filed1=filed1;
    
    UIImageView *line=[UIImageView new];
    line.frame=CGRectMake(l1.left, l1.bottom+IFScreenFit2(10.f,10.f), GlobleWidth-l1.left, 0.5f);
    line.backgroundColor=RGB(170, 170, 170);
    //line.image=[UIImage imageNamed:@"分栏线.png"];
    [self.firstView addSubview:line];
    
    
    
    
    UIImageView *icon2=[[UIImageView alloc] init];
    icon2.image=[UIImage imageNamed:@"地理位置.png"];
    icon2.frame=CGRectMake(IFScreenFit2s(23.f), icon1.bottom+IFScreenFit2s(35.f), IFScreenFit2s(11.f), IFScreenFit2s(12.5));
    [self.firstView addSubview:icon2];
    
    UILabel *l2=[UILabel new];
    l2.frame=CGRectMake(icon2.right+IFScreenFit2s(15.f), icon2.top, IFScreenFit2(60.f,60.f), IFScreenFit2(15.f,15.f));
    l2.font=CNBold(IFScreenFit2(15.f,15.f));
    l2.textColor=RGB(144, 144, 144);
    l2.text=@"地理位置";
    [self.firstView addSubview:l2];
    
    UITextField *filed2=[[UITextField alloc] init];
    filed2.textColor=[UIColor blackColor];
    filed2.font=CNBold(IFScreenFit2(15.f,15.f));
    filed2.frame=
    CGRectMake(l2.right+IFScreenFit2s(15.f), icon2.top-IFScreenFit2s(7),
               GlobleWidth-(l2.right+IFScreenFit2s(15.f))-IFScreenFit2(40,40), IFScreenFit2(31.f,31.f));
    filed2.placeholder=@"50字以内，必填";
    filed2.delegate=self;
    [self.firstView addSubview:filed2];
    self.filed2=filed2;
    
   
    
    UIImageView *line2=[UIImageView new];
    line2.frame=CGRectMake(l2.left, l2.bottom+IFScreenFit2(10.f,10.f), GlobleWidth-l2.left, 0.5f);
    line2.backgroundColor=RGB(170, 170, 170);
    //line.image=[UIImage imageNamed:@"分栏线.png"];
    [self.firstView addSubview:line2];

    
    
    
    //line.backgroundColor=[UIColor redColor];
    
    
//    UILabel *l2=[UILabel new];
//    l2.frame=CGRectMake(IFScreenFit2(25.f,25.f), l1.bottom+IFScreenFit2(50.f,50.f), IFScreenFit2(60.f,60.f), IFScreenFit2(15.f,15.f));
//    l2.font=CNFont(IFScreenFit2(15.f,15.f));
//    l2.textColor=RGB(144, 144, 144);
//    l2.text=@"地理位置";
//    [self.firstView addSubview:l2];
//    
//    UITextField *filed2=[[UITextField alloc] init];
//    filed2.frame=
//    CGRectMake(IFScreenFit2(95.f,95.f), l1.bottom+IFScreenFit2(39.f,39.f),
//               GlobleWidth-IFScreenFit2(95.f,95.f)-IFScreenFit2(40,40), IFScreenFit2(31.f,31.f));
//    [self.firstView addSubview:filed2];
//    self.filed2=filed2;
//    
//    line=[UIImageView new];
//    line.frame=CGRectMake(filed1.left, l2.bottom+IFScreenFit2(20.f,20.f), GlobleWidth-IFScreenFit2(95.f,95.f)-IFScreenFit2(10,10), 1.5);
//    line.image=[UIImage imageNamed:@"分栏线.png"];
//    [self.firstView addSubview:line];
    
    CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
    [button setContentEdgeInsets:
     UIEdgeInsetsMake(IFScreenFit2(10.f,10.f), IFScreenFit2(10.f,10.f), IFScreenFit2(10.f,10.f), IFScreenFit2(10.f,10.f))];
    [button setImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(self.filed1.right-IFScreenFit2(33,33), self.filed2.top-2, IFScreenFit2(34,34), IFScreenFit2(37.5,37.5));
    
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if(!me.location.isLocating)
        [me dolocation];
        [((CNButton *)sender) nonClickButton];
    }];
    [self.firstView addSubview:button];
    
    
    
    UIImageView *icon3=[[UIImageView alloc] init];
    icon3.image=[UIImage imageNamed:@"播放.png"];
    icon3.frame=CGRectMake(IFScreenFit2s(23.f), icon2.bottom+IFScreenFit2s(35.f), IFScreenFit2s(11.f), IFScreenFit2s(11.f));
    [self.firstView addSubview:icon3];
    
    UILabel *l3=[UILabel new];
    l3.frame=CGRectMake(icon2.right+IFScreenFit2s(15.f), icon3.top, IFScreenFit2(60.f,60.f), IFScreenFit2(15.f,15.f));
    l3.font=CNBold(IFScreenFit2(15.f,15.f));
    l3.textColor=RGB(144, 144, 144);
    l3.text=@"直播封面";
    [self.firstView addSubview:l3];
    
    UILabel *filed3=[[UILabel alloc] init];
    filed3.textColor=RGB(200, 200, 200);
    filed3.font=CNBold(IFScreenFit2(15.f,15.f));
    filed3.frame=
    CGRectMake(l3.right+IFScreenFit2s(15.f), icon3.top-IFScreenFit2s(7),
               GlobleWidth-(l3.right+IFScreenFit2s(15.f))-IFScreenFit2(40,40), IFScreenFit2(31.f,31.f));
    filed3.text=@"选填，如果不填将启用默认封面";
    [self.firstView addSubview:filed3];
    self.field3=filed3;

    self.changeImg=[UIImageView new];
    self.changeImg.frame=CGRectMake(l3.left, filed3.bottom+IFScreenFit2(22.f,22.f), IFFitFloat6(313), IFScreenFit2(115,115));
    UIImage *img=[UIImage imageNamed:@"上传图片.png"];
    self.changeImg.contentMode=UIViewContentModeScaleAspectFill;
    self.changeImg.image=img;
    self.changeImg.clipsToBounds=YES;
    self.changeImg.userInteractionEnabled=YES;
    //self.changeImg.contentMode=UIViewContentModeScaleAspectFit;
    [self.firstView addSubview:self.changeImg];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(addImg:)];
    [self.changeImg addGestureRecognizer:tap];

    
    CNButton *comfirm=[CNButton buttonWithType: UIButtonTypeCustom];
    self.comfirm=comfirm;
    
    [comfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirm.titleLabel.font=CNBold(15.f);
    [comfirm setTitle:@"开始" forState:UIControlStateNormal];
    [comfirm setTitleColor:RGB(170, 170, 170) forState:UIControlStateDisabled];
    [comfirm setTitleColor:RGB(253, 170, 28) forState:UIControlStateNormal];
    comfirm.enabled=NO;
    
    comfirm.frame=CGRectMake(self.navagator.width-IFScreenFit2s(50), self.navagator.height-IFScreenFit2(28,28), IFScreenFit2s(50), IFScreenFit2(15,15));
    [self.navagator addSubview:comfirm];

    self.location = [[IFLocationManager alloc] init];
    [self dolocation];
    
    
    [comfirm handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSString *title=me.filed1.text.trim;
        NSString *loc=me.filed2.text.trim;
        
        if(_isStrNULL(title)|| _isStrNULL(loc)){
            [me showModelView:@"请填写标题和者位置"];
            return ;
        }
        if(title.length>16){
            [me showModelView:@"标题不能超过30个字"];
            return ;
        }
        
        if(loc.length>50){
            [me showModelView:@"位置不能超过50个字"];
            return ;
        }
        UIImage *theImg=(me.changeImg.image==img)?nil:me.changeImg.image;
        [me showLoadingModel:@"正在创建直播信号中..." subTitle:@"您的直播正在创建中，请稍候......"];
       // [me showLoadingModel:@"您的直播正在创建中，请稍候......" ];
        [[CNDataModel sharedInstance] createLive:title
                                        location:loc
                                           cover:theImg
                                        complate:^(BOOL success, NSString *message,NSDictionary *dic) {
                                            if(success){
                                                if(!dic){
                                                    [me disShowLoadingModel];
                                                    [me showModelView:@"接口错误，请重新尝试"];
                                                }else{
                                                    [me startLive:dic];
                                                }
                                            }else{
                                                [me disShowLoadingModel];
                                                if(message)
                                                    [me showModelView:message];
                                            }
                                        }];
        [((CNButton *)sender) nonClickButton];
    }];

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     NSLog(@"%@--%@",self.filed2.text,self.filed1.text);
    
    UITextField *antherText=(textField==self.filed1)?self.filed2:self.filed1;
    
    if(_isStrNotNull(antherText.text) && _isStrNotNull(string)){
        self.comfirm.enabled=YES;
    }else{
        self.comfirm.enabled=NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.comfirm.enabled=NO;
    return YES;
}

- (void)startLive:(NSDictionary *) dic{
    [self.oneView removeFromSuperview];
    self.oneView=nil;
    self.navagator=nil;
    self.pushUrl=[dic sgrGetStringForKey:@"url"];
    self.liveCode=[dic sgrGetStringForKey:@"code"];
    [self setUPLiveUI];
    
}

- (void)dolocation{
    
    __weak typeof(self) me=self;
   
    [self.location startLocationCallback:^(IFLocation_response *response) {
        if(response.isSuccess){
            NSString *str=[NSString stringWithFormat:@"%@,%@",
                           [response.responseObject sgrGetStringForKey:@"State"],
                           [response.responseObject sgrGetStringForKey:@"City"]
//                           ,
//                           [response.responseObject sgrGetStringForKey:@"SubLocality"],
//                           [response.responseObject sgrGetStringForKey:@"Street"]
                           ];
            me.filed2.text=str;
            
        }else{
            
            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
                [me showModelView:@"获取位置信息失败\n请打开手机[设置]->[隐私]->[定位服务],允许VGC客户访问位置信息"];
            }else{
                [me showModelView:@"获取位置信息失败\n请重新尝试"];
            }
            
        }
    }];

}


                                 
                                 
- (void)addImg:(id )sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    __weak typeof(self) me=self;
    if(buttonIndex==0){
        [self userSelectPicWithType:UIImagePickerControllerSourceTypeCamera result:^(UIImage* image){
            me.field3.hidden=YES;
            if(image){
                me.changeImg.image=image;
                
            }
        }];
    }else if(buttonIndex==1){
        [self userSelectPicWithType:UIImagePickerControllerSourceTypePhotoLibrary result:^(UIImage* image){
            me.field3.hidden=YES;
            if(image){
                me.changeImg.image=image;
                
            }
        }];

    }
}

- (void)setUPLiveUI{
    
    
    self.isInLive=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:CN_Change_reflash_index2 object:nil];
    [self didChangeToInterfaceOrientationLand];
    
   // [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    self.twoView=[UIView new];
    self.twoView.frame=self.view.bounds;
    [self.view addSubview:self.twoView];
    
    if(self.loadingModel){
        [self.view bringSubviewToFront:self.loadingModel];
    }
//    self.fps = 24;
//    self.bitrate = 500000;
    
    self.useAutoEstimateBitrate = NO;
    self.useDebugMode = YES;
    self.audioSourceType = LiveAudioSourceMic;
    
    [self addLiveUI];
    __weak typeof(self) me=self;
    [[SgrGCD sharedInstance] enMain:^{
        [me start];
    }];
    
    
}

- (void)pop{
    self.isInLive=NO;
    self.isStop=YES;
    
    [self didChangeToInterfaceOrientationLand2];
    [[SgrGCD sharedInstance] enMain:^{
         [CNGlobal didChangeToInterfaceOrientationPortrait];
    }];
   

    __weak typeof(self)me=self;
//    [[SgrGCD sharedInstance] enMain:^{
//        [me.dispatchObj performSelector:@selector(pop) withObject:nil afterDelay:0.5];
//    }];
    
    
}

//- (void)willpop{
//    NSLog(@"-----1");
//    [self.class didChangeToInterfaceOrientationPortrait];
//}

- (void)addLiveUI{
    
   __weak typeof(self) me=self;
    
    UIView *cover=[UIView new];
    self.cover=cover;
    self.cover.hidden=YES;
//    UIButton *b44=[UIButton buttonWithType:UIButtonTypeCustom];
//    b44.backgroundColor=[UIColor blueColor];
//    [b44 setTitle:@"测试" forState:UIControlStateNormal];
//    
//    b44.frame=CGRectMake(0, 100, 44, 44);
//    self.test=LiveFilterTypeNormal;
//    [b44 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        me.test++;
//        [me.streamer switchFilter:(me.test%7)];
//    }];
//    
//    [self.cover addSubview:b44];
    //cover.backgroundColor=[UIColor blueColor];
    cover.frame=self.twoView.bounds;
    [self.twoView addSubview:cover];
    
    CNButton *backButton=[CNButton buttonWithType:UIButtonTypeCustom];
    self.liveBackButton=backButton;
 
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backButton setImage:[UIImage imageNamed:@"关闭按钮.png"] forState:UIControlStateNormal];
    backButton.frame=CGRectMake(IFScreenFit2(18.f,18.f), IFScreenFit2s(13.f), IFScreenFit2(45.f,45.f), IFScreenFit2(45,45));
    
    [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me _showAlertWithTitle:@"是否退出" message:@"退出后直播就将结束" block:^(int buttonIndex) {
            if(1==buttonIndex){
                [me stop];
                
                [me performSelector:@selector(pop) withObject:nil afterDelay:0.5];
            }
            
        } cancelButtonTitle:@"取消" confirmButtonTitles:@"确定"];
        [((CNButton *)sender) nonClickButton];
    }];
    
    [cover addSubview:backButton];

    UIView *tl=[[UIView alloc] initWithFrame:CGRectMake((GlobleHeight-IFScreenFit2(102,102))/2.f, 0, IFScreenFit2(102,102), IFScreenFit2(30,30))];
     tl.center=CGPointMake(tl.center.x, backButton.center.y);
    
    tl.layer.cornerRadius=15.f;
    tl.clipsToBounds=YES;
    tl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UILabel *timeLabel=[UILabel new];
    
    timeLabel.frame=tl.bounds;
   
    timeLabel.textColor=[UIColor whiteColor];
    timeLabel.font=CNFont(IFScreenFit2(10,10));
    timeLabel.textAlignment=NSTextAlignmentCenter;
 
    //timeLabel.backgroundColor=RGB(175.f, 175.f, 175.f);
  
    
    self.timeLabel=timeLabel;

    [tl addSubview:timeLabel];
    [cover addSubview:tl];
    
    UIView *tools=[[UIView alloc] init];
    
 
    self.tools=tools;
    tools.frame=
    CGRectMake(GlobleHeight-20.f-IFScreenFit2(44.f,44.f), GlobleWidth-35.f-IFScreenFit2(220.f,220.f), IFScreenFit2(74.f,74.f), IFScreenFit2(220.f,220.f));
    
    [cover addSubview:tools];
    
    
    
    CNButton *button1=[CNButton buttonWithType:UIButtonTypeCustom];
    //button1.backgroundColor=[UIColor orangeColor];
    [button1 setContentEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
    [button1 setImage:[UIImage imageNamed:@"i按钮.png"] forState:UIControlStateNormal];
    button1.frame=CGRectMake(IFScreenFit2(4.f,4.f), IFScreenFit2(0.f,0.f), IFScreenFit2(56.f,56.f), IFScreenFit2(36,36));
    [tools addSubview:button1];
    
    
    [button1 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:me.liveCode];
        [me showSearchCode];
       
    }];
    
    CNButton *button2=[CNButton buttonWithType:UIButtonTypeCustom];
    [button2 setContentEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
    [button2 setImage:[UIImage imageNamed:@"补光.png"] forState:UIControlStateNormal];
    button2.frame=CGRectMake(IFScreenFit2(0.f,0.f), button1.bottom+IFScreenFit2(10.f,10.f), IFScreenFit2(64.f,64.f), IFScreenFit2(42,42));
    [tools addSubview:button2];
    
    [button2 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (me.streamer) {
            [me.streamer switchFlash];
        }
       
    }];
    
    CNButton *button3=[CNButton buttonWithType:UIButtonTypeCustom];
    [button3 setContentEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
    [button3 setImage:[UIImage imageNamed:@"矩形-43.png"] forState:UIControlStateNormal];
    button3.frame=CGRectMake(IFScreenFit2(0.f,0.f), button2.bottom+IFScreenFit2(10.f,10.f), IFScreenFit2(64.f,64.f), IFScreenFit2(42,42));
    [tools addSubview:button3];
    
    [button3 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (me.streamer) {
            [me.streamer switchCamera];
        }
    }];
    
    CNButton *button4=[CNButton buttonWithType:UIButtonTypeCustom];
    //[button4 setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button4 setImage:[UIImage imageNamed:@"按钮展开.png"] forState:UIControlStateNormal];
    [button4 setImage:[UIImage imageNamed:@"按钮展开.png"] forState:UIControlStateSelected];
    button4.frame=CGRectMake(IFScreenFit2(2.f,2.f)+10.f, button3.bottom+IFScreenFit2(10.f,10.f), IFScreenFit2(40.f,40.f), IFScreenFit2(40,40));
    [tools addSubview:button4];

    [button4 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        CNButton *b=(CNButton *)sender;
        [b setSelected:!b.isSelected];
        [UIView animateWithDuration:0.2
                         animations:^{
                             if(b.isSelected){
                                 button1.top=button4.top;
                                 button2.top=button4.top;
                                 button3.top=button4.top;
                                 
                                 
//                                  button1.frame=
//                                 CGRectMake(IFScreenFit2(4.f,4.f), button4.top, IFScreenFit2(36.f,36.f), IFScreenFit2(36,36));
//                                 button2.frame=CGRectMake(IFScreenFit2(0.f,0.f), button4.top, IFScreenFit2(44.f,44.f), IFScreenFit2(42,42));
//                                 button3.frame=CGRectMake(IFScreenFit2(0.f,0.f), button4.top, IFScreenFit2(44.f,44.f), IFScreenFit2(42,42));
                                 
                                 button1.alpha=0;
                                 button2.alpha=0;
                                 button3.alpha=0;
                                 
                                 
                             }else{
                                 button1.top=IFScreenFit2(0.f,0.f);
                                 button2.top=button1.bottom+IFScreenFit2(10.f,10.f);
                                 button3.top=button2.bottom+IFScreenFit2(10.f,10.f);
//                                 button1.frame=
//                                 CGRectMake(IFScreenFit2(4.f,4.f), IFScreenFit2(0.f,0.f), IFScreenFit2(36.f,36.f), IFScreenFit2(36,36));
//                                 button2.frame=CGRectMake(IFScreenFit2(0.f,0.f), button1.bottom+IFScreenFit2(10.f,10.f), IFScreenFit2(44.f,44.f), IFScreenFit2(42,42));
//                                 button3.frame=CGRectMake(IFScreenFit2(0.f,0.f), button2.bottom+IFScreenFit2(10.f,10.f), IFScreenFit2(44.f,44.f), IFScreenFit2(42,42));
                                 
                                 button1.alpha=1;
                                 button2.alpha=1;
                                 button3.alpha=1;
                             }
                             
                             
                         } completion:nil];
    }];
    
}



- (void)showSearchCode{
    if(self.codeView){
        [self.codeView removeFromSuperview];
    }
    
    self.codeView=[UIView new];
    self.codeView.frame=
    CGRectMake((GlobleHeight-IFScreenFit2(224.f,224.f))/2.f, (GlobleWidth-IFScreenFit2(101,101))/2.f-30.f, IFScreenFit2(224.f,224), IFScreenFit2(101,101));
    self.codeView.backgroundColor=RGB(245, 246, 247);
    UILabel *l1=[UILabel new];
    l1.frame=self.codeView.bounds;
    l1.height=IFScreenFit2(164.f,164)/2.f;
    l1.left=l1.top=0;//IFScreenFit2(15,15);
    l1.textColor=RGB(0x33, 0x33, 0x33);
    l1.font=CNSubFont(IFScreenFit2(35,35));
    l1.textAlignment=NSTextAlignmentCenter;
    l1.numberOfLines=0;
    l1.text=self.liveCode;
    [self.codeView addSubview:l1];
    
    UILabel *l2=[UILabel new];
    l2.frame=CGRectMake(0, self.codeView.height-IFScreenFit2(27.f,27.f), self.codeView.width, IFScreenFit2(27.f,27.f));
    l2.textColor=RGB(0x33, 0x33, 0x33);
    l2.textAlignment=NSTextAlignmentCenter;
    l2.font=CNBold(IFScreenFit2(11,11));
    l2.text=@"已拷贝直播码,请直接拷贝给运营人员";
    [self.codeView addSubview:l2];
    
    [self.view addSubview:self.codeView];

    [self performSelector:@selector(disappearCodeView) withObject:nil afterDelay:3.5];
    
}

- (void)disappearCodeView{
    if(self.codeView){
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.codeView.alpha=0;
                         } completion:^(BOOL finished) {
                             [self.codeView removeFromSuperview];
                         }];
    }
}

- (void)startStream{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [_streamer start];
}

- (void)start
{
    [self stop];
    
    
    
   // [self showLoadingModel:@"您的直播正在创建中,请稍后。。。。"];
    self.canvasView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.canvasView];
    [self.view sendSubviewToBack:self.canvasView];
    
    
    NSString *rtmpURL=self.pushUrl;
    NSLog(@"========>推流地址 %@",rtmpURL);
//    rtmpURL=@"rtmp://rtmpup4.pstatp.com/hudong/stream-6277720885117848322?wsSecret=20b110105b177b774a5726d2d03266e3&wsTime=571ef1e2&wsHost=rtmpup4.pstatp.com";
    _streamer = [[TTLiveStreamer alloc]initWithURL:[NSURL URLWithString:rtmpURL] with:self.canvasView frameRate:25 bitrate:1000000 audioSource:self.audioSourceType];
    _streamer.streamerDelegate = self;

    CGSize videoSize=CGSizeMake(1280, 720);
    
 
    _streamer.videoSize=videoSize;
    
    _streamer.videoInitBitrate = 1000000;

    

    
//<<<<<<< HEAD
//    _streamer.videoMaxBitrate = 500000;
//    _streamer.videoMinBitrate = 10;
//    _streamer.debugMode = YES;
//=======
    _streamer.videoMaxBitrate = 2500000;
    _streamer.videoMinBitrate = 500000;
    _streamer.debugMode = NO;

    _streamer.autoAppleEstimateBitrate = YES;
    
    [_streamer addWatermarkWithImage:[UIImage imageNamed:@"logo.png"]
                            withRect:CGRectMake(videoSize.width-64, 70, 80, 80)];
    
    [_streamer switchFilter:LiveFilterTypeNormal];
  
    
  //  [_streamer start];
    [self startStream];
    
}

- (void)stop
{
    NSLog(@"stop");
    if (_streamer) {
        [_streamer stop];
    }
    
    [self.timer invalidate];
    self.timer=nil;
    
    [self.canvasView removeFromSuperview];
    self.canvasView = nil;
}

//MARK:TTLiveStreamerDelegate
- (void)flashModeChanged:(TTLiveStreamer *)streamer
{
    
}

- (void)showLivetoolUI{
    self.cover.hidden=NO;
}


- (void)regisnActive{
    [_streamer stop];
    [self.timer invalidate];
    self.timer=nil;
}

- (void)beActive{
    if(self.streamer!=nil && self.errorView==nil){
    
        [self showLoadView];
        [self disLoadingView];
        [self performSelector:@selector(disLoadingView)   withObject:nil afterDelay:0.5];
        //[_streamer start];
        [self startStream];
        [self reCaretTime];
    }
}

- (void)notificationAdd{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regisnActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beActive) name: UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)notificationCancel{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)liveStreamer:(TTLiveStreamer *)streamer streamStateDidChange:(LiveStreamState)state withError:(NSString *)description
{
    
    __weak typeof(self) me=self;
    switch (state) {
        case LiveStreamStateReadyForPush:{
            
            NSLog(@"=======-0");
            break;
        }
            
        case LiveStreamStatePreview:{
            NSLog(@"========-1");
             break;
        }
            
           
            
        case LiveStreamStateConnecting:{
            [[SgrGCD sharedInstance] enqueueSafeMain:^{
                if (me.streamer) {
                    [me.streamer switchFilter:LiveFilterTypeNormal];
                    [_streamer switchCamera];
                    [me showLivetoolUI];
                    [me createTimer];
                }
                
                [[SgrGCD sharedInstance] enMain:^{
                    [me disShowLoadingModel];
                    [me showTilwhenPortrait];
                    [me notificationAdd];
                    
                }];
                
                
            }];
            break;
        }
            
        case LiveStreamStateDisconnecting:{
            NSLog(@"=======3");
            break;
        }
            
        case LiveStreamStateError:{
            NSLog(@"=======000");
            [me doLiveError];
                     break;
        }
            
        case LiveStreamStateIdle:{
            NSLog(@"======5");
            break;
        }
        case LiveStreamStateConnected:{
            NSLog(@"======6");
            break;
        }
            
            
       
    }
}

- (void)doLiveError{
    [self disShowLoadingModel];
    [self.timer invalidate];
    self.timer=nil;
    __weak typeof(self) me=self;
    [[SgrGCD sharedInstance] enMain:^{
        [me showLiveError];
    }];

}


- (void)showLoadingModel:(NSString *)title subTitle:(NSString *)subTitle{
    __weak typeof(self)me=self;
    self.istransform=NO;
    //    if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft||
    //       [UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight){
    //
    //    }
    [[SgrGCD sharedInstance] enqueueSafeMain:^{
        [me.loadingModel removeFromSuperview];
        UIView *bgview=[[UIView alloc] init];
        bgview.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        bgview.backgroundColor=RGB(245, 246, 247);
        me.loadingModel=bgview;
        [me.view addSubview:bgview];
        
        
        UIView *navagator=[UIView new];
        navagator.backgroundColor=[UIColor whiteColor];
        navagator.frame=CGRectMake(0, 0, GlobleWidth, CCTopHeight);
        navagator.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [bgview addSubview:navagator];
        
        
        
        
        
        
        UILabel *label=[UILabel new];
        label.frame=CGRectMake((GlobleWidth-IFScreenFit2(200,200))/2.f, 20.f, IFScreenFit2(200,200), IFScreenFit2(CCTopHeight-20.f,CCTopHeight-20.f));
        label.font=CNBold(IFScreenFit2(16.f,16.f));
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        label.text=title;
        [navagator addSubview:label];
        
        
        CNLoadingView *model=[CNLoadingView new];
        [model setUp:subTitle];
        model.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        model.top=IFScreenFit2s(150.f);
        model.left=(GlobleWidth-IFScreenFit2s(250.f))/2.f;
        [bgview addSubview:model];
        
        
        
        CNButton *backButton=[CNButton buttonWithType:UIButtonTypeCustom];
        backButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
        backButton.frame=CGRectMake(IFScreenFit2(14.f,14.f), CCTopHeight-IFScreenFit2(40.f,40.f), IFScreenFit2(30.f,30.f), IFScreenFit2(39,39));
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f)];
        [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [navagator addSubview:backButton];
        
        __weak typeof(self) me=self;
        [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if([me respondsToSelector:@selector(pop)]){
                [me performSelector:@selector(pop)];
            }else{
                [me.dispatchObj pop];
            }
            
        }];
        if(self.twoView)
        bgview.frame=self.twoView.bounds;
//        if(_isInLive==YES && _istransform==NO){
//            if(me.loadingModel){
//                
//                if(me.istransform==NO){
//                    // self.loadingModel.layer.anchorPoint=CGPointMake(0, 0);
//                    CGAffineTransform transform =CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
//                    [me.loadingModel setTransform:transform];
//                    //self.loadingModel.center=CGPointMake(GlobleHeight/2.f, GlobleWidth/2.f);
//                    me.istransform=YES;
//                    
//                    me.loadingModel.top=0;
//                    me.loadingModel.left=0;
//                }
//            }
//        }
        
        
        //        UIButton *bs=[UIButton buttonWithType:UIButtonTypeCustom];
        //        bs.frame=CGRectMake(100, 100, 200, 200);
        //        [bs setBackgroundColor:[UIColor redColor]];
        
        
    }];
}

//- (void)showLoadingModel:(NSString *)title view:(UIView *)view{
//    __weak typeof(self)me=self;
//    sgrSafeMainThread(^{
//        [me.loadingModel removeFromSuperview];
//        me.loadingModel=[CNLoadingView new];
//        [me.loadingModel setUp:title];
//        [me.view addSubview:me.loadingModel];
//        me.loadingModel.top=(me.view.height-me.loadingModel.height)/2.f;
//        me.loadingModel.left=(me.view.width-me.loadingModel.width)/2.f;
//    });
//}

- (void)disShowLoadingModel{
    __weak typeof(self)me=self;
    self.istransform=NO;
    sgrSafeMainThread(^{
        [me.loadingModel removeFromSuperview];
    });
}

- (void)showLiveError{
    [self stop];
    [self.cover removeFromSuperview];
    self.cover=nil;
    
    
    UIView *errorView=[UIView new];
    errorView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    errorView.backgroundColor=[UIColor whiteColor];
    errorView.frame=CGRectMake(0, 0, GlobleHeight, GlobleWidth);
    [self.twoView addSubview:errorView];
    self.errorView=errorView;
    
//    [self setNavagator:errorView];
//    [self addBackButton];
    

    
    UILabel *bitian=[UILabel new];
    bitian.font=CNFont(IFScreenFit2(17,17));
    bitian.numberOfLines=0;
    bitian.textAlignment=NSTextAlignmentCenter;
    bitian.textColor=[UIColor blackColor];
    bitian.text=@"因网络问题,你的直播暂时中断,\n请稍后重试";
    bitian.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    bitian.frame=CGRectMake((GlobleHeight-IFScreenFit2(300.f,300.f))/2.f, IFScreenFit2(135.f,135.f), IFScreenFit2(300.f,300.f), IFScreenFit2(75.f,75.f));
    [errorView addSubview:bitian];
    
    
    CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
     button.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=CNFont(17.f);
    [button setTitle:@"尝试重新开始直播" forState:UIControlStateNormal];
  
    [button setBackgroundColor:RGB(31.f, 76.f, 152.f)];
    button.frame=CGRectMake((GlobleHeight-IFScreenFit2(200.f,200.f))/2.f, bitian.bottom+IFFitFloat6(43), IFScreenFit2(200.f,200.f), IFFitFloat6(42));
    [errorView addSubview:button];

    __weak typeof(self)me=self;
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.errorView removeFromSuperview];
        me.errorView=nil;
        me.navagator=nil;
        me.istransformError=NO;
        [me showLoadingModel:@"正在连接直播信号中..." subTitle:@"您的直播正在准备继续，请稍候......"];
        [me addLiveUI];
 
        [me start];
        [((CNButton *)sender) nonClickButton];
    }];
    
    
    CNButton *backButton=[CNButton buttonWithType:UIButtonTypeCustom];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backButton setImage:[UIImage imageNamed:@"关闭按钮.png"] forState:UIControlStateNormal];
    backButton.frame=CGRectMake(IFScreenFit2(14.f,14.f), CCTopHeight-IFScreenFit2(40.f,40.f), IFScreenFit2(45.f,45.f), IFScreenFit2(45,45));
  
    [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me _showAlertWithTitle:@"是否退出" message:@"退出后直播就将结束" block:^(int buttonIndex) {
            if(1==buttonIndex){
                [me stop];
                [me performSelector:@selector(pop) withObject:nil afterDelay:0.5];
            }
            
        } cancelButtonTitle:@"取消" confirmButtonTitles:@"确定"];
        
    }];
    [errorView addSubview:backButton];
    
    
//    if(_isInLive==YES && _istransformError==NO){
//        CGAffineTransform transform =CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
//        [errorView setTransform:transform];
//        //self.loadingModel.center=CGPointMake(GlobleHeight/2.f, GlobleWidth/2.f);
//        self.istransformError=YES;
//        
//        errorView.top=0;
//        errorView.left=0;
//    }
    
    
}

- (void)createTimer{
    SgrWeakTarget *target=[[SgrWeakTarget alloc] init];
    target.obj=self;
    target.select=@selector(checkProgress);
    self.liveTime=0.f;
    self.errorCountTime=0;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(perform) userInfo:nil repeats:YES];
}

- (void)reCaretTime{
    SgrWeakTarget *target=[[SgrWeakTarget alloc] init];
    target.obj=self;
    self.errorCountTime=0;
    target.select=@selector(checkProgress);
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(perform) userInfo:nil repeats:YES];
}

- (void)checkProgress{
    self.liveTime++;
    self.timeLabel.text=[self formatSecond:self.liveTime];
    
 //   NSLog(@"+++++++++++%d",_streamer.isRunning);
    
    if(!_streamer.isRunning){
        NSLog(@"timer_error");
        self.errorCountTime++;
        if(self.errorCountTime>7){
            self.errorCountTime=0;
            [self doLiveError];
        }
    }else{
        _errorCountTime=0;
    }
    
}


- (void)outputAccelertionData:(CMAcceleration)acceleration{
    UIInterfaceOrientation orientationNew;
    if (acceleration.x >= 0.75) {
        orientationNew = UIInterfaceOrientationLandscapeRight;
    }
    else if (acceleration.x <= -0.75) {
        orientationNew = UIInterfaceOrientationLandscapeLeft;
    }
    else if (acceleration.y <= -0.75) {
        orientationNew = UIInterfaceOrientationPortrait;
    }
    else if (acceleration.y >= 0.75) {
        orientationNew = UIInterfaceOrientationPortraitUpsideDown;
    }
    else {
        // Consider same as last time
        return;
    }
    self.orientationLast=orientationNew;
   
    if (orientationNew == UIInterfaceOrientationLandscapeLeft ||
        orientationNew== UIInterfaceOrientationLandscapeRight){
        [self.showTie removeFromSuperview];
   
        [self.motionManager stopGyroUpdates];
        self.motionManager=nil;

    }
 
}


- (void)initializeMotionManager{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = .2;
    motionManager.gyroUpdateInterval = .2;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                            if (!error) {
                                                [self outputAccelertionData:accelerometerData.acceleration];
                                            }
                                            else{
                                                NSLog(@"%@", error);
                                            }
                                        }];
    
 
    self.motionManager=motionManager;
    
}



- (void)showTilwhenPortrait{
  

    
    if(self.orientationLast==UIInterfaceOrientationPortrait){
        self.showTie=[[UIImageView alloc] init];
        self.showTie.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.showTie.layer.cornerRadius=16.f;
        //self.showTie.image=[UIImage imageNamed:@"横屏提示.png"];
        self.showTie.frame=CGRectMake(0, 0, IFFitFloat6(210), IFFitFloat6(210));
        
        UIImageView *img=[[UIImageView alloc] init];
        img.frame=CGRectMake(0, 0, IFFitFloat6(32), IFFitFloat6(32));
        
        img.center=CGPointMake(self.showTie.width/2.f, IFFitFloat6(200)/2.f-IFFitFloat6(30));
        img.image=[UIImage imageNamed:@"横屏手机.png"];
        [self.showTie addSubview:img];
        
        UILabel *l1=[UILabel new];
        l1.frame=CGRectMake(0, 0, IFFitFloat6(60.f), IFFitFloat6(19.f));
        l1.center=CGPointMake(img.centerX, img.bottom+25);
        l1.font=CNBold(IFFitFloat6(18.f));
        l1.textColor=[UIColor whiteColor];
        l1.textAlignment=NSTextAlignmentCenter;
        l1.text=@"提示";
        [self.showTie addSubview:l1];
        
        
        UILabel *l2=[UILabel new];
        l2.frame=CGRectMake(0, 0, self.showTie.width, IFFitFloat6(22.f));
        l2.center=CGPointMake(img.centerX, l1.bottom+25);
        l2.font=CNBold(IFFitFloat6(20.f));
        l2.textColor=[UIColor whiteColor];
        l2.textAlignment=NSTextAlignmentCenter;
        l2.text=@"请横置手机进行直播";
        [self.showTie addSubview:l2];

    
        CGAffineTransform transform =CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        [self.showTie setTransform:transform];
    
    
        self.showTie.top=(GlobleWidth-IFFitFloat6(210))/2.f;
        self.showTie.left=(GlobleHeight-IFFitFloat6(210))/2.f;
        [self.view addSubview:self.showTie];
       
       // [self initializeMotionManager];
    }else{
        [self.motionManager stopGyroUpdates];
    }
    
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    // NSLog(@"---%f----%f",self.view.width,self.view.height);
    
    if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft||
       [UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight){
        self.view.frame=CGRectMake(0, 0, GlobleHeight, GlobleWidth);
        self.twoView.frame=CGRectMake(0, 0, GlobleHeight, GlobleWidth);
        self.loadingModel.frame=CGRectMake(0, 0, GlobleHeight, GlobleWidth);
        
//        if(self.loadingModel){
//            
//            if(self.istransform==NO){
//                // self.loadingModel.layer.anchorPoint=CGPointMake(0, 0);
//                CGAffineTransform transform =CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
//                [self.loadingModel setTransform:transform];
//                //self.loadingModel.center=CGPointMake(GlobleHeight/2.f, GlobleWidth/2.f);
//                self.istransform=YES;
//                
//                self.loadingModel.top=0;
//                self.loadingModel.left=0;
//            }
//        }
        
//        if(self.errorView){
//            CGAffineTransform transform =CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
//            [self.errorView setTransform:transform];
//            //self.loadingModel.center=CGPointMake(GlobleHeight/2.f, GlobleWidth/2.f);
//            
//            self.istransformError=YES;
//            self.errorView.top=0;
//            self.errorView.left=0;
//
//        }
        
    }else{
        
        self.view.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
         self.twoView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        self.loadingModel.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
//        if(self.loadingModel){
//            [self.loadingModel setTransform:CGAffineTransformIdentity];
//            self.loadingModel.top=0;
//            self.loadingModel.left=0;
//        }
        
//        if(self.errorView){
//            [self.errorView setTransform:CGAffineTransformIdentity];
//            self.errorView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
//        }

        
        if(self.isStop){
            __weak typeof(self) me=self;
            [[SgrGCD sharedInstance] enMain:^{
                [me.dispatchObj pop];
            }];
        }
        
        
    }
}


- (NSString *)formatSecond:(float)second{
    int x=(int)second;
    int y=x/3600;
    int x1=x%3600;
    int miu=x1/60;
    int sec=x1%60;
    
    return [NSString stringWithFormat:@"%@%d:%@%d:%@%d",(y>9)?@"":@"0",y,(miu>9)?@"":@"0",miu,(sec>9)?@"":@"0",sec];
}

- (void)didChangeToInterfaceOrientationLand
{
    if([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait){
        self.orientationLast=UIInterfaceOrientationPortrait;
    }
    [self initializeMotionManager];
   // self.orientationLast=[[UIDevice currentDevice] orientation];
   // if(self.deviceOrenLast!=UIDeviceOrientationLandscapeRight)self.ignorOnce=YES;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


- (void)didChangeToInterfaceOrientationLand2
{
    if([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait){
        self.orientationLast=UIInterfaceOrientationPortrait;
    }
    [self initializeMotionManager];
    // self.orientationLast=[[UIDevice currentDevice] orientation];
    // if(self.deviceOrenLast!=UIDeviceOrientationLandscapeRight)self.ignorOnce=YES;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (BOOL)showPopAction{
    return self.oneView!=nil;
}


- (BOOL)__shouldAutorotate{
    return YES;
}

- (NSUInteger)__supportedInterfaceOrientations{
    if(self.isInLive){
    return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
