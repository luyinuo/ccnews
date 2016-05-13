//
//  JTableView.m
//  cactus
//
//  Created by li hongdan on 12-7-19.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#import "JTableView.h"
#import <objc/runtime.h>
#import "NSObject+sagittarius.h"

@interface JTableView()
@property(nonatomic,strong)NSMutableDictionary *channelDate;



@end

@implementation JTableView
@synthesize notNeedBottomMoreView;
@synthesize pageIndex;
@synthesize tableUuid;


- (void)initContext:(CGRect)frame{
    self.channelDate=[NSMutableDictionary dictionary];
    self.pageIndex = 1;
    if(!self.jrefrashHeaderView){
        
        self.jrefrashHeaderView=[[JTableHeaderView alloc] init];
        [self.jrefrashHeaderView setObserverScrollView:self];
        self.backgroundColor=[UIColor whiteColor];
       // super.backgroundColor=ICurrentTheme.globleStyle.indexTableColor;
//        [self setNightBlock:^(UIView *me, BOOL isDay) {
//            me.backgroundColor=isDay?RGB(0xf7, 0xf7, 0xf7):RGB(36.f, 36.f, 36.f);
// 
//        }];
        
        UIView *view=[[UIView alloc] init];
        [view addSubview:self.jrefrashHeaderView];
        //self.backgroundColor=[UIColor clearColor];
        
//        [view setNightBlock:^(UIView *me, BOOL isDay) {
//             me.backgroundColor=isDay?RGB(0xf7, 0xf7, 0xf7):RGB(36.f, 36.f, 36.f);
//        }];
       // view.backgroundColor=ICurrentTheme.globleStyle.indexTableColor;
        [super setBackgroundView:view];
       
    }
    if(!notNeedBottomMoreView && !self.jrefrashBottomView){
        self.jrefrashBottomView=[JTableBottomView new];
        self.jrefrashBottomView.frame=CGRectMake(0,0, self.frame.size.width,50.0f);
        [self.jrefrashBottomView setObserverScrollView:self];
        self.tableFooterView=self.jrefrashBottomView;
        
        
    }
    self.bounces = YES;
}

- (void)hiddenHead{
    if(self.jrefrashHeaderView){
        [self.jrefrashHeaderView removeFromSuperview];
        self.jrefrashHeaderView=nil;
    }
}

- (void)setBackgroundColorReal:(UIColor *)backgroundColor{
    super.backgroundColor=backgroundColor;
}


- (void)setBackgroundViewReal:(UIView *)backgroundView{
    [super setBackgroundView:backgroundView];
   // backgroundView.backgroundColor=[UIColor yellowColor];
}

- (void)setBackgroundViewColorReal:(UIColor *)backgroundColor{
    super.backgroundView.backgroundColor = backgroundColor;
}

-(void)clearBackgroundColor{
    super.backgroundColor = [UIColor clearColor];
    [super setBackgroundView:nil];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
}

- (void)setHiddleBottomLine:(BOOL)hiddleBottomLine{
    _hiddleBottomLine=hiddleBottomLine;
   
    if(self.jrefrashBottomView){
        [self.jrefrashBottomView  hiddenSeperatorLine];
    }
}

- (void)hiddenBottom:(BOOL)isHiddenBottom{
    self.jrefrashBottomView.hidden=isHiddenBottom;
}

- (void)setAutoLoadingNext:(BOOL)isAuto{
        
    [self.jrefrashBottomView setAuto:isAuto];
}
- (void)showLoadingNext:(BOOL)isShow{
    self.jrefrashBottomView.hidden=!isShow;
}



- (void)updateCSS{
    [self.jrefrashHeaderView updateCSS];
//    [self.backgroundView setNightBlock:^(UIView *me, BOOL isDay) {
//        me.backgroundColor=isDay?RGB(0xf7, 0xf7, 0xf7):RGB(36.f, 36.f, 36.f);
//    }];
    [self.jrefrashBottomView updateCSS];
}

- (void)setContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
    [self.jrefrashHeaderView resetSubViewFrame];
}

- (void)setContentInsetReal:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
}


//- (void)setBackgroundColor:(UIColor *)abackgroundColor{
//       // trace(@"话说这个不让用了");
//}
//
//- (void)setBackgroundView:(UIView *)abackgroundView{
//   // trace(@"话说这个不让用了");
//}

- (void)dealloc{
    [self.jrefrashHeaderView removeObserverScrollView:self];
    [self.jrefrashBottomView removeObserverScrollView:self];
   // [self removeObserver:self forKeyPath:@"contentOffset"];
  self.delegate=nil;
  self.dataSource=nil;
}

