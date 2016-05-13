//
//  JTableHeaderView.h
//  IfengNews
//
//  Created by Ryan on 14-1-23.
//
//

#import <UIKit/UIKit.h>
#import "JUIheader.h"

@class JTableView;
@interface JTableHeaderView : UIView
//@property (nonatomic, assign) JRHPullRefreshState state;
@property (nonatomic,assign) BOOL needReset;
//@property (nonatomic,strong) UIImageView *logoView;


- (void)updateCSS;

- (void)setObserverScrollView:(JTableView *)ascrollView;

- (void)removeObserverScrollView:(JTableView *)ascrollView;

- (void)resetSubViewFrame;

- (BOOL)isNormal;

- (BOOL)isLoading;
- (void)finishLoading:(UIScrollView *)scrollView withResult:(BOOL)bSucc animated:(BOOL)bAnimation;

- (void)becameReflashLoading:(void (^)(BOOL finished))completion;

- (void)updateTimestamp:(NSDate *)date;

- (void)free;

@end
