//
//  update1ViewController.m
//  cnnews
//
//  Created by wanglb on 16/4/25.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "update1ViewController.h"
#import "summaryViewController.h"
#import "CNBreakoffViewController.h"
#import "CNFinishUploadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "CNDataModel.h"
#import "CNUploadCell.h"

@interface update1ViewController ()<UITextFieldDelegate,CNUploadCellDelegate,UIActionSheetDelegate>
//是否暂停
@property (nonatomic,assign) BOOL isPause;//0:没有暂停  1：暂停
@property (nonatomic,assign) BOOL uploadState; //0:没有上传   1：正在上传


@property (nonatomic,strong) NSMutableArray* files;
@property (nonatomic,strong) NSMutableArray* movieFiles;
@property (nonatomic,strong) NSMutableArray* picFiles;
@property (nonatomic,strong) NSMutableArray* desMovies;
@property (nonatomic,strong) NSMutableArray* desPics;


@property (nonatomic,strong) UIView* headerView;
@property (nonatomic,strong) UITextField* titleTextField;
@property (nonatomic,strong) UILabel* leee;//title有几个字
@property (nonatomic,strong) UILabel* laaa;//摘要
@property (nonatomic,strong) UIImageView *line;
@property (nonatomic,strong) UIButton* comfirm;


@property (nonatomic,strong) NSDate* date;

@end

@implementation update1ViewController

