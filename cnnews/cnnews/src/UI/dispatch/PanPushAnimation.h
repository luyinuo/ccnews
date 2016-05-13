//
//  PanPushAnimation.h
//  IfengNews
//
//  Created by Ryan on 13-10-15.
//
//

#import <Foundation/Foundation.h>
#import "CLPushAnimated.h"

@class  DispatchViewController;
@interface PanPushAnimation : NSObject

@property (nonatomic,strong)UIView *gusetView;
@property (nonatomic,strong)UIView *imgView;
@property (nonatomic,strong)UIView *markView;
//@property (nonatomic,strong)PathEntity *entity;
@property (nonatomic,weak) DispatchViewController *baseVC;
@property (nonatomic,strong)NSString *linkType;
//@property (nonatomic,assign)Dispatch_AnimationType animationType;
@property (nonatomic,strong)NSString *pathName;
@property (nonatomic,assign)BOOL isBegin;
@property (nonatomic,assign)CGPoint startPoint;
//@property (nonatomic,assign)BOOL isMove;
@property (nonatomic,assign)CLPushAnimated_Animation_status moveStatus;
@property (nonatomic,assign)BOOL isCovery;
@property (nonatomic,strong)UIImageView *touchHandle;
@property (nonatomic,weak) UIView *realTouchHandleSuperView;
@property (nonatomic,assign)NSTimeInterval startTime;


- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *) gestureRecognizer;

- (void)doAnimation:(UIPanGestureRecognizer *)recognizer;

- (void)cancleImmdiatelay;

- (void)createTouchHandle:(UIView *)aSuperView;
- (void)forceBegin;
- (void)addNextController:(UIViewController *)controller;

- (void)pushDirectly;



@end
