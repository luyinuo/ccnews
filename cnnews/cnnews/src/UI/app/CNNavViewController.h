//
//  CNNavViewController.h
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNViewController.h"

@interface CNNavViewController : CNViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *sec1;
@property (nonatomic,strong) NSArray *sec2;
@property (nonatomic,strong) NSArray *sec3;

@property (nonatomic,strong) NSArray *t1;
@property (nonatomic,strong) NSArray *t2;
@property (nonatomic,strong) NSArray *t3;


- (void)willPop;
@end
