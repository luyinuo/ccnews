//
//  JTableView.h
//  cactus
//
//  Created by li hongdan on 12-7-19.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUIheader.h"
#import "UIView+Utils.h"
#import "JTableBottomView.h"
#import "JTableHeaderView.h"

@protocol CTWindowsEventProtocol;


typedef enum
{
  JTableViewRefrashType_RefrashAuto = 0,
  JTableViewRefrashType_RefrashManually = 1
  
} JTableViewRefrashType;


@class JTableView;
@protocol JTableViewDelegate<NSObject, UIScrollViewDelegate,UITableViewDelegate>
-(void)jTableViewStartHeadLoading:(JTableView *)tableView;
-(void)jTableViewStartHeadLoading:(JTableView *)tableView withRefrashType:(NSNumber *)type;
-(void)jTableViewStartBottomLoading:(JTableView *)tableView;

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
@protocol JTableViewDataSource <NSObject,UITableViewDataSource>



@end

@interface JTableView : UITableView<UITableViewDelegate>{
  //JRefrashTableHeadView *refrashHeadView;
 // JRefrashTableBottomMoreView *refrashBottomMoreView;
  BOOL notNeedBottomMoreView;
  NSString *tableUuid;
  @private
  int pageIndex;
}
@property (nonatomic, assign) float refrashHeadViewOffset;
@property (nonatomic,unsafe_unretained) BOOL hiddleBottomLine;
//@property (nonatomic,retain) JRefrashTableHeadView *refrashHeadView;
//@property (nonatomic,retain) JRefrashTableBottomMoreView *refrashBottomMoreView;
@property (nonatomic,assign) BOOL notNeedBottomMoreView;
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,retain) NSString *tableUuid;
@property (nonatomic,assign) BOOL needRefrashView;
@property (nonatomic,unsafe_unretained) JTableViewRefrashType refrashType;
@property (nonatomic,strong)JTableHeaderView *jrefrashHeaderView;
@property (nonatomic,strong)JTableBottomView *jrefrashBottomView;
- (void)stopHeadLoading;
-(BOOL)isPullReadyStart;
- (void)stopHeadLoadingWithResult:(BOOL)bSucc;
- (void)stopHeadLoadingNoAnimatedWithResult:(BOOL)bSucc;
-(void)JTableViewStartHeadLoading;
- (void)updateHeadTimestamp:(NSDate *)date;

- (void)setAutoLoadingNext:(BOOL)isAuto;
- (void)showLoadingNext:(BOOL)isShow;

- (void)stopBottomMoreWithScuessLoading;
- (void)stopBottomMoreWithFailedLoading;
- (void)stopBottomMoreWithNoMoreData;

- (void)becameHeadReflashLoading;
- (void)resetBottomMoreViewAutoLoadTimes:(NSInteger)times;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withBottomMoreView:(BOOL)isNeed;
-(void)clearBackgroundColor;
- (void)saveDate:(NSDate *)date forChannelId:(NSString *)key;
- (NSDate *)dateForChannelId:(NSString *)key;

- (void)pageIndexAscending;  //pageindex加1
- (void)pageIndexDescending;  //pageindex减1
- (void)pageIndexReset;  //pageindex重置为1
- (void)updateCSS;
- (BOOL)isLoading;
- (void)isNeedReset:(BOOL)isReset;
- (void)stopHeadLoadingNoAnimated;
- (void)becameHeadReflashLoadingNoAnimation;
- (void)becameHeadReflashLoadingIgnoreCache;
- (void)stopBottomWithSuccessLoadingNoAuto;
- (void)stopBottomMoreWithNothingLoading;

- (void)setContentInsetReal:(UIEdgeInsets)contentInset;

- (void)hiddenBottom:(BOOL)isHiddenBottom;

- (void)setBackgroundColorReal:(UIColor *)backgroundColor;

- (void)setBackgroundViewReal:(UIView *)backgroundView;

- (void)setBackgroundViewColorReal:(UIColor *)backgroundColor;
- (void)hiddenHead;

@end
