//
//  CNMenuCell.m
//  cnnews
//
//  Created by Ryan on 16/4/23.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNMenuCell.h"

@implementation CNMenuCell

- (void)uiInit{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(IFFitFloat6(24.f), (self.height-IFFitFloat6(25.f))/2.f, GlobleWidth-IFFitFloat6(100.f), IFFitFloat6(25.f));
    view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.baseV=view;
    [self.contentView addSubview:view];
    
    _icon=[[UIImageView alloc] init];
    _icon.frame=CGRectMake(0, (view.height-IFFitFloat6(22.f))/2.f, IFFitFloat6(22.f), IFFitFloat6(22.f));
   // _icon.image=[UIImage imageNamed:@"默认状态.png"];
    [view addSubview:self.icon];
    
    self.label=[[UILabel alloc] init];
    self.label.frame=CGRectMake(_icon.right+IFFitFloat6(10), _icon.top, view.width-_icon.right-IFFitFloat6(5), _icon.height);
    self.label.font=CNBold(17.f);
    self.label.textColor=RGB(0xaa, 0xaa, 0xaa);
    [view addSubview:self.label];
    
//    UIImageView *img=[UIImageView new];
//    img.image=[UIImage imageNamed:@"选中.png"];
    
    UIView *select=[[UIView alloc] init];
    select.frame=CGRectMake(0,0,self.width,self.height);
    select.backgroundColor=[RGB(0xaa,0xaa,0xaa) colorWithAlphaComponent:0.35];
    UIView *xian=[UIView new];
    xian.frame=CGRectMake(0,0,3,select.height);
    xian.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    xian.backgroundColor=RGB(0x77,0x77,0x77);
    [select addSubview:xian];
    
    
    self.selectedBackgroundView=select;
    self.contentView.backgroundColor=RGB(0xf5, 0xf6, 0xf6);
    
    
    
}

- (void)load:(NSString *)icon title:(NSString *)title{
    UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",icon]];
    _icon.image=img;
    _icon.frame=CGRectMake(0, (self.baseV.height-img.size.height)/2.f, img.size.width, img.size.height);
    self.label.text=title;
    
}



- (void)beSelect:(BOOL)beselect{
    self.label.textColor=beselect?RGB(0x33, 0x33, 0x33):RGB(0xaa, 0xaa, 0xaa);
}


@end
