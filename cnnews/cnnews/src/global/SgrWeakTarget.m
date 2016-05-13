//
//  SgrWeakTarget.m
//  IfengNews
//
//  Created by Ryan on 14-4-29.
//
//

#import "SgrWeakTarget.h"

@implementation SgrWeakTarget


- (void)perform{
    if(self.obj  && [self.obj respondsToSelector:self.select]){
        [self.obj performSelector:self.select];
    }
}

@end
