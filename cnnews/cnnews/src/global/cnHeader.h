//
//  cnHeader.h
//  ccnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#ifndef cnHeader_h
#define cnHeader_h

#define SGR_SINGLETION(__clazz) \
+ (__clazz *)sharedInstance;

#define SGR_DEF_SINGLETION(__clazz) \
+ (__clazz *)sharedInstance \
{\
static dispatch_once_t once; \
static __clazz * __singletion;\
dispatch_once(&once,^{__singletion = [[__clazz alloc] init];});\
return __singletion;\
}

#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0
#define RGB(r,g,b)  [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
#define _safeStr(a) (a?a:@"")


#define _isStrNULL(a) (!a || [a length]==0  || ![a isKindOfClass:[NSString class]])
#define _isStrNotNull(a) (a && [a isKindOfClass:[NSString class]] && [a length])

#define sgrSafeMainThread(block)  if ([NSThread isMainThread ]) {\
block();\
}else{\
dispatch_async(dispatch_get_main_queue(), block);\
}\

#define RGBINT(num) [UIColor                          \
colorWithRed: (float)((num>>16)&0xff) / 0xff        \
green: (float)((num>>8)&0xff)  / 0xff        \
blue: (float)((num)&0xff)     / 0xff        \
alpha: 1.0]                                  \

#define RGBHEX( num ) RGBINT( 0x##num )


#endif /* cnHeader_h */
