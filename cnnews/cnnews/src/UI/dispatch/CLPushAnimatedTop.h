//
//  CLPushAnimatedTop.h
//  chanlin
//
//  Created by Ryan on 14-11-9.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "CLPushAnimated.h"


@interface CLPushAnimatedTop : CLPushAnimated

SGR_SINGLETION(CLPushAnimatedTop)

- (void)popTop:(void (^)(BOOL finish)) block before:(void (^)(void)) block2;


@end