-(BOOL)isPullReadyStart{
   return  [self.jrefrashHeaderView isNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initContext:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self initContext:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withBottomMoreView:(BOOL)isNeed
{
    self = [super initWithFrame:frame style:style];
    if(self){
        self.notNeedBottomMoreView = !isNeed;
        [self initContext:frame];
    }
    return self;
}

#pragma mark -
#pragma mark manager pageindex
- (void)pageIndexAscending  //pageindex加1
{
    self.pageIndex++;
}

- (void)pageIndexDescending  //pageindex减1
{
    self.pageIndex--;
}

- (void)pageIndexReset  //pageindex重置为1
{
    self.pageIndex = 1;
}

#pragma mark -

- (void)saveDate:(NSDate *)date forChannelId:(NSString *)key{
    if(!key || !date)return;
    if ([key hasPrefix:@"SY"]) {
        key = @"SY";
    }
    NSString *akey = [NSString stringWithFormat:@"%@_updateTimestamp",key];
    NSNumber *number=@([date timeIntervalSince1970]);
    [self.channelDate sgrSetObject:number forKey:akey];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:akey];
}

- (NSDate *)dateForChannelId:(NSString *)key{
    if(!key)return nil;
    NSString *akey = [NSString stringWithFormat:@"%@_updateTimestamp",key];
    NSNumber *number=[self.channelDate sgrGetNumberForKey:akey];
    if(!number){
        number=[[NSUserDefaults standardUserDefaults] objectForKey:akey];
        if(number)[self.channelDate sgrSetObject:number forKey:akey];
    }
    
    if(!number || ![number isKindOfClass:[NSNumber class]])return nil;
    return [NSDate dateWithTimeIntervalSince1970:[number doubleValue]];
}

- (void)initComponent{
    [super setDelegate:self];
}


- (void)stopHeadLoading{
    [self stopHeadLoadingWithResult:YES];
}

- (void)stopHeadLoadingWithResult:(BOOL)bSucc{
    [self.jrefrashHeaderView finishLoading:self withResult:bSucc animated:YES];
}
- (void)stopHeadLoadingNoAnimatedWithResult:(BOOL)bSucc{
  [self.jrefrashHeaderView finishLoading:self withResult:bSucc animated:NO];
}
- (void)stopHeadLoadingNoAnimated{
     [self.jrefrashHeaderView finishLoading:self withResult:YES animated:NO];
}

- (void)stopBottomMoreWithScuessLoading
{
    //[self.jrefrashBottomView finishWithScuessLoading:self];
    [self.jrefrashBottomView finishWithSuccessLoading:self];
}

- (void)stopBottomMoreWithFailedLoading
{
    [self.jrefrashBottomView finishWithFailLoading:self];
}

- (void)stopBottomMoreWithNothingLoading
{
   // [self.jrefrashBottomView finishWithNothingLoading:self];
    [self.jrefrashBottomView finishWithNoMoreData:self];
}

- (void)stopBottomMoreWithNoMoreData
{
    [self.jrefrashBottomView finishWithNoMoreData:self];
}

- (void)stopBottomWithSuccessLoadingNoAuto{
    [self.jrefrashBottomView finishWithFailLoading:self];
}

- (BOOL)isLoading
{
    return [self.jrefrashHeaderView isLoading];
}

- (void)becameHeadReflashLoadingNoAnimation{
    self.refrashType=JTableViewRefrashType_RefrashAuto;
    [self JTableViewStartHeadLoading];
}

- (void)becameHeadReflashLoading{
    //[self resetHeadView];
    
    if (![self.jrefrashHeaderView isLoading]) {
        self.refrashType=JTableViewRefrashType_RefrashAuto;
        JTableView __weak *me=self;
        [self.jrefrashHeaderView becameReflashLoading:^(BOOL finish){
                me.refrashType=JTableViewRefrashType_RefrashAuto;
  
        }];
    }
}

- (void)becameHeadReflashLoadingIgnoreCache{
   // [self resetHeadView];
    
    if (![self.jrefrashHeaderView isLoading]) {
            self.refrashType=JTableViewRefrashType_RefrashManually;
            JTableView __weak *me=self;
            [self.jrefrashHeaderView becameReflashLoading:^(BOOL finish){
                if(finish){
                    me.refrashType=JTableViewRefrashType_RefrashManually;
                }
            }];
    }
}

- (void)updateHeadTimestamp:(NSDate *)date{
    [self.jrefrashHeaderView updateTimestamp:date];
}


- (void)resetBottomMoreViewAutoLoadTimes:(NSInteger)times
{
    [self.jrefrashBottomView reset:YES];
}


- (void)reloadData{
    [super reloadData];

    
}

-(void)JRefrashTableBottomMoreViewStartLoading
{
    if([self.delegate respondsToSelector:@selector(jTableViewStartBottomMoreLoading:)])
        [self.delegate performSelector:@selector(jTableViewStartBottomMoreLoading:) withObject:self];
}

- (void)JRefrashTableBottomMoreViewStopLoading
{
    if([self.delegate respondsToSelector:@selector(jTableViewStopBottomMoreLoading:)])
        [self.delegate performSelector:@selector(jTableViewStopBottomMoreLoading:) withObject:self];
}

-(void)JTableViewStartHeadLoading{
    [self pageIndexReset];
    [self resetBottomMoreViewAutoLoadTimes:0];
    if([self.delegate respondsToSelector:@selector(jTableViewStartHeadLoading:)]){
        [self.delegate performSelector:@selector(jTableViewStartHeadLoading:) withObject:self];
    }
}

- (void)JTableViewStartHeadLoadingWithType:(NSNumber *)type
{
    [self pageIndexReset];
    [self resetBottomMoreViewAutoLoadTimes:0];
    if([self.delegate respondsToSelector:@selector(jTableViewStartHeadLoading:withRefrashType:)])
        [self.delegate performSelector:@selector(jTableViewStartHeadLoading:withRefrashType:)
                            withObject:self
                            withObject:type];
}


- (void)resetHeadView{
    [self.jrefrashHeaderView finishLoading:self withResult:YES animated:NO];

}




- (void)isNeedReset:(BOOL)isReset
{
    self.jrefrashHeaderView.needReset=isReset;
}
- (void)setRefrashHeadViewOffset:(float)refrashHeadViewOffset{
    _refrashHeadViewOffset = refrashHeadViewOffset;
    [self resetHeadView];
}
@end
