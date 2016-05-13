//
//  CNFinishUploadViewController.m
//  cnnews
//
//  Created by wanglb on 16/5/5.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNFinishUploadViewController.h"
#import "update1ViewController.h"

@interface CNFinishUploadViewController ()

@end

@implementation CNFinishUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigator:nil];
    //[self addBackButton];
    [self setNavigatorTitle:@"上传完成"];
    
    self.view.backgroundColor=RGB(245, 245, 245);
    
    [self setupUI];
}
- (void)setupUI
{
    UIImageView* iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(0, CCTopHeight + IFScreenFit2s(60)  , IFScreenFit2s(50), IFScreenFit2s(50));
    iv.centerX = self.view.centerX;
    iv.image = [UIImage imageNamed:@"上传完成"];
    [self.view addSubview:iv];
    
    UILabel* tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.bottom + IFScreenFit2s(21), GlobleWidth, IFScreenFit2s(20))];
    tishiLabel.text = @"辛苦上传！喝杯茶歇一会吧~";
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.font = CNBold(IFScreenFit2s(19));
    tishiLabel.textColor = [UIColor colorFromString_Ext:@"#333333"];
    [self.view addSubview:tishiLabel];
    
    UILabel* subTishi = [[UILabel alloc] initWithFrame:CGRectMake(IFScreenFit2s(24), tishiLabel.bottom + IFScreenFit2s(25), GlobleWidth - IFScreenFit2s(48), IFScreenFit2s(40))];
    subTishi.numberOfLines = 0;
    NSString* text = [NSString stringWithFormat:@"你上传的视频内容《%@》在%@上传成功！",self.titleStr,[self getCurrentTime]];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(subTishi.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:subTishi.font} context:nil];
    subTishi.frame = CGRectMake(IFScreenFit2s(24), tishiLabel.bottom + IFScreenFit2s(25), GlobleWidth - IFScreenFit2s(48), rect.size.height);
    subTishi.text = text;
    subTishi.textAlignment = NSTextAlignmentCenter;
    subTishi.textColor = [UIColor colorFromString_Ext:@"#aaaaaa"];
    subTishi.font = CNFont(IFScreenFit2s(14));
    [self.view addSubview:subTishi];
    
    UIButton* upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(IFScreenFit2s(24), subTishi.bottom + IFScreenFit2s(50), GlobleWidth - IFScreenFit2s(48), IFScreenFit2s(43));
    [upBtn setTitle:@"继续上传" forState:UIControlStateNormal];
    upBtn.titleLabel.font = CNBold(17);
    [upBtn setBackgroundColor:[UIColor colorFromString_Ext:@"#000020"]];
    upBtn.alpha = 0.7;
    upBtn.layer.cornerRadius = IFScreenFit2s(3);
    upBtn.layer.masksToBounds = YES;
    [self.view addSubview:upBtn];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(IFScreenFit2s(24), upBtn.bottom + IFScreenFit2s(28), GlobleWidth - IFScreenFit2s(48), IFScreenFit2s(43));
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    backBtn.titleLabel.font = CNBold(17);
    [backBtn setTitleColor:[UIColor colorFromString_Ext:@"#aaaaaa"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorFromString_Ext:@"#333333"] forState:UIControlStateHighlighted];
    backBtn.layer.cornerRadius = IFScreenFit2s(3);
    backBtn.layer.masksToBounds = YES;
    backBtn.layer.borderWidth = IFScreenFit2s(1);
    backBtn.layer.borderColor = [UIColor colorFromString_Ext:@"#d3d3d3"].CGColor;
    [self.view addSubview:backBtn];
    
    __weak typeof(self) me=self;
    [backBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [upBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        update1ViewController* upload = [[update1ViewController alloc] init];
        [[CLPushAnimatedRight sharedInstance] pushController:upload];
    }];
}

-(NSString*)getCurrentTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    //dateformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@",locationString);
    return locationString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
