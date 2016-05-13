//
//  CNNavViewController.m
//  cnnews
//
//  Created by Ryan on 16/4/21.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNNavViewController.h"
#import "CNMenuCell.h"
#import "CNUser.h"
#import "CNSettingViewController.h"
#import "CLPushAnimatedRight.h"
#import "CNAboutViewController.h"
#import "SgrGCD.h"

@interface CNNavViewController ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign)BOOL isInit;
@property (nonatomic,assign) int currentSelect;

@end

@implementation CNNavViewController

- (instancetype)init{
    self = [super init];
    if(self){
           }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isInit=NO;
    
    self.sec1=@[@"默认状态"];
    self.sec2=@[@"全部",@"上传",@"已上传"];
    self.sec3=@[@"设置",@"关于",@"选中离开"];
    
    self.t1=@[@""];
    self.t2=@[@"全部上传内容",@"已上传内容",@"待上传内容"];
    self.t3=@[@"功能设置",@"关于",@"退出"];

    
    self.view.backgroundColor=RGB(0xf5, 0xf6, 0xf6);
    
    self.tableView=[[UITableView alloc] init];
    self.tableView.frame=CGRectMake(0, 0, GlobleWidth, GlobleHeight);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.bounces=NO;
    self.tableView.scrollsToTop=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=self.view.backgroundColor;
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    CNMenuCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell beSelect:YES];

    
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:CNUserLoginsuccess object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(reloadData) name:CNUserLoginsuccess object:nil];

}

- (void)reloadData{
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows=0;
    switch (section) {
        case 0:
            rows=1;
            break;
        case 1:
            rows=3;
            break;
        case 2:
            rows=3;
            break;
            
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0.f;
    switch (indexPath.section) {
        case 0:
            height=IFFitFloat6(153.f);
            break;
        case 1:
            height=IFFitFloat6(73.f);
            break;
        case 2:
            height=IFFitFloat6(73.f);
            break;
            
        default:
            break;
    }

    
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CNMenuCell *cell=nil;
    static NSString *cellid=@"CNMenuCell";
    cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell=[[CNMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    if(indexPath.section==0){
        
        [cell load:self.sec1[indexPath.row] title:[CNUser sharedInstance].userName];
    }else if(indexPath.section==1){
        [cell load:self.sec2[indexPath.row] title:self.t2[indexPath.row]];
//        if(indexPath.row==0 && self.isInit==NO){
//            [cell setSelected:YES];
//            [cell setHighlighted:YES animated:NO];
//            self.isInit=YES;
//        }
    }else if(indexPath.section==2){
        [cell load:self.sec3[indexPath.row] title:self.t3[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height=0.f;
    if(section==2){
        height=IFFitFloat6(50.f);
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==2){
        UIView *view=[[UIView alloc] init];
        view.backgroundColor=RGB(0xf5, 0xf6, 0xf6);
        UIImageView *line=[UIImageView new];
        line.backgroundColor=RGB(157, 158, 159);
       // line.backgroundColor=[UIColor redColor];
        line.frame=CGRectMake(46.f, (IFFitFloat6(50.f)-IFScreenFit(2,2,3))/2.f, IFScreenFit(238.f,238.f,357.f), IFScreenFit(1,1,1));
        //line.image=[UIImage imageNamed:@"线.png"];
        [view addSubview:line];
        return view;
        
        
    }
    return nil;
}

- (void)willPop{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelect inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
    NSArray *array= [self.tableView visibleCells];
    for(CNMenuCell *cell in array){
        [cell beSelect:NO];
    }
        
    
    CNMenuCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelect inSection:1]];
    [cell beSelect:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //CNMenuCell *cell=[tableView cellForRowAtIndexPath:indexPath];
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
    if(indexPath.section==1){
        [[NSNotificationCenter defaultCenter] postNotificationName:CN_Change_reflash_index1 object:@(indexPath.row)];
        self.currentSelect=indexPath.row;
        [self.dispatchObj pop];
    }else

    if(indexPath.section==2){
        
        
        if(indexPath.row==2){
            [CNUser sharedInstance].userID=nil;
            [CNUser sharedInstance].userName=nil;
            [CNUser sharedInstance].sessionId=nil;
            [[CNUser sharedInstance] save];
            
            [self k_showLoginView];
            [self.dispatchObj pop];
        }else if(indexPath.row==0){
            CNSettingViewController *pass=[[CNSettingViewController alloc] init];
            [[SgrGCD sharedInstance] enMain:^{
                [[CLPushAnimatedRight sharedInstance] pushController:pass];
            }];
            
            
        }else if(indexPath.row==1){
            CNAboutViewController *about=[CNAboutViewController new];
            
            [[SgrGCD sharedInstance] enMain:^{
                [[CLPushAnimatedRight sharedInstance] pushController:about];
            }];
            
        }
        
        
    }

    
    
//    if(indexPath.section==2){
//        if(indexPath.row==2){
//            [CNUser sharedInstance].userID=nil;
//            [CNUser sharedInstance].userName=nil;
//            [CNUser sharedInstance].sessionId=nil;
//            [[CNUser sharedInstance] save];
//            
//            [self k_showLoginView];
//            [self.dispatchObj pop];
//        }
//    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return (indexPath.section==1 || indexPath.section==2);
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CNMenuCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell beSelect:YES];
    return indexPath;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    CNMenuCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell beSelect:NO];
    return indexPath;
}




- (BOOL)showPopAction{
    return YES;
}

@end
