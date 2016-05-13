//
//  JUIheader.h
//  cactus
//
//  Created by li hongdan on 12-7-20.
//  Copyright (c) 2012年 ifeng. All rights reserved.
//

#ifndef cactus_JUIheader_h
#define cactus_JUIheader_h
typedef enum{
	JRHPullRefreshNormal = 0,
	JRHPullRefreshPulling,
	JRHPullRefreshLoading,	
} JRHPullRefreshState;

#define JRH_OFFET 65

typedef enum{
    JRHLoadMoreStateNormal = 0,
    JRHLoadMoreStatePull,
    JRHLoadMoreStateLoading,
    JRHLoadMoreStateNoMore,
    JRHLoadMoreStateError,
}JRHLoadMoreState;


#endif
