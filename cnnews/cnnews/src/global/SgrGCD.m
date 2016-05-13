//
//  SgrGCD.m
//  ifengBlog
//
//  Created by li hongdan on 13-1-28.
//  Copyright (c) 2013年 ifeng. All rights reserved.
//

#import "SgrGCD.h"

@implementation SgrGCD

@synthesize foreQueue=_foreQueue;
@synthesize backQueue=_backQueue;
@synthesize globleQueue=_globleQueue;
@synthesize backHttpQueue=_backHttpQueue;

- (id)init{
  
  if(self=[super init]){
    _foreQueue = dispatch_get_main_queue();
    _backQueue = dispatch_queue_create("com.ifeng.sgr", NULL);
    _globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _backHttpQueue=NULL;
  }
  return self;
}

- (void)dealloc{
//  dispatch_release(_foreQueue);
//  dispatch_release(_backQueue);
//  dispatch_release(_globleQueue);
//    if(_backHttpQueue!=NULL){
//            dispatch_release(_backHttpQueue);
//        _backHttpQueue=NULL;
//    }
}

SGR_DEF_SINGLETION(SgrGCD)

- (dispatch_queue_t)httpQueue{
    if(_backHttpQueue==NULL){
        _backHttpQueue = dispatch_queue_create("com.ifeng.sgr.http", NULL);
    }
    return _backHttpQueue;
}


- (void)enqueueForeground:(dispatch_block_t)block{
  dispatch_async(_foreQueue, block);
}
- (void)enqueueBackground:(dispatch_block_t)block{
  dispatch_async(_backQueue, block);
}

- (void)enMain:(dispatch_block_t)block{
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)enqueueHttpBackground:(dispatch_block_t)block{
    dispatch_async([self httpQueue], block);
}
- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block{
  dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, ms*USEC_PER_SEC);
  dispatch_after(time,_foreQueue,block);
}
- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block{
  dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, ms*USEC_PER_SEC);
  dispatch_after(time,_backQueue,block);
}
- (void)enqueueGloble:(dispatch_block_t)block{
  dispatch_async(_globleQueue, block);
}

- (dispatch_source_t)createDispathcTimerInterval:(uint64_t)intreval
                                          leeway:(uint64_t)leeway
                                           queue:(dispatch_queue_t)queue
                                           block:(dispatch_block_t)block{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer,
                                  dispatch_time(DISPATCH_TIME_NOW, intreval*NSEC_PER_SEC),
                                  intreval*NSEC_PER_SEC,
                                  leeway*NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (void)enqueueSafeMain:(dispatch_block_t)block{
    
    if([NSThread isMainThread]){
        block();
    }else{
        dispatch_async(_foreQueue, block);
    }
    
}

@end
