//
//  NSString+Filter.m
//  cactus
//
//  Created by wuzhikun on 12-6-28.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#import "NSString+Filter.h"
#import <CoreText/CoreText.h>



@implementation NSString(Filter)

+ (NSString *)filterSpace:(NSString *)str
{      
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}

+ (NSString *)filterEnter:(NSString *)str
{
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return newStr;
}

+ (NSString *)filterCity:(NSString *)str
{
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"市" withString:@""];
    return newStr;
}

- (NSString *)trim{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSString *)replaceSepecialStr{
    NSString *replaceStr = @"";
    replaceStr = [self stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    return [replaceStr stringByReplacingOccurrencesOfString:@"&quot" withString:@""];
}

- (NSString *)replaceQuotationStr{
    NSString *replaceStr = @"";
    replaceStr = [self stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    return [replaceStr stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
}

- (CGSize)sgrSizeWithFont:(UIFont *)font with:(float)width{
    if(_isStrNULL(self))return CGSizeZero;
    
    NSMutableAttributedString *mbstring=[[NSMutableAttributedString alloc] initWithString:self];
    NSUInteger length=[self length];
    //NSLog(@"%f--%f",self.font.pointSize);
    // 字体
    CTFontRef reffont=CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [mbstring addAttribute:(id)kCTFontAttributeName value:(__bridge id)reffont range:NSMakeRange(0, length)];
    CFRelease(reffont);
    
    
    
    
    
    CTFramesetterRef framesetter=CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)mbstring);
    
    CGSize size=CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, length), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    
    CFRelease(framesetter);
    
    return size;
    
}
@end
