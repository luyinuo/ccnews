//
//  JTableHeaderView.m
//  IfengNews
//
//  Created by Ryan on 14-1-23.
//
//

#import "JTableHeaderView.h"
#import "JTableRefrashIndicater.h"
#import "UIView+Utils.h"
#import "JTableView.h"


//const CGFloat MJRefreshViewHeight = 64.0;
//const CGFloat MJRefreshAnimationDuration = 0.25;

#define MJRefreshViewInsetHeight 63.0f
#define MJRefreshViewHeight 64.0f
#define MJRefreshAnimationDuration 0.25f

/**
 枚举
 */
// 控件的刷新状态
typedef enum {
	MJRefreshStatePulling = 1, // 松开就可以进行刷新的状态
	MJRefreshStateNormal = 2, // 普通状态
	MJRefreshStateRefreshing = 3, // 正在刷新中的状态
    MJRefreshStateWillRefreshing = 4,
    MJRefreshStateResetting,
    MJRefreshStateAuto
} MJRefreshState;

@interface JTableHeaderView ()

@property (nonatomic,weak) JTableView *scrollView;

@property (nonatomic,unsafe_unretained) UIEdgeInsets scrollViewInitInset;

//@property (nonatomic,strong)UILabel *wordLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,assign) NSTimeInterval jTableHeadViewRefrashTimesTemp;
@property (nonatomic,strong) JTableRefrashIndicater *indicater;
@property (nonatomic,assign)MJRefreshState state;
@property (nonatomic,assign) float validY;
@property (nonatomic,unsafe_unretained) float topInsert;



@end

@implementation JTableHeaderView

- (void)setObserverScrollView:(JTableView *)ascrollView{
    
   
    
   // [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    self.scrollView=ascrollView;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self resetSubViewFrame];
}



