//
//  CNPasswordViewController.m
//  cnnews
//
//  Created by Ryan on 16/5/1.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNPasswordViewController.h"
#import "CNDataModel.h"

@interface CNPasswordViewController ()

@end

@implementation CNPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
  
    
    __weak typeof(self) me=self;
   
    [self.view addSubview:but];
    [self createNavigator:nil];
    [self addBackButton];
    [self setNavigatorTitle:@"修改密码"];
    self.view.backgroundColor=RGB(246, 246, 246);
    
    float margn=14.f;
    
    UILabel *l2=[UILabel new];
    l2.frame=CGRectMake(margn, CCTopHeight, GlobleWidth-IFScreenFit2s(100.f), IFScreenFit2s(38.f));
    l2.font=CNBold(IFScreenFit2(13.f,13.f));
    l2.textColor=RGB(119, 119, 119);
    l2.text=@"当前密码";
    [self.view addSubview:l2];
    
    UIView *bg=[UIView new];
    bg.frame=CGRectMake(0, l2.bottom, GlobleWidth, IFScreenFit2s(50.f));
    bg.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bg];
    
    UITextField *filed2=[[UITextField alloc] init];
    filed2.backgroundColor=[UIColor whiteColor];
    filed2.clearButtonMode=UITextFieldViewModeAlways;
    
    //filed2.borderStyle=UITextBorderStyleLine;
    filed2.textColor=RGB(119, 119, 119);
    filed2.font=CNBold(IFScreenFit2(13.f,13.f));
    filed2.frame=CGRectMake(margn, 0, GlobleWidth-IFScreenFit2s(50.f), IFScreenFit2s(50.f));

    [bg addSubview:filed2];
    
    CALayer *line=[CALayer layer];
    line.backgroundColor=RGB(232, 233, 232).CGColor;
    line.frame=CGRectMake(0, bg.top, GlobleWidth, 0.5);
    [self.view.layer addSublayer:line];
    
    CALayer *line2=[CALayer layer];
    line2.backgroundColor=RGB(232, 233, 232).CGColor;
    line2.frame=CGRectMake(0, bg.bottom, GlobleWidth, 0.5);
    [self.view.layer addSublayer:line2];
    
    
    UILabel *l3=[UILabel new];
    l3.frame=CGRectMake(margn, bg.bottom+0.5, GlobleWidth-IFScreenFit2s(100.f), IFScreenFit2s(38.f));
    l3.font=CNBold(IFScreenFit2(13.f,13.f));
    l3.textColor=RGB(119, 119, 119);
    l3.text=@"新密码";
    [self.view addSubview:l3];
    
    UIView *bg3=[UIView new];
    bg3.frame=CGRectMake(0, l3.bottom, GlobleWidth, IFScreenFit2s(50.f));
    bg3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bg3];
    
    UITextField *filed3=[[UITextField alloc] init];
    filed3.backgroundColor=[UIColor whiteColor];
    filed3.clearButtonMode=UITextFieldViewModeAlways;
    filed3.placeholder=@"6-16个字符,区分大小写";
    //filed2.borderStyle=UITextBorderStyleLine;
    filed3.textColor=RGB(119, 119, 119);
    filed3.font=CNBold(IFScreenFit2(13.f,13.f));
    filed3.frame=CGRectMake(margn, 0, GlobleWidth-IFScreenFit2s(50.f), IFScreenFit2s(50.f));
    
    [bg3 addSubview:filed3];
    
    CALayer *line3=[CALayer layer];
    line3.backgroundColor=RGB(232, 233, 232).CGColor;
    line3.frame=CGRectMake(0, bg3.top, GlobleWidth, 0.5);
    [self.view.layer addSublayer:line3];
    
    CALayer *line32=[CALayer layer];
    line32.backgroundColor=RGB(232, 233, 232).CGColor;
    line32.frame=CGRectMake(0, bg3.bottom, GlobleWidth, 0.5);
    [self.view.layer addSublayer:line32];

    UILabel *l4=[UILabel new];
    l4.frame=CGRectMake(margn, bg3.bottom+0.5, GlobleWidth-IFScreenFit2s(100.f), IFScreenFit2s(38.f));
    l4.font=CNBold(IFScreenFit2(13.f,13.f));
    l4.textColor=RGB(119, 119, 119);
    l4.text=@"确定新密码";
    [self.view addSubview:l4];
    
    UIView *bg4=[UIView new];
    bg4.frame=CGRectMake(0, l4.bottom, GlobleWidth, IFScreenFit2s(50.f));
    bg4.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bg4];
    
    UITextField *filed4=[[UITextField alloc] init];
    filed4.backgroundColor=[UIColor whiteColor];
    filed4.clearButtonMode=UITextFieldViewModeAlways;
    filed4.placeholder=@"6-16个字符,区分大小写";
    //filed2.borderStyle=UITextBorderStyleLine;
    filed4.textColor=RGB(119, 119, 119);
    filed4.font=CNBold(IFScreenFit2(13.f,13.f));
    filed4.frame=CGRectMake(margn, 0, GlobleWidth-IFScreenFit2s(50.f), IFScreenFit2s(50.f));
    
    [bg4 addSubview:filed4];
    
    CALayer *line4=[CALayer layer];
    line4.backgroundColor=RGB(232, 233, 232).CGColor;
    line4.frame=CGRectMake(0, bg4.top, GlobleWidth, 0.5);
    [self.view.layer addSublayer:line4];
    
    CALayer *line42=[CALayer layer];
    line42.backgroundColor=RGB(232, 233, 232).CGColor;
    line42.frame=CGRectMake(0, bg4.bottom, GlobleWidth, 0.5);
    [self.view.layer addSublayer:line42];
    
    
    UIButton *login=[CNButton buttonWithType:UIButtonTypeCustom];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.titleLabel.font=CNFont(17.f);
    [login setTitle:@"确定修改" forState:UIControlStateNormal];
    [login setBackgroundColor:RGB(73.f, 74.f, 97.f)];
    login.frame=CGRectMake(0, GlobleHeight-IFFitFloat6(42), GlobleWidth, IFFitFloat6(42));
    [self.view addSubview:login];
    
    
    
    [login handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSString *f1=filed2.text.trim;
         NSString *f2=filed3.text.trim;
        NSString *f3=filed4.text.trim;
        if(_isStrNULL(f1)){
            [me showModelView:@"请输入当前密码"];
            return ;
        }
        if(_isStrNULL(f2)){
            [me showModelView:@"请输入新密码"];
            return ;
        }
        if(_isStrNULL(f3)){
            [me showModelView:@"请输入确认新密码"];
            return ;
        }
        if(![f3 isEqualToString:f2]){
            [me showModelView:@"新密码两次输入不一致"];
            return ;
        }
        [((CNButton *)sender) nonClickButton];
        __weak typeof(self) me=self;
        [me showLoadView];
        [[CNDataModel sharedInstance] changePassword:f1 newPassword:f2 uiBlock:^(BOOL success, id responseObj, NSString *message) {
            [me disLoadingView];
            if(success){
                [me showModelView:@"修改成功"];
            }else{
                NSString *str=[responseObj sgrGetStringForKey:@"desc"];
                if(!str) str=message;
                if(!str) str=@"修改失败";
                [me showModelView:str];
            }
        }];
        
    }];
    
    [but handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [filed2 resignFirstResponder];
        [filed3 resignFirstResponder];
        [filed4 resignFirstResponder];
    }];

    
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"输入关闭.png"] forState:UIControlStateNormal];
//    
//    btn.frame=CGRectMake(filed2.width-IFScreenFit2s(41.f), (filed2.height-IFScreenFit2s(21.f))/2.f, IFScreenFit2s(21.f), IFScreenFit2s(21.f));
//    [filed2 addSubview:btn];
//    
//    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        filed2.text=nil;
//    }];

}

- (BOOL)showPopAction{
    return YES;
}

@end
