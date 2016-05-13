//
//  CNSettingViewController.m
//  cnnews
//
//  Created by Ryan on 16/5/1.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNSettingViewController.h"
#import "CNDataModel.h"
#import "CNPasswordViewController.h"
#import "CLPushAnimatedRight.h"

@interface CNSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation CNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self createNavigator:nil];
    [self addBackButton];
    [self setNavigatorTitle:@"功能设置"];
    self.view.backgroundColor=RGB(246, 246, 246);
    
    
    self.tableView=[[UITableView alloc] init];
    self.tableView.frame=CGRectMake(0, self.navagator.height, GlobleWidth, GlobleHeight-self.navagator.height);
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollsToTop=NO;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=0;
    switch (section) {
        case 0:
            num=1;
            break;
        case 1:
            num=1;
            break;
            
        default:
            break;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[UIView new];
    view.backgroundColor=RGB(245, 246, 247);
    if(section==0){
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(25.f, 0, GlobleWidth-50.f, 38.f)];
        label.font=CNBold(12);
        label.textColor=RGB(160, 160, 160);
        label.text=@"网络设置";
        [view addSubview:label];
        
        
    }else if(section==1){
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(25.f, 0, GlobleWidth-50.f, 38.f)];
        label.font=CNBold(12);
        label.textColor=RGB(160, 160, 160);
        label.text=@"密码设置";
        [view addSubview:label];

    }
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil ];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(indexPath.section==0){
        UILabel *label=[UILabel new];
        label.font=CNBold(13);
        label.textColor=RGB(51, 52, 53);
        label.text=@"在无WIFI的情况下,使用4G网络上传视频";
        label.frame=CGRectMake(25, 0, 250.f, 55.f);
        [cell addSubview:label];
        
        UISwitch *sw=[[UISwitch alloc] init];
        sw.frame=CGRectMake(GlobleWidth-10.f-50.f, 25.f/2.f, 50, 30);
        [cell addSubview:sw];
        [sw setOn:[[CNDataModel sharedInstance] uploadWifi]];
        
        __weak UISwitch *sww=sw;
        [sw handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
            [[CNDataModel sharedInstance] setUploadWifi:sww.on];
            
        }];
        
        CALayer *line=[CALayer layer];
        line.backgroundColor=RGB(232, 233, 232).CGColor;
        line.frame=CGRectMake(0, 0.f, GlobleWidth, 0.5);
        [cell.layer addSublayer:line];
        
        CALayer *line2=[CALayer layer];
        line2.backgroundColor=RGB(232, 233, 232).CGColor;
        line2.frame=CGRectMake(0, 55.f, GlobleWidth, 0.5);
        [cell.layer addSublayer:line2];


        
    }else if(indexPath.section==1){
        UILabel *label=[UILabel new];
        label.font=CNBold(13);
        label.textColor=RGB(51, 52, 53);
        label.text=@"修改当前密码";
        label.frame=CGRectMake(25, 0, 250.f, 55.f);
        [cell addSubview:label];
        
        CALayer *line=[CALayer layer];
        line.backgroundColor=RGB(232, 233, 232).CGColor;
        line.frame=CGRectMake(0, 0.f, GlobleWidth, 0.5);
        [cell.layer addSublayer:line];
        
        CALayer *line2=[CALayer layer];
        line2.backgroundColor=RGB(232, 233, 232).CGColor;
        line2.frame=CGRectMake(0, 55.f, GlobleWidth, 0.5);
        [cell.layer addSublayer:line2];

        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==1){
        CNPasswordViewController *pass=[[CNPasswordViewController alloc] init];
        [[CLPushAnimatedRight sharedInstance] pushController:pass];

    }
}

- (BOOL)showPopAction{
    return YES;
}

@end
