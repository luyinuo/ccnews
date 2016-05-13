//
//  CNUploadCell.h
//  cnnews
//
//  Created by wanglb on 16/5/3.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNUploadCellDelegate <NSObject>

-(void)pauseOrContinue:(NSIndexPath*)indexP;

@end

@interface CNUploadCell : UITableViewCell

@property (nonatomic,strong) UIImageView* imageIV;
@property (nonatomic,strong) UILabel* indexLabel;

@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,strong) UILabel* stateLabel;
@property (nonatomic,strong) UILabel* rateLabel;
@property (nonatomic,strong) UIProgressView* progressView;
@property (nonatomic,strong) UIButton* btn;
@property (nonatomic,strong) UILabel* finishLabel;

@property (nonatomic,strong) NSIndexPath* indexP;
@property (nonatomic,assign) id<CNUploadCellDelegate> delegate;
@end
