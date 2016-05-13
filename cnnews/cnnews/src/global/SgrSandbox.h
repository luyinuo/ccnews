//
//  SgrSandbox.h
//  plu_temp
//
//  Created by li hongdan on 12-11-27.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SgrSandbox : NSObject

+ (NSString *)appPath;
+ (NSString *)docPath;
+ (NSString *)libPrePath;
+ (NSString *)libCachePath;
+ (NSString *)tmpPath;

+ (NSString *)touch:(NSString *)path;
+ (void)remove:(NSString *)path;


@end
