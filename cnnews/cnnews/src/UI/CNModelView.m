//
//  CNModelView.m
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNModelView.h"

@implementation CNModelView


- (void)show:(NSString *)title view:(UIView *) view{
    if(_isStrNULL(title)) return;
    
    CGRect rect=[title boundingRectWithSize:CGSizeMake(150.f, MAXFLOAT)
                                    options:(NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName:CNFont(15.f)}
                                    context:nil];
    
    rect.size.width+=60.f;
    rect.size.height+=30.f;
    
    rect.origin.x=(GlobleWidth-rect.size.width)/2.f;
    rect.origin.y=(GlobleHeight-rect.size.height)/2.f-IFFitFloat6(80);

    
    self.frame=rect;
    
    UIView *bg=[UIView new];
    bg.backgroundColor=[UIColor blackColor];
    bg.alpha=0.7;
    bg.frame=self.bounds;
    bg.layer.cornerRadius=4.f;
    [self addSubview:bg];
    
    UILabel *label=[UILabel new];
    
    label.numberOfLines=0;
    
    
    
    label.frame=self.bounds;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=CNFont(15.f);
    label.textColor=[UIColor whiteColor];
    label.text=title;
    
    [self addSubview:label];
    if(view){
        [view addSubview:self];
    }else{
         [[self k_mainWindow] addSubview:self];
    }
   
    
    //[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
    
    
    
    
}

- (void)disShow{
    [self removeFromSuperview];
}

@end
