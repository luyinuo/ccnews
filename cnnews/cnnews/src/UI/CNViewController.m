//
//  CNViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNViewController.h"
#import "CNModelView.h"
#import "SgrGCD.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "CNLoadingView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface CNViewController ()

@property (nonatomic, copy) void (^pickblock)(UIImage*);
@property (nonatomic,strong) NSMutableDictionary *blocks;

@property (nonatomic,strong) UILabel *thetitleLabel;
@property (nonatomic,assign) int selectType;
@property (nonatomic,assign)BOOL istransform;

@property (nonatomic, copy) void (^movieblock)(NSString* fileInfo,NSString* filePath,NSString* fileName,NSInteger fileSize,UIImage* fileImage);
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic,strong) UIView *loadingView;

@end

@implementation CNViewController

- (instancetype)init{
    self=[super init];
    if(self){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    return self;
}

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)createNavigator:(UIView *)view{
    if(!view)view=self.view;
    
    self.navagator=[UIView new];
    self.navagator.backgroundColor=[UIColor whiteColor];
    self.navagator.frame=CGRectMake(0, 0, GlobleWidth, CCTopHeight);
    [view addSubview:self.navagator];
    
}

- (void)addBackButton{
    self.backButton=[CNButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame=CGRectMake(IFScreenFit2(14.f,14.f), CCTopHeight-IFScreenFit2(40.f,40.f), IFScreenFit2(30.f,30.f), IFScreenFit2(39,39));
    [self.backButton setContentEdgeInsets:UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f)];
    [self.backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [self.navagator addSubview:self.backButton];
    
    __weak typeof(self) me=self;
    [self.backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [me.dispatchObj pop];
    }];
}

- (void)setNavigatorTitle:(NSString *)title{
    
    if(self.thetitleLabel){
        self.thetitleLabel.text=title;
        return;
    }
    
    UILabel *label=[UILabel new];
    label.frame=CGRectMake((GlobleWidth-IFScreenFit2(200,200))/2.f, 20.f, IFScreenFit2(200,200), IFScreenFit2(CCTopHeight-20.f,CCTopHeight-20.f));
    label.font=CNBold(IFScreenFit2(16.f,16.f));
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=title;
    self.thetitleLabel=label;
    [self.navagator addSubview:label];
}


- (void)showModelView:(NSString *)title{
    sgrSafeMainThread(^{
        CNModelView *model=[CNModelView new];
        [model show:title view:nil];

        [model performSelector:@selector(disShow) withObject:nil afterDelay:2];
    });
    
    
    
}



//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    
//    
//}


- (void)showLoadView{
    __weak typeof(self) me=self;
    [[SgrGCD sharedInstance] enqueueSafeMain:^{
        [me.loadingView removeFromSuperview];
        
       
        
        UIView *v=[UIView new];
        v.frame=CGRectMake((GlobleWidth-50.f)/2.f, (GlobleHeight-50.f)/2.f-80.f, 50, 50);
        v.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIActivityIndicatorView *active=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        active.frame=CGRectMake(0, 0, 30.f, 30.f);
        active.center=CGPointMake(25.f, 25.f);
        [active startAnimating];
        [v addSubview:active];
        [me.view addSubview:v];
        me.loadingView=v;
    }];
    
   
    
    
}

- (void)disLoadingView{
    [self.loadingView removeFromSuperview];
}




