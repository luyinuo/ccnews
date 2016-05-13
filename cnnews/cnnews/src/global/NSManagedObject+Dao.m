//
//  NSManagedObject+Dao.m
//  IfengNews
//
//  Created by Ryan on 14-4-8.
//
//

#import "NSManagedObject+Dao.h"
#import "IFCoreDataManager.h"

@implementation NSManagedObjectContext (chanlin)
- (id)securityObjectWithID:(NSManagedObjectID *)objectID{
    NSError *err = nil;
    if (!objectID)
        return nil;
    
    NSManagedObject *obj = [self existingObjectWithID:objectID error:&err];
    if (err) {
        NSLog(@"%@", err);
        //        NSAssert(NO, @"existObjectWithID error");
    }
    if (obj && obj.isFault)
        obj = nil;
    return obj;
}
@end

@implementation NSManagedObject (Dao)

- (void)initBeforeProcessWith:(NSDictionary *)dic {
    //TODO: addtional process
}
- (void)initLaterProcessWith:(NSDictionary *)dic {
    //TODO: addtional process
}
- (NSMutableDictionary *)deInitLaterProcess:(NSMutableDictionary *)dic isUpload:(BOOL)isUpload{
    //TODO: addtional process
    return dic;
}

- (void)proInitwithDictionary:(NSDictionary *)dic{
    
}

+ (NSPredicate *)preForDiction:(NSDictionary *)dic withMOC:(NSManagedObjectContext *)currentMoc{
    return nil;
}

+ (NSEntityDescription *)entityWithMoc:(NSManagedObjectContext *)moc{
    if ([self class] == [NSManagedObject class] || !moc)
        return nil;
    

    return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];

}

+ (id)managerObjWithMoc:(NSManagedObjectContext *)moc{
    if(!moc) return nil;
    NSEntityDescription *ed=[self entityWithMoc:moc];
    if(!ed) return nil;
    return [[self alloc] initWithEntity:ed insertIntoManagedObjectContext:moc];
    
}

+ (id)managerObjByCreateOrGetWithPredicate:(NSPredicate *)predicate
                                             moc:(NSManagedObjectContext *)moc{
   
    id item= [self fetchWithPredict:predicate withMOC:moc];
    if(!item)
        item=[self managerObjWithMoc:moc];
    return item;
}

+ (id)managerObjByCreateOrGetWithPredicateString:(NSString *)PredicateString
                                             moc:(NSManagedObjectContext *)moc{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:PredicateString];
    return [self managerObjByCreateOrGetWithPredicate:predicate moc:moc];
}

+(NSArray *)fetchAllWithPreformat:(NSString *)format sortKey:(NSString *)sortKey ascend:(BOOL)ascend withMOC:(NSManagedObjectContext *)currentMoc{
    NSPredicate *pre = nil;
    NSSortDescriptor *sort = nil;
    NSArray *sortArray = nil;
    if(_isStrNotNull(format)){
        pre = [NSPredicate predicateWithFormat:format];
    }
    if (_isStrNotNull(sortKey)) {
        sort = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascend];
        sortArray = (sort)?@[sort]:nil;
    }
    NSArray *arr = [self fetchAllWithPredict:pre withMOC:currentMoc count:0 sort:sortArray];
    return arr;
    
}


+ (NSUInteger)countWithPredict:(NSPredicate *)pre
                       withMOC:(NSManagedObjectContext *)currentMoc{
    if (!currentMoc)
        return 0;
    
    NSEntityDescription *ent = [self entityWithMoc:currentMoc];
    if (pre && ent) {
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        [req setIncludesSubentities:NO];
        [req setEntity:ent];
        [req setPredicate:pre];
        
        NSUInteger count = [currentMoc countForFetchRequest:req error:nil];
        
        return count;
    }
    return 0;
}