- (void)removeObserverScrollView:(JTableView *)ascrollView{
    
    [ascrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
}


- (void)resetSubViewFrame{
    CGRect aframe=self.indicater.frame;
    aframe.origin.y=20.0f+self.scrollView.contentInset.top;
    self.indicater.frame=aframe;
    
//    aframe=self.logoView.frame;
//    aframe.origin.y=83.0f+self.scrollView.contentInset.top;
//    self.logoView.frame=aframe;
////
////    
//    aframe=self.wordLabel.frame;
//    aframe.origin.y=_indicater.top;
//    self.wordLabel.frame=aframe;
//
//    
//    aframe=self.timeLabel.frame;
//    aframe.origin.y=_indicater.top;
//    self.timeLabel.frame=aframe;
    self.scrollViewInitInset=self.scrollView.contentInset;
}

- (id)init
{
    self = [super init];
      if (self) {
        self.frame=CGRectMake(0, 0, GlobleWidth, 170.0f);
          
        
        self.jTableHeadViewRefrashTimesTemp=0.0f;
        self.indicater=[[JTableRefrashIndicater alloc] init];
          
           self.indicater.frame=CGRectMake((GlobleWidth-36.f)/2.f, 0.0f, 36.0f, 36.0f);
          [self addSubview:self.indicater];
          //self.backgroundColor=[UIColor blueColor];
//          self.logoView=[[UIImageView alloc] init];
//          self.logoView.frame=CGRectMake((GlobleWidth-143.f)/2.f, 83.0f, 143.0f, 40.0f);
//          self.logoView.image=[UIImage imageNamed:@"logo_bg.png"];
//          [self addSubview:self.logoView];
//          
//          _state=MJRefreshStateNormal;
//          
//          self.wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indicater.right+10, 42.0f, 80, _indicater.height)];
//          self.wordLabel.autoresizingMask = _indicater.autoresizingMask;
//          self.wordLabel.font = [UIFont systemFontOfSize:16];
//          self.wordLabel.backgroundColor = [UIColor clearColor];
//          self.wordLabel.textColor=[UIColor colorWithRed:0x86/255.0f green:0x86/255.0f blue:0x86/255.0f alpha:1.0f];
//          self.wordLabel.text=@"下拉加载";
//          //self.wordLabel.bOptimize = YES;
//          [self addSubview:self.wordLabel];
//
//          self.timeLabel = [[UILabel alloc]
//                            initWithFrame:CGRectMake(self.wordLabel.left+85.0f, self.wordLabel.top+1, 60, self.wordLabel.height)];
//          //self.timeLabel.centerX = self.wordLabel.right+28;
//          self.timeLabel.textAlignment = NSTextAlignmentCenter;
//          self.timeLabel.autoresizingMask = _indicater.autoresizingMask;
//          self.timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//          self.timeLabel.backgroundColor = [UIColor clearColor];
//          self.timeLabel.textColor = [UIColor colorWithRed:0x6a/255.0f green:0x6a/255.0f blue:0x6a/255.0f alpha:1.0f];
        //  [self addSubview:self.timeLabel];
          
          [self updateCSS];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
//    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
//        || _state == MJRefreshStateRefreshing) return;
    if(_state==MJRefreshStateRefreshing ||self.scrollView.contentOffset.y>0  || _state==MJRefreshStateAuto) return;
    
    CGFloat offsetY = self.scrollView.contentOffset.y * -1-_scrollViewInitInset.top;
   // CGFloat limitY=self.scrollView.contentInset.top+MJRefreshViewHeight;

    float progress=0.0f;
    if(offsetY>=MJRefreshViewHeight)progress=1.0f;
    if(offsetY>20.0f)progress=(offsetY-20.0f)/(MJRefreshViewHeight-20.0f);
    
   
    [self.indicater
     setProgress:progress];
 
    if(offsetY<=0) return;
    
    if (self.scrollView.isDragging){
      
        if(_state == MJRefreshStatePulling && offsetY<MJRefreshViewHeight){
            [self setState:MJRefreshStateNormal];
        }else if (_state == MJRefreshStateNormal && offsetY >= MJRefreshViewHeight){
            [self setState:MJRefreshStatePulling];
        }
    }else{
      
        if (_state == MJRefreshStatePulling){
            
            [self setState:MJRefreshStateRefreshing];
        }
    }
    
    
    
}

- (BOOL)isNormal{
    return self.state==MJRefreshStateNormal;
}

- (BOOL)isLoading
{
    return (self.state == MJRefreshStateRefreshing);
}

- (void)becameReflashLoading:(void (^)(BOOL finished))completion{
    
    
    
    _state=MJRefreshStateAuto;
    [self.indicater
     setProgress:1.0f];
    
    [self.scrollView setContentOffset:CGPointMake(0, -_scrollViewInitInset.top)
                             animated:NO];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, -MJRefreshViewInsetHeight-_scrollViewInitInset.top)
                                 animated:NO];
    
    } completion:^(BOOL finish){
    
    
        [UIView animateWithDuration:0.1
                         animations:^{
                             UIEdgeInsets inset = _scrollViewInitInset;
                             inset.top = _scrollViewInitInset.top + MJRefreshViewInsetHeight;
                             [_scrollView setContentInsetReal:inset];
                             
                         }
                         completion:^(BOOL finish){
                             
                             completion(finish);
                          //   self.wordLabel.text=@"正在载入...";
                             [self.indicater setLogoState:JTableRefrashIndicaterStateImgLoading];
                             [self.indicater starInfinitAnimation];
                             _state =MJRefreshStateRefreshing;
                             if ([self.scrollView respondsToSelector:@selector(JTableViewStartHeadLoading)]) {
                                 [self.scrollView performSelector:@selector(JTableViewStartHeadLoading)];
                                 self.jTableHeadViewRefrashTimesTemp = [[NSDate date] timeIntervalSince1970];
                             }
                             
                             if([self.scrollView respondsToSelector:@selector(JTableViewStartHeadLoadingWithType:)])
                                 [self.scrollView performSelector:@selector(JTableViewStartHeadLoadingWithType:)
                                                       withObject:[NSNumber numberWithInt:1]];
                             
                             //15秒重置
                             //                         if (_needReset) {
                             //                             [self performSelector:@selector(becomeReset:) withObject:nil afterDelay:15];
                             //                         }
                             
                             
                             
                         }];

    
    
    }];

    
    
    
    
