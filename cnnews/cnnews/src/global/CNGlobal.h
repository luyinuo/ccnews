//
//  CNGlobal.h
//  ccnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiHReachability.h"


#define AtLeastIOS8 [CNGlobal systemVersionAtLeastIOS8]

#define CN_Change_reflash_index1 @"CN_Change_reflash_index1"
#define CN_Change_reflash_index2 @"CN_Change_reflash_index2"

@interface CNGlobal : NSObject

@property (nonatomic,strong) JiHReachability *reachability;

SGR_SINGLETION(CNGlobal)

+ (BOOL)systemVersionAtLeastIOS8;

+ (void)didChangeToInterfaceOrientationPortrait;

@end
