//
//  CNTableViewCell.m
//  cnnews
//
//  Created by Ryan on 16/4/23.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNTableViewCell.h"

@implementation CNTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
       // self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self uiInit];
    }
    return self;
}

- (void)uiInit{

    
}
@end
