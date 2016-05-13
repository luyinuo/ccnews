//
//  CNScrollView.m
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNScrollView.h"

@implementation CNScrollView

- (instancetype)init{
    self=[super init];
    if(self){
        self.scrollsToTop=NO;
    }
    return self;
}

@end
