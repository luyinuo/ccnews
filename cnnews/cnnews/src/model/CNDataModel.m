//
//  CNDataModel.m
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNDataModel.h"
#import "CNList+Oper.h"
#import "SgrSandbox.h"


@implementation CNDataModel

SGR_DEF_SINGLETION(CNDataModel)

- (instancetype)init{
    self=[super init];
    if(self){
        self.urlMap=@{@"liveCreate":@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/livetest.php",
                      @"live":
                          @"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/ugcappliveindex.php?card=%@&sessionid=%@&page=%d&orderby=%d",
                      @"login":@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/cardverify_passwd.php",
                      @"createLive":@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/ugcappliveapplication.php?card=%@",
                      @"video":@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/ugcappindex.php?card=%@&sessionid=%@&page=%d&orderby=%d",
                      @"detail":@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/ugcappdetail.php?card=%@&sessionid=%@&id=%@",
                      @"password":@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/modifypasswd.php?card=%@"};
    }
    return self;
}

- (NSString *)urlWithCategory:(NSString *)key{
    return [self.urlMap sgrGetStringForKey:key];
    
}

- (void)login:(NSString *)account
     password:(NSString*) password
     complate:(void (^)(BOOL success,NSString *message) )block{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:account forKey:@"card"];
    long long a=[[NSDate date] timeIntervalSince1970]*1000;
    NSString *sendpw=[self k_md5:[NSString stringWithFormat:@"%@|%@||xkeis9@kslw.di",account,password]];
    [dic setObject:sendpw forKey:@"passwd"];
    
    [dic setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"time"];
    NSString *sin=[self k_md5:[NSString stringWithFormat:@"%@|xkeis9@kslw.di||%@|||%lld",account,sendpw,a]];
    [dic setObject:sin forKey:@"sign"];
    
 
    
    [self getWithUrl:[self urlWithCategory:@"login"] param:dic
            dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
                if(success&& [responseObj isKindOfClass:[NSDictionary class]]&&
                   [@"1" isEqualToString:[responseObj sgrFGetStringForKey:@"result"]]){
                    [CNUser sharedInstance].userID=account;
                    [CNUser sharedInstance].userName=[responseObj sgrGetStringForKey:@"username"];
                    [CNUser sharedInstance].sessionId=[responseObj  sgrGetStringForKey:@"sessionid"];
                    [CNUser sharedInstance].password=password;
                    [[CNUser sharedInstance] save];

                }
                
        
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        
        
        
        if(success&& [responseObj isKindOfClass:[NSDictionary class]]&&
           [@"1" isEqualToString:[responseObj sgrFGetStringForKey:@"result"]]){
            
            if(block){
                block(YES,@"");
            }
            
        }else{
            NSString *str=[responseObj sgrGetStringForKey:@"desc"];
            if(_isStrNULL(str)){
                str=@"登陆错误，请重试";
            }
            
            if(block){
                block(NO,str);
            }
        }

    } checkSession:NO];
    
}

