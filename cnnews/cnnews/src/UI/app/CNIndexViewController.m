//
//  CNIndexViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/23.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNIndexViewController.h"
#import "IFCoreDataManager.h"
#import "CNDataModel.h"
#import "CNIndexCell.h"
#import "SgrGCD.h"
#import "CNVideoViewController.h"
#import "CLPushAnimatedRight.h"
#import "CNLiveCell.h"
#import "CNLive1ViewController.h"
#import "update1ViewController.h"
#import "CNFile.h"
#define SEARCHBARHEIGHT IFScreenFit2s(50)

@interface CNIndexViewController ()

@property (nonatomic,assign) BOOL inRequest;
@property (nonatomic,assign) BOOL ascending;


@end

@implementation CNIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.height=self.view.height;
    
//    UIImageView *imageview=[[UIImageView alloc] init];
//    imageview.image=[UIImage imageNamed:@"央视新闻icon.png"];
//    imageview.frame=CGRectMake(0, 0, 567/2.f, 510/2.f);
//    UIView *tablebg=[[UIView alloc] init];
//    imageview.center=CGPointMake(GlobleWidth/2.f, self.tableView.height/2.f-50.f);
//    [tablebg addSubview:imageview];
//    self.tableView.backgroundView=tablebg;
    
    UIView *headv=[UIView new];
    headv.frame=CGRectMake(0, 0, GlobleWidth, SEARCHBARHEIGHT);
    UIButton *b1=[UIButton buttonWithType:UIButtonTypeCustom];
    b1.frame=CGRectMake(0, 0, GlobleWidth/2.f, SEARCHBARHEIGHT);
    b1.titleLabel.font=CNBold(IFScreenFit2s(13));
    [b1 setTitleColor:RGB(0x33, 0x33, 0x33) forState:UIControlStateSelected];
    [b1 setTitleColor:RGB(0xaa, 0xaa, 0xaa) forState:UIControlStateNormal];
    [b1 setBackgroundColor:RGB(245, 246, 247)];
    [b1 setTitle:@"按最新上传显示" forState:UIControlStateNormal];
    [headv addSubview:b1];
    [b1 setSelected:YES];
    self.ascending=NO;
   
    
    
    UIButton *b2=[UIButton buttonWithType:UIButtonTypeCustom];
    b2.frame=CGRectMake(GlobleWidth/2.f, 0, GlobleWidth/2.f, SEARCHBARHEIGHT);
    b2.titleLabel.font=CNBold(IFScreenFit2s(13));
    [b2 setTitleColor:RGB(0x33, 0x33, 0x33) forState:UIControlStateSelected];
    [b2 setTitleColor:RGB(0xaa, 0xaa, 0xaa) forState:UIControlStateNormal];
    [b2 setBackgroundColor:b1.backgroundColor];
    [b2 setTitle:@"按最早上传显示" forState:UIControlStateNormal];
    [headv addSubview:b2];
    
    __weak typeof(self) me=self;
    [b1 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIButton *b=(UIButton *)sender;
        [b setSelected:YES];
        [b2 setSelected:NO];
         me.ascending=NO;
        [me reloadData];
        
    }];
    
    [b2 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIButton *b=(UIButton *)sender;
        [b setSelected:YES];
        [b1 setSelected:NO];
        me.ascending=YES;
        [me reloadData];
    }];
    
    UILabel *bitian=[UILabel new];
   // bitian.font=[UIFont systemFontOfSize:(IFScreenFit2(28,28))];
    bitian.numberOfLines=0;
    bitian.textAlignment=NSTextAlignmentCenter;
    bitian.textColor=RGB(0x33, 0x33, 0x33);
   // bitian.textColor=[UIColor redColor];
    bitian.backgroundColor=RGB(0x33, 0x33, 0x33);
    bitian.text=@"|";
    bitian.frame=CGRectMake(b1.right-0.25, IFScreenFit2s(11.f), 0.5, SEARCHBARHEIGHT-IFScreenFit2s(22.f));
    [headv addSubview:bitian];

   // self.tableView.tableHeaderView=headv;
    
    
    if(_isStrNotNull([CNUser sharedInstance].userID)){
        [self setFetchUser];
        
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:[@"video" isEqualToString:self.category]?0.1:1];
       // [self reloadData:nil];
    }
    if([@"video" isEqualToString:self.category]){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //CN_Change_reflash_index1
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetType:) name:CN_Change_reflash_index1 object:nil];
    }else{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            //CN_Change_reflash_index1
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNewsCategory) name:CN_Change_reflash_index2 object:nil];
        }
}

