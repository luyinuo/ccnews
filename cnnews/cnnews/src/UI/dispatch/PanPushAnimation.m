//
//  PanPushAnimation.m
//  IfengNews
//
//  Created by Ryan on 13-10-15.
//
//

#import "PanPushAnimation.h"
#import "DispatchViewController.h"
#import "CLPushAnimatedRight.h"


@implementation PanPushAnimation

- (id)init{
    
    self=[super init];
    if(self){

        self.isBegin=NO;
        self.isCovery=NO;
   
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(clearMemory)
//                                                     name:UIApplicationDidReceiveMemoryWarningNotification
//                                                   object:nil];
//            // When in background, clean memory in order to have less chance to be killed
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(clearMemory)
//                                                         name:UIApplicationDidEnterBackgroundNotification
//                                                       object:nil];

        self.moveStatus=Dispatch_Animation_status_ready;
       
    }
    return self;
}

- (void)createTouchHandle:(UIView *)aSuperView{
    if(!self.touchHandle){
        self.touchHandle=[[UIImageView alloc] init];
        self.touchHandle.frame=CGRectMake(0, GlobleHeight-IFFitFloat(119.0f), IFFitFloat(7.0f), IFFitFloat(28.0f));
        self.touchHandle.image=[UIImage imageNamed:@"dispatch_handle.png"];
        [aSuperView addSubview:self.touchHandle];
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearMemory{
    self.baseVC=nil;
    //self.entity=nil;
}

- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *) gestureRecognizer{
    
    self=[super init];
    if(self){
        self.gusetView=[[UIView alloc] init];
        self.gusetView.userInteractionEnabled=NO;
        self.isBegin=NO;
        self.gusetView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        [gestureRecognizer addTarget:self action:@selector(doAnimation:)];
//        UIPanGestureRecognizer *recognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                   action:@selector(doAnimation:)];
//        [self.gusetView addGestureRecognizer:recognizer];
        
    }
    return self;
}

- (void)forceBegin{
    [self begin];

}

- (void)doAnimation:(UIPanGestureRecognizer *)recognizer{
 
    CGPoint point=[recognizer locationInView:[self k_mainWindow]];
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.startPoint=point;
        CGPoint v=[recognizer velocityInView:[self k_mainWindow]];
        
        if(self.moveStatus==Dispatch_Animation_status_ready &&
           v.x>0 &&fabsf(v.y/v.x)<0.5){
            [self begin];
            
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
      
        if(self.moveStatus==Dispatch_Animation_status_Move){
       
            if (point.x-self.startPoint.x  > IFFitFloat(100)){
                [self push];
            }else{
                [self cancle];
            }
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
       
        
    } else if(recognizer.state==UIGestureRecognizerStateCancelled){
   
        if(self.moveStatus==Dispatch_Animation_status_Move){
            [self cancle];
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
     
        
        
    }
    

    
    if(self.moveStatus==Dispatch_Animation_status_Move){

        [self moveViewWithX:point.x-self.startPoint.x];
    }

}

- (void)moveViewWithX:(float )x{
        x = x>GlobleWidth?GlobleWidth:x;
        x = x<0?0:x;
    UIView *naviView=self.baseVC.view;
        CGRect frame = naviView.frame;
        float w=frame.size.width;
        float m=x-w;
        frame.origin.x = m<0?m:0;
        naviView.frame = frame;
        frame=self.imgView.frame;
    
    self.markView.alpha=0.2f*(x/w);
    frame.origin.x=x*Dispatch_distance_x2;
    self.imgView.frame=frame;
}

- (void)addNextController:(DispatchViewController *)controller{
    self.baseVC=controller;
    self.baseVC.dispatchObj=[CLPushAnimatedRight sharedInstance];
//    self.entity=[DispatchCenter createEntityByController:controller
//                                                        :self.animationType
//                                                        :self.pathName];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)begin{
    if(![[CNUIUtil sharedInstance] checkAnimationLock:self])return;

    if(self.moveStatus!=Dispatch_Animation_status_ready) return;
  
    if(!self.baseVC){
        return;
       // self.entity=[DispatchCenter createEntityByType:self.linkType :self.animationType :self.pathName];
    }else{
        //self.entity.preImage=[DispatchCenter capture];
        self.baseVC.preSnapShot=[[self k_currentController].view snapshotViewAfterScreenUpdates:NO];
    }
    
        CGRect rect=[self k_rootController].view.bounds;
    
    self.gusetView=[[UIView alloc] init];
    self.gusetView.userInteractionEnabled=YES;
    self.gusetView.frame=rect;
    self.imgView=self.baseVC.preSnapShot;
    self.imgView.frame=self.gusetView.bounds;
    

    self.markView=[[UIView alloc] initWithFrame:self.gusetView.bounds];
    self.markView.userInteractionEnabled=NO;
    self.markView.backgroundColor=[UIColor blackColor];
    self.markView.alpha=0.0f;
    self.baseVC.view.frame=CGRectMake(-GlobleWidth, 0, GlobleWidth, rect.size.height);
    [self.gusetView addSubview:self.imgView];
    [self.imgView addSubview:self.markView];
    [self.gusetView addSubview:self.baseVC.view];
    
    
    if(self.touchHandle){
        self.realTouchHandleSuperView=self.touchHandle.superview;
        CGRect frame=self.touchHandle.frame;
        frame.origin.x+=GlobleWidth;
        self.touchHandle.frame=frame;
        [self.baseVC.view addSubview:self.touchHandle];
    }
    [[self k_rootController].view addSubview:self.gusetView];
    
    self.isBegin=YES;
    self.moveStatus=Dispatch_Animation_status_Move;
}


- (void)cancleImmdiatelay{
    if(!self.isBegin) return;
    
    
    CGRect frame=self.touchHandle.frame;
    frame.origin.x=0;
    self.touchHandle.frame=frame;
    [self.realTouchHandleSuperView addSubview:self.touchHandle];
    
    [self.baseVC.view removeFromSuperview];
    [self.gusetView removeFromSuperview];
    self.baseVC.preSnapShot=nil;
    self.gusetView=nil;
    self.imgView=nil;
    self.markView=nil;
    self.isBegin=NO;
    [[CNUIUtil sharedInstance] cleanAnimationLock];
     self.moveStatus=Dispatch_Animation_status_ready;
}


- (void)cancle{
    if(!self.isBegin) return;
    [UIView animateWithDuration:0.2 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finish){
        
        
        CGRect frame=self.touchHandle.frame;
        frame.origin.x=0;
        self.touchHandle.frame=frame;
        [self.realTouchHandleSuperView addSubview:self.touchHandle];
        [self.baseVC.view removeFromSuperview];
        [self.gusetView removeFromSuperview];
        self.baseVC.preSnapShot=nil;
        self.gusetView=nil;
        self.imgView=nil;
        self.markView=nil;
     
        [[CNUIUtil sharedInstance] cleanAnimationLock];
         self.moveStatus=Dispatch_Animation_status_ready;
    }];
    self.isBegin=NO;
}

- (void)pushDirectly{
    [self forceBegin];
    [self push];
}

- (void)push{
   if(!self.isBegin) return;
    [UIView animateWithDuration:0.2 animations:^{
        [self moveViewWithX:GlobleWidth];
    } completion:^(BOOL finish){
        [self.baseVC.view removeFromSuperview];
        [self.gusetView removeFromSuperview];
        
        UINavigationController *root=[self k_rootController];
        self.baseVC.dispatchObj=[CLPushAnimatedRight sharedInstance];
        [root pushViewController:self.baseVC animated:NO];
        self.gusetView=nil;
        self.imgView=nil;
        self.markView=nil;
        [[CNUIUtil sharedInstance] cleanAnimationLock];
        self.moveStatus=Dispatch_Animation_status_ready;
        
    }];
   
    self.isBegin=NO;
    
}

@end