- (void)createLive:(NSString *)title location:(NSString *)loc cover:(UIImage *)img complate:(void (^)(BOOL success,NSString *message,NSDictionary *dic) )block{
    
    NSString *url=[NSString stringWithFormat:[self urlWithCategory:@"createLive"],[CNUser sharedInstance].userID];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic sgrSetObject:[CNUser sharedInstance].sessionId forKey:@"sessionid"];
    [dic sgrSetObject:title forKey:@"title"];
    [dic sgrSetObject:loc forKey:@"location"];
    
    NSData *data=nil;
    if(img){
       data= UIImageJPEGRepresentation(img, 0.7);
    }
    
    __block BOOL bsuccess=YES;
    [self getWithUrlJpeg:url param:dic file:data fileName:@"cover" dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        NSLog(@"%@",responseObj);
        if(success &&
                      [responseObj isKindOfClass:[NSDictionary class]] &&
                      [@"1" isEqualToString:[responseObj sgrFGetStringForKey:@"result"]]){
            [CNUser sharedInstance].sessionId=[responseObj sgrGetStringForKey:@"sessionid"];
                       NSString *url=[responseObj  sgrGetStringForKey:@"rtmp_push_url"];
                        NSString *code=[responseObj sgrFGetStringForKey:@"id"];
                       long long time=[[responseObj sgrGetNumberForKey:@"now"] longLongValue];
           
                       [[IFCoreDataManager sharedInstance] performBlockAndWait:^(NSManagedObjectContext *moc) {
                           CNList *ordItem=[CNList fetchFirstWithPredict:[NSPredicate predicateWithFormat:
                                                                          @"category==%@  and userId==%@",@"live",[CNUser sharedInstance].userID] withMOC:moc order:@"sort"];
                           
                          // NSLog(@"%d==%@",ordItem.sort,ordItem.title);
                           CNList *list=[CNList managerObjWithMoc:moc];
                           list.pushUrl=url;
                           list.code=code;
                           list.title=title;
                           list.location=loc;
                           list.time=time;
                           list.category=@"live";
                           list.userId=[CNUser sharedInstance].userID;
                           int sort=ordItem?ordItem.sort:0;
                           list.sort=sort-1;
                           [[IFCoreDataManager sharedInstance] saveContext:moc ToPersistentStore:nil];
           
                       }];
                       
                       [param sgrSetObject:url forKey:@"url"];
                       [param sgrSetObject:code forKey:@"code"];
                       
        }else{
            bsuccess=NO;
        }

        
        
        
        
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        
        if(bsuccess){
                        if(block){
                            block(YES,message.localizedFailureReason,param);
                        }
                    }else{
                        if(block){
                            NSString *str= (message.code==-1009)?@"网络连接断开,请检查网络":[responseObj sgrGetStringForKey:@"desc"];
                            block(NO,str,nil);
                        }
                    }
        
        
        
    }];
        


}


//- (void)test{
//    [[IFCoreDataManager sharedInstance] performBlockAndWait:^(NSManagedObjectContext *moc) {
//       
//        CNList *listitem=[CNList managerObjWithMoc:moc];
//       
//        listitem.userId=[CNUser sharedInstance].userID;
//        listitem.title=@"失联飞机是劳动法";
//        listitem.image=@"";
//        listitem.category=@"live";
//        listitem.sort=2;
//        [[IFCoreDataManager sharedInstance] saveContext:moc ToPersistentStore:nil];
//    }];
//}


- (void)getCommListWithCategroy:(NSString *)category
                       withPage:(int) num
                       lastList:(CNList *)clList
                        orderBy:(int)orderBy
                        uiBlock:(void (^)(BOOL success,id responseObj,NSString *message) )block{
    NSString *url=[self urlWithCategory:category];
    if(_isStrNULL(url)) return;
    url=[NSString stringWithFormat:url,[[CNUser sharedInstance].userID urlEncodeComm],[[CNUser sharedInstance].sessionId urlEncodeComm],num,orderBy];
//    NSString *surl=[NSString stringWithFormat:url,[CNUser sharedInstance].userID,[CNUser sharedInstance].sessionId,num];
  //  NSLog(@"%@",[NSString stringWithFormat:url,[CNUser sharedInstance].userID,[CNUser sharedInstance].sessionId,num]);
    
    __block BOOL isSuccess;
    __block NSString *errormessage;
    __block BOOL arrayCount=YES;
    [self getWithUrl:url param:nil dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        if(success && [responseObj isKindOfClass:[NSDictionary class]]
           && [@"1" isEqualToString:[responseObj sgrFGetStringForKey:@"result"]]){
            
            [CNUser sharedInstance].sessionId=[responseObj sgrGetStringForKey:@"sessionid"];
            [[CNUser sharedInstance] save];
            [[IFCoreDataManager sharedInstance] performBlockAndWait:^(NSManagedObjectContext *moc) {
                if(num==0){
                    NSArray *items=[CNList
                                    fetchAllWithPredict:
                                    [NSPredicate predicateWithFormat:@"uploading==%@ and category==%@ and userId==%@",@(0),category,[CNUser sharedInstance].userID]
                                                                                           withMOC:moc];
                    for(CNList *item in items){
                            [moc deleteObject:item];
                        }
                    
                }
                
                NSArray *list=[((NSObject *)responseObj) sgrGetArrayForKey:@"data"];
                NSUInteger n=[list count];
                int last=clList?clList.sort+1:0;
                arrayCount=(list.count>0);
                for(int i=0;i<n;i++){
                    NSDictionary *dic=[list sgrGetDictionaryForIndex:i];
                    if(!dic)continue;
                    NSString *itmeId=[dic sgrFGetStringForKey:@"id"];
                    CNList *listitem=[CNList managerObjByCreateOrGetWithPredicate:
                                      [NSPredicate predicateWithFormat:
                                       @"category==%@ and listId==%@ and userId==%@",category,itmeId,[CNUser sharedInstance].userID]
                     
                                                                              moc:moc];
                    if([@"live" isEqualToString:category]){
                        [listitem loadLive:dic];
                    }else if ([@"video" isEqualToString:category]){
                        [listitem loadVideo:dic];
                    }
                    
                    listitem.userId=[CNUser sharedInstance].userID;
                    listitem.category=category;
                    listitem.sort=i+1+last;
                    
                    
                    
                }
                isSuccess=YES;
                [[IFCoreDataManager sharedInstance] saveContext:moc ToPersistentStore:nil];
            }];
            
        }else{
            isSuccess=NO;
            errormessage=@"数据失败!";
        }
        
        
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        block(isSuccess,((arrayCount>0)?responseObj:nil),errormessage);
    }];
    
    
}