- (void)resetType:(NSNotification *)noti{
    int type= [noti.object intValue];
    self.index1Type=type;
    [self setFetchUser];
    [self reloadData];
}


- (void)setFetchUser{
    
   // NSLog(@"%d",[NSThread currentThread].isMainThread);
    self.pageNum=0;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"CNList"];
    if([@"video" isEqualToString:self.category]){
        if(self.index1Type==0){
            req.predicate = [NSPredicate predicateWithFormat:@"category==%@  and userId==%@", self.category,[CNUser sharedInstance].userID];
        }else if(self.index1Type==1){
            req.predicate = [NSPredicate predicateWithFormat:@"category==%@  and userId==%@ and uploading==%@", self.category,[CNUser sharedInstance].userID,@(0)];
        }else if(self.index1Type==2){
            req.predicate = [NSPredicate predicateWithFormat:@"category==%@  and userId==%@ and uploading==%@", self.category,[CNUser sharedInstance].userID,@(1)];
        }
    }else{
        req.predicate = [NSPredicate predicateWithFormat:@"category==%@  and userId==%@", self.category,[CNUser sharedInstance].userID];
    }
    
    
    req.sortDescriptors = @[sort];
    self.fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                     managedObjectContext:[IFCoreDataManager sharedInstance].mainMoc
                                                       sectionNameKeyPath:nil
                                                                cacheName:nil];
    self.fetch.delegate=self;
    [self.fetch performFetch:nil];
    if([self isViewLoaded])
        [self reloadTable];
    
    


}


- (void)reloadData{
    self.inRequest=NO;
    [self.tableView stopBottomMoreWithScuessLoading];
    [self setNewsCategory];
}


- (void)setNewsCategory{
  
    
    
    
   
    self.isShouldReloadTableView=YES;
    [self.tableView becameHeadReflashLoading];
    
    //__weak typeof(self) me=self;
    //[[SgrGCD sharedInstance] enMain:^{
       // [me requestData:block];
  //  }];
    
    
    
//    if([self isViewLoaded])
//        [self reloadTable];
    
    
    
}



- (void)requestData:(void (^)() )block{

}

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    [scrollView setContentOffset:CGPointMake(0, SEARCHBARHEIGHT) animated:NO];
//}

-(void)jTableViewStartHeadLoading:(JTableView *)tableView{
//    if(self.inRequest){
//        return;
//    }
    if(self.index1Type==2){
        [self.tableView stopHeadLoading];
        return;
    }
    
    
    self.isShouldReloadTableView=YES;
    self.pageNum=0;
    __weak typeof(self) me=self;
    self.inRequest=YES;
    //[self showLoadingModel:@"正在加载页面" view:self.view];
    int orderby=self.ascending?0:1;
    [[CNDataModel sharedInstance] getCommListWithCategroy:self.category withPage:self.pageNum lastList:nil orderBy:orderby
                                                  uiBlock:^(BOOL success, id responseObj, NSString *message) {
                                                      [me.tableView stopHeadLoading];
                                                     // [me disShowLoadingModel];
                                                    // [me.tableView setContentOffset:CGPointMake(0, SEARCHBARHEIGHT) animated:NO];
                                                      me.inRequest=NO;
                                                      if(success){
                                                          
                                                      }else{
                                                          [me showModelView:message];
                                                      }
                                                  }];
}

