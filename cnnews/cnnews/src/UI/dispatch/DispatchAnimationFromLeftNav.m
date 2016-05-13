//
//  DispatchAnimationFromLeftNav.m
//  IfengNews
//
//  Created by Ryan on 13-11-13.
//
//

#import "DispatchAnimationFromLeftNav.h"
#import "DispatchViewController.h"

#define  panpushWidthdis IFFitFloat(269)

@implementation DispatchAnimationFromLeftNav

//SGR_DEF_SINGLETION(DispatchAnimationFromLeftNav)

SGR_DEF_SINGLETION(DispatchAnimationFromLeftNav)


- (void)perpareBackgroundImage4pop{
    
    
  
        UIViewController *rootCtrl=[self k_rootController];
        
        if(!self.guestView){
            self.guestView=[[UIView alloc] init];
            self.guestView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
            
            self.markView=[[UIView alloc] init];
            self.markView.frame=rootCtrl.view.bounds;
            self.markView.backgroundColor=[UIColor blackColor];
        }
        
        self.markView.alpha=0.0;
        
        
        
    
          
            if (!self.upViewPicture) {
                self.upViewPicture=[self k_currentController].preSnapShot;
                
//                self.upViewPicture=[[UIView alloc] initWithFrame:[DispatchCenter indexConroller].view.bounds];
//                self.upViewPicture.backgroundColor=[UIColor orangeColor];
                
            }
            
            
          [[self k_rootController].view.superview addSubview:self.upViewPicture];

       
        
      
        
          //  self.upViewPicture.frame=CGRectMake(IFFitFloat(269), IFFitFloat(103), GlobleWidth, GlobleHeight-IFFitFloat(206));
    
    self.upViewPicture.frame=CGRectMake(IFFitFloat(269), 0, GlobleWidth, GlobleHeight);
            
       
      [self moveViewWithX:0.f];
    
   
}
- (void)clearPopBackground{
    [self.downView removeFromSuperview];
    self.downView=nil;
    
    [self.upView removeFromSuperview];
    self.upView=nil;
  
    [self.upViewPicture removeFromSuperview];
    self.upViewPicture = nil;
    self.upViewPicture.hidden = YES;
    
    [self.guestView removeFromSuperview];
    [self.markView removeFromSuperview];
    
//    [self k_currentController].preSnapShot.frame=
//    CGRectMake(IFFitFloat(269), IFFitFloat(103), IFFitFloat(204), GlobleHeight-IFFitFloat(206));
    [self k_currentController].preSnapShot.frame=
    CGRectMake(IFFitFloat(269), 0, GlobleWidth, GlobleHeight);
    // self.viewController.preSnapShot.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // [img addSubview:self.viewController.preSnapShot];
    
    [[self k_currentController].view addSubview:[self k_currentController].preSnapShot];

    
    
}



- (void)doPan:(UIPanGestureRecognizer *)recognizer{
    CGPoint touchPoint =[recognizer locationInView:[self k_mainWindow]];
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.startPoint=touchPoint;
        CGPoint v=[recognizer velocityInView:[self k_mainWindow]];
        
        if(self.moveStatus==Dispatch_Animation_status_ready &&
           v.x<0 &&fabsf(v.y/v.x)<0.5f&&[[CNUIUtil sharedInstance] checkAnimationLock:self]
           ){
            [self perpareBackgroundImage4pop];
            self.moveStatus=Dispatch_Animation_status_Move;
        }
        
        
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        if(self.moveStatus==Dispatch_Animation_status_Move){
            
            if (touchPoint.x-self.startPoint.x  < -IFDPSAnimationDistanceNav){
                [self pop2Left:DispatchAnimationBase_animationTimeNav*(1-(fabs(touchPoint.x-self.startPoint.x)/GlobleWidth))];
            }
            else{
            [self canclePopBack4Left:DispatchAnimationBase_animationTimeNav*(fabs(touchPoint.x-self.startPoint.x)/GlobleWidth)];
            }
            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
        
    } else if(recognizer.state==UIGestureRecognizerStateCancelled){
        if(self.moveStatus==Dispatch_Animation_status_Move){
            [self canclePopBack4Left:DispatchAnimationBase_animationTimeNav*(fabs(touchPoint.x-self.startPoint.x)/GlobleWidth)];

            self.moveStatus=Dispatch_Animation_status_decelerate;
        }
        
        
    }
    
    if(self.moveStatus==Dispatch_Animation_status_Move){
        
        [self moveViewWithX:touchPoint.x-self.startPoint.x];
    }
    
  
}