- (void)netChanged
{
    if([CNGlobal sharedInstance].reachability.currentReachabilityStatus == JiHNotReachable){
        [self showModelView:@"未检测到网络连接,请检查你的网络设置"];
    }else if([CNGlobal sharedInstance].reachability.currentReachabilityStatus == JiHReachableViaWiFi)
    {
        [self showModelView:@"您现在已连接wifi"];
    }else
    {
        [self showModelView:@"您现在在使用2G/3G/4G网络"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netChanged)
                                                 name:kJiHReachabilityChangedNotification
                                               object:nil];
    if([CNGlobal sharedInstance].reachability.currentReachabilityStatus == JiHNotReachable){
        [self showModelView:@"未检测到网络连接,请检查你的网络设置"];
    }else if([CNGlobal sharedInstance].reachability.currentReachabilityStatus == JiHReachableViaWiFi)
    {
        //[self showModelView:@"您已连接wifi"];
    }else
    {
        [self showModelView:@"您现在在使用2G/3G/4G网络"];
    }
    
    
    NSLog(@"self.summaryStr = %@   self.titleStr = %@",self.summaryStr,self.titleStr);
    NSLog(@"self.movieFiles.count = %d",self.movieFiles.count);
    
    
    //    UIApplication* app = [ UIApplication  sharedApplication ];
    //    app.networkActivityIndicatorVisible = YES;
    
    self.files = [NSMutableArray arrayWithArray:self.files1];
    self.movieFiles = [NSMutableArray arrayWithArray:self.movieFiles1];
    self.picFiles = [NSMutableArray arrayWithArray:self.picFiles1];
    self.desMovies = [NSMutableArray arrayWithArray:self.desPics1];
    self.desPics = [NSMutableArray arrayWithArray:self.desPics1];
    self.breakoffChunk = -1;
    
    [self createNavigator:nil];
    [self addBackButton];
    [self setNavigatorTitle:@"上传素材"];
    [self setUploadUI];
    
    if (self.comeFromCamera) {
        [self performSelector:@selector(addVidioFromCamera) withObject:nil afterDelay:0.5];
    }
    
}
- (void)setUploadUI{
    
    CNButton *comfirm=[CNButton buttonWithType: UIButtonTypeCustom];
    [comfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirm.titleLabel.font=CNBold(15.f);
    [comfirm setTitle:@"全部提交" forState:UIControlStateNormal];
    [comfirm setTitleColor:RGB(170, 170, 170) forState:UIControlStateDisabled];
    [comfirm setTitleColor:RGB(253, 170, 28) forState:UIControlStateNormal];
    comfirm.enabled=NO;
    
    comfirm.frame=CGRectMake(self.navagator.width-IFScreenFit2s(60) - IFScreenFit2s(16), self.navagator.height-IFScreenFit2(28,28), IFScreenFit2s(60), IFScreenFit2(15,15));
    self.comfirm = comfirm;
    [self.navagator addSubview:comfirm];
    
    [comfirm addTarget:self action:@selector(infoSave) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CCTopHeight, GlobleWidth, GlobleHeight - CCTopHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB(246, 246, 246);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    //headerView
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, IFScreenFit2s(200));
    _headerView.backgroundColor = RGB(246, 246, 246);
    self.tableView.tableHeaderView = _headerView;
    
    
    UIImageView *icon1=[[UIImageView alloc] init];
    icon1.image=[UIImage imageNamed:@"标题.png"];
    icon1.frame=CGRectMake(IFScreenFit2s(23), IFScreenFit2s(25), IFScreenFit2s(11), IFScreenFit2s(12.5f));
    [self.headerView addSubview:icon1];
    
    
    UITextField *filed1=[[UITextField alloc] init];
    filed1.textColor=[UIColor blackColor];
    filed1.font=CNBold(IFScreenFit2s(15));
    filed1.frame=
    CGRectMake(icon1.right+IFScreenFit2s(15), icon1.top,
               GlobleWidth- IFScreenFit2s(15) - icon1.right - IFScreenFit2s(35), IFScreenFit2s(19));
    filed1.placeholder=@"标题，30字以内";
    filed1.text = self.titleStr;
    filed1.delegate=self;
    filed1.returnKeyType = UIReturnKeyDone;
    [self.headerView addSubview:filed1];
    self.titleTextField=filed1;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.leee = [[UILabel alloc] init];
    self.leee.frame = CGRectMake(filed1.right + IFScreenFit2s(5), filed1.top + IFScreenFit2s(3), IFScreenFit2s(30), IFScreenFit2s(12));
    self.leee.text = [NSString stringWithFormat:@"%lu/30",self.titleTextField.text.length];
    self.leee.textColor = [UIColor colorFromString_Ext:@"#aaaaaa"];
    self.leee.backgroundColor = [UIColor clearColor];
    self.leee.font = CNBold(IFScreenFit2s(12));
    [self.headerView addSubview:self.leee];
    
    
    
    UIImageView *line=[UIImageView new];
    line.frame=CGRectMake(filed1.left, filed1.bottom+IFScreenFit2s(7), GlobleWidth-filed1.left, 0.5f);
    line.backgroundColor=RGB(170, 170, 170);
    [self.headerView addSubview:line];
    
    
    UIImageView *icon2=[[UIImageView alloc] init];
    icon2.image=[UIImage imageNamed:@"摘要.png"];
    icon2.frame=CGRectMake(IFScreenFit2s(23), icon1.bottom + IFScreenFit2s(25), IFScreenFit2s(11), IFScreenFit2s(12.5));
    [self.headerView addSubview:icon2];
    
    UILabel *l2=[UILabel new];//字体大小15号  行间距10px
    l2.frame=CGRectMake(icon2.right+IFScreenFit2s(15), icon2.top, GlobleWidth - (icon2.right+IFScreenFit2s(15)) - IFScreenFit2s(10), IFScreenFit2s(125));
    l2.font=CNFont(IFScreenFit2s(15));
    l2.textColor=RGB(144, 144, 144);
    l2.numberOfLines = 6;
    self.summaryLabel = l2;
    l2.text = self.summaryStr;
    l2.userInteractionEnabled = YES;
    [self.headerView addSubview:l2];
    
    UITapGestureRecognizer* tap4Summary = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4SummaryAction)];
    [l2 addGestureRecognizer:tap4Summary];
    
    
    //显示摘要两个字的label
    UILabel *laaa=[UILabel new];
    laaa.frame=CGRectMake(icon2.right+IFScreenFit2s(15), icon2.top, IFScreenFit2s(60), IFScreenFit2s(15));
    laaa.font=CNBold(IFScreenFit2s(15));
    laaa.textColor=RGB(144, 144, 144);
    laaa.text=@"摘要";
    laaa.hidden = self.summaryStr.length == 0?NO:YES;
    self.laaa = laaa;
    [self.headerView addSubview:laaa];
    
    
    UIImageView *line2=[UIImageView new];
    line2.frame=CGRectMake(l2.left, l2.bottom + IFScreenFit2s(10), GlobleWidth-l2.left, 0.5f);
    line2.backgroundColor=RGB(170, 170, 170);
    [self.headerView addSubview:line2];
    self.line = line2;
    
    CGRect frame = self.headerView.frame;
    frame.size.height = line2.bottom;
    self.headerView.frame = frame;
    
}

