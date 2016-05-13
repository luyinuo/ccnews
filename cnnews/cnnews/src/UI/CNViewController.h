//
//  CNViewController.h
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "DispatchViewController.h"

@interface CNViewController : DispatchViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) NSString *itemId;

@property (nonatomic,strong) UIView *navagator;

@property (nonatomic,strong) CNButton *backButton;

@property (nonatomic,strong) UIView *loadingModel;

- (void)showModelView:(NSString *)title;

- (void)createNavigator:(UIView *)view;

- (void)addBackButton;

- (void)setNavigatorTitle:(NSString *)title;

- (void)userSelectPicWithType:(UIImagePickerControllerSourceType)sourceType result:(void(^)(UIImage* image))block;
- (void)userSelectPicWithType2:(UIImagePickerControllerSourceType)sourceType result:(void(^)(UIImage* image))block;
- (void)_showAlertWithTitle:(NSString *)title message:(NSString *)message block:(void(^)(int buttonIndex))block cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitles:(NSString *)confirmButtonTitles;
- (void)userSelectMovieWithType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray*)mediaTypes result:(void(^)(NSString* fileInfo,NSString* filePath,NSString* fileName,NSInteger fileSize,UIImage* fileImage))block;

- (void)cnshowLoadingModel:(NSString *)title subTitle:(NSString *)subTitle;
- (void)cndisShowLoadingModel;

//- (void)showLoadingModel:(NSString *)title view:(UIView *)view;

- (void)showLoadView;

- (void)disLoadingView;

@end
