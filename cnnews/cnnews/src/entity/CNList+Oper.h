//
//  CNList+Oper.h
//  cnnews
//
//  Created by Ryan on 16/4/25.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNList.h"

@interface CNList (Oper)

- (void)loadLive:(NSDictionary *)dic;

- (void)loadVideo:(NSDictionary *)dic;

- (void)sugestHeight;

@end