- (void)cnshowLoadingModel:(NSString *)title subTitle:(NSString *)subTitle{
    __weak typeof(self)me=self;
    self.istransform=NO;
    //    if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft||
    //       [UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight){
    //
    //    }
    [[SgrGCD sharedInstance] enqueueSafeMain:^{
        [me.loadingModel removeFromSuperview];
        UIView *bgview=[[UIView alloc] init];
        bgview.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
        bgview.backgroundColor=RGB(245, 246, 247);
        me.loadingModel=bgview;
        [me.view addSubview:bgview];
        
        
        UIView *navagator=[UIView new];
        navagator.backgroundColor=[UIColor whiteColor];
        navagator.frame=CGRectMake(0, 0, GlobleWidth, CCTopHeight);
        [bgview addSubview:navagator];
        
        
        
        
        
        
        UILabel *label=[UILabel new];
        label.frame=CGRectMake((GlobleWidth-IFScreenFit2(200,200))/2.f, 20.f, IFScreenFit2(200,200), IFScreenFit2(CCTopHeight-20.f,CCTopHeight-20.f));
        label.font=CNBold(IFScreenFit2(16.f,16.f));
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=title;
        [navagator addSubview:label];
        
        
        CNLoadingView *model=[CNLoadingView new];
        [model setUp:subTitle];
        
        model.top=IFScreenFit2s(150.f);
        model.left=(GlobleWidth-IFScreenFit2s(250.f))/2.f;
        [bgview addSubview:model];
        
        
        
        CNButton *backButton=[CNButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(IFScreenFit2(14.f,14.f), CCTopHeight-IFScreenFit2(40.f,40.f), IFScreenFit2(30.f,30.f), IFScreenFit2(39,39));
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f)];
        [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [navagator addSubview:backButton];
        
        __weak typeof(self) me=self;
        [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if([me respondsToSelector:@selector(pop)]){
                [me performSelector:@selector(pop)];
            }else{
                [me.dispatchObj pop];
            }
            
        }];
        
        
        //        UIButton *bs=[UIButton buttonWithType:UIButtonTypeCustom];
        //        bs.frame=CGRectMake(100, 100, 200, 200);
        //        [bs setBackgroundColor:[UIColor redColor]];
        
        
    }];
}


- (void)cndisShowLoadingModel{
    __weak typeof(self)me=self;
    sgrSafeMainThread(^{
        [me.loadingModel removeFromSuperview];
    });
}




- (void)_showAlertWithTitle:(NSString *)title message:(NSString *)message block:(void(^)(int buttonIndex))block cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitles:(NSString *)confirmButtonTitles{
    
#ifdef __IPHONE_8_0
    if (AtLeastIOS8)
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
        if(cancelButtonTitle){
            UIAlertAction *action=[UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){
                                                             
                                                             if(block)
                                                                 block(0);
                                                             
                                                         }];
            [alert addAction:action];
        }
        
        if(confirmButtonTitles){
            UIAlertAction *action=[UIAlertAction actionWithTitle:confirmButtonTitles
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             if(block)
                                                                 block(1);
                                                             
                                                             
                                                         }];
            [alert addAction:action];
        }
        
        [[self k_rootController] presentViewController:alert animated:YES completion:nil];
        
    }else{
//        IFAlertView *alert=[[IFAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle confirmButtonTitles:confirmButtonTitles];
//        
//        if(block){
//            if(self.blocks==nil){
//                self.blocks=[NSMutableDictionary dictionary];
//            }
//            NSString *alertHash = [NSString stringWithFormat:@"%lu",(unsigned long)[alert hash]];
//            [self.blocks sgrSetObject:block forKey:alertHash];
//        }
//        
//        
//        [alert show];
    }
    
    
#endif
    
    
}

