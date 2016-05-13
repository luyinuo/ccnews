//
//  IFTableViewControler.h
//  IfengNews
//
//  Created by Ryan on 14-7-31.
//
//

#import "JTableView.h"
#import <CoreData/CoreData.h>
#import "CNViewController.h"

@interface IFTableViewControler : CNViewController<JTableViewDataSource,JTableViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) JTableView *tableView;
@property (nonatomic,strong) NSFetchedResultsController *fetch;
@property (nonatomic,assign) BOOL isShouldReloadTableView;

@property (nonatomic,strong) NSMutableArray *insertCellArray;
@property (nonatomic,strong) NSMutableArray *updateCellArray;
@property (nonatomic,strong) NSMutableIndexSet *insertSections;
@property (nonatomic,strong) NSMutableIndexSet *updateSections;



- (void)tableViewWillUpdate;

- (void)tableViewDidUpdate;

- (void)reloadTable;

@end
