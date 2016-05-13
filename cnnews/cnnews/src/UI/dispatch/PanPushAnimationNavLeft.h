//
//  PanPushAnimationNavLeft.h
//  IfengNews
//
//  Created by Ryan on 13-11-12.
//
//

#import <Foundation/Foundation.h>
#import "CLPushAnimated.h"

#define Dispatch_distance_x1 0.25f
#define Dispatch_distance_x2 0.75f
#define Dispatch_navScaleRate 0.95f
#define DispatchPopMaskAlpha 0.2f

@class  DispatchViewController;
@interface PanPushAnimationNavLeft : NSObject

@property (nonatomic,strong)UIView *gusetView;
//@property (nonatomic,strong)UIView *markView;
//@property (nonatomic,strong)PathEntity *entity;
@property (nonatomic,strong)NSString *linkType;
//@property (nonatomic,assign)Dispatch_AnimationType animationType;
@property (nonatomic,strong)NSString *pathName;
@property (nonatomic,assign)BOOL isBegin;
@property (nonatomic,assign)CGPoint startPoint;
//@property (nonatomic,assign)BOOL isMove;
@property (nonatomic,assign)CLPushAnimated_Animation_status moveStatus;
@property (nonatomic,assign)BOOL isCovery;
//@property (nonatomic,strong)UIImageView *touchHandle;
//@property (nonatomic,weak) UIView *realTouchHandleSuperView;
@property (nonatomic,assign)NSTimeInterval startTime;
@property (nonatomic,strong)UIView *upViewPicture;
@property (nonatomic,strong)UIView *upView;
@property (nonatomic,strong)UIView *downView;
@property (nonatomic,assign)float downHeight;
@property (nonatomic,strong)UIView *naView;
@property (nonatomic,assign)BOOL isInitPrepared;
@property (nonatomic,strong) DispatchViewController *viewController;
//@property (nonatomic,weak) id<UIViewControllerDispatchable> backTarget;


SGR_SINGLETION(PanPushAnimationNavLeft)


- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *) gestureRecognizer;

- (void)doAnimation:(UIPanGestureRecognizer *)recognizer;

- (void)cancleImmdiatelay;

- (void)createTouchHandle:(UIView *)aSuperView;
- (void)forceBegin;
- (void)addNextControllerByType:(DispatchViewController  *)controller;

- (void)pushDirectly;

- (void)prepareBack;

@end
