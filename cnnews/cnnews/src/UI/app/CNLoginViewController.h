//
//  CNLoginViewController.h
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNViewController.h"

@interface CNLoginView : UIView

@property (nonatomic,strong)UITextField *account;
@property (nonatomic,strong)UITextField *password;
@property (nonatomic,strong)CNButton *login;

@end

@interface CNLoginViewController : CNViewController

@end
