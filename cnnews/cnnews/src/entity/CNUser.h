//
//  CNUser.h
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CNUserLoginsuccess @"CNusetlsdfjssfhhgefhdhwuwu3"

@interface CNUser : NSObject

SGR_SINGLETION(CNUser)

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *sessionId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *password;

- (void)save;

@end