//    //[self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top)];
//    
//    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:NO];
//    
//    [self setState:MJRefreshStatePulling];
//    [UIView animateWithDuration:0.4 animations:^(){
//    
//        [self.scrollView setContentOffset:CGPointMake(0, -MJRefreshViewHeight-self.scrollView.contentInset.top)];
//    
//    } completion:completion];
    
    //[self setState:MJRefreshStateRefreshing];
}


- (void)setState:(MJRefreshState)state{
    if (state == _state)
        return;
     _state = state;
    switch (state) {
        case MJRefreshStatePulling:{
          //  self.wordLabel.text=@"释放加载";
            [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
          
//            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
//                UIEdgeInsets inset = _scrollView.contentInset;
//                inset.top = _scrollViewInitInset.top;
//                _scrollView.contentInset = inset;
//            }];
        }
            break;
        case MJRefreshStateNormal:{
          //  self.wordLabel.text=@"下拉加载";
            [self.indicater setLogoState:JTableRefrashIndicaterStateProgress];
            //self.indicater.IndicaterState=JTableRefrashIndicaterStateProgress;
//            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
//            
//                UIEdgeInsets inset = _scrollView.contentInset;
//                inset.top = _scrollViewInitInset.top;
//                _scrollView.contentInset = inset;
//            }];
            
        }
            break;
        case MJRefreshStateRefreshing:{
           
        //    self.wordLabel.text=@"正在载入...";
            //self.indicater.IndicaterState=JTableRefrashIndicaterStateImgLoading;
            [self.indicater setLogoState:JTableRefrashIndicaterStateImgLoading];
            [self.indicater starInfinitAnimation];
            //MJRefreshAnimationDuration
            
            self.scrollView.refrashType=JTableViewRefrashType_RefrashManually;
            void (^completion)(BOOL finished);
            
            completion=^(BOOL finished){
                
                if ([self.scrollView respondsToSelector:@selector(JTableViewStartHeadLoading)]) {
                    [self.scrollView performSelector:@selector(JTableViewStartHeadLoading)];
                    self.jTableHeadViewRefrashTimesTemp = [[NSDate date] timeIntervalSince1970];
                }
                
                if([self.scrollView respondsToSelector:@selector(JTableViewStartHeadLoadingWithType:)])
                    [self.scrollView performSelector:@selector(JTableViewStartHeadLoadingWithType:)
                                          withObject:[NSNumber numberWithInt:1]];
                
                //15秒重置
//                if (_needReset) {
//                    [self performSelector:@selector(becomeReset:) withObject:nil afterDelay:15];
//                }
                
                
            };
            
            
            
            float timeInterval=((_scrollView.contentOffset.y-_scrollViewInitInset.top-MJRefreshViewInsetHeight)/MJRefreshViewInsetHeight)*0.4f;
          
            [UIView animateWithDuration:timeInterval>0?timeInterval:0.2f
                             animations:^{
                                 
                                 // 1.增加65的滚动区域
                                 UIEdgeInsets inset = _scrollView.contentInset;
                                 inset.top = _scrollViewInitInset.top + MJRefreshViewInsetHeight;
                                 [_scrollView setContentInsetReal:inset];
                                 
                            
                                 // 2.设置滚动位置
                                 //    _scrollView.contentOffset = CGPointMake(0, - _scrollViewInitInset.top - MJRefreshViewHeight);
                                 
                             } completion:completion];
            
        }
            break;
            
        default:
            break;
    }
   
}

- (void)finishLoading:(UIScrollView *)scrollView withResult:(BOOL)bSucc animated:(BOOL)bAnimation{
    
    
    //[NSThread sleepForTimeInterval:5] ;
    if(self.state!=MJRefreshStateRefreshing){
        return;
    }

    //[self.indicater stopInfinitAnimation];
    if(bAnimation){
        if(bSucc){
        //    self.wordLabel.text = @"加载成功";
           // [self.indicater setLogoState:JTableRefrashIndicaterStateImgFail];
        }else{
         //   self.wordLabel.text = @"加载失败";
            [self.indicater setLogoState:JTableRefrashIndicaterStateImgFail];
        }
        self.state = MJRefreshStateResetting;
        [UIView animateWithDuration:0.4 delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                            [self.scrollView setContentInsetReal:_scrollViewInitInset];
                         }
                         completion:^(BOOL finished) {
                             
                            self.state = MJRefreshStateNormal;
                             [self.indicater setProgress:0.0f];
                             [self.indicater stopInfinitAnimation];
                         }];
        
    }else{
        self.state = MJRefreshStateNormal;
        [self.scrollView setContentInsetReal:_scrollViewInitInset];
        [self.indicater setProgress:0.0f];
        
    }
}

