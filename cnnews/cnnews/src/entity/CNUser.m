//
//  CNUser.m
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNUser.h"

@implementation CNUser

SGR_DEF_SINGLETION(CNUser)

- (instancetype)init{
    self=[super init];
    if(self){
       _userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentUserStr"];
        _sessionId=[[NSUserDefaults standardUserDefaults] stringForKey:@"currentSessionId"];
        _userName=[[NSUserDefaults standardUserDefaults] stringForKey:@"currentUname"];
        _password=[[NSUserDefaults standardUserDefaults] stringForKey:@"currentPassword"];
      
    }
    return self;
}


- (void)setUserID:(NSString *)userID{
    _userID=userID;
    if(_isStrNotNull(userID)){
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"currentUserStr"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserStr"];
    }

}

- (void)setSessionId:(NSString *)sessionId{
    _sessionId=sessionId;
    if(_isStrNotNull(sessionId)){
        [[NSUserDefaults standardUserDefaults] setObject:_sessionId forKey:@"currentSessionId"];
        

    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentSessionId"];
    }
    
}

- (void)setUserName:(NSString *)userName{
    _userName=userName;
    if(_isStrNotNull(userName)){
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"currentUname"];
        
        
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUname"];
    }
}

- (void)setPassword:(NSString *)password{
    _password=password;
    if(_isStrNotNull(password)){
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"currentPassword"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"currentPassword"];
    }
    
}

- (void)save{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
