//
//  CLDataModel.m
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import "CLDataModel.h"
#import "AFNetworking.h"
#import "SgrGCD.h"
#import "CNGlobal.h"
#import "NSObject+sagittarius.h"
#import "CNUser.h"

#define  cn_session_error @"-1001"

@implementation CLDataModel

//SGR_DEF_SINGLETION(CLDataModel)


- (void)getWithUrl:(NSString *)url
             param:(NSDictionary *)param
         dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
           uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2{
    [self getWithUrl:url param:param dataBlock:block1 uiBlock:block2 checkSession:YES];
}

- (void)getWithUrl:(NSString *)url
             param:(NSDictionary *)param
         dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
           uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2
      checkSession:(BOOL) isCheckSession{
    
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak typeof(self) me=self;
    // Get请求
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        //NSLog(@"%@",task.currentRequest);
     
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        
    
        if(isCheckSession){
            if(![me checkSession:obj]){
                me.retry1++;
                if(me.retry1>2){
                    if(block2){
                        block2(NO,nil,nil,@{@"result":@"-1001",@"desc":@"sesssion过期，请重新登录"}.mutableCopy);
                        return ;
                    }
                }
                
                [me login:[CNUser sharedInstance].userID
                 password:[CNUser sharedInstance].password
                 complate:^(BOOL success, NSString *message) {
                     if(success){
                         [me getWithUrl:url param:param dataBlock:block1 uiBlock:block2];
                     }else{
                         if(block2){
                          
                             block2(NO,nil,nil,@{@"result":@"-1001",@"desc":@"sesssion过期，请重新登录"}.mutableCopy);
                         }
                     }

                 }];
                
                
                return ;
            }
            me.retry1=0;
        }
        
      

        
      
        
        
         NSMutableDictionary *params=[NSMutableDictionary dictionary];
        
        if(block1){
            [[SgrGCD sharedInstance] enqueueGloble:^{
                block1(YES,obj,nil,params);
                sgrSafeMainThread(^{
                    if(block2)
                    block2(YES,obj,nil,params);
                }
            );
            }];
        }else if(block2){
            block2(YES,obj,nil,params);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        if(block1){
            [[SgrGCD sharedInstance] enqueueGloble:^{
                block1(NO,nil,error,params);
                sgrSafeMainThread(^{
                     if(block2)
                    block2(NO,nil,error,params);
                }
                );
            }];
        }else if(block2){
            block2(NO,nil,error,params);
        }
        
    }];
    
    

}



- (void)postWithUrl:(NSString *)url
              param:(NSDictionary *)param
          dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
            uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak typeof(self) me=self;
    [manager POST:url
       parameters:param
     progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    
             if(![me checkSession:obj]){
                 
                 me.retry2++;
                 if(me.retry2>2){
                     if(block2){
                         block2(NO,nil,nil,@{@"result":@"-1001",@"desc":@"sesssion过期，请重新登录"}.mutableCopy);
                         return ;
                     }
                 }
                 [me login:[CNUser sharedInstance].userID
                  password:[CNUser sharedInstance].password
                  complate:^(BOOL success, NSString *message) {
                      if(success){
                          [me postWithUrl:url param:param dataBlock:block1 uiBlock:block2];
                      }else{
                          if(block2){
                              
                              block2(NO,nil,nil,@{@"result":@"-1001",@"desc":@"sesssion过期，请重新登录"}.mutableCopy);
                              
                          }
                      }
                      
                  }];
                 
                 
                 return ;
             }
         

         me.retry2=0;
         
         
         NSMutableDictionary *params=[NSMutableDictionary dictionary];
         if(block1){
             [[SgrGCD sharedInstance] enqueueGloble:^{
            
                 block1(YES,obj,nil,params);
                 sgrSafeMainThread(^{
                     if(block2)
                     block2(YES,obj,nil,params);
                 }
                                   );
             }];
         }else if(block2){
             if(block2)
             block2(YES,obj,nil,params);
         }

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSMutableDictionary *params=[NSMutableDictionary dictionary];
         if(block1){
             [[SgrGCD sharedInstance] enqueueGloble:^{
                 
              
                 block1(NO,nil,error,params);
                 sgrSafeMainThread(^{
                     if(block2)
                     block2(NO,nil,error,params);
                 }
                                   );
             }];
         }else if(block2){
             block2(NO,nil,error,params);
         }

     }
          ];
    

}

