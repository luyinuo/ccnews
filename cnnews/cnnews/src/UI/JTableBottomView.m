//
//  JTableViewBottomView.m
//  IfengNews
//
//  Created by Ryan on 14-1-28.
//
//

#import "JTableBottomView.h"
#import "JTableView.h"
#import "JTableRefrashIndicater.h"
//#import "CTIndexCell.h"
//#import "IFFrameAndFont.h"
//#import "JRefrashTableBottomMoreView.h"
#define JTableBottomMoreView_Height IFScreenFit2s(50.0f)

@interface JTableBottomView ()

@property (nonatomic,weak) JTableView *scrollView;

@property (nonatomic,strong) UILabel *wordLabel;
@property (nonatomic,strong) UIImageView *separatorLine;

@property (nonatomic, unsafe_unretained) BOOL is24H;

@end

@implementation JTableBottomView

- (id)initBy24H:(BOOL)is24H
{
    self = [super init];
    if (self) {
        self.is24H = is24H;
        
        self.frame=CGRectMake(0, 0, GlobleWidth, JTableBottomMoreView_Height);
        self.isAutoReflash=YES;
        
//        self.indicater = [JTableRefrashIndicater new];
//        self.indicater.frame=
//        CGRectMake(IFScreenFit2(96.0f, 124.f), (JRefrashTableBottomMoreView_Height - IFScreenFit2s(17.0f))/2.0f, IFScreenFit2s(17.0f), IFScreenFit2s(17.0f));
//        [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
//        self.indicater.autoresizingMask =
//        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//        //[_indicater stopAnimationOnComplete:nil isSucc:YES animated:YES];
//        [self addSubview:self.indicater];
        
        _state = JTableViewLoadMoreStateNormal;
        
        _wordLabel =
        [[UILabel alloc] initWithFrame:CGRectMake((GlobleWidth-IFScreenFit2s(110))/2.f+IFScreenFit2s(12), IFScreenFit2s(17.0f), IFScreenFit2s(110), IFScreenFit2s(17.0f))];
        _wordLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _wordLabel.font = CNFont(IFScreenFit2s(16));
        _wordLabel.backgroundColor = [UIColor clearColor];
        _wordLabel.textColor = [UIColor colorWithRed:0x6a/255.0f green:0x6a/255.0f blue:0x6a/255.0f alpha:1.0f];
        _wordLabel.text=@"没有更多内容";
        
        //wordLabel.bOptimize = YES;
        [self addSubview:_wordLabel];
        
        // 上面的一条分割线
        _separatorLine =[[UIImageView alloc] initWithImage:nil];
        _separatorLine.frame = CGRectMake(IFIndexCellEdgeCap, 0, GlobleWidth-2*IFIndexCellEdgeCap, 0.5);
        [self addSubview:_separatorLine];
        [self updateCSS];
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        self.frame=CGRectMake(0, 0, GlobleWidth, JTableBottomMoreView_Height);
        self.isAutoReflash=YES;
        
//        self.indicater = [JTableRefrashIndicater new];
//        self.indicater.frame=
//        CGRectMake(IFScreenFit2(96.0f, 124.f), (JRefrashTableBottomMoreView_Height - IFScreenFit2s(17.0f))/2.0f, IFScreenFit2s(17.0f), IFScreenFit2s(17.0f));
//        [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
//        self.indicater.autoresizingMask =
//        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//        //[_indicater stopAnimationOnComplete:nil isSucc:YES animated:YES];
//        [self addSubview:self.indicater];
        
        _state = JTableViewLoadMoreStateNormal;
        
        _wordLabel =
        [[UILabel alloc] initWithFrame:CGRectMake((GlobleWidth-IFScreenFit2s(110))/2.f+IFScreenFit2s(12), IFScreenFit2s(17.0f), IFScreenFit2s(110), IFScreenFit2s(17.0f))];
        _wordLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _wordLabel.font = CNFont(IFScreenFit2s(16));
        _wordLabel.backgroundColor = [UIColor clearColor];
        _wordLabel.textColor = [UIColor colorWithRed:0x6a/255.0f green:0x6a/255.0f blue:0x6a/255.0f alpha:1.0f];
        _wordLabel.text=@"没有更多内容";

        //wordLabel.bOptimize = YES;
        [self addSubview:_wordLabel];
        
        // 上面的一条分割线
        _separatorLine =[[UIImageView alloc] initWithImage:nil];
        _separatorLine.frame = CGRectMake(IFIndexCellEdgeCap, 0, GlobleWidth-2*IFIndexCellEdgeCap, 0.5);
        [self addSubview:_separatorLine];
        [self updateCSS];

    }
    
    return self;
}

- (void)hiddenSeperatorLine{
    _separatorLine.hidden=YES;
}

- (BOOL)isLoading{
    return _state==JTableViewLoadMoreStateLoading;
}


