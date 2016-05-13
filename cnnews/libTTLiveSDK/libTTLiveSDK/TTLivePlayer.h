//
//  TTLivePlayer.h
//  TTLiveSDK
//
//  Created by zhaokai on 16/3/10.
//  Copyright © 2016年 zhaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLivePlayer : NSObject
@property (nonatomic,assign)BOOL debugMode;//默认NO=不打开
- (void)start;
- (void)stop;
@end
