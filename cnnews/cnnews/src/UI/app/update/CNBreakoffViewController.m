//
//  CNBreakoffViewController.m
//  cnnews
//
//  Created by wanglb on 16/5/9.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNBreakoffViewController.h"
#import "CNSettingViewController.h"
#import "CLPushAnimatedRight.h"

@interface CNBreakoffViewController ()

@end

@implementation CNBreakoffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigator:nil];
    //[self addBackButton];
    [self setNavigatorTitle:@"暂时无法上传"];
    
    self.view.backgroundColor=RGB(245, 245, 245);
    
    [self setupUI];
}
- (void)setupUI
{
    
    UILabel* tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CCTopHeight + IFScreenFit2s(78), GlobleWidth, IFScreenFit2s(15))];
    tishiLabel.text = @"因网络问题，你的视频暂时无法上传。";
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.font = CNBold(IFScreenFit2s(15));
    tishiLabel.textColor = [UIColor colorFromString_Ext:@"#333333"];
    [self.view addSubview:tishiLabel];
    
    
    UILabel* l2 = [UILabel new];
    l2.frame = CGRectMake(0, tishiLabel.bottom + IFScreenFit2s(10), GlobleWidth, IFScreenFit2s(15));
    l2.text = @"待网络连通后，请在“待上传视频”中";
    l2.textAlignment = NSTextAlignmentCenter;
    l2.font = CNBold(IFScreenFit2s(15));
    l2.textColor = [UIColor colorFromString_Ext:@"#333333"];
    [self.view addSubview:l2];
    
    
    UILabel* l3 = [UILabel new];
    l3.frame = CGRectMake(0, l2.bottom + IFScreenFit2s(10), GlobleWidth, IFScreenFit2s(15));
    l3.text = @"再次提交你要上传的内容。";
    l3.textAlignment = NSTextAlignmentCenter;
    l3.font = CNBold(IFScreenFit2s(15));
    l3.textColor = [UIColor colorFromString_Ext:@"#333333"];
    [self.view addSubview:l3];
    
    
    UIButton* setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(IFScreenFit2s(24), l3.bottom + IFScreenFit2s(50), GlobleWidth - IFScreenFit2s(48), IFScreenFit2s(43));
    [setBtn setTitle:@"进行设置" forState:UIControlStateNormal];
    setBtn.titleLabel.font = CNBold(17);
    [setBtn setBackgroundColor:[UIColor colorFromString_Ext:@"#000020"]];
    setBtn.alpha = 0.7;
    setBtn.layer.cornerRadius = IFScreenFit2s(3);
    setBtn.layer.masksToBounds = YES;
    [self.view addSubview:setBtn];
    __weak typeof(self) me=self;
    [setBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        CNSettingViewController* setting = [CNSettingViewController new];
        [[CLPushAnimatedRight sharedInstance] pushController:setting];
        
    }];
    
    
    UIButton* checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame =CGRectMake(IFScreenFit2s(24), setBtn.bottom + IFScreenFit2s(23), GlobleWidth - IFScreenFit2s(48), IFScreenFit2s(43));
    [checkBtn setTitle:@"查看待传视频" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = CNBold(17);
    [checkBtn setTitleColor:[UIColor colorFromString_Ext:@"#aaaaaa"] forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor colorFromString_Ext:@"#333333"] forState:UIControlStateHighlighted];
    checkBtn.layer.cornerRadius = IFScreenFit2s(3);
    checkBtn.layer.masksToBounds = YES;
    checkBtn.layer.borderWidth = IFScreenFit2s(1);
    checkBtn.layer.borderColor = [UIColor colorFromString_Ext:@"#d3d3d3"].CGColor;
    [self.view addSubview:checkBtn];

    [checkBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    
    
    
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(IFScreenFit2s(24), checkBtn.bottom + IFScreenFit2s(23), GlobleWidth - IFScreenFit2s(48), IFScreenFit2s(43));
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    backBtn.titleLabel.font = CNBold(17);
    [backBtn setTitleColor:[UIColor colorFromString_Ext:@"#aaaaaa"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorFromString_Ext:@"#333333"] forState:UIControlStateHighlighted];
    backBtn.layer.cornerRadius = IFScreenFit2s(3);
    backBtn.layer.masksToBounds = YES;
    backBtn.layer.borderWidth = IFScreenFit2s(1);
    backBtn.layer.borderColor = [UIColor colorFromString_Ext:@"#d3d3d3"].CGColor;
    [self.view addSubview:backBtn];

    [backBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.navigationController popToRootViewControllerAnimated:YES];
    }];
    
//    [upBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        update1ViewController* upload = [[update1ViewController alloc] init];
//        [[CLPushAnimatedRight sharedInstance] pushController:upload];
//    }];
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
