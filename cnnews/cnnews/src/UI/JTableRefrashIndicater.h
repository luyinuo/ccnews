//
//  JTableRefrashIndicater.h
//  IfengNews
//
//  Created by Ryan on 14-1-23.
//
//

#import <UIKit/UIKit.h>

/**
 枚举
 */
// 控件的刷新状态
typedef enum {
	JTableRefrashIndicaterStateProgress,
    JTableRefrashIndicaterStateImg,
    JTableRefrashIndicaterStateImgLoading,
    JTableRefrashIndicaterStateImgFail
} JTableRefrashIndicaterState;

@interface JTableRefrashIndicater : UIView

@property (nonatomic,strong) UIColor *progressTintColor;

@property (nonatomic,strong) CALayer *add1;
@property (nonatomic,strong) CALayer *add2;

- (void)setLogoState:(JTableRefrashIndicaterState )aindicaterState;
- (void)setProgress:(float)progress;

- (void)updateCSS;

- (void)starInfinitAnimation;
- (void)stopInfinitAnimation;

@end
