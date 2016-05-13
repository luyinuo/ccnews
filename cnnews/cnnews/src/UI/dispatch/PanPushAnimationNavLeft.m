//
//  PanPushAnimationNavLeft.m
//  IfengNews
//
//  Created by Ryan on 13-11-12.
//
//

#import "PanPushAnimationNavLeft.h"
#import "DispatchViewController.h"
#import "DispatchAnimationFromLeftNav.h"


#define  panpushWidth IFFitFloat(269)

@implementation PanPushAnimationNavLeft


SGR_DEF_SINGLETION(PanPushAnimationNavLeft)

- (id)init{
    
    self=[super init];
    if(self){
        
        self.isBegin=NO;
        self.isCovery=NO;
        self.isInitPrepared=NO;
        
        self.gusetView=[[UIView alloc] init];
        self.gusetView.userInteractionEnabled=YES;
        
      
            self.gusetView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
//            self.gusetView.backgroundColor=[UIColor blackColor];
      
        self.gusetView.backgroundColor=[UIColor clearColor];
        
       
        
        
        self.moveStatus=Dispatch_Animation_status_ready;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_removeFremSuperView:) name:@"RemovePictureNotification" object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pictureRemoveFromSuperView:) name:@"RemoveSubPictureNotification" object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_showRemoveFromSuperView:) name:@"ShowSubPictureNotification" object:nil];
        
        
    }
    return self;
}



- (void)_removeFremSuperView:(NSNotification *)notification{
    [self.upViewPicture removeFromSuperview];
    self.upViewPicture = nil;
}

- (void)createTouchHandle:(UIView *)aSuperView{
//    if(!self.touchHandle){
//        self.touchHandle=[[UIImageView alloc] init];
//        self.touchHandle.frame=CGRectMake(0, GlobleHeight-119.0f, 7.0f, 28.0f);
//        
//       // self.touchHandle.image=[UIImage imageNamed:@"dispatch_handle.png"];
//        [aSuperView addSubview:self.touchHandle];
//    }
}

- (UIImageView *)needTouchHandle{
    
    return nil;

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *) gestureRecognizer{
    
    self=[super init];
    if(self){
        self.gusetView=[[UIView alloc] init];
//        self.gusetView.userInteractionEnabled=NO;
//        self.isBegin=NO;
//        self.gusetView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
//        [gestureRecognizer addTarget:self action:@selector(doAnimation:)];
//        //        UIPanGestureRecognizer *recognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self
//        //                                                                                   action:@selector(doAnimation:)];
//        //        [self.gusetView addGestureRecognizer:recognizer];
        
    }
    return self;
}

- (void)forceBegin{
    [self begin];
    
}

- (void)addNextControllerByType:(DispatchViewController  *)controller{
    self.viewController=controller;
    self.viewController.view.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
    //self.downView=[self.entity.contoller.view snapshotViewAfterScreenUpdates:NO];

}

