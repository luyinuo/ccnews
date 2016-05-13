//
//  DispatchAnimationFromLeftNav.h
//  IfengNews
//
//  Created by Ryan on 13-11-13.
//
//

#import "CLPushAnimated.h"


@interface DispatchAnimationFromLeftNav : CLPushAnimated

@property (nonatomic,assign) float donwHeight;
@property (nonatomic,strong) UIView *markView;
@property (nonatomic,strong) UIView *guestView;
@property (nonatomic,strong) UIView *upView;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,strong) UIView *upViewPicture;
@property (nonatomic,unsafe_unretained) CGPoint startPoint;
//@property (nonatomic,strong)UIView *drawerView;

SGR_SINGLETION(DispatchAnimationFromLeftNav)

@end