- (void)tap4SummaryAction
{
    self.laaa.hidden = YES;
    summaryViewController* sss = [[summaryViewController alloc] init];
    sss.up1 = self;
    sss.summary = self.summaryLabel.text;
    [self presentViewController:sss animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.movieFiles.count;
    }
    else
    {
        return self.picFiles.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CNUploadCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.section*10+(int)indexPath.row]];
    if (cell == nil) {
        cell = [[CNUploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.section*10+(int)indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.indexP = indexPath;
    if (indexPath.section == 0) {
        
        CNFile* file = self.movieFiles[indexPath.row];
        cell.imageIV.image = file.fileImage;
        cell.imageIV.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.text = file.fileName;
        cell.indexLabel.text = [NSString stringWithFormat:@"视频%ld/3",(long)indexPath.row+1];//@"视频1/3";
    }
    else
    {
        CNFile* file = self.picFiles[indexPath.row];
        cell.imageIV.image = file.fileImage;
        cell.imageIV.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.text = file.fileName;
        cell.indexLabel.text = [NSString stringWithFormat:@"图片%ld/3",(long)indexPath.row+1];
    }
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction* deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSUInteger row = [indexPath row]; //获取当前行
        if (indexPath.section == 0) {
            [self.movieFiles removeObjectAtIndex:row];
            if (self.desMovies.count>=row+1) {
                [self.desMovies removeObjectAtIndex:row];
            }
        }else
        {
            [self.picFiles removeObjectAtIndex:row];
            if (self.desPics.count>=row+1) {
                [self.desPics removeObjectAtIndex:row];
            }
        }
        
        //[self.files removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//数组执行删除操作
        
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"垃圾箱.png"]];
    return @[deleteRowAction];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return PX_TO_PT(300);
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GlobleWidth, IFScreenFit2s(50))];
    
    UIImageView* icon = [[UIImageView alloc] init];
    icon.frame = CGRectMake(IFScreenFit2s(23), IFScreenFit2s(23), IFScreenFit2s(11), IFScreenFit2s(12.5f));
    [view addSubview:icon];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = CNBold(IFScreenFit2s(15));
    titleLabel.textColor = RGB(144, 144, 144);
    titleLabel.userInteractionEnabled = YES;
    [view addSubview:titleLabel];
    
    titleLabel.frame = CGRectMake(icon.right + IFScreenFit2s(15), icon.top, GlobleWidth - icon.right - IFScreenFit2s(15) - IFScreenFit2s(10), IFScreenFit2s(15));
    
    UITapGestureRecognizer* tap4Movie = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addVideoTap)];
    UITapGestureRecognizer* tap4Pic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageTap)];
    
    
    if (section == 0) {
        icon.image = [UIImage imageNamed:@"添加视频.png"];
        if (self.movieFiles.count == 3) {
            titleLabel.text = @"已上传最多3个视频，可左滑删除";
        }else
        {
            titleLabel.text = @"添加视频";
        }
        [titleLabel addGestureRecognizer:tap4Movie];
    }else
    {
        icon.image = [UIImage imageNamed:@"添加图片.png"];
        if (self.picFiles.count == 9) {
            titleLabel.text = @"已上传最多9张图片，可左滑删除";
        }else
        {
            titleLabel.text = @"添加图片";
        }
        [titleLabel addGestureRecognizer:tap4Pic];
    }
    
    UIImageView *line=[UIImageView new];
    line.frame=CGRectMake(titleLabel.left, view.bottom-0.5f, GlobleWidth- titleLabel.left, 0.5f);
    line.backgroundColor=RGB(170, 170, 170);
    [view addSubview:line];
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return IFScreenFit2s(50);
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

