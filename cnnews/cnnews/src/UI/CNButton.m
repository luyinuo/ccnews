//
//  CNButton.m
//  cnnews
//
//  Created by Ryan on 16/4/26.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNButton.h"

@implementation CNButton




- (void)nonClickButton{
    self.enabled=NO;
    [self performSelector:@selector(canClick) withObject:nil afterDelay:1.5];
    
  

}

- (void)canClick{
    self.enabled=YES;
}

@end
