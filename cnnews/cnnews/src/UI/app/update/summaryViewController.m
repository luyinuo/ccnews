//
//  summaryViewController.m
//  cnnews
//
//  Created by wanglb on 16/5/3.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "summaryViewController.h"

@interface summaryViewController ()
@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UILabel* countLabel;
@property (nonatomic,strong) UIButton* comfirm;
@end

@implementation summaryViewController

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.origin.y, self.textView.frame.size.width, GlobleHeight - self.textView.origin.y - kbSize.height);
    
    self.countLabel.frame = CGRectMake(PX_TO_PT(10), self.textView.height-PX_TO_PT(20) - PX_TO_PT(26), PX_TO_PT(120), PX_TO_PT(26));
    self.countLabel.textColor = RGB(144, 144, 144);
    self.countLabel.font = CNBold(IFScreenFit2(15, 15));
    [self.textView addSubview:self.countLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.oneView=[UIView new];
    self.oneView.frame=self.view.bounds;
    [self.view addSubview:self.oneView];
    
    [self createNavigator:self.oneView];
    [self addBackButton];
    [self setNavigatorTitle:@"添加摘要"];
    
    
    CNButton *comfirm=[CNButton buttonWithType: UIButtonTypeCustom];
    [comfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirm.titleLabel.font=CNBold(15.f);
    [comfirm setTitle:@"完成" forState:UIControlStateNormal];
    [comfirm setTitleColor:RGB(170, 170, 170) forState:UIControlStateDisabled];
    [comfirm setTitleColor:RGB(253, 170, 28) forState:UIControlStateNormal];
    comfirm.enabled = NO;
    
    comfirm.frame=CGRectMake(self.navagator.width-IFScreenFit2s(60), self.navagator.height-IFScreenFit2(28,28), IFScreenFit2s(50), IFScreenFit2(15,15));
    [self.navagator addSubview:comfirm];
    self.comfirm = comfirm;
    
    __weak typeof(self) me=self;
    [comfirm handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [me dismissViewControllerAnimated:YES completion:^{
            
            NSString* text = self.textView.text;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:PX_TO_PT(10)];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
            
            self.up1.summaryLabel.attributedText = attributedString;
            //[self.up1.summaryLabel sizeToFit];
        }];
    }];
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CCTopHeight, GlobleWidth - 20, GlobleHeight -CCTopHeight - 320)];
    self.textView.backgroundColor = RGB(246, 246, 246);
    self.textView.font = CNFont(IFScreenFit2(16, 16));
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    self.textView.text = self.summary;

    self.countLabel = [[UILabel alloc] init];
    self.countLabel.text = [NSString stringWithFormat:@"%lu/1000",(unsigned long)_textView.text.length];
    
    [self.backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [me dismissViewControllerAnimated:YES completion:nil];
    }];
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 1000)
    {
        textView.text = [textView.text substringToIndex:1000];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu/1000",(unsigned long)textView.text.length];
    if(textView.text.length>=1)
    {
        self.comfirm.enabled = YES;
    }else
    {
        self.comfirm.enabled = NO;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.text.length>=1)
    {
        self.comfirm.enabled = YES;
    }else
    {
        self.comfirm.enabled = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