- (void)alertView:(NSString *)key index:(int)index{
    void(^block)(int buttonIndex)=(id)[self.blocks sgrObjectForKey:key];
    if(block){
        block(index);
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString *key=[NSString stringWithFormat:@"%lu",(unsigned long)[alertView hash]];
    [[SgrGCD sharedInstance] enqueueSafeMain:^{
        void(^block)(int buttonIndex)=(id)[self.blocks sgrObjectForKey:key];
        if(block){
            block((int)buttonIndex);
        }
    }];
    
    //    void(^block)(int buttonIndex)=[self.blocks objectForKey:[NSString stringWithFormat:@"%u",[alertView hash]]];
    //    if(block){
    //        block(buttonIndex);
    //    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark --UCChangeUserHeaderMenuViewDelegate
- (void)userSelectPicWithType:(UIImagePickerControllerSourceType)sourceType result:(void(^)(UIImage* image))block
{
    self.selectType=1;
    self.pickblock = block;
    //self.ucm=nil;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self showModelView:@"设备不支持"];
        return;
    }
    // NSLog(@"%s",__PRETTY_FUNCTION__);
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = sourceType;
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (void)userSelectPicWithType2:(UIImagePickerControllerSourceType)sourceType result:(void(^)(UIImage* image))block
{
    self.selectType=2;
    self.pickblock = block;
    //self.ucm=nil;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self showModelView:@"设备不支持"];
        return;
    }
    // NSLog(@"%s",__PRETTY_FUNCTION__);
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = sourceType;
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (void)userSelectMovieWithType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray*)mediaTypes result:(void(^)(NSString* fileInfo,NSString* filePath,NSString* fileName,NSInteger fileSize,UIImage* fileImage))block
{
    
    self.selectType=3;
    self.movieblock = block;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self showModelView:@"è®¾å¤ä¸æ¯æ"];
        return;
    }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.videoQuality = 0;
    pickerController.sourceType = sourceType;
    pickerController.mediaTypes = mediaTypes;
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark --UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if(self.selectType==1){
        [self imagePickerController1:picker didFinishPickingMediaWithInfo:info];
    }else{
        [self imagePickerController2:picker didFinishPickingMediaWithInfo:info];
    }
}
- (void)imagePickerController1:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info sgrGetStringForKey:UIImagePickerControllerMediaType];
    // 默认只能看到图片，这个可以不考虑
    if ([mediaType isEqualToString:((NSString *)kUTTypeMovie)]) {
        [self showModelView:@"设备不支持"];
        
        // 警告，用户不能选择视频、音频
        return;
    }
    
    
    UIImage *userSelectedHeaderImage = [info sgrGetType:[UIImage class] forKey:UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing) {
        userSelectedHeaderImage = [info sgrGetType:[UIImage class] forKey:UIImagePickerControllerEditedImage];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(userSelectedHeaderImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        
    }];
    
    if (self.pickblock != NULL)
        self.pickblock(userSelectedHeaderImage);
    self.pickblock=NULL;
    //[self __photoGet:userSelectedHeaderImage];
    // 用Data换取URL地址
    //[_userModel exchangeURLWithImage:self.userSelectedHeaderImage];
}


