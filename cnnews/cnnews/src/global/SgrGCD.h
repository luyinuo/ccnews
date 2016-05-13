//
//  SgrGCD.h
//  ifengBlog
//
//  Created by li hongdan on 13-1-28.
//  Copyright (c) 2013年 ifeng. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SgrGCD : NSObject{
  dispatch_queue_t _foreQueue;
  dispatch_queue_t _backQueue;
  dispatch_queue_t _globleQueue;
  dispatch_queue_t _backHttpQueue;
}

@property (nonatomic,strong) dispatch_queue_t foreQueue;
@property (nonatomic,strong)dispatch_queue_t backQueue;
@property (nonatomic,strong)dispatch_queue_t globleQueue;
@property (nonatomic,strong)dispatch_queue_t backHttpQueue;

SGR_SINGLETION(SgrGCD)

- (void)enqueueForeground:(dispatch_block_t)block;
- (void)enqueueBackground:(dispatch_block_t)block;
- (void)enqueueHttpBackground:(dispatch_block_t)block;
- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
- (void)enqueueGloble:(dispatch_block_t)block;
- (void)enMain:(dispatch_block_t)block;
- (dispatch_source_t)createDispathcTimerInterval:(uint64_t)intreval
                                          leeway:(uint64_t)leeway
                                           queue:(dispatch_queue_t)queue
                                           block:(dispatch_block_t)block;
- (void)enqueueSafeMain:(dispatch_block_t)block;


@end