- (void)doAnimation:(UIPanGestureRecognizer *)recognizer{
    CGPoint point=[recognizer locationInView:[self k_mainWindow]];
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.startPoint=point;
        CGPoint v=[recognizer velocityInView:[self k_mainWindow]];
        if(self.moveStatus==Dispatch_Animation_status_ready && v.x>0 &&fabsf(v.y/v.x)<0.5){
            [self begin];
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        if(self.moveStatus==Dispatch_Animation_status_Move){
            if (point.x-self.startPoint.x  > IFDPSAnimationDistanceNav){
                [self push:(DispatchAnimationBase_animationTimeNav*((GlobleWidth-fabs(point.x-self.startPoint.x))/GlobleWidth))];
            }else{
                [self cancle:(DispatchAnimationBase_animationTimeNav*((point.x-self.startPoint.x)/GlobleWidth))];
            }
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
        
        
    } else if(recognizer.state==UIGestureRecognizerStateCancelled){
        if(self.moveStatus==Dispatch_Animation_status_Move){
            
            [self cancle:(DispatchAnimationBase_animationTimeNav*((point.x-self.startPoint.x)/GlobleWidth))];
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
    }
    
    if(self.moveStatus==Dispatch_Animation_status_Move ){
        [self moveViewWithX:(point.x-self.startPoint.x)];
    }

}

- (void)prepareBack{
 
    self.isInitPrepared=YES;
    for(UIView *view in [self.gusetView subviews]){
        if([view isKindOfClass:[UIView class]]){
            [view removeFromSuperview];
        }
    }
   
        self.viewController.view.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        self.downView=[self.viewController.view snapshotViewAfterScreenUpdates:YES];
       // self.downView=self.entity.contoller.view;
    
        float w=GlobleWidth;
        float h=GlobleHeight;
        CGRect rect=self.downView.frame;
   

        self.downHeight=rect.size.height;
   
        rect.size.width=(rect.size.width*Dispatch_navScaleRate);
        rect.size.height=(rect.size.height*Dispatch_navScaleRate);
        float scaleh=(GlobleHeight*Dispatch_navScaleRate);
    
        float y1 = (h-scaleh)/2.0f;
    
        float x1=(w-rect.size.width)/2.0f;
        rect.origin.y=y1;
    
    
        rect.origin.x=x1;
//        self.downView.frame=rect;
        
//        self.markView.alpha=0.5f;
      //  self.markView.alpha=0;
    
        [self.gusetView addSubview:self.downView];
       // self.markView.frame=self.gusetView.bounds;
      //  [self.gusetView addSubview:self.markView];

  
    [[self k_rootController].view.superview insertSubview:self.gusetView
                                           belowSubview:[self k_rootController].view];

}

- (void)moveViewWithX:(float )x{
    x = x>panpushWidth?panpushWidth:x;
    x = x<0?0:x;
    
    
    UIViewController *ctrl=[self k_rootController];
    
    CGRect frame=ctrl.view.frame;
    
    frame.origin.x = x;
//    if (x != GlobleWidth) {
//        
//      
//            frame.origin.y = x*DispatchAnimationBase_animationTimeNav;
//            frame.origin.y = frame.origin.y>IFFitFloat(103)?IFFitFloat(103):frame.origin.y;
//            frame.size.height = GlobleHeight - 2*frame.origin.y;
//            frame.size.width = frame.size.height*ctrl.view.frame.size.width/ctrl.view.frame.size.height;
//
//        
//        
//    }
//    else{
//        frame.origin.x = IFFitFloat(269);
//    
//            frame.origin.y = IFFitFloat(103.0f);
//            frame.size.height = GlobleHeight-IFFitFloat(206);
//            frame.size.width = IFFitFloat(204);
//      
//        
//    }
    
    
    
  //  float w=frame.size.width;
 
  
   
    CGRect frame2 =self.downView.frame;
    float x2=(x/panpushWidth)*(Dispatch_distance_x2*panpushWidth)-(Dispatch_distance_x2*panpushWidth);//+(-(Dispatch_distance_x1*panpushWidth));
    
    frame2.origin.x=x2;
    
    //frame2.origin.x=-(Dispatch_distance_x2+Dispatch_distance_x1*(x/GlobleWidth))*w+x;
//    ctrl.view.frame=frame2;
    
    self.downView.frame=frame2;
   // self.upViewPicture.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    ctrl.view.frame=frame;
   // self.upView.frame = frame;
    
    
    
  
    
   // float w=frame.size.width;
//    self.markView.alpha=0.5f*fabs(1-x/w);
   // self.markView.alpha = 0;
    /*
    CGRect frame=self.upView.frame;
    frame.origin.x = x;
    self.upView.frame=frame;
    self.markView.alpha=0.5f*fabs(1-x/w);
    frame=self.downView.frame;
    */
//    self.upView.frame = CGRectMake(269, 103, GlobleWidth, GlobleHeight-206);
}




- (void)begin{
    
    if(![[CNUIUtil sharedInstance] checkAnimationLock:self])return;
    
    if(self.moveStatus!=Dispatch_Animation_status_ready) return;
    
    [[self k_rootController].view.superview insertSubview:self.gusetView
                                             belowSubview:[self k_rootController].view];
    
   // [self k_rootController].view.layer.shadowOffset=CGSizeMake(10, 10);

    
    self.viewController.preSnapShot=[[self k_rootController].view snapshotViewAfterScreenUpdates:NO];
    


        if (!self.upViewPicture){
            UIImageView *left=[[UIImageView alloc] init];
           //gs left.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
            left.image=[UIImage imageNamed:@"list_dispatch_left.png"];
            left.frame=CGRectMake(-5.f, 0, 5.f, GlobleHeight);
            self.upViewPicture = self.viewController.preSnapShot;
            [self.upViewPicture addSubview:left];
        }
        self.viewController.view.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        self.downView=self.viewController.view;

        
        self.upView.frame=self.gusetView.bounds;
    
        CGRect rect=self.downView.frame;
        
        
        self.downHeight=rect.size.height;
    
    self.downView.frame=self.gusetView.bounds;
        [self.gusetView addSubview:self.downView];
        [self.gusetView addSubview:self.upView];
    self.downView.left=-(Dispatch_distance_x2*panpushWidth);
    
 
  
    [[self k_rootController].view addSubview:self.upViewPicture];
    self.upViewPicture.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR2Right = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pop2Right)];
    [self.upViewPicture addGestureRecognizer:tapGR2Right];
    self.isBegin=YES;
    self.moveStatus=Dispatch_Animation_status_Move;
}

