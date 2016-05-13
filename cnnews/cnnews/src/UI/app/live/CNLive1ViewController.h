//
//  CNLive1ViewController.h
//  cnnews
//
//  Created by Ryan on 16/4/24.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNViewController.h"

@interface CNLive1ViewController : CNViewController<UIActionSheetDelegate,UITextFieldDelegate>

- (void)setPushUrl:(NSString *)pushUrl andLiveCode:(NSString *)code;

@end
