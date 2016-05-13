//
//  update1ViewController.h
//  cnnews
//
//  Created by wanglb on 16/4/25.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNViewController.h"
#import "CLPushAnimatedRight.h"
#import "CNFile.h"

@interface update1ViewController : CNViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL comeFromCamera;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UILabel* summaryLabel;
//断点信息
@property (nonatomic,strong) NSMutableArray* files1;
@property (nonatomic,strong) NSMutableArray* movieFiles1;
@property (nonatomic,strong) NSMutableArray* picFiles1;
@property (nonatomic,strong) NSMutableArray* desMovies1;
@property (nonatomic,strong) NSMutableArray* desPics1;
@property (nonatomic,strong) CNFile* breakoffFile;//读到了哪个文件
@property (nonatomic,assign) NSInteger breakoffChunk;//读到了第几片
@property (nonatomic,assign) NSTimeInterval time;
@property (nonatomic,copy)   NSString* summaryStr;
@property (nonatomic,copy)   NSString* titleStr;
@property (nonatomic,assign) int fileIndex;//breakoffFile的fileIndex
@end