- (void)getWithUrlJpeg:(NSString *)url
              param:(NSDictionary *)param
               file:(NSData *)data
           fileName:(NSString *)fileName
          dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
            uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    __weak typeof(self) me=self;
    [manager POST:url
       parameters:param
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if(data && fileName)
        [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpeg"];
    
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
                   if(![me checkSession:obj] ){
                
                me.retry3++;
                if(me.retry3>2){
                    if(block2){
                        block2(NO,nil,nil,@{@"result":@"-1001",@"desc":@"sesssion过期，请重新登录"}.mutableCopy);
                        return ;
                    }
                }
                [me login:[CNUser sharedInstance].userID
                 password:[CNUser sharedInstance].password
                 complate:^(BOOL success, NSString *message) {
                     if(success){
                         [me postWithUrl:url param:param file:data fileName:fileName dataBlock:block1 uiBlock:block2];
                     }else{
                         if(block2){
                             
                             block2(NO,nil,nil,@{@"result":@"-1001",@"desc":@"sesssion过期，请重新登录"}.mutableCopy);
                         }
                     }
                     
                 }];
                
                
                return ;
            }
        
        
        me.retry3=0;

        
        
        
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        if(block1){
            [[SgrGCD sharedInstance] enqueueGloble:^{
                block1(YES,obj,nil,params);
                sgrSafeMainThread(^{
                     if(block2)
                    block2(YES,obj,nil,params);
                }
                );
            }];
        }else if(block2){
            block2(YES,obj,nil,params);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        if(block1){
            [[SgrGCD sharedInstance] enqueueGloble:^{
                
                
                block1(NO,nil,error,params);
                sgrSafeMainThread(^{
                     if(block2)
                    block2(NO,nil,error,params);
                }
                                  );
            }];
        }else if(block2){
            block2(NO,nil,error,params);
        }

        
    }];
    
}

- (BOOL)checkSession:(id) json{
 
    
    if([json isKindOfClass:[NSDictionary class]] && [cn_session_error isEqualToString:[json sgrFGetStringForKey:@"result"]]){
        return NO;
    }
    return YES;
}

- (void)login:(NSString *)account password:(NSString*) password complate:(void (^)(BOOL success,NSString *message) )block1{
    //子类实现
}

- (void)postWithUrl:(NSString *)url
              param:(NSDictionary *)param
               file:(NSData *)data
           fileName:(NSString *)fileName
          dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
            uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url
       parameters:param
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if(data && fileName)
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/json"];
    
} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //NSLog(@"%@",task.originalRequest.HTTPBody);
    id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    
    if([obj isKindOfClass:[NSDictionary class]]&&
       [@"1" isEqualToString:[obj sgrFGetStringForKey:@"result"]]){
        [CNUser sharedInstance].sessionId=[obj  sgrGetStringForKey:@"sessionid"];
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    if(block1){
        [[SgrGCD sharedInstance] enqueueGloble:^{
            block1(YES,obj,nil,params);
            sgrSafeMainThread(^{
                if(block2)
                    block2(YES,obj,nil,params);
            }
                              );
        }];
    }else if(block2){
        block2(YES,obj,nil,params);
    }
    
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    if(block1){
        [[SgrGCD sharedInstance] enqueueGloble:^{
            
            
            block1(NO,nil,error,params);
            sgrSafeMainThread(^{
                if(block2)
                    block2(NO,nil,error,params);
            }
                              );
        }];
    }else if(block2){
        block2(NO,nil,error,params);
    }
    
    
}];
    
}




@end
