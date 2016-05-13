//
//  IFCoreDataManager.m
//  IfengNews
//
//  Created by Ryan on 14-3-31.
//
//

#import "IFCoreDataManager.h"
#import "SgrSandbox.h"



static IFCoreDataManager *manager = nil;

@interface IFCoreDataManager()

@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSManagedObjectContext *rootManagedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *privateManagedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *mainManagedObjectContextReadOnly;


@end

@implementation IFCoreDataManager

//SGR_DEF_SINGLETION(IFCoreDataManager)

- (instancetype)init{
    self=[super init];
    if(self){
        [self setup];
    }
    return self;
}

+ (IFCoreDataManager *)sharedInstance
{
    if(manager == nil){
        manager = [[IFCoreDataManager alloc] init];
    }
    return manager;
}

- (void)setup{
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"ccnews" withExtension:@"momd"];
    self.managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:path];
    self.persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *storeURL =[NSURL fileURLWithPath:[[SgrSandbox libCachePath] stringByAppendingPathComponent:@"ccnews.sqlite"]];
    NSError *error = nil;
    // handle db upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if(![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"IfengNewsData Unresolved error %@,%@",error,[error userInfo]);
        // abort();
    }
    
    
//   NSArray *a= [[self.persistentStoreCoordinator managedObjectModel] entities];
//    for(NSEntityDescription *desc in a){
//        NSLog(@"%@",desc.managedObjectClassName);
//    }
   
    self.rootManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.rootManagedObjectContext.persistentStoreCoordinator=self.persistentStoreCoordinator;
    self.rootManagedObjectContext.mergePolicy=NSMergeByPropertyStoreTrumpMergePolicy;
    
    self.mainManagedObjectContextReadOnly = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.mainManagedObjectContextReadOnly.parentContext=self.rootManagedObjectContext;
    self.mainManagedObjectContextReadOnly.mergePolicy=NSMergeByPropertyStoreTrumpMergePolicy;
    
    self.privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    self.privateManagedObjectContext.parentContext=self.mainManagedObjectContextReadOnly;
    self.privateManagedObjectContext.mergePolicy=NSMergeByPropertyStoreTrumpMergePolicy;
    
    
    
    
    
}


- (NSManagedObjectContext *)mainMoc{
    return self.mainManagedObjectContextReadOnly;
}

- (NSManagedObjectContext *)workMoc{
    return self.privateManagedObjectContext;
}


- (NSManagedObjectContext *)getMainManagedObjectContextReadOnly{
    return self.mainManagedObjectContextReadOnly;
}

- (void)performBlock:(void (^)(NSManagedObjectContext *moc))block{
    if(!block)return;
    [self.privateManagedObjectContext performBlock:^(){
        block(self.privateManagedObjectContext);
    }];
}

- (void)performBlockAndWait:(void (^)(NSManagedObjectContext *moc))block{
    if(!block)return;
    [self.privateManagedObjectContext performBlockAndWait:^(){
        block(self.privateManagedObjectContext);
    }];
}

- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error;
{
    // todo by walfer
    __block NSError *localError = nil;
    NSManagedObjectContext *contextToSave = savedMoc;
    while (contextToSave) {
        __block BOOL success;
        /**
         To work around issues in ios 5 first obtain permanent object ids for any inserted objects.  If we don't do this then its easy to get an `NSObjectInaccessibleException`.  This happens when:
         
         1. Create new object on main context and save it.
         2. At this point you may or may not call obtainPermanentIDsForObjects for the object, it doesn't matter
         3. Update the object in a private child context.
         4. Save the child context to the parent context (the main one) which will work,
         5. Save the main context - a NSObjectInaccessibleException will occur and Core Data will either crash your app or lock it up (a semaphore is not correctly released on the first error so the next fetch request will block forever.
         */
        [contextToSave obtainPermanentIDsForObjects:[[contextToSave insertedObjects] allObjects] error:&localError];
        if (localError) {
            if (error) *error = localError;
            return NO;
        }
        
        [contextToSave performBlockAndWait:^{
            success = [contextToSave save:&localError];
            if (! success && localError == nil) NSLog(@"Saving of managed object context failed, but a `nil` value for the `error` argument was returned. This typically indicates an invalid implementation of a key-value validation method exists within your model. This violation of the API contract may result in the save operation being mis-interpretted by callers that rely on the availability of the error.");
        }];
        
        if (! success) {
            if (error) *error = localError;
            return NO;
        }
        
        if (! contextToSave.parentContext && contextToSave.persistentStoreCoordinator == nil) {
            NSLog(@"Reached the end of the chain of nested managed object contexts without encountering a persistent store coordinator. Objects are not fully persisted.");
            return NO;
        }
        contextToSave = contextToSave.parentContext;
    }
    return YES;
}





@end
