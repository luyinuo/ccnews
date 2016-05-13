//
//  summaryViewController.h
//  cnnews
//
//  Created by wanglb on 16/5/3.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNViewController.h"
#import "update1ViewController.h"

@interface summaryViewController : CNViewController<UITextViewDelegate>

@property (nonatomic,strong) UITextView* textView;
@property (nonatomic,strong) update1ViewController* up1;
@property (nonatomic,copy)   NSString* summary;
@end