-(void)updatee
{
    [self.tableView beginUpdates];
    CGRect frame = self.summaryLabel.frame;
    frame.size.height = IFScreenFit2(65, 65);
    self.summaryLabel.frame = frame;
    self.summaryLabel.numberOfLines = 3;
    
    self.line.frame=CGRectMake(self.summaryLabel.left, self.summaryLabel.bottom + PX_TO_PT(20), GlobleWidth-self.summaryLabel.left, 0.5f);
    
    
    CGRect frame1 = self.headerView.frame;
    frame1.size.height = self.line.bottom;
    self.headerView.frame = frame1;
    
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView endUpdates];
    
}

- (void)addVideoTap
{
    if (self.movieFiles.count >= 3) {
        return;
    }
    UIActionSheet *imgPickSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从本地选取",@"启用相机", nil];
    imgPickSheet.tag = 10;
    imgPickSheet.delegate = self;
    [imgPickSheet showInView:self.view];
}
- (void)addImageTap
{
    if (self.picFiles.count>=9) {
        return;
    }
    UIActionSheet *imgPickSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从本地选取",@"启用相机", nil];
    imgPickSheet.tag = 20;
    imgPickSheet.delegate = self;
    [imgPickSheet showInView:self.view];
}

-(void)selectPicFromLib
{
    __weak typeof(self) me=self;
    [self userSelectMovieWithType:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil] result:^(NSString *fileInfo, NSString *filePath, NSString *fileName, NSInteger fileSize, UIImage *fileImage) {
        
        NSDictionary* fileDic = @{@"fileType":@"image",@"filePath":filePath,@"fileName":fileName,@"fileSize":[NSNumber numberWithInteger:fileSize],@"fileInfo":fileInfo,@"fileImage":fileImage};
        CNFile* file = [[CNFile alloc] initWithDictionary:fileDic];
        [me.picFiles addObject:file];
        [me.files addObject:file];
        
        //做一个判断，如果是不是上传状态，那么就开始上传；如果已经是上传状态，说明上传过程正在进行
        if (self.uploadState == NO && self.isPause == NO) {
            [self readWithFile:file];
        }
        
        [me.tableView reloadData];
        [me updatee];
        
        if (self.tableView.contentSize.height -self.tableView.bounds.size.height >0) {
            [me.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        }
    }];
}

-(void)selectPicFromCamera
{
    __weak typeof(self) me=self;
    [self userSelectMovieWithType:UIImagePickerControllerSourceTypeCamera mediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil] result:^(NSString *fileInfo, NSString *filePath, NSString *fileName, NSInteger fileSize, UIImage *fileImage) {
        
        NSDictionary* fileDic = @{@"fileType":@"image",@"filePath":filePath,@"fileName":fileName,@"fileSize":[NSNumber numberWithInteger:fileSize],@"fileInfo":fileInfo,@"fileImage":fileImage};
        CNFile* file = [[CNFile alloc] initWithDictionary:fileDic];
        [me.picFiles addObject:file];
        [me.files addObject:file];
        
        //做一个判断，如果是不是上传状态，那么就开始上传；如果已经是上传状态，说明上传过程正在进行
        if (self.uploadState == NO && self.isPause == NO) {
            [self readWithFile:file];
        }
        
        [me.tableView reloadData];
        [me updatee];
        
        if (self.tableView.contentSize.height -self.tableView.bounds.size.height >0) {
            [me.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        }
    }];
}

