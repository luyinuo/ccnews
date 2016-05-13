//
//  CNList+Oper.m
//  cnnews
//
//  Created by Ryan on 16/4/25.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNList+Oper.h"
#import <CoreText/CoreText.h>

@implementation CNList (Oper)

- (void)loadLive:(NSDictionary *)dic{
    self.listId=[dic sgrFGetStringForKey:@"id"];
    self.title=[dic sgrFGetStringForKey:@"title"];
    self.location=[dic sgrGetStringForKey:@"location"];
    self.image=[dic sgrGetStringForKey:@"cover"];
    self.timeFormat=[dic sgrGetStringForKey:@"livetime"];
    self.livePushUrl=[dic sgrGetStringForKey:@"rtmp_push_url"];
    self.liveCreateTime=[[dic sgrFGetStringForKey:@"applytime"] longLongValue];
    self.liveExpireTime=[[dic sgrFGetStringForKey:@"deadline"] longLongValue];
    
    self.uploading=0;
    
    self.titleHeight=IFFitFloat6(190.f);
}


- (void)loadVideo:(NSDictionary *)dic{
    self.listId=[dic sgrFGetStringForKey:@"id"];
    self.title=[dic sgrGetStringForKey:@"title"];
    self.timeFormat=[dic sgrGetStringForKey:@"createtime"];
    self.image=[dic sgrGetStringForKey:@"thumimg"];
    self.videos=[[dic sgrGetNumberForKey:@"videonum"] intValue];
    self.pics=[[dic sgrGetNumberForKey:@"imagenum"] intValue];
    self.uploading=0;
    [self sugestHeight];
   // if([self.title rangeOfString:@""])
   // self.title=@"司法解释雷锋精神老地方收代理费加上贷款雷锋精神塑料袋福建省代理费就死定了";
    }

- (void)sugestHeight{
    if(self.title){
        UIFont *font=CNBold(IFScreenFit2s(17.f));
        float width=GlobleWidth-IFScreenFit2s(40.f);
        
        float h=[self.class suggestHeightOfString:self.title withWidth:width font:font lineSpace:0];
        
        //        CGRect rect=[self.title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSAttachmentAttributeName:font} context:nil];
        if(h>font.lineHeight+3){
            self.titleHeight=IFScreenFit2(238,269.f);
          //  self.titleHeight = IFScreenFit2(273, 269);
        }else{
            self.titleHeight=IFFitFloat6(254.f);
        }
    }

}


+ (float)suggestHeightOfString:(NSString *)str withWidth:(float)width font:(UIFont *)_font lineSpace:(float)lineSpace{
    
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
