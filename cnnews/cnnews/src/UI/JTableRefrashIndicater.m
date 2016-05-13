//
//  JTableRefrashIndicater.m
//  IfengNews
//
//  Created by Ryan on 14-1-23.
//
//

#import "JTableRefrashIndicater.h"
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0


@interface JTableRefrashIndicater ()

@property (nonatomic,unsafe_unretained) float theProgress;
@property (nonatomic,unsafe_unretained)JTableRefrashIndicaterState indicaterState;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) UIImageView *animationImageView;
@property (nonatomic,strong) UIActivityIndicatorView *active;
@property (nonatomic,strong) UIImageView *iconView;



@end

@implementation JTableRefrashIndicater

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.indicaterState=JTableRefrashIndicaterStateProgress;
        
        self.iconView=[[UIImageView alloc] init];
        self.iconView.image=[UIImage imageNamed:@"刷新小楼.png"];
        self.iconView.frame=CGRectMake(0, 11, 25.f, 30.f);
        [self addSubview:self.iconView];
        
        
        self.add1=[CALayer layer];
        self.add1.frame=CGRectMake(self.iconView.right-3, 6.f, 6.f, 6.f);
        self.add1.contents=(__bridge id _Nullable)([UIImage imageNamed:@"闪烁加号大.png"].CGImage);
        [self.layer addSublayer:self.add1];
        //self.add1.opacity=0;
        
        self.add2=[CALayer layer];
        self.add2.frame=CGRectMake(self.add1.frame.origin.x+6.f, self.add1.frame.origin.y-3, 3.f, 3.f);
        self.add2.contents=(__bridge id _Nullable)([UIImage imageNamed:@"闪烁加号大.png"].CGImage);
        [self.layer addSublayer:self.add2];
        
        
        
        
        
        
       // NSMutableArray *array=@[];
      //  self.array=array;
        
//        self.progressTintColor=RGB(0x70, 0x70, 0x70);
//        
//        self.animationImageView=[UIImageView new];
//        self.animationImageView.image=[UIImage imageNamed:@"闪烁加号大.png"];
//        self.animationImageView.frame=CGRectMake(self.iconView.right-3, 6.f, 6.f, 6.f);
//        
//        
//        [self addSubview:self.animationImageView];
 
       // self.loadImg=[UIImage imageNamed:@"02.png"];
        
      //  self.backgroundColor=[UIColor redColor];
        
//        self.active=[UIActivityIndicatorView new];
//        self.active.frame=self.bounds;
//        [self addSubview:self.active];
//        self.active.hidesWhenStopped=YES;
       
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.add1.frame=CGRectMake(self.iconView.right-3, 6.f, 6.f, 6.f);
    self.add2.frame=CGRectMake(self.add1.frame.origin.x+6.f, self.add1.frame.origin.y-3, 3.f, 3.f);
   // self.animationImageView.frame=CGRectMake(self.iconView.right-3, 6.f, 6.f, 6.f);

   

}


- (void)setProgress:(float)progress{
    if(self.indicaterState!=JTableRefrashIndicaterStateProgress) return;
//    if(progress>1.0f)self.theProgress=1.0f;
//    if(progress<0.0f)self.theProgress=0.0f;
//    self.theProgress=progress;
    
    
    //[self addSubview:<#(UIView *)#>];
    [self setNeedsDisplay];

}

- (void)updateCSS{
    //self.progressTintColor = ICurrentTheme.listStyle.listReflashTextColor;
//    [self setNightBlock:^(UIView *me, BOOL isDay) {
//        ((JTableRefrashIndicater *)me).progressTintColor=
//        isDay?[UIColor colorWithRed:0x86/255.0f green:0x86/255.0f blue:0x86/255.0f alpha:1.0f]:
//        [UIColor colorWithRed:0x63/255.0f green:0x6e/255.0f blue:0x7c/255.0f alpha:1.0f];
//        
//    }];
    
}


- (void)starInfinitAnimation{
  //  [self.active startAnimating];
   
//  self.animationImageView.frame=CGRectMake(self.iconView.right-3, 6.f, 6.f, 6.f);
//    CGPoint p=self.animationImageView.center;
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionRepeat animations:^{
//        self.animationImageView.frame=CGRectMake(self.iconView.right-1.5, 7.5f, 3.f, 3.f);
//       // self.animationImageView.center=p;
//       // self.animationImageView.frame=CGRectMake(self.iconView.right-3, 7.f, 3.f, 3.f);
//    } completion:nil];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration	= 0.2;
    //animation.delegate	= self;
    animation.removedOnCompletion = NO;
    //animation.fillMode = kCAFillModeBoth;
    animation.repeatCount=HUGE_VALF;
    animation.autoreverses = YES;
    
    animation.fromValue	= [NSNumber numberWithFloat:1.0f];
    animation.toValue   = [NSNumber numberWithFloat:0.1f];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.add1 addAnimation:animation forKey:@"flash"];
    
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration	= 0.15;
    //animation.delegate	= self;
    animation2.removedOnCompletion = NO;
    //animation.fillMode = kCAFillModeBoth;
    animation2.repeatCount=HUGE_VALF;
    animation2.autoreverses = YES;
    
    animation2.fromValue	= [NSNumber numberWithFloat:1.0f];
    animation2.toValue   = [NSNumber numberWithFloat:0.1f];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.add2 addAnimation:animation2 forKey:@"flash"];



    

}

- (void)stopInfinitAnimation{
[self.add1 removeAnimationForKey:@"flash"];
    [self.add2 removeAnimationForKey:@"flash"];
    
    
    
    
    
   // [self.active stopAnimating];
//    [self.animationImageView removeFromSuperview];
//    self.animationImageView=[UIImageView new];
//    self.animationImageView.image=[UIImage imageNamed:@"闪烁加号大.png"];
//    self.animationImageView.frame=CGRectMake(self.iconView.right-3, 6.f, 6.f, 6.f);
//    [self addSubview:self.animationImageView];
}


- (void)setLogoState:(JTableRefrashIndicaterState )aindicaterState{
    self.indicaterState=aindicaterState;
     //  [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
//    CGContextFillRect(ctx, rect);
//    
//    
//    if(self.indicaterState==JTableRefrashIndicaterStateProgress){
//        
//        if(self.theProgress>=1.0f){
//            [self.array[0] drawInRect:rect];
//        }else{
//            CGContextSetStrokeColorWithColor(ctx, self.progressTintColor.CGColor);
//            CGContextStrokeEllipseInRect(ctx, CGRectInset(self.bounds, 1, 1));
//            CGPoint center = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
//            CGContextMoveToPoint(ctx, center.x, center.y);
//            CGContextSetFillColorWithColor(ctx, self.progressTintColor.CGColor);
//            
//            CGContextAddArc(ctx, center.x, center.y, self.bounds.size.width/2-1,  DEGREES_TO_RADIANS(-90), DEGREES_TO_RADIANS(-90+self.theProgress*360), 0);
//            CGContextFillPath(ctx);
//
//        }
//    }else if(self.indicaterState==JTableRefrashIndicaterStateImg){
//        [self.array[0] drawInRect:rect];
//    }else if(self.indicaterState==JTableRefrashIndicaterStateImgLoading){
//        [self.array[0] drawInRect:rect];
//    }else if(self.indicaterState==JTableRefrashIndicaterStateImgFail){
//       
//        [self.array[0] drawInRect:rect];
//    }
//
//    
//    
//
//}


@end
