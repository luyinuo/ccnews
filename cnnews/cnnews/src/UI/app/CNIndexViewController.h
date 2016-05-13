//
//  CNIndexViewController.h
//  cnnews
//
//  Created by Ryan on 16/4/23.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "IFTableViewControler.h"

@interface CNIndexViewController : IFTableViewControler

@property (nonatomic,strong)NSString *category;
@property (nonatomic,assign)int pageNum;
@property (nonatomic,assign) int index1Type;

- (void)reloadData;

- (void)setFetchUser;

@end