- (void)imagePickerController2:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info sgrGetStringForKey:UIImagePickerControllerMediaType];
    NSLog(@"fileInfo = %@", info);
    NSURL* referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSURL* MediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    if ([mediaType isEqualToString:((NSString *)kUTTypeMovie)]) {//如果是movie
        //视频介绍
        NSString* infoM = [MediaURL absoluteString];
        
        //从视频库中选取
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [self.assetsLibrary assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
                NSString* fileInfo = infoM;
                ALAssetRepresentation *representation = [asset defaultRepresentation];
                NSString* fileName = representation.filename;
                NSString* filePath = [MediaURL path];
                //缩略图
                CGImageRef cgImRef = [asset thumbnail];
                UIImage* image = [UIImage imageWithCGImage:cgImRef];
                UIImage* fileImage = image;
                NSInteger fileSize = [self getFileSize:filePath];
                
                if (self.movieblock != NULL)
                    self.movieblock(fileInfo,filePath,fileName,fileSize,fileImage);
                self.movieblock = NULL;
            } failureBlock:^(NSError *error) {
                NSLog(@"获取文件错误！！");
            }];
        }
        //用相机拍摄
        else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            [self.assetsLibrary writeVideoAtPathToSavedPhotosAlbum:MediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error)
                {
                    [self.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        NSString* fileInfo = infoM;
                        ALAssetRepresentation *representation = [asset defaultRepresentation];
                        NSString* fileName = representation.filename;
                        NSString* filePath = [MediaURL path];
                        //缩略图
                        CGImageRef cgImRef = [asset thumbnail];
                        UIImage* image = [UIImage imageWithCGImage:cgImRef];
                        UIImage* fileImage = image;
                        NSInteger fileSize = [self getFileSize:filePath];
                        
                        if (self.movieblock != NULL)
                            self.movieblock(fileInfo,filePath,fileName,fileSize,fileImage);
                        self.movieblock = NULL;
                    } failureBlock:^(NSError *error) {
                        NSLog(@"获取文件错误！！");
                    }];
                }else
                {
                    NSLog(@"error occured while saving the image:%@", error);
                }
            }];
        }
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {//是图片
        UIImage *userSelectedHeaderImage = [info sgrGetType:[UIImage class] forKey:UIImagePickerControllerOriginalImage];
        if (picker.allowsEditing) {
            userSelectedHeaderImage = [info sgrGetType:[UIImage class] forKey:UIImagePickerControllerEditedImage];
        }
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            [self.assetsLibrary writeImageDataToSavedPhotosAlbum:UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerOriginalImage],(CGFloat)1.0) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error)
                {
                    if (self.movieblock != NULL)//需要文件的详细信息
                    {
                        [self.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            NSString* fileInfo = @"无图片信息";
                            ALAssetRepresentation *representation = [asset defaultRepresentation];
                            NSString* fileName = representation.filename;
                            
                            //需要将图片存到本地
                            [self writeToLocalWithRepresentation:representation];
                            NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",representation.filename];
                            UIImage* fileImage = userSelectedHeaderImage;
                            NSInteger fileSize = [self getFileSize:filePath];
                            
                            self.movieblock(fileInfo,filePath,fileName,fileSize,fileImage);
                            self.movieblock = NULL;
                        } failureBlock:^(NSError *error) {
                            NSLog(@"获取文件错误！！");
                        }];
                    }
                    
                    if (self.pickblock != NULL)//只要图片
                        self.pickblock(userSelectedHeaderImage);
                    self.pickblock=NULL;
                    [picker dismissViewControllerAnimated:NO completion:nil];
                    
                }else{
                    NSLog(@"error occured while saving the image:%@", error);
                }
            }];
        }
        
        
        else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            if (self.movieblock != NULL)//需要文件的详细信息
            {
                [self.assetsLibrary assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
                    NSString* fileInfo = @"无图片信息";
                    ALAssetRepresentation *representation = [asset defaultRepresentation];
                    NSString* fileName = representation.filename;
                    
                    //需要将图片存到本地
                    [self writeToLocalWithRepresentation:representation];
                    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",representation.filename];
                    UIImage* fileImage = userSelectedHeaderImage;
                    NSInteger fileSize = [self getFileSize:filePath];
                    
                    self.movieblock(fileInfo,filePath,fileName,fileSize,fileImage);
                    self.movieblock = NULL;
                } failureBlock:^(NSError *error) {
                    NSLog(@"获取文件错误！！");
                }];
            }
            
            if (self.pickblock != NULL)//只要图片
                self.pickblock(userSelectedHeaderImage);
            self.pickblock=NULL;
            [picker dismissViewControllerAnimated:NO completion:nil];
        }
        
    }
}

- (void)__photoGet:(UIImage *)image{
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString * message = [error description];
    if ([message length]==0) {
        // 用户锁拍着照片保存成功
    }
    else{
        // 用户锁拍摄照片保存失败
    }
}

- (NSInteger) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSInteger filesize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//è·åæä»¶çå±æ§
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = size;
    }else{
        NSLog(@"æ¾ä¸å°æä»¶");
    }
    return filesize;
}

-(void)writeToLocalWithRepresentation:(ALAssetRepresentation *)representation
{
    
    NSString *savingPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",representation.filename];
    //filePath = savingPath;
    
    NSUInteger size = representation.size;
  
    const int bufferSize = 65636;
    FILE *fileOpen = fopen([savingPath cStringUsingEncoding:1], "wb+");
    if (fileOpen == NULL) {
        NSLog(@"ç£çç©ºé´ä¸è¶³ï¼&*");
        return;
    }
    Byte *buffer =(Byte*)malloc(bufferSize);
    NSUInteger read =0, offset = 0;
    NSError *error;
    if (size != 0) {
        do {
            read = [representation getBytes:buffer fromOffset:offset length:bufferSize error:&error];
            fwrite(buffer, sizeof(char), read, fileOpen);
            offset += read;
        } while (read != 0);
    }
    free(buffer);
    buffer = NULL;
    fclose(fileOpen);
    fileOpen= NULL;
}



@end
