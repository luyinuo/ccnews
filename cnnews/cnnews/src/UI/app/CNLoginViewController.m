//
//  CNLoginViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNLoginViewController.h"
#import "CNDataModel.h"

@implementation CNLoginView

- (void)setUp{
 

    self.frame=CGRectMake(0, 0, GlobleWidth-IFFitFloat6(48.f), IFFitFloat6(106+43+21.5));
    UIView *bgView=[[UIView alloc] init];
    bgView.clipsToBounds=YES;
    bgView.layer.cornerRadius=4.f;
    bgView.frame=CGRectMake(0, 0, GlobleWidth-IFFitFloat6(48.f), IFFitFloat6(106));
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.alpha=0.3;
    

    
    [self addSubview:bgView];
    
    self.account=[[UITextField alloc] init];
    self.account.frame=
    CGRectMake(IFFitFloat6(32)+IFFitFloat6(16.5), 0, self.width-(IFFitFloat6(32)+IFFitFloat6(16.5)), IFFitFloat6(53.f));
    self.account.textColor=[UIColor whiteColor];
    
    self.password=[[UITextField alloc] init];
    self.password.secureTextEntry=YES;
    self.password.frame=
    CGRectMake(IFFitFloat6(32)+IFFitFloat6(16.5), IFFitFloat6(53.f), self.width-(IFFitFloat6(32)+IFFitFloat6(16.5)), IFFitFloat6(53.f));
    self.password.textColor=[UIColor whiteColor];
    [self addSubview:self.account];
    [self addSubview:self.password];
    
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0, self.account.height-0.5, self.width, 0.5);
    layer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor;
    [self.layer addSublayer:layer];
    
    UIImageView *icon=[[UIImageView alloc] init];
    icon.image=[UIImage imageNamed:@"登陆.png"];
    icon.frame=CGRectMake(IFFitFloat6(16), (self.account.height-IFFitFloat6(16.5))/2.f, IFFitFloat6(16.5), IFFitFloat6(16.5));
    [self addSubview:icon];
    
    UIImageView *icon2=[[UIImageView alloc] init];
    icon2.image=[UIImage imageNamed:@"锁.png"];
    icon2.frame=CGRectMake(IFFitFloat6(16), self.account.height+(self.account.height-IFFitFloat6(16.5))/2.f,
                          IFFitFloat6(16.5), IFFitFloat6(16.5));
    [self addSubview:icon2];
    
    
    UIImageView *biyan=[[UIImageView alloc] init];
    biyan.image=[UIImage imageNamed:@"闭眼.png"];
    
    biyan.frame=CGRectMake(self.width-IFFitFloat6(16.5+16), self.account.height+(self.account.height-IFFitFloat6(6.5))/2.f,
                           IFFitFloat6(16.5), IFFitFloat6(6.5));
    [self addSubview:biyan];
    
    
    UIImageView *biyan2=[[UIImageView alloc] init];
    biyan2.image=[UIImage imageNamed:@"眼睛.png"];
    biyan2.hidden=YES;
    
    biyan2.frame=CGRectMake(self.width-IFFitFloat6(20+16), self.account.height+(self.account.height-IFFitFloat6(12.f))/2.f,
                           IFFitFloat6(20), IFFitFloat6(12.5));
    [self addSubview:biyan2];
    
    
    CNButton *btn=[CNButton buttonWithType:UIButtonTypeCustom];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(IFFitFloat6(6.5), IFFitFloat6(6.5), IFFitFloat6(6.5), IFFitFloat6(6.5))];
    btn.frame=CGRectMake(self.width-IFFitFloat6(19.5)-IFFitFloat6(16.5), self.account.height,
                         IFFitFloat6(16.5+13), self.account.height);
    [self addSubview:btn];
    
    __weak typeof(self) me=self;
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        CNButton *b=((CNButton *)sender);
        [b setSelected:!b.selected];
        me.password.secureTextEntry=!b.isSelected;
        biyan.hidden=b.isSelected;
        biyan2.hidden=!b.isSelected;
    
        
    }];
    
    
    
    self.login=[CNButton buttonWithType:UIButtonTypeCustom];
    [self.login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.login.titleLabel.font=CNFont(17.f);
    [self.login setTitle:@"登录" forState:UIControlStateNormal];
    self.login.layer.cornerRadius=5.f;
    [self.login setBackgroundColor:RGB(31.f, 76.f, 152.f)];
    self.login.frame=CGRectMake(0, self.password.bottom+IFScreenFit2s(10), self.width, IFScreenFit2s(42));
    [self addSubview:self.login];
    
    
    
}