- (void)setObserverScrollView:(JTableView *)ascrollView{
    
    
    // [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    self.scrollView=ascrollView;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    

    
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    if(_state==JTableViewLoadMoreStateLoading || self.hidden==YES) return;
    
    if(self.scrollView.contentSize.height<self.scrollView.height){
        if (self.is24H) {
            self.scrollView.tableFooterView = nil;
            self.frame = CGRectMake(0, (self.scrollView.height-self.scrollView.contentOffset.y), GlobleWidth, 50.f);
            //NSLog(@"[%f],[%f]",self.scrollView.height,self.scrollView.contentOffset.y);
        }
        else {
            //当数据过少时底部上拉隐藏 by wfm
           // self.indicater.hidden = YES;
            self.wordLabel.hidden = YES;
            return;
        }
    }
    else{
        if (self.is24H) {
            self.scrollView.tableFooterView = self;
        }
        else {
          //  self.indicater.hidden = NO;
            self.wordLabel.hidden = NO;
        }
    }
    
    if(_isAutoReflash){
        float originYOfMoreViewShow=
        self.scrollView.contentSize.height-self.scrollView.frame.size.height-self.frame.size.height;
        
        if (self.is24H) {
            NSLog(@"originYOfMoreViewShow:[%f],_scrollView.contentOffset.y:[%f]\n结果:[%f]",originYOfMoreViewShow,_scrollView.contentOffset.y,(_scrollView.contentOffset.y-originYOfMoreViewShow));
            if(self.scrollView.contentOffset.y>self.scrollView.contentInset.top&&
               originYOfMoreViewShow>60 &&
               (_scrollView.contentOffset.y-originYOfMoreViewShow)>self.frame.size.height+IFScreenFit2(40.f, 40.f)){
                [self changeState:JTableViewLoadMoreStateLoading];
                if(_scrollView && [_scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStartLoading)]){
                    [_scrollView performSelector:@selector(JRefrashTableBottomMoreViewStartLoading)];
                }
            }
        }
        else {
            if(self.scrollView.contentOffset.y>self.scrollView.contentInset.top&&
               originYOfMoreViewShow>60 &&
               (_scrollView.contentOffset.y-originYOfMoreViewShow)>0){
                [self changeState:JTableViewLoadMoreStateLoading];
                if(_scrollView && [_scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStartLoading)]){
                    [_scrollView performSelector:@selector(JRefrashTableBottomMoreViewStartLoading)];
                }
            }
        }
        
    }else{
        float offsetY=self.scrollView.contentOffset.y-self.scrollView.contentSize.height+self.scrollView.height;
        
        if (self.is24H) {
            NSLog(@"offsetY:[%f]",offsetY);
        }
        
        if(offsetY<0)return;
        if(self.scrollView.isDragging){
      
            if(_state == JTableViewLoadMoreStatePulling && offsetY<64.0f){
                [self setState:JTableViewLoadMoreStateNormal];
            }else if (_state == JTableViewLoadMoreStateNormal && offsetY >= 64.0f){
                [self changeState:JTableViewLoadMoreStatePulling];
            }
        }else{
            if (_state == JTableViewLoadMoreStatePulling){
                [self changeState:JTableViewLoadMoreStateLoading];
                _isAutoReflash=YES;
                if(_scrollView && [_scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStartLoading)]){
                    //[_scrollView performSelector:@selector(JRefrashTableBottomMoreViewStartLoading)];
                    [_scrollView performSelector:@selector(JRefrashTableBottomMoreViewStartLoading)
                                      withObject:nil
                                      afterDelay:0.3];
                }
            }
            

        }
    }
}

- (void)becameReflashLoading:(void(^)(BOOL isfinish))finish {
    if (_state == JTableViewLoadMoreStateNoMore ||
        _state == JTableViewLoadMoreStateLoading || self.hidden)
    {
        if (finish) finish(NO);
        return;
    }
    [self changeState:JTableViewLoadMoreStateLoading];
    if(_scrollView && [_scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStartLoading)]){
        [_scrollView performSelector:@selector(JRefrashTableBottomMoreViewStartLoading)];
    }
    if (finish) finish(YES);
}

- (void)finishWithSuccessLoading:(UIScrollView *)scrollView{
    if (self.state != JTableViewLoadMoreStateLoading)
        return;
    
    //[self changeState:JTableViewLoadMoreStateNormal];
    
//    [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
//    [_indicater stopInfinitAnimation];
    self.wordLabel.text=@"加载成功";
    JTableBottomView __weak *me=self;
    double delayInSeconds = 0.3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [me changeState:JTableViewLoadMoreStateNormal];
                    if(self.scrollView && [self.scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStopLoading)])
                        [self.scrollView performSelector:@selector(JRefrashTableBottomMoreViewStopLoading)];
    });
    

}

- (void)setAuto:(BOOL)isAuto{
    if(isAuto){
        self.wordLabel.text=@"正在载入...";
        self.isAutoReflash=YES;
    }else{
        self.wordLabel.text=@"上拉加载";
        self.isAutoReflash=NO;
    }
}

