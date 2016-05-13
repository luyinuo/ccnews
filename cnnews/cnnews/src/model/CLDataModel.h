//
//  CLDataModel.h
//  chanlin
//
//  Created by Ryan on 14-11-1.
//  Copyright (c) 2014年 chanlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObject+Dao.h"

@interface CLDataModel : NSObject

@property (nonatomic,assign) int retry1;
@property (nonatomic,assign) int retry2;
@property (nonatomic,assign) int retry3;


//SGR_SINGLETION(CLDataModel)

- (void)getWithUrl:(NSString *)url
             param:(NSDictionary *)param
         dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
           uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2;

- (void)postWithUrl:(NSString *)url
              param:(NSDictionary *)param
          dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
            uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2;

- (void)postWithUrl:(NSString *)url
              param:(NSDictionary *)param
               file:(NSData *)data
           fileName:(NSString *)fileName
          dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
            uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2;

- (void)getWithUrl:(NSString *)url
             param:(NSDictionary *)param
         dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
           uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2
      checkSession:(BOOL) isCheckSession;

- (void)login:(NSString *)account password:(NSString*) password complate:(void (^)(BOOL success,NSString *message) )block1;

- (void)getWithUrlJpeg:(NSString *)url
              param:(NSDictionary *)param
               file:(NSData *)data
           fileName:(NSString *)fileName
          dataBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block1
            uiBlock:(void (^)(BOOL success,id responseObj,NSError *message,NSMutableDictionary *param) )block2;

@end
