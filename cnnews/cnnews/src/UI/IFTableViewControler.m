///
//  IFTableViewControler.m
//  IfengNews
//
//  Created by Ryan on 14-7-31.
//
//

#import "IFTableViewControler.h"
#import "BlockUI.h"
#import "SgrGCD.h"

@interface IFTableViewControler ()





@end

@implementation IFTableViewControler

- (instancetype)init{
    self=[super init];
    if(self){
        self.isShouldReloadTableView=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.tableView=[[JTableView alloc] initWithFrame:CGRectMake(0, 0, GlobleWidth, GlobleHeight-CCTopHeight)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollsToTop=NO;
    
    [self.tableView isNeedReset:YES];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateCSS];
    [self.view addSubview:self.tableView];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.fetch){
       // [self.tableView hiddenBottom:(self.fetch.fetchedObjects.count<=0)];
        return [self.fetch sections].count;
    }
    //[self.tableView hiddenBottom:YES];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo=[[self.fetch sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(void)jTableViewStartHeadLoading:(JTableView *)tableView{
    
}
-(void)jTableViewStartHeadLoading:(JTableView *)tableView withRefrashType:(NSNumber *)type{
    
}
-(void)jTableViewStartBottomLoading:(JTableView *)tableView{
    
}

#pragma mark - CoreData -

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            if(!self.insertCellArray){
                self.insertCellArray=[NSMutableArray array];
            }
            [self.insertCellArray sgrAddObject:newIndexPath?newIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            if(!self.updateCellArray){
                self.updateCellArray=[NSMutableArray array];
            }
            [self.updateCellArray sgrAddObject:newIndexPath?newIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeDelete:
        case NSFetchedResultsChangeMove:
            self.isShouldReloadTableView=YES;
            break;
            
        default:
            break;
    }
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
  
    switch (type) {
        case NSFetchedResultsChangeInsert:
            if(!self.insertSections){
                self.insertSections=[NSMutableIndexSet indexSet];
            }
            [self.insertSections addIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeUpdate:
            if(self.updateSections){
                self.updateSections=[NSMutableIndexSet indexSet];
            }
            [self.updateSections addIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
        case NSFetchedResultsChangeMove:
            self.isShouldReloadTableView=YES;
            break;
            
        default:
            break;
    }

}

- (void)clearChange{
    self.insertCellArray=nil;
    self.insertSections=nil;
    self.updateCellArray=nil;
    self.updateSections=nil;
}

- (void)setFetch:(NSFetchedResultsController *)fetch{
    _fetch=fetch;
    [self clearChange];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self clearChange];
    //self.isShouldReloadTableView=NO;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    __weak typeof(self) me=self;
   // sgrSafeMainThread(^{
    [[SgrGCD sharedInstance] enMain:^{
        [me doLoadView];
    }];
    
  //  })
    
    
}

- (void)doLoadView{
    NSIndexPath *path=[self.insertCellArray sgrGetType:[NSIndexPath class] forIndex:0];
    NSLog(@"%d==%d",path.section,path.row);
    
    [self tableViewWillUpdate];
    if(self.isShouldReloadTableView){
        [self reloadTable];
        self.isShouldReloadTableView=NO;
    }else{
        if(!(self.insertSections||
             self.updateSections||
             self.insertCellArray||
             self.updateCellArray)){
            
            [self tableViewDidUpdate];
            return;
        }
        [self.tableView beginUpdates];
        if(self.insertSections)[self.tableView insertSections:self.insertSections withRowAnimation:UITableViewRowAnimationNone];
        if(self.updateSections)[self.tableView reloadSections:self.updateSections withRowAnimation:UITableViewRowAnimationNone];
        if(self.insertCellArray)[self.tableView insertRowsAtIndexPaths:self.insertCellArray withRowAnimation:UITableViewRowAnimationNone];
        if(self.updateCellArray)[self configureRowsAtIndexPaths:self.updateCellArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    [self tableViewDidUpdate];
}

- (void)configureRowsAtIndexPaths:(NSArray *)indexpaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableViewWillUpdate{
    
}

- (void)tableViewDidUpdate{
    
}

- (void)reloadTable{
    __weak typeof(self) me=self;
    sgrSafeMainThread(^{
        [me.tableView reloadData];
    })
   
}








@end