+ (NSArray *)fetchAllWithPredict:(NSPredicate *)pre
                         withMOC:(NSManagedObjectContext *)currentMoc
                           count:(int) count
                            sort:(NSArray *)sortDescriptors{
    NSEntityDescription *ent = [self entityWithMoc:currentMoc];
    if (pre && ent) {
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        [req setEntity:ent];
        [req setSortDescriptors:sortDescriptors];
        if(count>0)
        [req setFetchLimit:count];
        [req setPredicate:pre];
        
        NSArray *arr = [currentMoc executeFetchRequest:req error:nil];
        
        if (arr.count > 0)
            return arr;
        else
            return nil;
    }
    return nil;
    
    
    
}

+ (NSArray *)fetchAllWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc{
    if (!currentMoc)
        return nil;
    
    NSEntityDescription *ent = [self entityWithMoc:currentMoc];
    if (ent) {
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        [req setEntity:ent];
        if(pre)
        [req setPredicate:pre];
  
        NSArray *arr = [currentMoc executeFetchRequest:req error:nil];
     
        if (arr.count > 0)
            return arr;
        else
            return nil;
    }
    return nil;
}

+(id)fetchFirstWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc order:(NSString *)orderKey{
    if (!currentMoc)
        return nil;
    
    NSEntityDescription *ent = [self entityWithMoc:currentMoc];
    if (ent) {
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        req.fetchLimit=1;
        [req setEntity:ent];
        if(pre)
            [req setPredicate:pre];
        if(_isStrNotNull(orderKey)){
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:orderKey ascending:YES];
            [req setSortDescriptors:@[sort]];
        }
        
        NSArray *arr = [currentMoc executeFetchRequest:req error:nil];
        
        if (arr.count > 0)
            return arr.firstObject;
        else
            return nil;
    }
    return nil;
}

+ (NSManagedObject *)fetchWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc{
    
    NSArray *arr = [self fetchAllWithPredict:pre withMOC:currentMoc];
   // NSAssert([arr count]<2, @"find more than one items, which expect to be one");
    if (arr.count > 0)
        return [arr lastObject];
    else
        return nil;
}

+ (NSArray *)fetchAllWithMoc:(NSManagedObjectContext *)moc{
    NSEntityDescription *ent = [self entityWithMoc:moc];
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:ent.name];
    NSArray *arr = [moc executeFetchRequest:req error:nil];
    if (arr.count > 0)
        return arr;
    else
        return nil;
}

+ (void)deleteAllWtihMoc:(NSManagedObjectContext *)moc{
    NSArray *arr=[self fetchAllWithMoc:moc];
    if(arr){
        for(NSManagedObject *obj in arr){
            [moc deleteObject:obj];
        }
    }
}

// will NOT insert new Object
+ (id)managerObjForDiction:(NSDictionary *)dic withMOC:(NSManagedObjectContext *)currentMoc{
    if ([self class] == [NSManagedObject class])
        return nil;
    NSPredicate *pre = [self preForDiction:dic withMOC:currentMoc];
    return [self fetchWithPredict:pre withMOC:currentMoc];
}

+ (NSArray *)allManagerObjsWithMoc:(NSManagedObjectContext *)currentMoc{
    return [self fetchAllWithPredict:nil withMOC:currentMoc];
}

+ (id)managerObjWithDic:(NSDictionary *)dic inMOC:(NSManagedObjectContext *)currentMoc{
    if (!dic || !currentMoc)
        return nil;
    
    id itm = [self managerObjForDiction:dic withMOC:currentMoc];
    if (!itm)
        itm = [self managerObjWithMoc:currentMoc];
    else
        [itm initBeforeProcessWith:dic];
    
    [itm proInitwithDictionary:dic];
    return itm;
}

//从MainMOC中获取的到一个只读的Object;
+ (id)managerObjWithObjectID:(NSManagedObjectID *)objectID{
	return [[IFCoreDataManager sharedInstance].mainMoc securityObjectWithID:objectID];
}
//从当前MOC中的到Object
+ (id)managerObjWithObjectID:(NSManagedObjectID *)objectID inMOC:(NSManagedObjectContext *)currentMoc{
	return [currentMoc securityObjectWithID:objectID];
}

@end