-(void)addVidioFromLib
{
    __weak typeof(self) me=self;
    [self userSelectMovieWithType:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil] result:^(NSString *fileInfo, NSString *filePath, NSString *fileName, NSInteger fileSize, UIImage *fileImage) {
        
        NSDictionary* fileDic = @{@"fileType":@"movie",@"filePath":filePath,@"fileName":fileName,@"fileSize":[NSNumber numberWithInteger:fileSize],@"fileInfo":fileInfo,@"fileImage":fileImage};
        
        CNFile* file = [[CNFile alloc] initWithDictionary:fileDic];
        [me.movieFiles addObject:file];
        [me.files addObject:file];
        
        
        //做一个判断，如果是不是上传状态，那么就开始上传；如果已经是上传状态，说明上传过程正在进行
        if (self.uploadState == NO) {
            [self readWithFile:file];
        }
        
        //更新UI
        [me.tableView reloadData];
        [me updatee];
    }];
}
-(void)addVidioFromCamera
{
    __weak typeof(self) me=self;
    [self userSelectMovieWithType:UIImagePickerControllerSourceTypeCamera mediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil] result:^(NSString *fileInfo, NSString *filePath, NSString *fileName, NSInteger fileSize, UIImage *fileImage) {
        
        NSDictionary* fileDic = @{@"fileType":@"movie",@"filePath":filePath,@"fileName":fileName,@"fileSize":[NSNumber numberWithInteger:fileSize],@"fileInfo":fileInfo,@"fileImage":fileImage};
        
        CNFile* file = [[CNFile alloc] initWithDictionary:fileDic];
        [me.movieFiles addObject:file];
        [me.files addObject:file];
        
        
        //做一个判断，如果是不是上传状态，那么就开始上传；如果已经是上传状态，说明上传过程正在进行
        if (self.uploadState == NO) {
            [self readWithFile:file];
        }
        
        //更新UI
        [me.tableView reloadData];
        [me updatee];
    }];
}

#pragma mark cellDelegate
-(void)pauseOrContinue:(NSIndexPath *)indexP//用户点击了暂停或者继续
{
    self.isPause = !self.isPause;
    if (!self.isPause) {
        NSLog(@"继续上传");
        NSString* fileName = self.breakoffFile.fileName;
        [self readDataWithChunk:self.breakoffChunk fileName:fileName file:self.breakoffFile];
        [self readDataWithChunk:self.breakoffChunk + 1 fileName:fileName file:self.breakoffFile];
        //清除上次的断点
        self.breakoffChunk = -1;
    }else
    {
        NSLog(@"暂停上传");
    }
}

-(void)pauseAction//断网
{
    self.isPause = YES;
}

-(void)readWithFile:(CNFile*)file//下一个方法的衔接
{
    self.isPause = NO;
    self.uploadState = YES;//开始上传
    
    [self readDataWithChunk:0 fileName:file.fileName file:file];
    [self readDataWithChunk:1 fileName:file.fileName file:file];
}

-(void)readDataWithChunk:(NSInteger)chunk fileName:(NSString*)fileName file:(CNFile*)file
{
    NSLog(@"chunk = %ld",(long)chunk);
    
    //判断是否存在该片
    int offset = 1024*1024;
    NSInteger chunks = (file.fileSize%1024==0)?((int)(file.fileSize/1024*1024)):((int)(file.fileSize/(1024*1024) + 1));
    NSLog(@"chunks = %ld",(long)chunks);
    
    if (chunk >= chunks) {
        return;
    }
    
    NSData* data;
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:file.filePath];
    [readHandle seekToFileOffset:offset * chunk];
    data = [readHandle readDataOfLength:offset];
    
    //询问该片是否已经上传
    [self ifHaveData:data WithChunk:chunk chunks:chunks fileName:fileName file:file];
}