- (void)popToController:(UIViewController *)controller{
//    self.moveStatus=Dispatch_Animation_status_decelerate;
//    [self perpareBackgroundImage4pop:1];
//    [self pop2Left:controller];

}

- (void)pop{
    [self popController];
}

- (void)popController{
    self.moveStatus=Dispatch_Animation_status_decelerate;
   // [self perpareBackgroundImage4pop:1];
    [self perpareBackgroundImage4pop];
//    [self.upViewPicture removeFromSuperview];
//    self.upViewPicture = nil;
//    self.upViewPicture.hidden = YES;
    [self pop2Left:DispatchAnimationBase_animationTimeNav];
}

- (void)canclePopBack4Left:(NSTimeInterval )interval{
    [UIView animateWithDuration:interval animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {

        [self clearPopBackground];
        
        [[CNUIUtil sharedInstance] cleanAnimationLock];
        self.moveStatus=Dispatch_Animation_status_ready;
    }];
}

//-(void)touchDrawer{
//    [self pop2Left:1.0];
//}


- (void)pop2Left:(NSTimeInterval )interval{
    
    [UIView animateWithDuration:interval animations:^{
        [self moveViewWithX:-GlobleWidth];

    } completion:^(BOOL finished) {
      
        UIViewController *rootCtrl=[self k_rootController];
        CGRect frame = rootCtrl.view.frame;
        frame.origin.x = 0;
    
            frame.origin.y = 0;
      
        rootCtrl.view.frame = frame;
        
        
        [self clearPopBackground];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemovePictureNotification" object:nil];
        [self doNavigationPop];

        [[CNUIUtil sharedInstance] cleanAnimationLock];
        self.moveStatus=Dispatch_Animation_status_ready;
//        self.drawerView.frame = CGRectMake(0, 0, GlobleWidth, GlobleHeight);
//        [DispatchCenter rootController].view.frame = CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        
        
    }];
}

- (void)moveViewWithX:(float)x{
    //NSLog(@"====%f",x);
    x = x<-panpushWidthdis?-panpushWidthdis:x;
    x = x>0?0:x;
    UIViewController *rootCtrl=[self k_rootController];
    
    CGRect frame=rootCtrl.view.frame;
    float w=rootCtrl.view.bounds.size.width;
    //float h=rootCtrl.view.bounds.size.height;
    frame.origin.x=w+x-IFFitFloat(51);
    
//    self.markView.alpha=0.5*fabs(x/w);
    self.markView.alpha=0;
    
//    if (x != -IFFitFloat(269)) {
//       
//            frame.origin.y = frame.origin.x*0.4;
//            frame.origin.y = frame.origin.y>IFFitFloat(103)?IFFitFloat(103):frame.origin.y;
//            
//            frame.size.height = GlobleHeight - 2*frame.origin.y;
//            frame.size.width = frame.size.height * (rootCtrl.view.frame.size.width/rootCtrl.view.frame.size.height);
//        
//        
//    }
//    else{
//        frame.origin.x = 0;
//        
//            frame.origin.y = 0;
//       
//        
//        frame.size.height = GlobleHeight;
//    }

 
    self.upView.frame=frame;
    self.upViewPicture.frame = frame;
    
    frame.origin.x=
    (x/panpushWidthdis)*(Dispatch_distance_x2*panpushWidthdis);
    rootCtrl.view.frame=frame;
    
//    PathEntity *entity=[[DispatchCenter dispatchCenter_stack] sgrlastObjectOfType:[PathEntity class]];
//     frame=entity.contoller.view.frame;
//  
//  
//        
//        float height=(1-(1-Dispatch_navScaleRate)*(-x/w))*self.donwHeight;
//        float width=(1-(1-Dispatch_navScaleRate)*(-x/w))*w;
//        float scaleH=(1-(1-Dispatch_navScaleRate)*(-x/w))*h;
//        float y1 = (h-scaleH)/2.0f;
//        float x1 = (w-width)/2.0f;
//        frame.origin.y=y1;
//        frame.origin.x=x1;
//        frame.size.height=height;
//        frame.size.width=width;
//    entity.contoller.view.frame=frame;
}

//- (void)pushController:(DispatchCenter *)dispatchCenter{
////    self.moveStatus=Dispatch_Animation_status_decelerate;
////    [self perpareBackgroundImage4pop];
////    [self pop2Left];
//}


@end
