//
//  JTableViewBottomView.h
//  IfengNews
//
//  Created by Ryan on 14-1-28.
//
//

#import <UIKit/UIKit.h>
#import "JTableRefrashIndicater.h"

typedef enum{
    JTableViewLoadMoreStateLoading = 0,
    JTableViewLoadMoreStateNormal,
    JTableViewLoadMoreStateNoMore,
    JTableViewLoadMoreStatePulling
}JTableViewLoadMoreState;


#define JRefrashTableBottomMoreView_Height 50.0
#define JRefrashTableBottomMoreViewIgnore_Height 15.0

@class JTableView;
@interface JTableBottomView : UIView

@property (nonatomic,unsafe_unretained) BOOL isAutoReflash;

@property (nonatomic,assign) JTableViewLoadMoreState state;

//@property (nonatomic,strong) JTableRefrashIndicater *indicater;

- (id)initBy24H:(BOOL)is24H;

- (void)setObserverScrollView:(JTableView *)ascrollView;

- (void)removeObserverScrollView:(JTableView *)ascrollView;

- (void)updateCSS;

- (void)becameReflashLoading:(void(^)(BOOL isfinish))finish;

- (void)finishWithSuccessLoading:(UIScrollView *)scrollView;
- (void)finishWithFailLoading:(UIScrollView *)scrollView;
- (void)finishWithNoMoreData:(UIScrollView *)scrollView;
- (void)finishWithSuccessLoadingNoAuto:(UIScrollView *)scrollView;

- (void)reset:(BOOL)autoload;
- (void)setAuto:(BOOL)isAuto;

- (void)hiddenSeperatorLine;
- (void)setHidden:(BOOL)hidden;

//4.6.1
//调整显示类容的左右位置
-(void)updateSignForLeftPadding:(CGFloat)leftPadding;
- (void)hiddenWordAndImage;

@end
