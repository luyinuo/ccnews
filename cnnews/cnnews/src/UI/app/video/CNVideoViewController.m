//
//  CNVideoViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/26.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNVideoViewController.h"
#import "CNDataModel.h"
#import "UIImageView+WebCache.h"

@interface CNVideoViewController ()

@property (nonatomic,strong) CNDetail *detail;
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,assign) float minDescHeight;
@property (nonatomic,assign) float maxDescHeight;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation CNVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minDescHeight=IFScreenFit2s(52.f);
    [self createNavigator:nil];
    [self addBackButton];
    [self setNavigatorTitle:@"上传详情"];
    self.view.backgroundColor=RGB(245, 246, 247);
    [self requestData];
    
    
    self.scrollView=[UIScrollView new];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.frame=CGRectMake(0, CCTopHeight, GlobleWidth, GlobleHeight-CCTopHeight);
    self.scrollView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:self.scrollView];
    
    self.bg=[UIView new];
    self.bg.backgroundColor=RGB(245, 246, 247);
    self.bg.frame=CGRectMake(25.f, 0, GlobleWidth-50.f, GlobleHeight-CCTopHeight);
    [self.scrollView addSubview:self.bg];
    
}


- (void)setUPUI{
    if(!_detail) return;
    float allHeight=0.f;
    
    UILabel *info=[UILabel new];
    info.font=CNSubFont(IFScreenFit2(10,10));
    info.textColor=RGB(0xaa, 0xaa, 0xaa);
    //info.numberOfLines=0;
    info.text=[NSString stringWithFormat:@"%@ 上传",self.detail.createtime];
    info.frame=CGRectMake(0, IFScreenFit2s(10.f), self.bg.width, info.font.lineHeight+1);
    info.textAlignment=NSTextAlignmentRight;
    [self.bg addSubview:info];
    allHeight=info.bottom;
    
    
    UIImageView *icon1=[[UIImageView alloc] init];
    icon1.frame=CGRectMake(0, info.bottom+IFScreenFit2s(10.f), IFScreenFit2s(11.f), IFScreenFit2s(12.5f));
    icon1.image=[UIImage imageNamed:@"标题.png"];
    [self.bg addSubview:icon1];
    
    float height=[CNUIUtil suggestHeightOfString:self.detail.title
                                       withWidth:self.bg.width-(icon1.right+IFScreenFit2s(15.f))
                                            font:CNBold(IFScreenFit2(15,15))];
    
    
    UILabel *bitian=[UILabel new];
    bitian.font=CNBold(IFScreenFit2(15,15));
    //  NSLog(@"==%f",bitian.font.lineHeight);
    bitian.textColor=[UIColor blackColor];
    bitian.numberOfLines=0;
    bitian.text=self.detail.title;
    bitian.frame=
    CGRectMake(icon1.right+IFScreenFit2s(15.f), icon1.top-4,
               self.bg.width-(icon1.right+IFScreenFit2s(15.f)),
               height+3);
    bitian.textAlignment=NSTextAlignmentLeft;
    [self.bg addSubview:bitian];
    allHeight=bitian.bottom;
    
    float bottom=bitian.bottom;
    
    UIView *bottomView=[UIView new];
    bottomView.backgroundColor=RGB(245, 246, 247);
    if(_isStrNotNull(_detail.summary)){
        
        UIImageView *icon2=[[UIImageView alloc] init];
        icon2.frame=CGRectMake(0, bottom+IFScreenFit2s(7.f), IFScreenFit2s(13.f), IFScreenFit2s(13.f));
        icon2.image=[UIImage imageNamed:@"摘要.png"];
        [self.bg addSubview:icon2];
        
        float maxHeight=[CNUIUtil suggestHeightOfString:_detail.summary withWidth:self.bg.width-bitian.left font:CNBold(IFScreenFit2(14,14))];
        NSString *minStr=self.detail.summary;
        
        if(maxHeight>self.minDescHeight &&self.detail.summary.length>IFScreenFit(53,60,65)){
            self.maxDescHeight=maxHeight+3*CNBold(IFScreenFit2(14,14)).lineHeight;
            
            minStr=[NSString stringWithFormat:@"%@...",[self.detail.summary substringWithRange:NSMakeRange(0, IFScreenFit(53,60,65))]];
            
            float minHeight=[CNUIUtil suggestHeightOfString:minStr withWidth:self.bg.width-bitian.left font:CNBold(IFScreenFit2(14,14))];
            self.minDescHeight=minHeight+5;
        }else{
            self.maxDescHeight=self.minDescHeight=maxHeight;
        }
        
        
        
        UILabel *summary=[UILabel new];
        summary.font=CNBold(IFScreenFit2(14,14));
        summary.textColor=RGB(74, 78, 78);
        summary.numberOfLines=0;
        summary.text=minStr;
        summary.frame=CGRectMake(bitian.left, icon2.top, self.bg.width-bitian.left, self.minDescHeight);
        summary.textAlignment=NSTextAlignmentLeft;
        [self.bg addSubview:summary];
        bottom=allHeight=summary.bottom;
        if(self.maxDescHeight>self.minDescHeight){
            UILabel *click=[UILabel new];
            
            NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:@"展开更多"];
            NSDictionary *dic=@{NSAttachmentAttributeName:CNBold(IFScreenFit2(11.f,11.f)),
                                NSForegroundColorAttributeName:RGB(237, 169, 20),
                                NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
            [attr addAttributes:dic range:NSMakeRange(0, attr.length)];
            click.attributedText=attr;
            
            float h=CNBold(IFScreenFit2(11.f,11.f)).lineHeight+2;
            click.frame=CGRectMake(summary.right-IFScreenFit2s(100), summary.bottom-h,IFScreenFit2s(100) , h);
            click.textAlignment=NSTextAlignmentRight;
            click.font=CNBold(IFScreenFit2(11.f,11.f));
            
            [self.bg addSubview:click];
            
            bottom=click.bottom;
            
            CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
            button.frame=click.frame;
            [self.bg addSubview:button];
            __weak typeof(self) me=self;
            [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                CNButton *b=(CNButton *)sender;
                [b setSelected:!b.isSelected];
                if(b.selected){
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        summary.height=me.maxDescHeight;
                        bottomView.top+=(me.maxDescHeight-me.minDescHeight);
                        button.top+=(me.maxDescHeight-me.minDescHeight);
                        click.top=button.top;
                    } completion:^(BOOL finished) {
                        summary.text=me.detail.summary;
                        me.bg.height+=(me.maxDescHeight-me.minDescHeight);
                        me.scrollView.contentSize
                        =CGSizeMake(me.scrollView.contentSize.width, me.scrollView.contentSize.height+(me.maxDescHeight-me.minDescHeight));
                        
                        NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:@"收起摘要"];
                        NSDictionary *dic=@{NSAttachmentAttributeName:CNBold(IFScreenFit2(11.f,11.f)),
                                            NSForegroundColorAttributeName:RGB(237, 169, 20),
                                            NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                        [attr addAttributes:dic range:NSMakeRange(0, attr.length)];
                        click.attributedText=attr;
                        
                    }];
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        summary.height=me.minDescHeight;
                        bottomView.top-=(me.maxDescHeight-me.minDescHeight);
                        button.top-=(me.maxDescHeight-me.minDescHeight);
                        click.top=button.top;
                    } completion:^(BOOL finished) {
                        summary.text=minStr;
                        me.bg.height-=(me.maxDescHeight-me.minDescHeight);
                        me.scrollView.contentSize
                        =CGSizeMake(me.scrollView.contentSize.width, me.scrollView.contentSize.height-(me.maxDescHeight-me.minDescHeight));
                        NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:@"收起摘要"];
                        NSDictionary *dic=@{NSAttachmentAttributeName:CNBold(IFScreenFit2(11.f,11.f)),
                                            NSForegroundColorAttributeName:RGB(237, 169, 20),
                                            NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                        [attr addAttributes:dic range:NSMakeRange(0, attr.length)];
                        click.attributedText=attr;
                        
                    }];
                }
                
            }];
        }
        
        
        allHeight=summary.bottom;
        
        bottom=summary.bottom;
        
    }
    
    
    bottomView.frame=CGRectMake(0, bottom+IFScreenFit2s(14.f), self.bg.width, 1.f);
    bottomView.backgroundColor=self.view.backgroundColor;
    [self.bg addSubview:bottomView];
    
    UIImageView *icon3=[[UIImageView alloc] init];
    icon3.frame=CGRectMake(0, info.bottom+IFScreenFit2s(5.f), IFScreenFit2s(14.f), IFScreenFit2s(14.5f));
    icon3.image=[UIImage imageNamed:@"添加视频.png"];
    [bottomView addSubview:icon3];
    
    UILabel *l1=[UILabel new];
    l1.font=CNBold(IFScreenFit2(15,15));
    //  NSLog(@"==%f",bitian.font.lineHeight);
    l1.textColor=RGB(0xaa, 0xaa, 0xaa);
    l1.numberOfLines=1;
    l1.text=@"主画面视频";
    l1.frame=
    CGRectMake(bitian.left, icon3.top,
               self.bg.width-bitian.left,
               l1.font.lineHeight+2);
    l1.textAlignment=NSTextAlignmentLeft;
    [bottomView addSubview:l1];
    
    
    
    bottomView.height=l1.bottom;
    
    
    NSString *url=nil;
    if(self.detail.thumimg.count>0 && _isStrNotNull((url=[_detail.thumimg sgrGetStringForIndex:0]))){
        UIImageView *mage1=[[UIImageView alloc] init];
        mage1.layer.cornerRadius = IFScreenFit2(2, 2);
        mage1.layer.masksToBounds = YES;
        mage1.frame=CGRectMake(bitian.left, l1.bottom+10, bitian.width, IFFitFloat6(115));
        mage1.clipsToBounds=YES;
        mage1.contentMode=UIViewContentModeScaleAspectFill;
        [mage1 sd_setImageWithURL:[NSURL URLWithString:url]];
        [bottomView addSubview:mage1];
        bottomView.height=mage1.bottom;
        
        NSString *titlestr=[NSString stringWithFormat:@"  %@(%@)",_safeStr([_detail.videosfiletype sgrGetStringForIndex:0]),
                            _safeStr([_detail.videosfilesize sgrGetStringForIndex:0])];
        
        UIView *titleBg=[UIView new];
        titleBg.backgroundColor=[UIColor blackColor];
        titleBg.alpha=0.3;
        titleBg.frame=CGRectMake(0, mage1.height-IFScreenFit2s(35.f), mage1.width, IFScreenFit2s(35.f));
        [mage1 addSubview:titleBg];
        
        UILabel *title=[[UILabel alloc] init];
        title.numberOfLines=1;
        title.font=CNSubFont( IFScreenFit2(13.f,13.f));
        title.textColor=[UIColor whiteColor];
        title.frame=titleBg.frame;
        title.textAlignment=NSTextAlignmentLeft;
        title.text=titlestr;
        [mage1 addSubview:title];
        
    }
    bottom=bottomView.bottom;
    NSArray *arr=@[@"一",@"二",@"三",
                   @"四",
                   @"五",@"六",@"七",@"八",@"九",@"十",@"十一"];
    
    for(int i=1;i<self.detail.thumimg.count;i++){
        
        url=[_detail.thumimg sgrGetStringForIndex:i];
        if(_isStrNotNull(url)){
            UIImageView *icon4=[[UIImageView alloc] init];
            icon4.frame=CGRectMake(0, bottomView.height+10, IFScreenFit2s(14.f), IFScreenFit2s(14.5f));
            icon4.image=[UIImage imageNamed:@"添加视频.png"];
            [bottomView addSubview:icon4];
            
            UILabel *l4=[UILabel new];
            l4.font=CNBold(IFScreenFit2(15,15));
            
            l4.textColor=RGB(0xaa, 0xaa, 0xaa);
            l4.numberOfLines=1;
            if(i<11){
                l4.text=[NSString stringWithFormat:@"辅助视频%@",arr[i-1]];
            }else{
                l4.text=[NSString stringWithFormat:@"辅助视频%d",i-1];
            }
            
            l4.frame=
            CGRectMake(bitian.left, icon4.top,
                       self.bg.width-bitian.left,
                       l1.font.lineHeight+2);
            l4.textAlignment=NSTextAlignmentLeft;
            [bottomView addSubview:l4];
            
            
            
            UIImageView *mage1=[[UIImageView alloc] init];\
            mage1.layer.cornerRadius = IFScreenFit2(2, 2);
            mage1.layer.masksToBounds = YES;
            mage1.frame=CGRectMake(bitian.left, l4.bottom+10, bitian.width, IFFitFloat6(115));
            mage1.clipsToBounds=YES;
            mage1.contentMode=UIViewContentModeScaleAspectFill;
            [mage1 sd_setImageWithURL:[NSURL URLWithString:url]];
            [bottomView addSubview:mage1];
            bottomView.height=mage1.bottom;
            
            NSString *titlestr=[NSString stringWithFormat:@"  %@(%@)",_safeStr([_detail.videosfiletype sgrGetStringForIndex:i]),
                                _safeStr([_detail.videosfilesize sgrGetStringForIndex:i])];
            
            UIView *titleBg=[UIView new];
            titleBg.backgroundColor=[UIColor blackColor];
            titleBg.alpha=0.3;
            titleBg.frame=CGRectMake(0, mage1.height-IFScreenFit2s(35.f), mage1.width, IFScreenFit2s(35.f));
            [mage1 addSubview:titleBg];
            
            UILabel *title=[[UILabel alloc] init];
            title.numberOfLines=1;
            title.font=CNSubFont( IFScreenFit2(13.f,13.f));
            title.textColor=[UIColor whiteColor];
            title.frame=titleBg.frame;
            title.textAlignment=NSTextAlignmentLeft;
            title.text=titlestr;
            [mage1 addSubview:title];
            
            
            bottomView.height=mage1.bottom;
            bottom=bottomView.bottom;
        }
        
        
        
        
    }
    
    
    
    if(self.detail.imagesurl){
        
        UIImageView *icon4=[[UIImageView alloc] init];
        icon4.frame=CGRectMake(0, bottomView.height+10, IFScreenFit2s(14.f), IFScreenFit2s(14));
        icon4.image=[UIImage imageNamed:@"添加图片.png"];
        [bottomView addSubview:icon4];
        
        UILabel *l4=[UILabel new];
        l4.font=CNBold(IFScreenFit2(15,15));
        
        l4.textColor=RGB(0xaa, 0xaa, 0xaa);
        l4.numberOfLines=1;
        
        l4.text=@"图片内容";
        
        
        
        
        l4.frame=
        CGRectMake(bitian.left, icon4.top,
                   self.bg.width-bitian.left,
                   l1.font.lineHeight+2);
        l4.textAlignment=NSTextAlignmentLeft;
        [bottomView addSubview:l4];
        
        bottomView.height=l4.bottom;
        bottom=bottomView.bottom;
        
        for(int i=0;i<self.detail.imagesurl.count;i++){
            
            url=[_detail.imagesurl sgrGetStringForIndex:i];
            if(_isStrNotNull(url)){
                
                UIImageView *mage1=[[UIImageView alloc] init];
                mage1.layer.cornerRadius = IFScreenFit2(2, 2);
                mage1.layer.masksToBounds = YES;
                mage1.frame=CGRectMake(bitian.left, bottomView.height+15, bitian.width, IFFitFloat6(115));
                mage1.clipsToBounds=YES;
                mage1.contentMode=UIViewContentModeScaleAspectFill;
                [mage1 sd_setImageWithURL:[NSURL URLWithString:url]];
                [bottomView addSubview:mage1];
                bottomView.height=mage1.bottom;
                
                NSString *titlestr=[NSString stringWithFormat:@"  %@(%@)",_safeStr([_detail.imagesfiletype sgrGetStringForIndex:i]),
                                    _safeStr([_detail.imagesfilesize sgrGetStringForIndex:i])];
                
                UIView *titleBg=[UIView new];
                titleBg.backgroundColor=[UIColor blackColor];
                titleBg.alpha=0.3;
                titleBg.frame=CGRectMake(0, mage1.height-IFScreenFit2s(35.f), mage1.width, IFScreenFit2s(35.f));
                [mage1 addSubview:titleBg];
                
                UILabel *title=[[UILabel alloc] init];
                title.numberOfLines=1;
                title.font=CNSubFont( IFScreenFit2(13.f,13.f));
                title.textColor=[UIColor whiteColor];
                title.frame=titleBg.frame;
                title.textAlignment=NSTextAlignmentLeft;
                title.text=titlestr;
                [mage1 addSubview:title];
                
                
                bottomView.height=mage1.bottom;
                bottom=bottomView.bottom;
            }
            
        }
        
        
    }
    
    
    
    
    allHeight=bottomView.bottom;
    
    
    
    
    
    self.bg.height=allHeight+60.f;
    self.scrollView.contentSize=CGSizeMake(self.bg.width, allHeight+60.f);
    
    /*
     
     
     
     UIView *pannel=nil;
     UIView *bottomView=[UIView new];
     bottomView.backgroundColor=RGB(245, 246, 247);
     
     if(_isStrNotNull(_detail.summary)){
     CGRect rect;
     rect=[_detail.summary boundingRectWithSize:CGSizeMake(self.bg.width, MAXFLOAT)
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{NSAttachmentAttributeName:CNFont(IFScreenFit2(12.f,12.f))}
     context:nil];
     if(rect.size.height>self.minDescHeight){
     self.maxDescHeight=rect.size.height;
     }else{
     self.maxDescHeight=self.minDescHeight=rect.size.height;
     }
     
     UILabel *summary=[UILabel new];
     summary.font=CNFont(IFScreenFit2(12,12));
     summary.textColor=RGB(170, 170, 170);
     summary.numberOfLines=0;
     summary.text=self.detail.summary;
     summary.frame=CGRectMake(0, bottom+20.f, self.bg.width, self.minDescHeight);
     summary.textAlignment=NSTextAlignmentLeft;
     [self.bg addSubview:summary];
     bottom=allHeight=summary.bottom;
     
     if(self.maxDescHeight>self.minDescHeight){
     
     
     UILabel *click=[UILabel new];
     //            click.font=[UIFont systemFontOfSize:IFScreenFit2(10,10)];
     //            click.textColor=RGB(170, 170, 170);
     //info.numberOfLines=0;
     //  click.text=[NSString stringWithFormat:@"%@ 上传",self.detail.createtime];
     NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:@"展开更多"];
     NSDictionary *dic=@{NSAttachmentAttributeName:CNFont(IFScreenFit2(13.f,13.f)),
     NSForegroundColorAttributeName:RGB(49, 67, 118),
     NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
     [attr addAttributes:dic range:NSMakeRange(0, attr.length)];
     
     click.frame=CGRectMake(0, summary.bottom+7.f, self.bg.width, IFScreenFit2(15.f,15.f));
     click.textAlignment=NSTextAlignmentRight;
     click.attributedText=attr;
     [self.bg addSubview:click];
     
     bottom=click.bottom;
     
     CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
     button.frame=click.frame;
     [self.bg addSubview:button];
     __weak typeof(self) me=self;
     [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
     CNButton *b=(CNButton *)sender;
     [b setSelected:!b.isSelected];
     if(b.selected){
     [UIView animateWithDuration:0.2 animations:^{
     summary.height=me.maxDescHeight;
     bottomView.top+=(me.maxDescHeight-me.minDescHeight);
     button.top+=(me.maxDescHeight-me.minDescHeight);
     click.top=button.top;
     } completion:^(BOOL finished) {
     me.bg.height+=(me.maxDescHeight-me.minDescHeight);
     me.scrollView.contentSize
     =CGSizeMake(me.scrollView.contentSize.width, me.scrollView.contentSize.height+(me.maxDescHeight-me.minDescHeight));
     }];
     }else{
     [UIView animateWithDuration:0.2 animations:^{
     summary.height=me.minDescHeight;
     bottomView.top-=(me.maxDescHeight-me.minDescHeight);
     button.top-=(me.maxDescHeight-me.minDescHeight);
     click.top=button.top;
     } completion:^(BOOL finished) {
     me.bg.height-=(me.maxDescHeight-me.minDescHeight);
     me.scrollView.contentSize
     =CGSizeMake(me.scrollView.contentSize.width, me.scrollView.contentSize.height-(me.maxDescHeight-me.minDescHeight));
     }];
     }
     
     }];
     
     }
     
     }
     
     //    CALayer *line=[CALayer layer];
     //    line.frame=CGRectMake(0, bottom+25.f, GlobleWidth, 1);
     //    line.backgroundColor=RGB(205, 216, 243).CGColor;
     //    [self.bg.layer addSublayer:line];
     allHeight=bottom+25.f;
     
     
     bottomView.frame=CGRectMake(0, bottom+25.f, self.bg.width, 1.f);
     bottomView.backgroundColor=[UIColor whiteColor];
     
     float bottomViewHeight=1.f;
     
     [self.bg addSubview:bottomView];
     
     UIImageView *line=[UIImageView new];
     line.frame=CGRectMake(-10, 0, GlobleWidth, IFScreenFit2(1.f,1.f));
     line.backgroundColor=RGB(170, 170, 170);
     // line.image=[UIImage imageNamed:@"线.png"];
     // line.backgroundColor=[UIColor blueColor];
     [bottomView addSubview:line];
     bottomViewHeight=line.bottom;
     
     
     
     float imgbottom=0.f;
     if(self.detail.thumimg && self.detail.thumimg.count>0){
     int row=self.detail.thumimg.count/3+((self.detail.thumimg.count%3>0)?1:0);
     
     pannel=[UIView new];
     pannel.frame=CGRectMake(0, 30.f, self.bg.width, row*IFScreenFit2(130.f,130.f));
     [bottomView addSubview:pannel];
     
     float twidth=(self.bg.width-24.f)/3.f;
     
     
     
     for(int i=0;i<row;i++){
     NSString *string =[self.detail.thumimg sgrGetStringForIndex:i*3];
     if(_isStrNULL(string)) break;
     CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
     button.imageView.clipsToBounds=YES;
     button.imageView.contentMode=UIViewContentModeScaleAspectFill;
     button.clipsToBounds=YES;
     button.frame=CGRectMake(0, i*IFScreenFit2(30.f,30.f)+(i*twidth), twidth, twidth);
     [button sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
     [pannel addSubview:button];
     imgbottom=button.bottom;
     NSString *string2 =[self.detail.thumimg sgrGetStringForIndex:i*3+1];
     if(_isStrNULL(string)) break;
     CNButton *button2=[CNButton buttonWithType:UIButtonTypeCustom];
     button2.imageView.clipsToBounds=YES;
     button2.imageView.contentMode=UIViewContentModeScaleAspectFill;
     button2.clipsToBounds=YES;
     button2.frame=CGRectMake(twidth+12.f, i*IFScreenFit2(30.f,30.f)+(i*twidth), twidth, twidth);
     [button2 sd_setImageWithURL:[NSURL URLWithString:string2] forState:UIControlStateNormal];
     [pannel addSubview:button2];
     
     NSString *string3 =[self.detail.thumimg sgrGetStringForIndex:i*3+2];
     if(_isStrNULL(string)) break;
     CNButton *button3=[CNButton buttonWithType:UIButtonTypeCustom];
     button3.imageView.clipsToBounds=YES;
     button3.imageView.contentMode=UIViewContentModeScaleAspectFill;
     button3.clipsToBounds=YES;
     button3.frame=CGRectMake(2*twidth+24.f, i*IFScreenFit2(30.f,30.f)+(i*twidth), twidth, twidth);
     [button3 sd_setImageWithURL:[NSURL URLWithString:string3] forState:UIControlStateNormal];
     [pannel addSubview:button3];
     
     
     
     }
     
     
     }
     
     
     
     
     bottomViewHeight=imgbottom;
     
     if(self.detail.imagesurl && self.detail.imagesurl.count>0){
     int row=self.detail.imagesurl.count/3+((self.detail.imagesurl.count%3>0)?1:0);
     
     if(!pannel){
     pannel=[UIView new];
     pannel.frame=CGRectMake(0, 2.f, self.bg.width, row*IFScreenFit2(130.f,130.f));
     [bottomView addSubview:pannel];
     }else{
     pannel.height+=row*IFScreenFit2(130.f,130.f);
     }
     
     
     UILabel *xuantian=[UILabel new];
     xuantian.font=CNFont(IFScreenFit2(17,17));
     xuantian.textColor=RGB(49, 67, 118);
     xuantian.text=@"·图片内容·";
     xuantian.frame=CGRectMake(IFScreenFit2(5.f,55.f),imgbottom+ IFScreenFit2(30.f,30.f), IFScreenFit2(80.f,80.f), IFScreenFit2(25.f,25.f));
     [pannel addSubview:xuantian];
     
     imgbottom+=xuantian.height+2*IFScreenFit2(30.f,30.f);
     
     
     float twidth=(self.bg.width-24.f)/3.f;
     
     for(int i=0;i<row;i++){
     NSString *string =[self.detail.imagesurl sgrGetStringForIndex:i*3];
     if(_isStrNULL(string)) break;
     CNButton *button=[CNButton buttonWithType:UIButtonTypeCustom];
     button.imageView.clipsToBounds=YES;
     button.imageView.contentMode=UIViewContentModeScaleAspectFill;
     button.clipsToBounds=YES;
     button.frame=CGRectMake(0, imgbottom+i*IFScreenFit2(30.f,30.f)+(i*twidth), twidth, twidth);
     [button sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
     [pannel addSubview:button];
     bottomViewHeight=button.bottom;
     
     NSString *string2 =[self.detail.imagesurl sgrGetStringForIndex:i*3+1];
     if(_isStrNULL(string)) break;
     CNButton *button2=[CNButton buttonWithType:UIButtonTypeCustom];
     button2.imageView.clipsToBounds=YES;
     button2.imageView.contentMode=UIViewContentModeScaleAspectFill;
     button2.clipsToBounds=YES;
     button2.frame=CGRectMake(twidth+12.f, imgbottom+i*IFScreenFit2(30.f,30.f)+(i*twidth), twidth, twidth);
     [button2 sd_setImageWithURL:[NSURL URLWithString:string2] forState:UIControlStateNormal];
     [pannel addSubview:button2];
     
     NSString *string3 =[self.detail.imagesurl sgrGetStringForIndex:i*3+2];
     if(_isStrNULL(string)) break;
     CNButton *button3=[CNButton buttonWithType:UIButtonTypeCustom];
     button3.imageView.clipsToBounds=YES;
     button3.imageView.contentMode=UIViewContentModeScaleAspectFill;
     button3.clipsToBounds=YES;
     button3.frame=CGRectMake(2*twidth+24.f, imgbottom+i*IFScreenFit2(30.f,30.f)+(i*twidth), twidth, twidth);
     [button3 sd_setImageWithURL:[NSURL URLWithString:string3] forState:UIControlStateNormal];
     [pannel addSubview:button3];
     
     
     
     }
     
     
     }
     
     bottomView.height=bottomViewHeight;
     
     allHeight+=bottomViewHeight;
     
     self.bg.height=allHeight+60.f;
     self.scrollView.contentSize=CGSizeMake(self.bg.width, allHeight+60.f);
     
     pannel.backgroundColor=bottomView.backgroundColor=self.view.backgroundColor;
     
     
     */
    
    
}