- (void)finishWithFailLoading:(UIScrollView *)scrollView{
    if (self.state != JTableViewLoadMoreStateLoading)
        return;
//    [self.indicater setLogoState:JTableRefrashIndicaterStateImgFail];
//    [_indicater stopInfinitAnimation];
    self.wordLabel.text=@"加载失败";
    self.isAutoReflash=NO;
    JTableBottomView __weak *me=self;
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [me changeState:JTableViewLoadMoreStateNormal];
        if(self.scrollView && [self.scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStopLoading)])
            [self.scrollView performSelector:@selector(JRefrashTableBottomMoreViewStopLoading)];
    });

    
}


- (void)finishWithSuccessLoadingNoAuto:(UIScrollView *)scrollView{
    if (self.state != JTableViewLoadMoreStateLoading)
        return;
//    [self.indicater setLogoState:JTableRefrashIndicaterStateImgFail];
//    [_indicater stopInfinitAnimation];
    self.wordLabel.text=@"加载成功";
    self.isAutoReflash=NO;
    JTableBottomView __weak *me=self;
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [me changeState:JTableViewLoadMoreStateNormal];
        if(self.scrollView && [self.scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStopLoading)])
            [self.scrollView performSelector:@selector(JRefrashTableBottomMoreViewStopLoading)];
    });
    
    
}

- (void)reset:(BOOL)autoload{
    [self changeState:JTableViewLoadMoreStateNormal];
    self.isAutoReflash=autoload;
}

- (void)finishWithNoMoreData:(UIScrollView *)scrollView{
    if (self.state != JTableViewLoadMoreStateLoading)
        return;
    self.isAutoReflash=NO;
    [self changeState:JTableViewLoadMoreStateNoMore];
    
    if(self.scrollView && [self.scrollView respondsToSelector:@selector(JRefrashTableBottomMoreViewStopLoading)])
        [self.scrollView performSelector:@selector(JRefrashTableBottomMoreViewStopLoading)];
    
}


- (void)removeObserverScrollView:(JTableView *)ascrollView{
    
    [ascrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
}

- (void)changeState:(JTableViewLoadMoreState ) aState{
    if(_state == aState) return;
    _state=aState;
    
    switch (_state) {
        case JTableViewLoadMoreStateLoading:
//            [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
//            [_indicater starInfinitAnimation];
            self.wordLabel.text=@"正在载入...";
            
            break;
            
        case JTableViewLoadMoreStateNormal:
//            [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
//            [_indicater stopInfinitAnimation];
            self.wordLabel.text=@"上拉加载";
            break;
            
        case JTableViewLoadMoreStateNoMore:
//            [self.indicater setLogoState:JTableRefrashIndicaterStateImgFail];
//            [_indicater stopInfinitAnimation];
            self.wordLabel.text=@"没有更多内容";
            break;
            
        case JTableViewLoadMoreStatePulling:
//            [self.indicater setLogoState:JTableRefrashIndicaterStateImg];
//            [_indicater stopInfinitAnimation];
            self.wordLabel.text=@"释放加载";
            
            break;
            
        default:
            break;
    }
    
}

- (void)updateCSS{
    //self.backgroundColor=ICurrentTheme.globleStyle.indexTableColor;
   // [self setNightBlock:^(UIView *me, BOOL isDay) {
   // self.backgroundColor=RGBHEX(f2f2f2);
    
    self.backgroundColor=[UIColor whiteColor];
   // }];
  //  [self.indicater updateCSS];
    //_wordLabel.textColor = ICurrentTheme.listStyle.listReflashTextColor;
   // [_wordLabel setNightBlock:^(UIView *me, BOOL isDay) {
    _wordLabel.textColor=[UIColor colorWithRed:0x86/255.0f green:0x86/255.0f blue:0x86/255.0f alpha:1.0f];   // }];
   // _separatorLine.image = [UIImage imageNamed:ICurrentTheme.cellStyle.indexCellSeperator];
    //[_separatorLine setNightBlock:^(UIView *me, BOOL isDay) {
    _separatorLine.image=[UIImage imageNamed:@"seperator_line.png"];
       // [UIImage imageNamed:@"seperator_line_night.png"];
   // }];
}

//4.6.1
//调整显示类容的左右位置
-(void)updateSignForLeftPadding:(CGFloat)leftPadding
{
//    self.indicater.frame=
//    CGRectMake(leftPadding, (JRefrashTableBottomMoreView_Height - IFScreenFit2s(17.0f))/2.0f, IFScreenFit2s(17.0f), IFScreenFit2s(17.0f));
    self.wordLabel.frame = CGRectMake((GlobleWidth-IFScreenFit2s(110))/2.f+IFScreenFit2s(12), IFScreenFit2s(17.0f), IFScreenFit2s(110), IFScreenFit2s(17.0f));
}

- (void)hiddenWordAndImage
{
  //  self.indicater.frame = CGRectZero;
    self.wordLabel.frame = CGRectZero;
}

@end
