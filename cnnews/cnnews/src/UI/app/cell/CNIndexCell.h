//
//  CNIndexCell.h
//  cnnews
//
//  Created by Ryan on 16/4/26.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNTableViewCell.h"
#import "CNList.h"

@interface CNIndexCell : CNTableViewCell

@property (nonatomic,strong) UIImageView *thumImage;
@property (nonatomic,strong) UILabel *thetitlelabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *icon1;
@property (nonatomic,strong) UIImageView *icon2;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) CALayer *line;


- (void)loadData:(CNList *)list;

@end
