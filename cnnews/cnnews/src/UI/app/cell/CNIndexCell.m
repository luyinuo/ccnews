//
//  CNIndexCell.m
//  cnnews
//
//  Created by Ryan on 16/4/26.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNIndexCell.h"
#import "UIImageView+WebCache.h"

@implementation CNIndexCell

- (void)uiInit{
    //self.backgroundColor = [UIColor blackColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.thumImage=[[UIImageView alloc] init];
    self.thumImage.frame=CGRectMake(0, 0, GlobleWidth, IFFitFloat6(185.f));
    self.thumImage.contentMode=UIViewContentModeScaleAspectFill;
    self.thumImage.clipsToBounds=YES;
    [self.contentView addSubview:self.thumImage];
    
    
    
    self.thetitlelabel=[[UILabel alloc] init];
    _thetitlelabel.numberOfLines=2;
    _thetitlelabel.font=CNBold( IFScreenFit2(17.f,17.f));
    _thetitlelabel.textColor=RGB(0x33, 0x33, 0x33);
    _thetitlelabel.frame=CGRectMake(IFScreenFit2s(20.f), self.thumImage.bottom+IFFitFloat6(13), GlobleWidth-IFScreenFit2s(40.f), IFFitFloat6(35.f));
    _thetitlelabel.textAlignment=NSTextAlignmentLeft;
    
    [self.contentView addSubview:_thetitlelabel];
    
//    UIView  *bg1=[UIView new];
//    bg1.frame=_title.frame;
//    bg1.backgroundColor=[UIColor blackColor];
//    bg1.alpha=0.3;
//    [self.contentView insertSubview:bg1 aboveSubview:_title];
    
    
    self.timeLabel=[[UILabel alloc] init];
    _timeLabel.font=CNSubFont(IFScreenFit2(12.f,12.f));
    _timeLabel.textColor=RGB(119, 119, 119);
    _timeLabel.frame=CGRectMake(IFScreenFit2s(20.f), _thetitlelabel.bottom + IFScreenFit2(11,13), IFFitFloat6(150), IFFitFloat6(12.f));
    _timeLabel.textAlignment=NSTextAlignmentLeft;
    
    [self.contentView addSubview:_timeLabel];
    
    
//    UIView  *bg2=[UIView new];
//    bg2.frame=_timeLabel.frame;
//    bg2.backgroundColor=[UIColor blackColor];
//    bg2.alpha=0.3;
//    [self.contentView insertSubview:bg2 aboveSubview:_timeLabel];
    
    
    self.icon1=[[UIImageView alloc] init];
    self.icon1.frame=CGRectMake(IFFitFloat6(305), _timeLabel.top, IFScreenFit2(11.f,11.f),IFScreenFit2(11.f,11.f));
    self.icon1.image=[UIImage imageNamed:@"播放.png"];
    [self.contentView addSubview:self.icon1];
    
    
    self.label1=[[UILabel alloc] init];
    _label1.font=_timeLabel.font;
    _label1.textColor=_timeLabel.textColor;
    _label1.frame=CGRectMake(_icon1.right+5, _timeLabel.top, IFFitFloat6(10), IFScreenFit2(13.f,13.f));
    _label1.textAlignment=NSTextAlignmentLeft;
    
    [self.contentView addSubview:_label1];
    
    self.icon2=[[UIImageView alloc] init];
    self.icon2.frame=CGRectMake(_label1.right+1, _timeLabel.top, IFScreenFit2(13.f,13.f),IFScreenFit2(10.f,10.f));
    self.icon2.image=[UIImage imageNamed:@"图片.png"];
    [self.contentView addSubview:self.icon2];
    
    
    self.label2=[[UILabel alloc] init];
    _label2.font=_timeLabel.font;
    _label2.textColor=_timeLabel.textColor;
    _label2.frame=CGRectMake(_icon2.right+5, _timeLabel.top, IFFitFloat6(20), IFScreenFit2(13.f,13.f));
    _label2.textAlignment=NSTextAlignmentLeft;
    
    [self.contentView addSubview:_label2];
    
    CALayer *line=[CALayer layer];
    line.frame=CGRectMake(0, 0, GlobleWidth, 0.5);
    line.backgroundColor=RGB(214, 215, 216).CGColor;
    
    [self.contentView.layer addSublayer:line];
    self.line=line;
    
    
//    UIView  *bg3=[UIView new];
//    bg3.frame=
//    CGRectMake(self.icon1.left-IFFitFloat6(15), self.icon1.top, _label2.right-self.icon1.left+IFFitFloat6(30), _label2.height);
//    bg3.backgroundColor=[UIColor blackColor];
//    bg3.alpha=0.3;
//    [self.contentView insertSubview:bg3 aboveSubview:self.icon1];
    
}

- (void)loadData:(CNList *)list{
    
 
   
    
    //if(list.image){
    [self.thumImage sd_setImageWithURL:[NSURL URLWithString:list.image] placeholderImage:[UIImage imageNamed:@"图片显示不出的时候.png"]];
        
//    }else{
//        
//    }
    
    self.thetitlelabel.text=list.title;
    
    if(list.titleHeight>IFFitFloat6(254.f)){
        self.thetitlelabel.height=2*self.thetitlelabel.font.lineHeight+4.f;
        
    }else{
        self.thetitlelabel.height=_thetitlelabel.font.lineHeight+2;
    }
    _timeLabel.top=self.thetitlelabel.bottom+5;
    
    self.timeLabel.text=_safeStr(list.timeFormat);
    if(list.videos<0){
        self.label1.hidden=YES;
        self.icon1.hidden=YES;
    }else{
        self.label1.text=[NSString stringWithFormat:@"%d",list.videos];
        self.label1.hidden=NO;
        self.icon1.hidden=NO;
    }
    
    if(list.pics<0){
        self.label2.hidden=YES;
        self.icon2.hidden=YES;
    }else{
       self.label2.text=[NSString stringWithFormat:@"%d",list.pics];
        self.label2.hidden=NO;
        self.icon2.hidden=NO;
    }
    
    self.label1.top=self.label2.top=_timeLabel.top + IFScreenFit2(1, 1);
    self.icon2.top=_timeLabel.top+IFScreenFit2(3, 3);
    self.icon1.top= self.icon2.top - IFScreenFit2(1, 1);
    CGRect rect=self.line.frame;
    rect.origin.y=list.titleHeight-IFFitFloat6(4.f);
    self.line.frame=rect;
    
    NSLog(@"rect.y = %f",self.line.frame.origin.y);
}




@end
