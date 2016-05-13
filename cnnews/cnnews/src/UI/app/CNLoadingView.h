//
//  CNLoadingView.h
//  cnnews
//
//  Created by Ryan on 16/5/2.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNLoadingView : UIView

@property (nonatomic,strong) CALayer *layer1;
@property (nonatomic,strong) CALayer *layer2;
@property (nonatomic,strong) CALayer *layer3;

- (void)setUp:(NSString *)title;

@end
