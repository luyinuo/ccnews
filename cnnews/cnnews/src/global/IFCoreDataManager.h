//
//  IFCoreDataManager.h
//  IfengNews
//
//  Created by Ryan on 14-3-31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IFCoreDataManager : NSObject

//SGR_SINGLETION(IFCoreDataManager)

@property (nonatomic,readonly)NSManagedObjectContext *mainMoc;

- (NSManagedObjectContext *)getMainManagedObjectContextReadOnly;

- (void)performBlock:(void (^)(NSManagedObjectContext *moc))block;

- (void)performBlockAndWait:(void (^)(NSManagedObjectContext *moc))block;

- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error;

- (NSManagedObjectContext *)workMoc;

+ (IFCoreDataManager *)sharedInstance;
@end