-(void)ifHaveData:(NSData*)data WithChunk:(NSInteger)chunk chunks:(NSInteger)chunks fileName:(NSString*)fileName file:(CNFile*)file
{
    //将chunk置loading
    [file.fileArr replaceObjectAtIndex:chunk withObject:@"loading"];
    //先询问服务器该片是否已经上传
    
    //判断是否是最后一片
    NSInteger resumableChunkSize = 1024*1024;
    if(chunk == chunks - 1)
    {
        resumableChunkSize = file.fileSize%resumableChunkSize;
    }
    
    NSDictionary* para = @{@"card":[CNUser sharedInstance].userID,@"resumableChunkNumber":[NSNumber numberWithInteger:chunk],@"resumableChunkSize":[NSNumber numberWithInteger:resumableChunkSize],@"resumableFilename":fileName};
    [[CNDataModel sharedInstance] getWithUrl:[NSString stringWithFormat:@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/fileupload_3.php?card=%@",[CNUser sharedInstance].userID] param:para dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        
        NSLog(@"success = %d    responseObj = %@",success,responseObj);
        
        if (success) {
            NSDictionary* dic = responseObj;
            NSString* result = [dic[@"result"] description];
            if ([result intValue] == 0) {//如果没有
                [self uploadData:data WithChunk:chunk chunks:chunks fileName:(NSString*)fileName file:file];
            }else
            {//如果已经有了
                //将chunk置finish
                [file.fileArr replaceObjectAtIndex:chunk withObject:@"finish"];
                [self readDataWithChunk:chunk+1 fileName:fileName file:file];
            }
        }
        else//fail 本地保存进度
        {
            //将chunk置wait
            [file.fileArr replaceObjectAtIndex:chunk withObject:@"wait"];
            [self saveProgressWithChunk:chunk file:file];
        }
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        
        //这里写下面的代码是因为 要传的片可能已经在服务器中了
        
        NSDictionary* dic = responseObj;
        NSString* result = [dic[@"result"] description];
        
        if ([result intValue] == 1) {
            
            //拿到当前的cell
            CNUploadCell* cell = nil;
            
            NSString* fileType = file.fileType;
            
            if ([fileType isEqualToString:@"movie"]) {
                NSInteger row = [self.movieFiles indexOfObject:file];
                cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            else
            {
                NSInteger row = [self.picFiles indexOfObject:file];
                cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
            }
            
            float f = cell.progressView.progress;
            if ((chunk+1)*1.0/chunks > f) {
                cell.progressView.progress = (chunk+1)*1.0/chunks;
            }
            
            if (cell.progressView.progress == 1 ) {
                cell.stateLabel.text = @"上传完成";
                cell.rateLabel.text = @"0Kb/s";
                cell.rateLabel.hidden = YES;
                cell.stateLabel.hidden = YES;
                cell.progressView.hidden = YES;
                cell.finishLabel.hidden = NO;
            }
        }
        
    }];
}

-(void)uploadData:(NSData*) data WithChunk:(NSInteger) chunk chunks:(NSInteger)chunks fileName:(NSString*)fileName file:(CNFile*)file
{
    self.date = [NSDate date];
    
    __weak typeof(self) me=self;
    NSDictionary* params = @{@"chunk":[NSNumber numberWithInteger:chunk],@"chunks":[NSNumber numberWithInteger:chunks]};
    
    [[CNDataModel sharedInstance] postWithUrl:[NSString stringWithFormat:@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/fileupload_3.php?card=%@",[CNUser sharedInstance].userID] param:params file:data fileName:fileName dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        NSLog(@"success = %d  responseObj = %@",success,responseObj);
        NSDictionary* resDic = responseObj;
        if (success) {
            
            NSLog(@"我是%ld完成了上传",(long)chunk);
            //1.先将已经成功上传的本片的flag置finish
            [file.fileArr replaceObjectAtIndex:chunk withObject:@"finish"];
            NSLog(@"********");
            
            //2.查看是否所有片的flag都已经置finish
            for (NSInteger j = 0; j<chunks; j++)
            {
                NSString* flag = [file.fileArr objectAtIndex:j];
                if (![flag isEqualToString:@"finish"]) {//片没有都finish
                    NSLog(@"但%ld 是 %@",(long)j,flag);
                    break;
                }
                //该movie的所有片 都已经finish    那么删除该文件，并且开始传下一个文件
                if (j == chunks || ((j == chunks - 1)&&([file.fileArr[j] isEqualToString:@"finish"])) )
                {//这个判断没问题，就是有点绕
                    [me deleteFile:file.filePath];
                    
                    //保存返回的desFileName
                    NSString* descfilename = resDic[@"descfilename"];
                    [self saveFileName:descfilename file:file];
                    
                    //先判断有没有下一个文件
                    NSInteger index = [me.files indexOfObject:file];
                    if (me.files.count - 1  == index) {//说明没有下一个文件了
                        NSLog(@"已传完全部文件");
                        self.uploadState = NO;//该变上传状态为 no
                        //让comfirm可点击
                        me.comfirm.enabled = YES;
                        return ;
                    }else
                    {
                        NSLog(@"开始传下一个文件");
                        CNFile* nextFile = [me.files objectAtIndex:index + 1];
                        
                        [me readDataWithChunk:0 fileName:nextFile.fileName file:nextFile];
                        [me readDataWithChunk:1 fileName:nextFile.fileName file:nextFile];
                    }
                }
            }
            
            //2.5 是否暂停  如果暂停直接return
            if(me.isPause == YES)
            {
                //将目前读到了第几个文件的第几片保存到本地
                [self saveProgressWithChunk:chunk file:file];
                return ;
            }
            //3.先看本地的下一chunk对应的flag是否是waiting
            NSLog(@"查看第%ld片的状态",chunk+1);
            for(NSInteger i = chunk+1;i < chunks;i++)
            {
                NSString* flag = [file.fileArr objectAtIndex:i];
                if ([flag isEqualToString:@"wait"]) {
                    [me readDataWithChunk:i fileName:fileName file:file];
                    break;
                }
            }
        }
        
        
        
        else//如果上传失败，重传
        {
            //将chunk置wait
            [file.fileArr replaceObjectAtIndex:chunk withObject:@"wait"];
            [self saveProgressWithChunk:chunk file:file];
        }
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        
        //拿到当前的cell
        CNUploadCell* cell = nil;
        
        NSString* fileType = file.fileType;
        
        if ([fileType isEqualToString:@"movie"]) {
            NSInteger row = [self.movieFiles indexOfObject:file];
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        else
        {
            NSInteger row = [self.picFiles indexOfObject:file];
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
        }
        
        cell.stateLabel.text = @"正在上传";
        
        float f = cell.progressView.progress;
        
        if ((chunk+1)*1.0/chunks > f) {
            cell.progressView.progress = (chunk+1)*1.0/chunks;
        }
        
        NSDate * now = [NSDate date];
        NSTimeInterval timeBetween = [now timeIntervalSinceDate:self.date];
        
        if (cell.progressView.progress == 1 ) {
            cell.stateLabel.text = @"上传完成";
            cell.rateLabel.text = @"0Kb/s";
            
            cell.rateLabel.hidden = YES;
            cell.stateLabel.hidden = YES;
            cell.progressView.hidden = YES;
            cell.finishLabel.hidden = NO;
            
        }else
        {
            cell.rateLabel.text = [NSString stringWithFormat:@"%dKb/s",(int)(1024/timeBetween)];
        }
        if(self.isPause == YES)
        {
            cell.rateLabel.text = @"0Kb/s";
        }
    }];
}

-(void)deleteFile:(NSString*)filePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        if (delete) {
            NSLog(@"本地文件删除成功!");
        }else
        {
            NSLog(@"没有这个文件啊");
        }
    }
}

