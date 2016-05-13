//
//  CNUIUtil.m
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNUIUtil.h"
#import <CoreText/CoreText.h>


#define  cn_font @"FZNBSJW--GB1-0"
#define cn_bold @"FZS3JW--GB1-0"
#define cn_futura     @"Futura-CondensedMedium"

@implementation CNUIUtil


SGR_DEF_SINGLETION(CNUIUtil)

- (instancetype)init{
    self=[super init];
    if(self){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.globleWidth = screenRect.size.width; //屏幕宽度
        self.globleHeight = screenRect.size.height;  //屏幕高度（无顶栏）
    }
    return self;
}

- (BOOL)checkAnimationLock:(NSObject *)lock{
    if(self.dispatchLock==nil){
        self.dispatchLock=lock;
        return YES;
    }
    return self.dispatchLock==lock;
}

- (void)cleanAnimationLock{
    self.dispatchLock=nil;
    
}

- (UIFont *)fontWithSize:(float)size{

    return [UIFont fontWithName:cn_font size:size];
}

- (UIFont *)boldWithSize:(float)size{
   
    return [UIFont fontWithName:cn_bold size:size];
}

- (UIFont *)futuraWithSize:(float)size{
    
    return [UIFont fontWithName:cn_futura size:size];
}

+ (float)suggestHeightOfString:(NSString *)str withWidth:(float)width font:(UIFont *)_font{
    
    if(_isStrNULL(str))return 0.f;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    
    [attributeStr addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, str.length)];
    
    
    
    NSMutableParagraphStyle *nsstyle = [[NSMutableParagraphStyle alloc] init];
    nsstyle.alignment = NSTextAlignmentLeft;
    //nsstyle.lineSpacing = lineSpace;
    nsstyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:nsstyle range:NSMakeRange(0, str.length)];
    
    CTFramesetterRef framesetter=CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributeStr);
    
    // 内容所占的尺寸
    CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                      CFRangeMake(0, str.length),
                                                                      NULL,
                                                                      CGSizeMake(width, CGFLOAT_MAX),
                                                                      NULL);
    CFRelease(framesetter);
    return ceilf(contentSize.height);
}

@end