- (void)detail:(NSString *)detailId complate:(void (^)(BOOL success,NSString *message,CNDetail *detail) )block1{
    NSString *url=[self urlWithCategory:@"detail"];
    url=[NSString stringWithFormat:url,
         [[CNUser sharedInstance].userID urlEncodeComm],
         [[CNUser sharedInstance].sessionId urlEncodeComm],[detailId urlEncodeComm]];
    [self getWithUrl:url param:nil dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        if(success && [responseObj isKindOfClass:[NSDictionary class]] &&
           [@"1" isEqualToString:[responseObj sgrFGetStringForKey:@"result"]]){
            [CNUser sharedInstance].sessionId=[responseObj sgrGetStringForKey:@"sessionid"];
            NSDictionary *data=[responseObj sgrGetDictionaryForKey:@"data"];
            CNDetail *detail =[[CNDetail alloc] init];
            detail.deatilId=detailId;
            detail.title=[data sgrGetStringForKey:@"title"];
            detail.summary=[data sgrGetStringForKey:@"summary"];
            detail.createtime=[data sgrGetStringForKey:@"createtime"];
            detail.thumimg=[data sgrGetArrayForKey:@"thumimg"];
            detail.imagesurl=[data sgrGetArrayForKey:@"imagesurl"];
            detail.videosfilesize=[data sgrGetArrayForKey:@"videosfilesize"];
            detail.imagesfilesize=[data sgrGetArrayForKey:@"imagesfilesize"];
            detail.videosfiletype=[data sgrGetArrayForKey:@"videosfiletype"];
            detail.imagesfiletype=[data sgrGetArrayForKey:@"imagesfiletype"];
            [param sgrSetObject:detail forKey:@"entity"];
            
        }else{
            NSString *str=[responseObj sgrGetStringForKey:@"desc"];
            if(_isStrNULL(str)){
                str=@"获取数据错误，请重试";
            }
            [param sgrSetObject:str forKey:@"message"];
        }

        
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        CNDetail *detail=[param sgrGetType:[CNDetail class] forKey:@"entity"];
        if(detail){
            if(block1)
                block1(YES,nil,detail);
        }else{
            NSString *str=[param sgrGetStringForKey:@"message"];
            if(block1)
                block1(NO,str,nil);
        }
    }];
}