@end

@interface CNLoginViewController ()

@property (nonatomic,strong) UIImageView *backgroundImage;

@property (nonatomic,strong) CNLoginView *loginView;

@property (nonatomic,strong) UIImageView *bgView;

@end

@implementation CNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(10.f, 12.f, 33.f);
    
    self.bgView=[[UIImageView alloc] init];
    self.bgView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
    self.bgView.contentMode=UIViewContentModeScaleAspectFit;
    self.bgView.image=[UIImage imageNamed:@"登录背景.png"];
    [self.view addSubview:self.bgView];
    
    UIImageView *logo=[[UIImageView alloc] init];
//    logo.width=0.6*GlobleWidth;
//    float h=(127.f/278.f)*logo.width;
// 
//    logo.height=h;
//    logo.center=self.bgView.center;
    logo.frame=CGRectMake((GlobleWidth-IFScreenFit2s(79.5*0.8))/2.f, IFFitFloat6(200-80-22.5), IFScreenFit2s(79.5*0.8), IFScreenFit2s(67*0.8));
    logo.contentMode=UIViewContentModeScaleAspectFill;
    logo.image=[UIImage imageNamed:@"小楼.png"];
    [self.bgView addSubview:logo];
    
    UIImageView *text=[[UIImageView alloc] init];
    text.image=[UIImage imageNamed:@"央视新闻+.png"];
    text.frame=CGRectMake((GlobleWidth-IFScreenFit2s(90.5*0.8))/2.f, logo.bottom, IFFitFloat6(90.5*0.8), IFFitFloat6(22.5*0.8));
    
    [self.bgView addSubview:text];
    [self setlogin];
    
    
//    [UIView animateWithDuration:1.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//       // logo.top=(IFFitFloat6(200)-h);
//        logo.width=GlobleWidth*0.43;
//        logo.height=(127.f/278.f)*(GlobleWidth*0.43);
//        logo.center=CGPointMake(GlobleWidth/2.f, (IFFitFloat6(200)-(127.f/278.f)*(GlobleWidth*0.43)));
//    } completion:^(BOOL finished) {
//        [self setlogin];
//    }];

    UILabel *label1=[[UILabel alloc] init];
    // _label1.backgroundColor=RGB(245, 245, 245);
    label1.font=[UIFont systemFontOfSize:12.f];
    label1.textColor=[UIColor whiteColor];
    
    label1.frame=CGRectMake(0, 0, 240.f, 21.f);
    label1.center=CGPointMake(self.bgView.center.x, self.bgView.center.y*1.9);
    
    label1.textAlignment=NSTextAlignmentCenter;
    label1.text=@"Copyright © 2016 央视新闻 保留所有权利";
    [self.bgView addSubview:label1];
    
    
    
}

- (void)setlogin{
    self.loginView=[CNLoginView new];
    [self.loginView setUp];
    NSString *string=[[NSUserDefaults standardUserDefaults] stringForKey:@"currentUserAccount"];
    if(_isStrNotNull(string)){
        self.loginView.account.text=string;
    }
    self.loginView.left=IFFitFloat6(24);
    self.loginView.top=IFFitFloat6(200);
    [self.view addSubview:self.loginView];
    [self.loginView.login addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)doLogin{
    NSString *account=self.loginView.account.text.trim;
    NSString *password=self.loginView.password.text.trim;
    if(_isStrNULL(account) || _isStrNULL(password)){
        [self showModelView:@"请填写账号和密码"];
        return;
    }
    __weak typeof(self) me=self;
    [self showLoadView];
    [[CNDataModel sharedInstance] login:account password:password complate:^(BOOL success, NSString *message) {
        [me disLoadingView];
        if(success){
            [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"currentUserAccount"];
            [CNUser sharedInstance].userID=account;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CNUserLoginsuccess object:[CNUser sharedInstance]];
            me.view.alpha=1;
            
            [UIView animateWithDuration:0.35
                              animations:^{
                                  me.view.alpha=0;
                              }
                             completion:^(BOOL finished) {
                                 [me.view removeFromSuperview];
                                 [me removeFromParentViewController];
                             }];
            
           
            
        }else{
            [self showModelView:message];
        }
    }];
    
    
    [self.loginView.login nonClickButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
