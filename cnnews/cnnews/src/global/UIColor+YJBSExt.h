//
//  UIColor+YJBSExt.h
//  MSDoctor
//
//  Created by MSCompany on 15/11/25.
//  Copyright © 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YJBSExt)

/**
 * @brief 字符串中得到颜色值
 *
 * @param stringToConvert 字符串的值 e.g:@"#FF4500"
 *
 * @return 返回颜色对象
 */
+ (UIColor *)colorFromString_Ext:(NSString *)stringToConvert;

@end