- (void)becomeReset:(UIScrollView *)scrollView {
    [self finishLoading:scrollView withResult:YES animated:NO];
}

- (void)updateTimestamp:(NSDate *)date{
    if (date) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //    [formatter setAMSymbol:@"上午"];
//        //    [formatter setPMSymbol:@"下午"];
//        [formatter setDateFormat:@"H:mm"];
//        //   NSLog(@"%@",[NSString stringWithFormat:@"上次更新时间: %@", [formatter stringFromDate:date]]);
//        self.timeLabel.text = [NSString stringWithFormat:@"上次更新时间: %@", [formatter stringFromDate:date]];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //    [formatter setAMSymbol:@"上午"];
        //    [formatter setPMSymbol:@"下午"];
        [formatter setDateFormat:@"H:mm"];
        //   NSLog(@"%@",[NSString stringWithFormat:@"上次更新时间: %@", [formatter stringFromDate:date]]);
        self.timeLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
        
       
    }else{
        self.timeLabel.text=@"";
    }
    
    
    
}



- (void)updateCSS{
    //self.backgroundColor=ICurrentTheme.globleStyle.indexTableColor;
//    [self setNightBlock:^(UIView *me, BOOL isDay) {
//        me.backgroundColor=isDay?RGB(0xf7, 0xf7, 0xf7):RGB(36.f, 36.f, 36.f);
//    }];
    
    //self.logoView.image=[UIImage imageNamed:ICurrentTheme.globleStyle.refreshLogo];
//    [self.logoView setNightBlock:^(UIView *me, BOOL isDay) {
//        ((UIImageView *)me).image=isDay?[UIImage imageNamed:@"list_refresh_logo.png"]:
//        [UIImage imageNamed:@"list_refresh_logo_night.png"];
//    }];
    
    [self.indicater updateCSS];
    //self.timeLabel.textColor=ICurrentTheme.listStyle.listReflashTimeColor;

//    [self.timeLabel setNightBlock:^(UIView *me, BOOL isDay) {
//        ((UILabel *)me).textColor=
//        isDay?[UIColor colorWithRed:0xbe/255.0f green:0xbe/255.0f blue:0xbe/255.0f alpha:1.0f]:
//        [UIColor colorWithRed:0x63/255.0f green:0x6e/255.0f blue:0x7c/255.0f alpha:1.0f];
//    }];
   // self.wordLabel.textColor=ICurrentTheme.listStyle.listReflashTextColor;
//    [self.wordLabel setNightBlock:^(UIView *me, BOOL isDay) {
//        ((UILabel *)me).textColor=isDay?[UIColor colorWithRed:0x86/255.0f green:0x86/255.0f blue:0x86/255.0f alpha:1.0f]:
//        [UIColor colorWithRed:0x63/255.0f green:0x6e/255.0f blue:0x7c/255.0f alpha:1.0f];
//    }];
}

- (void)free{
  //  [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];

}



- (void)dealloc{
    [self removeObserverScrollView:self.scrollView];
}



@end
