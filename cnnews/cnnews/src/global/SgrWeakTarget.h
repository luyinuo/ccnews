//
//  SgrWeakTarget.h
//  IfengNews
//
//  Created by Ryan on 14-4-29.
//
//

#import <Foundation/Foundation.h>

@interface SgrWeakTarget : NSObject

@property (nonatomic,weak)NSObject *obj;
@property (nonatomic,unsafe_unretained)SEL select;

- (void)perform;

@end