-(void)saveFileName:(NSString*)filename file:(CNFile*)file
{
    NSString* fileType = file.fileType;
    if ([fileType isEqualToString:@"movie"]) {
        [self.desMovies addObject:filename];
    }else
    {
        [self.desPics addObject:filename];
    }
}

-(void)saveProgressWithChunk:(NSInteger)chunk file:(CNFile*)file//保存进度
{
    
    self.isPause = YES;
    self.uploadState = NO;

    NSLog(@"暂停的chunk是%ld",(long)chunk);
    
    self.breakoffFile = file;
    
    int fileIndex = (int)[self.files indexOfObject:file];
    
    if (chunk <= self.breakoffChunk || self.breakoffChunk == -1) {
        self.breakoffChunk = chunk;
    }
    NSLog(@"保存的chunk是%ld",(long)self.breakoffChunk);
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    
    [[CNDataModel sharedInstance] saveLocalUploadWithId:@"haha1" title:self.titleTextField.text cover:nil pics:(int)self.picFiles.count videos:(int)self.movieFiles.count upChunk:(int)chunk upDate:time upDesMov: [self.desMovies componentsJoinedByString:@","] upDesPic:[self.desPics componentsJoinedByString:@","] upFiles:[self.files componentsJoinedByString:@","] upMovies:[self.movieFiles componentsJoinedByString:@","] upPics:[self.picFiles componentsJoinedByString:@","] summary:self.summaryLabel.text fileIndex:fileIndex];
}

