//
//  NSManagedObject+Dao.h
//  IfengNews
//
//  Created by Ryan on 14-4-8.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext(IfengNews)
- (id)securityObjectWithID:(NSManagedObjectID *)objectID;
@end

@interface NSManagedObject (Dao)

+ (NSEntityDescription *)entityWithMoc:(NSManagedObjectContext *)moc;

+ (id)managerObjWithMoc:(NSManagedObjectContext *)moc;

+ (id)managerObjByCreateOrGetWithPredicateString:(NSString *)PredicateString
                                             moc:(NSManagedObjectContext *)moc;

+ (NSArray *)fetchAllWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc;
+ (NSManagedObject *)fetchWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc;
+ (NSArray *)fetchAllWithMoc:(NSManagedObjectContext *)moc;
+ (void)deleteAllWtihMoc:(NSManagedObjectContext *)moc;
+(NSArray *)fetchAllWithPreformat:(NSString *)format sortKey:(NSString *)sortKey ascend:(BOOL)ascend withMOC:(NSManagedObjectContext *)currentMoc;
+ (NSArray *)fetchAllWithPredict:(NSPredicate *)pre
                         withMOC:(NSManagedObjectContext *)currentMoc
                           count:(int) count
                            sort:(NSArray *)sortDescriptors;

+ (NSUInteger)countWithPredict:(NSPredicate *)pre
                       withMOC:(NSManagedObjectContext *)currentMoc;

// will NOT insert new Object
+ (id)managerObjForDiction:(NSDictionary *)dic withMOC:(NSManagedObjectContext *)currentMoc;

+ (NSArray *)allManagerObjsWithMoc:(NSManagedObjectContext *)currentMoc;

+ (id)managerObjWithDic:(NSDictionary *)dic inMOC:(NSManagedObjectContext *)currentMoc;

//从MainMOC中获取的到一个只读的Object;
+ (id)managerObjWithObjectID:(NSManagedObjectID *)objectID;
//从当前MOC中的到Object
+ (id)managerObjWithObjectID:(NSManagedObjectID *)objectID inMOC:(NSManagedObjectContext *)currentMoc;

+ (id)managerObjByCreateOrGetWithPredicate:(NSPredicate *)predicate
                                       moc:(NSManagedObjectContext *)moc;

- (void)proInitwithDictionary:(NSDictionary *)dic;

+(id)fetchFirstWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc order:(NSString *)orderKey;
@end
