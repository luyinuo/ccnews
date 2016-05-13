//
//  SgrSandbox.m
//  plu_temp
//
//  Created by li hongdan on 12-11-27.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#import "SgrSandbox.h"

@implementation SgrSandbox

+ (NSString *)appPath{
  NSArray *paths =NSSearchPathForDirectoriesInDomains(NSAdminApplicationDirectory, NSUserDomainMask, YES);
   
  return [paths objectAtIndex:0];
}
+ (NSString *)docPath{
  NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
  return [paths objectAtIndex:0];
}
+ (NSString *)libPrePath{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}
+ (NSString *)libCachePath{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}
+ (NSString *)tmpPath{
   return   NSTemporaryDirectory();
}

+ (NSString *)touch:(NSString *)path{
  if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
	}
	return path;
}

+ (void)remove:(NSString *)path{
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


@end
