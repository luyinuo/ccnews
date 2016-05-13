//
//  CNUploadCell.m
//  cnnews
//
//  Created by wanglb on 16/5/3.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNUploadCell.h"

@implementation CNUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGB(246, 246, 246);
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    self.imageIV = [[UIImageView alloc] init];
    self.imageIV.layer.cornerRadius = 3;
    self.imageIV.layer.masksToBounds = YES;
    self.imageIV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageIV.clipsToBounds = YES;
    self.imageIV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageIV];
    
    
    UIView* maskingView = [[UIView alloc] init];
    maskingView.tag = 111;
    maskingView.backgroundColor = [UIColor blackColor];
    maskingView.alpha = 0.2;
    [self.imageIV addSubview:maskingView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = CNSubFont(PX_TO_PT(22));
    [self.imageIV addSubview:self.nameLabel];
    self.nameLabel.text = @"2048.mov";
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.backgroundColor = [UIColor clearColor];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.font = CNBold(PX_TO_PT(22));
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    [self.imageIV addSubview:self.stateLabel];
    self.stateLabel.text = @"等待上传";
    
    
    self.rateLabel = [[UILabel alloc] init];
    self.rateLabel.backgroundColor = [UIColor clearColor];
    self.rateLabel.textColor = [UIColor whiteColor];
    self.rateLabel.font = CNSubFont(PX_TO_PT(22));
    self.rateLabel.textAlignment = NSTextAlignmentRight;
    [self.imageIV addSubview:self.rateLabel];
    self.rateLabel.text = @"0Kb/s";

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];

    self.progressView.trackTintColor = [UIColor whiteColor];
    self.progressView.progressTintColor = RGB(98, 98, 98);
    [self.imageIV addSubview:self.progressView];
    self.progressView.progress = 0;
    
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setImage:[UIImage imageNamed:@"暂停按钮.png"] forState:UIControlStateNormal];
    //[self.imageIV addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.delegate pauseOrContinue:self.indexP];
    }];
    
    
    self.finishLabel = [[UILabel alloc] init];
    self.finishLabel.backgroundColor = [UIColor clearColor];
    self.finishLabel.textColor = [UIColor whiteColor];
    self.finishLabel.font = CNSubFont(PX_TO_PT(22));
    self.finishLabel.textAlignment = NSTextAlignmentLeft;
    [self.imageIV addSubview:self.finishLabel];
    self.finishLabel.text = @"18MB 2016.2.1 10:00:00 上传";
    self.finishLabel.hidden = YES;
    
    
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.textAlignment = NSTextAlignmentRight;
    self.indexLabel.font = CNFont(PX_TO_PT(26));
    self.indexLabel.textColor = RGB(144, 144, 144);
    [self.contentView addSubview:self.indexLabel];
    
    UIImageView *line=[UIImageView new];
    line.tag = 101;
    [self.contentView addSubview:line];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    
    CGFloat left = IFScreenFit2s(49);
    CGFloat top =  PX_TO_PT(10);
    
    self.imageIV.frame = CGRectMake(left, top , GlobleWidth - left - PX_TO_PT(26), PX_TO_PT(230));
    
    UIView* maskingView = [self viewWithTag:111];
    maskingView.frame = CGRectMake(0, self.imageIV.bottom - PX_TO_PT(72), self.imageIV.frame.size.width, PX_TO_PT(72));
    
    self.nameLabel.frame = CGRectMake(PX_TO_PT(18), maskingView.top + PX_TO_PT(12), PX_TO_PT(230), PX_TO_PT(22));
    
    self.rateLabel.frame = CGRectMake(PX_TO_PT(528) - PX_TO_PT(90), self.nameLabel.top, PX_TO_PT(90), PX_TO_PT(22));
    
    self.stateLabel.frame = CGRectMake(self.rateLabel.left - PX_TO_PT(16) - PX_TO_PT(88), self.nameLabel.top, PX_TO_PT(88), PX_TO_PT(22));
    
    self.progressView.frame = CGRectMake(PX_TO_PT(18), self.nameLabel.bottom + PX_TO_PT(10), PX_TO_PT(510), PX_TO_PT(20));
    
    self.btn.frame = CGRectMake(self.progressView.right + PX_TO_PT(28), maskingView.top + PX_TO_PT(16), PX_TO_PT(40), PX_TO_PT(40));
    
    self.finishLabel.frame = CGRectMake(PX_TO_PT(18), self.nameLabel.bottom + PX_TO_PT(4), PX_TO_PT(300), PX_TO_PT(22));
    
    
    self.indexLabel.frame = CGRectMake(self.imageIV.right - 100, self.imageIV.bottom + PX_TO_PT(22), 100, PX_TO_PT(26));
    
    UIView* line = [self viewWithTag:101];
    line.frame=CGRectMake(left, self.frame.size.height-0.5, GlobleWidth-left, 0.5f);
    line.backgroundColor=RGB(170, 170, 170);
}

-(void)btnTap
{
    
}

@end



















