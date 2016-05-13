//
//  NSString+Filter.h
//  cactus
//
//  Created by wuzhikun on 12-6-28.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Filter)
+ (NSString *)filterSpace:(NSString *)str; // 滤掉空格
+ (NSString *)filterEnter:(NSString *)str; // 滤掉换行符
+ (NSString *)filterCity:(NSString *)str;  // 滤掉市字
- (NSString *)trim;
- (NSString *)replaceSepecialStr;//过滤&quot <br>等
/**
 *  替换&ldquo和&rdquo引号编码
 *
 *  @return 替换后的字符串
 */
- (NSString *)replaceQuotationStr;
- (CGSize)sgrSizeWithFont:(UIFont *)font with:(float)width;
@end