-(void)pop2Right{
    [[self k_currentController].dispatchObj pop];
    //[DispatchCenter pop];
}


- (void)cancleImmdiatelay{
    if(!self.isBegin) return;
  
    
    CGRect frame;
 
    
    [self.viewController.view removeFromSuperview];
    self.viewController.view.frame=[self k_rootController].view.bounds;
    [self.gusetView removeFromSuperview];
    
    [self.downView removeFromSuperview];
    self.downView=nil;
     self.viewController.preSnapShot=nil;
    [self.upView removeFromSuperview];
    self.upView=nil;

    
    [self.upViewPicture removeFromSuperview];
    self.upViewPicture = nil;
    
    self.isBegin=NO;
    frame=[self k_rootController].view.frame;
    frame.origin.x=0;
 
        frame.origin.y = 0;
   
    frame.size.height = GlobleHeight;
    frame.size.width = GlobleWidth;
    [self k_rootController].view.frame=frame;

    [[CNUIUtil sharedInstance] cleanAnimationLock];
   // [self prepareBack];
    self.moveStatus=Dispatch_Animation_status_ready;
}



- (void)cancle:(NSTimeInterval )interval{
    
    if(!self.isBegin) return;
    
    [UIView animateWithDuration:interval animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finish){
        
        CGRect frame;
        frame.origin.x=0;
    
        [self.viewController.view removeFromSuperview];
        [self.gusetView removeFromSuperview];
        self.viewController.view.frame=[self k_rootController].view.bounds;
        frame=[self k_rootController].view.frame;
        frame.origin.x=0;
        [self k_rootController].view.frame=frame;

        self.viewController.preSnapShot=nil;
        
        [self.downView removeFromSuperview];
        self.downView=nil;
        [self.upView removeFromSuperview];
        self.upView=nil;
        
        [self.upViewPicture removeFromSuperview];
        self.upViewPicture = nil;
        self.upViewPicture.hidden = YES;

        
        [[CNUIUtil sharedInstance] cleanAnimationLock];
        //[self prepareBack];
        self.moveStatus=Dispatch_Animation_status_ready;
        
    }];
    self.isBegin=NO;
    
    
}

- (void)pushDirectly{
    
    [self forceBegin];
    [self push:DispatchAnimationBase_animationTimeNav];
}

- (void)push:(NSTimeInterval )interval{
    if(!self.isBegin) return;

    [UIView animateWithDuration:interval animations:^{
        [self moveViewWithX:panpushWidth];
    } completion:^(BOOL finish){

    
        
        
        UIViewController *ctrl=[self k_rootController];
        CGRect frame1=ctrl.view.frame;
        frame1.origin.x = 0;

            frame1.origin.y = 0;
       
        frame1.size.height = GlobleHeight;
        frame1.size.width = GlobleWidth;
        ctrl.view.frame=frame1;
        
        CGRect rect=[self k_rootController].view.bounds;
        rect.origin.x=0.0f;

      
            frame1.origin.y = 0;
       
        rect.size.height = GlobleHeight;
        rect.size.width = GlobleWidth;
        self.viewController.view.frame=rect;
        

        
        self.upViewPicture=nil;
        

//        self.viewController.preSnapShot.frame=CGRectMake(IFFitFloat(269), IFFitFloat(103), IFFitFloat(204), GlobleHeight-IFFitFloat(206));
        
        self.viewController.preSnapShot.frame=CGRectMake(panpushWidth, 0, GlobleWidth, GlobleHeight);
       // self.viewController.preSnapShot.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
       // [img addSubview:self.viewController.preSnapShot];
        
        [self.viewController.view addSubview:self.viewController.preSnapShot];
        
        UINavigationController *root=[self k_rootController];
        self.viewController.dispatchObj=[DispatchAnimationFromLeftNav sharedInstance];
        //self.baseVC.dispatchObj=[CLPushAnimatedRight sharedInstance];
        [root pushViewController:self.viewController animated:NO];
        //[dispatchCenter dispatch];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tap)];
        self.viewController.preSnapShot.userInteractionEnabled=YES;
        [self.viewController.preSnapShot addGestureRecognizer:tap];
        
        
        //[[StadingChannelTransit shareInstance] clearTimer];
        
        CGRect frame=[self k_rootController].view.frame;
        frame.origin.x=0;
        [self k_rootController].view.frame=frame;
        

       
        
       
        [[CNUIUtil sharedInstance] cleanAnimationLock];
        self.moveStatus=Dispatch_Animation_status_ready;
   
        [UIView commitAnimations];
    }];
    
    
    self.isBegin=NO;
   

}

- (void)tap{
    [self.viewController.dispatchObj pop];
}
@end