-(void)infoSave{
    
    //判断是否有标题 简介 视频和图片
    if(self.titleTextField.text.length<=0)
    {
        [self showModelView:@"请填写标题"];
        return;
    }
    if (self.summaryLabel.text.length<=0) {
        [self showModelView:@"请填写摘要"];
        return;
    }
    
    if (self.movieFiles.count == 0 ) {
        [self showModelView:@"请至少添加视频"];
        return;
    }
    //判断网络状态
    if([CNGlobal sharedInstance].reachability.currentReachabilityStatus == JiHNotReachable){
        //[self showModelView:@"未检测到网络连接,请检查你的网络设置"];
        
        //保存到数据库    这里还是有问题  无法区分文件全部传完和全部未传两种状态
        NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
        int fileIndex = (int)[self.files indexOfObject:self.breakoffFile];
        [[CNDataModel sharedInstance] saveLocalUploadWithId:@"haha1" title:self.titleTextField.text cover:nil pics:(int)self.picFiles.count videos:(int)self.movieFiles.count upChunk:(int)self.breakoffChunk upDate:time upDesMov: [self.desMovies componentsJoinedByString:@","] upDesPic:[self.desPics componentsJoinedByString:@","] upFiles:[self.files componentsJoinedByString:@","] upMovies:[self.movieFiles componentsJoinedByString:@","] upPics:[self.picFiles componentsJoinedByString:@","] summary:self.summaryLabel.text fileIndex:fileIndex];
        
        
        CNBreakoffViewController* breakoff = [[CNBreakoffViewController alloc] init];
        [[CLPushAnimatedRight sharedInstance] pushController:breakoff];
        return;
    }
    
    
    
    
    __weak typeof(self) me=self;
    [me cnshowLoadingModel:@"正在上传" subTitle:@"正在上传中，请稍等"];
    
    NSMutableArray* originFilename = [NSMutableArray array];
    for (CNFile* file in self.movieFiles) {
        [originFilename addObject:file.fileName];
    }
    for (CNFile* file in self.picFiles) {
        [originFilename addObject:file.fileName];
    }
    
    
    NSMutableArray* desMs = [NSMutableArray array];
    NSMutableArray* desPs = [NSMutableArray array];
    
    for (NSString* name in self.desMovies) {
        if([desMs containsObject:name] == NO)
        {
            [desMs addObject:name];
        }
    }
    for (NSString* name in self.desPics) {
        if([desPs containsObject:name] == NO)
        {
            [desPs addObject:name];
        }
    }
    
    NSDictionary* params = @{@"title":self.titleTextField.text,@"summary":self.summaryLabel.text,@"mobile":@"18801231393",@"filename":originFilename,@"descfilename":desMs,@"images":desPs};
    
    //__weak typeof(self) me=self;
    [[CNDataModel sharedInstance] postWithUrl:[NSString stringWithFormat:@"http://cntvnews-ugcupload-td.mtq.tvm.cn/cctvnews/api/infosave_3.php?card=%@",[CNUser sharedInstance].userID] param:params dataBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        NSLog(@"success = %d   response = %@",success,responseObj);
        NSDictionary* resDic = responseObj;
        NSString* des = resDic[@"desc"];
        NSLog(@"des = %@",des);
        //[me showModelView:des];
        
    } uiBlock:^(BOOL success, id responseObj, NSError *message, NSMutableDictionary *param) {
        
        CNFinishUploadViewController* finish = [CNFinishUploadViewController alloc];
        finish.titleStr = self.titleTextField.text;
        [[CLPushAnimatedRight sharedInstance] pushController:finish];
        
        [me cndisShowLoadingModel];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.titleTextField) {
        if (textField.text.length > 30) {
            textField.text = [textField.text substringToIndex:30];
        }
        self.leee.text = [NSString stringWithFormat:@"%ld/30",(long)textField.text.length];
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10) {//添加视频
        if (buttonIndex == 0)
        {//本地选取
            [self addVidioFromLib];
        }else if (buttonIndex == 1)
        {
            [self addVidioFromCamera];
        }
    }
    else if (actionSheet.tag == 20){
        if (buttonIndex == 0) {
            [self selectPicFromLib];
        }else if (buttonIndex == 1)
        {
            [self selectPicFromCamera];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    UIApplication* app = [ UIApplication  sharedApplication ];
    app.networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"上传页面销毁了");
}
@end