- (void)jTableViewStartBottomMoreLoading:(JTableView *)tableView{
    
    if(self.index1Type==2){
        [self.tableView stopBottomWithSuccessLoadingNoAuto];
        return;
    }
    
    if(self.inRequest){
        return;
    }
    __weak typeof(self) me=self;
    self.inRequest=YES;
    int orderby=self.ascending?0:1;
    [[CNDataModel sharedInstance] getCommListWithCategroy:self.category withPage:self.pageNum+1 lastList:self.fetch.fetchedObjects.lastObject
     orderBy:orderby
                                                  uiBlock:^(BOOL success, id responseObj, NSString *message) {
                                                      me.inRequest=NO;
                                                      if(success){
                                                          if(responseObj){
                                                              
                                                              me.pageNum++;
                                                              [me.tableView stopBottomMoreWithScuessLoading];
                                                          }else{
                                                              [me.tableView stopBottomWithSuccessLoadingNoAuto];
                                                          }
                                                        
                                                      }else{
                                                          [me showModelView:message];
                                                          [me.tableView stopBottomMoreWithFailedLoading];
                                                      }
                                                  }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   CNList *list=[self.fetch objectAtIndexPath:indexPath];
  
    return (CGFloat)list.titleHeight;
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    //[cell1 setHighlighted:NO animated:NO];
    CNList *list=[self.fetch objectAtIndexPath:indexPath];
    UITableViewCell *cell=nil;
    if([@"video" isEqualToString:list.category]){
  
        CNIndexCell *cell1=nil;
        static NSString *cellid=@"CNIndexCell";
        cell1=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell1){
            cell1=[[CNIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell1 loadData:list];
        cell=cell1;
    }else{
        CNLiveCell *cell1=nil;
        static NSString *cellid=@"CNLiveCell";
        cell1=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell1){
            cell1=[[CNLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell1 loadData:list];
        cell=cell1;

    }
 
    
    
       
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CNList *list=[self.fetch objectAtIndexPath:indexPath];
    if([@"video" isEqualToString:self.category]){
    
    if(list.uploading==1){
        
//        long long current=(long long)([[NSDate date] timeIntervalSince1970]);
//        if(fabs(current - list.upDate)>1){
//            //[self showModelView:@"待上传内容已过期"];
//            NSLog(@"%d",fabs(current - list.upDate));
//            return;
//        }

        
        NSString* upFiles = list.upFiles;
        NSMutableArray* files1 = [NSMutableArray arrayWithArray:[upFiles componentsSeparatedByString:@","]];
        NSMutableArray* files = [NSMutableArray array];
        for (CNFile* file in files1) {
            [files addObject:file];
        }
        
        NSString* upMovies = list.upMovies;
        NSMutableArray* movieFiles1 = [NSMutableArray arrayWithArray:[upMovies componentsSeparatedByString:@","]];
        NSMutableArray* movieFiles = [NSMutableArray array];
        for (CNFile* file in movieFiles1) {
            [movieFiles addObject:file];
        }
        
        NSString* upPics = list.upPics;
        NSMutableArray* picFiles1 = [NSMutableArray arrayWithArray:[upPics componentsSeparatedByString:@","]];
        NSMutableArray* picFiles = [NSMutableArray array];
        for (CNFile* file in picFiles1) {
            [picFiles addObject:file];
        }
        
        NSString* upDesMov = list.upDesMov;
        NSMutableArray* desMovies1 = [NSMutableArray arrayWithArray:[upDesMov componentsSeparatedByString:@","]];
        NSMutableArray* desMovies = [NSMutableArray array];
        for (CNFile* file in desMovies1) {
            [desMovies addObject:file];
        }
        
        NSString* upDesPic = list.upDesPic;
        NSMutableArray* desPics1 = [NSMutableArray arrayWithArray:[upDesPic componentsSeparatedByString:@","]];
        NSMutableArray* desPics = [NSMutableArray array];
        for (CNFile* file in desPics1) {
            [desPics addObject:file];
        }
        
//        NSInteger breakoffChunk = list.upChunk;
//        
//        NSTimeInterval time = list.upDate;
//        
//        int fileIndex = list.fileIndex;
        
        
        update1ViewController* up1 = [[update1ViewController alloc] init];
        up1.summaryStr = list.summary;
        up1.titleStr = list.title;
//        up1.files1 = files;
//        up1.movieFiles1 = movieFiles;
//        up1.picFiles1 = picFiles;
//        up1.desMovies1 = desMovies;
//        up1.desPics1 = desPics;
//        up1.breakoffChunk = breakoffChunk;
//        up1.time = time;
//        up1.fileIndex = fileIndex;
        [[CLPushAnimatedRight sharedInstance] pushController:up1];
        
        
    }else{
        CNVideoViewController *video=[[CNVideoViewController alloc] init];
        video.videoId=list.listId;
        
        [[CLPushAnimatedRight sharedInstance] pushController:video];
    }
    
    }else if([@"live" isEqualToString:self.category]){
        long long current=(long long)([[NSDate date] timeIntervalSince1970]);
        if(_isStrNULL(list.livePushUrl) || current>=list.liveExpireTime){
            [self showModelView:@"直播已经过期,请重新创建直播"];
            return;
        }
        CNLive1ViewController *cn=[[CNLive1ViewController alloc] init];
        [cn setPushUrl:list.livePushUrl andLiveCode:list.listId];
        [[CLPushAnimatedRight sharedInstance] pushController:cn];
        
    }
   
    
}




@end