- (void)requestData{
    if(_isStrNULL(self.videoId)) return;
    __weak typeof(self) me=self;
    [[CNDataModel sharedInstance] detail:self.videoId complate:^(BOOL success, NSString *message, CNDetail *detail) {
        
        if(success){
            
            //             detail.summary=@"了试过堵上两个两个书法家李是福建省连收到了飞机失联的飞机上雷锋精神失联飞机少量的福建师范说服力进失联飞机收地建房收到了飞机失联的飞机上啥地方了坚实的飞洛杉矶是傅雷家书来得及发说服力及第三方聚少离多飞机失联的副教授李福建省连副教授李加福禄寿的解放路神九发射sfjsldfjsdfjdksfjslkdfjsdkfjdslfjsdlfjsdlfjsdlfjsdfjdslfjdslfjsdlfjsldjfdsjfldsjflsjflsiutoirg了试过堵上两个两个书法家李是福建省连收到了飞机失联的飞机上雷锋精神失联飞机少量的福建师范说服力进失联飞机收地建房收到了飞机失联的飞机上啥地方了坚实的飞洛杉矶是傅雷家书来得及发说服力及第三方聚少离多飞机失联的副教授李福建省连副教授李加福禄寿的解放路神九发射sfjsldfjsdfjdksfjslkdfjsdkfjdslfjsdlfjsdlfjsdlfjsdfjdslfjdslfjsdlfjsldjfdsjfldsjflsjflsiutoirg了试过堵上两个两个书法家李是福建省连收到了飞机失联的飞机上雷锋精神失联飞机少量的福建师范说服力进失联飞机收地建房收到了飞机失联的飞机上啥地方了坚实的飞洛杉矶是傅雷家书来得及发说服力及第三方聚少离多飞机失联的副教授李福建省连副教授李加福禄寿的解放路神九发射sfjsldfjsdfjdksfjslkdfjsdkfjdslfjsdlfjsdlfjsdlfjsdfjdslfjdslfjsdlfjsldjfdsjfldsjflsjflsiutoirg了试过堵上两个两个书法家李是福建省连收到了飞机失联的飞机上雷锋精神失联飞机少量的福建师范说服力进失联飞机收地建房收到了飞机失联的飞机上啥地方了坚实的飞洛杉矶是傅雷家书来得及发说服力及第三方聚少离多飞机失联的副教授李福建省连副教授李加福禄寿的解放路神九发射";
            //
            //
            //
            //                detail.thumimg=@[@"http://e.hiphotos.baidu.com/image/pic/item/0824ab18972bd407c9f505ac79899e510fb309b5.jpg",
            //                                      @"http://e.hiphotos.baidu.com/image/pic/item/0824ab18972bd407c9f505ac79899e510fb309b5.jpg"
            //                                      ];
            //
            //
            //                detail.imagesurl=@[@"http://img1.soufun.com/album/2013_07/03/1372866486083_000.jpg",
            //                                      @"http://img1.soufun.com/album/2013_07/03/1372866486083_000.jpg",
            //                                      @"http://img1.soufun.com/album/2013_07/03/1372866486083_000.jpg"
            //
            //                                      ];
            
            
            me.detail=detail;
            [me setUPUI];
        }else{
            [me showModelView:message?message:@"请求数据失败请退出重试"];
        }
    }];
}

- (BOOL)showPopAction{
    return YES;
}



@end
