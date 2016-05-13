//
//  CNLiveCell.m
//  cnnews
//
//  Created by Ryan on 16/5/1.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNLiveCell.h"
#import "UIImageView+WebCache.h"
#import "CNUser.h"

@implementation CNLiveCell



- (void)uiInit{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.thumImage=[[UIImageView alloc] init];
    self.thumImage.frame=CGRectMake(0, 0, GlobleWidth, IFFitFloat6(185.f));
    self.thumImage.contentMode=UIViewContentModeScaleAspectFill;
    self.thumImage.clipsToBounds=YES;
    [self.contentView addSubview:self.thumImage];
    
    
    
    UIView *titleBg=[UIView new];
    titleBg.backgroundColor=[UIColor blackColor];
    titleBg.alpha=0.3;
    titleBg.frame=CGRectMake(0, self.thumImage.bottom-IFFitFloat6(45.f), GlobleWidth, IFFitFloat6(45.f));
    [self.contentView addSubview:titleBg];
    
    self.title=[[UILabel alloc] init];
    _title.numberOfLines=2;
    _title.font=CNBold( IFScreenFit2(15.f,15.f));
    _title.textColor=[UIColor whiteColor];
    _title.frame=CGRectMake(IFScreenFit2s(25.f), self.thumImage.bottom-IFFitFloat6(45.f), GlobleWidth-IFScreenFit2s(50.f), IFFitFloat6(45.f));
    _title.textAlignment=NSTextAlignmentLeft;
    
    [self.contentView addSubview:_title];
    
    //    UIView  *bg1=[UIView new];
    //    bg1.frame=_title.frame;
    //    bg1.backgroundColor=[UIColor blackColor];
    //    bg1.alpha=0.3;
    //    [self.contentView insertSubview:bg1 aboveSubview:_title];
    
    
    self.timeLabel=[[UILabel alloc] init];
    _timeLabel.shadowOffset=CGSizeMake(2.5, 2.5);
    _timeLabel.shadowColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    _timeLabel.font=CNSubFont(IFScreenFit2(24.f,24.f));
    _timeLabel.textColor=_title.textColor;
    _timeLabel.frame=
    CGRectMake(((_thumImage.width-IFFitFloat6(150))/2.f),(_thumImage.height-IFFitFloat6(30.f))/2.f, IFFitFloat6(150), IFFitFloat6(30.f));
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.contentView addSubview:_timeLabel];
    
    
    //    UIView  *bg2=[UIView new];
    //    bg2.frame=_timeLabel.frame;
    //    bg2.backgroundColor=[UIColor blackColor];
    //    bg2.alpha=0.3;
    //    [self.contentView insertSubview:bg2 aboveSubview:_timeLabel];
    
    
    self.icon1=[[UIImageView alloc] init];
    self.icon1.frame=CGRectMake(IFFitFloat6(30.f), IFFitFloat6(28.f), IFScreenFit2(36.f,36.f),IFScreenFit2(36.f,36.f));
    self.icon1.layer.cornerRadius=IFScreenFit2s(18.f);
    self.icon1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.icon1.layer.borderWidth=1;
    self.icon1.image=[UIImage imageNamed:@"系统默认头像.png"];
    [self.contentView addSubview:self.icon1];
    
    
    self.label1=[[UILabel alloc] init];
    _label1.font=CNBold(10.f);
    _label1.textColor=[UIColor whiteColor];
    _label1.frame=CGRectMake(0, self.icon1.bottom+IFFitFloat6(7), self.icon1.width+IFFitFloat6(60.f), IFScreenFit2(13.f,13.f));
    _label1.textAlignment=NSTextAlignmentCenter;
    
    
    [self.contentView addSubview:_label1];
    
//    self.icon2=[[UIImageView alloc] init];
//    self.icon2.frame=CGRectMake(_label1.right+1, _timeLabel.top, IFScreenFit2(13.f,13.f),IFScreenFit2(10.f,10.f));
//    self.icon2.image=[UIImage imageNamed:@"图片.png"];
//    [self.contentView addSubview:self.icon2];
//    
//    
    self.label2=[[UILabel alloc] init];
    _label2.font=CNSubFont(10.f);
    _label2.textColor=[UIColor whiteColor];
    _label2.backgroundColor=RGB(253, 164, 0);
    _label2.frame=CGRectMake(GlobleWidth-IFFitFloat6(55+28), IFFitFloat6(20.f), IFFitFloat6(55), IFScreenFit2(20.f,20.f));
    _label2.textAlignment=NSTextAlignmentCenter;
    _label2.text=@"Live";
    _label2.layer.cornerRadius = IFScreenFit2s(2);
    _label2.layer.masksToBounds = YES;
    [self.contentView addSubview:_label2];
    
//    CALayer *line=[CALayer layer];
//    line.frame=CGRectMake(0, 0, GlobleWidth, 0.5);
//    line.backgroundColor=RGB(214, 215, 216).CGColor;
//    
//    [self.contentView.layer addSublayer:line];
//    self.line=line;
    
    
    //    UIView  *bg3=[UIView new];
    //    bg3.frame=
    //    CGRectMake(self.icon1.left-IFFitFloat6(15), self.icon1.top, _label2.right-self.icon1.left+IFFitFloat6(30), _label2.height);
    //    bg3.backgroundColor=[UIColor blackColor];
    //    bg3.alpha=0.3;
    //    [self.contentView insertSubview:bg3 aboveSubview:self.icon1];
    
}


- (void)loadData:(CNList *)list{
    //if(list.image)
        [self.thumImage sd_setImageWithURL:[NSURL URLWithString:list.image] placeholderImage:[UIImage imageNamed:@"直播原始背景.png"]];
    
    self.title.text=list.title;
    _label1.text=
    [CNUser sharedInstance].userName;
    self.timeLabel.text=list.timeFormat;
}

@end
