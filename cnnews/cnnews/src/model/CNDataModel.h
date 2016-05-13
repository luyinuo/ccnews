//
//  CNDataModel.h
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CLDataModel.h"
#import "IFCoreDataManager.h"
#import "CNList.h"
#import "CNDetail.h"

@interface CNDataModel : CLDataModel

@property (nonatomic,strong)NSDictionary *urlMap;
@property (nonatomic,strong)NSString *sessionId;

SGR_SINGLETION(CNDataModel)

- (NSString *)urlWithCategory:(NSString *)key;



- (void)createLive:(NSString *)title location:(NSString *)loc cover:(UIImage *)img complate:(void (^)(BOOL success,NSString *message,NSDictionary *dic) )block;

- (void)getCommListWithCategroy:(NSString *)category
                       withPage:(int) num
                       lastList:(CNList *)clList
                        orderBy:(int)orderBy
                        uiBlock:(void (^)(BOOL success,id responseObj,NSString *message) )block;


- (void)detail:(NSString *)detailId complate:(void (^)(BOOL success,NSString *message,CNDetail *detail) )block1;

- (void)relogin;

-(void)removeUploadingWithId:(NSString *)theId;

- (BOOL)saveLocalUploadWithId:(NSString *)theId
                        title:(NSString *)title
                        cover:(UIImage *)image
                         pics:(int)pics
                       videos:(int)videos
                      upChunk:(int )upChunk
                       upDate:(NSTimeInterval )upDate
                     upDesMov:(NSString *)upDesMov
                     upDesPic:(NSString *)upDesPic
                      upFiles:(NSString *)upFiles
                     upMovies:(NSString *)upMovies
                       upPics:(NSString *)upPics
                      summary:(NSString *)summary
                    fileIndex:(int)fileIndex;

- (BOOL)uploadWifi;
- (void)setUploadWifi:(BOOL)upload;

- (void)changePassword:(NSString *)oldpass newPassword:(NSString *)newPass uiBlock:(void (^)(BOOL success,id responseObj,NSString *message) )block;

@end
