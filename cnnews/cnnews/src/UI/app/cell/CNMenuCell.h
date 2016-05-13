//
//  CNMenuCell.h
//  cnnews
//
//  Created by Ryan on 16/4/23.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTableViewCell.h"

@interface CNMenuCell : CNTableViewCell

@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIView *baseV;


- (void)load:(NSString *)icon title:(NSString *)title;

- (void)beSelect:(BOOL)beselect;

@end