- (void)relogin{
    [self login:[CNUser sharedInstance].userID
     password:[CNUser sharedInstance].password
       complate:^(BOOL success, NSString *message) {
           NSLog(@"reload in %@",success?@"success":@"fail");
       }];
}

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
                    fileIndex:(int)fileIndex{
    if(_isStrNULL(theId)||
       _isStrNULL(title)||
       pics<0||
       videos<0){
        return NO;
    }
    [[IFCoreDataManager sharedInstance] performBlock:^(NSManagedObjectContext *moc) {
        CNList *listitem=[CNList managerObjByCreateOrGetWithPredicate:
                          [NSPredicate predicateWithFormat:
                           @"category==%@ and listId==%@ and userId==%@ and uploading==%@",@"video",theId,[CNUser sharedInstance].userID,@(1)]
                          
                                                                  moc:moc];
        
        listitem.title=title;
        listitem.listId=theId;
        if(_isStrNotNull(listitem.image)){
            [SgrSandbox remove:listitem.image];
            NSString *file=[NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
            NSData *data=UIImageJPEGRepresentation(image, 1.f);
            NSString *path=[[SgrSandbox docPath] stringByAppendingPathComponent:file];
            [data writeToFile:path atomically:YES];
            listitem.image=path;

            
        }
        
        listitem.pics=pics;
        listitem.videos=videos;
        listitem.userId=[CNUser sharedInstance].userID;
        listitem.uploading=1;
        listitem.category=@"video";
        
        listitem.upChunk=upChunk;
        listitem.upDate=upDate;
        listitem.upDesMov=upDesMov;
        listitem.upDesPic=upDesPic;
        listitem.upFiles=upFiles;
  
        listitem.upMovies=upMovies;
        listitem.upPics=upPics;
        
        listitem.summary=summary;
        listitem.fileIndex=fileIndex;
        
        
        CNList *ordItem=[CNList fetchFirstWithPredict:[NSPredicate predicateWithFormat:
                                                       @"category==%@  and userId==%@",@"video",[CNUser sharedInstance].userID] withMOC:moc order:@"sort"];
        int sort=ordItem?ordItem.sort:0;
        listitem.sort=sort-1;
        
        [listitem sugestHeight];
        
        [[IFCoreDataManager sharedInstance] saveContext:moc ToPersistentStore:nil];

    }];
    return YES;
}

- (void)removeUploadingWithId:(NSString *)theId{
    [[IFCoreDataManager sharedInstance] performBlock:^(NSManagedObjectContext *moc){
        NSArray *arr=[CNList fetchAllWithPredict:[NSPredicate predicateWithFormat:
                                               @"category==%@ and listId==%@ and userId==%@ and uploading=%@",@"video",theId,[CNUser sharedInstance].userID,@(1)] withMOC:moc];
        for(CNList *obj in arr){
            [moc deleteObject:obj];
            if(_isStrNotNull(obj.image)){
                [SgrSandbox remove:obj.image];
            }
        }
        [[IFCoreDataManager sharedInstance] saveContext:moc ToPersistentStore:nil];
    }];
}

- (BOOL)uploadWifi{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"uploadWifi"];
}

- (void)setUploadWifi:(BOOL)upload{
    [[NSUserDefaults standardUserDefaults] setBool:upload forKey:@"uploadWifi"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

- (void)changePassword:(NSString *)oldpass newPassword:(NSString *)newPass uiBlock:(void (^)(BOOL success,id responseObj,NSString *message) )block{
    NSString *url=[NSString stringWithFormat:[self urlWithCategory:@"password"],[CNUser sharedInstance].userID];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[CNUser sharedInstance].userID forKey:@"card"];
    long long a=[[NSDate date] timeIntervalSince1970]*1000;
    NSString *sendpw=[self k_md5:[NSString stringWithFormat:@"%@|%@||xkeis9@kslw.di",[CNUser sharedInstance].userID,oldpass]];
    [dic setObject:sendpw forKey:@"oldpasswd"];
    [dic setObject:newPass forKey:@"newpasswd"];
    
    [dic setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"time"];
    NSString *sin=[self k_md5:[NSString stringWithFormat:@"%@|xkeis9@kslw.di||%@|||%lld",[CNUser sharedInstance].userID,sendpw,a]];
    [dic setObject:sin forKey:@"sign"];
    [dic setObject:[CNUser sharedInstance].sessionId forKey:@"sessionid"];
    __block BOOL asuccess=NO;
    [self postWithUrl:url param:dic dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        if(success && [responseObj isKindOfClass:[NSDictionary class]] &&
           [@"1" isEqualToString:[responseObj sgrFGetStringForKey:@"result"]]){
            [CNUser sharedInstance].sessionId=[responseObj sgrGetStringForKey:@"sessionid"];
            [CNUser sharedInstance].password=newPass;
            [[CNUser sharedInstance] save];
            asuccess=YES;
        }
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        if(block){
            block(asuccess,responseObj,(message)?@"发送请求错误，请检查网络":nil);
        }
    }];
    
//    [self postWithUrl:url param:dic dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
//        NSLog(@"%@",responseObj);
//    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
//        
//    }];
}




@end
