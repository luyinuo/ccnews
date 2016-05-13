//
//  CNList+CoreDataProperties.h
//  cnnews
//
//  Created by Ryan on 16/5/10.
//  Copyright © 2016年 hongdan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CNList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *ext1;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *listId;
@property (nonatomic) int64_t liveCreateTime;
@property (nonatomic) int64_t liveExpireTime;
@property (nullable, nonatomic, retain) NSString *livePushUrl;
@property (nullable, nonatomic, retain) NSString *location;
@property (nonatomic) int32_t pics;
@property (nullable, nonatomic, retain) NSString *pushUrl;
@property (nonatomic) int32_t sort;
@property (nonatomic) int64_t time;
@property (nullable, nonatomic, retain) NSString *timeFormat;
@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) float titleHeight;
@property (nonatomic) int32_t upChunk;
@property (nonatomic) NSTimeInterval upDate;
@property (nullable, nonatomic, retain) NSString *upDesMov;
@property (nullable, nonatomic, retain) NSString *upDesPic;
@property (nullable, nonatomic, retain) NSString *upFiles;
@property (nonatomic) int32_t uploading;
@property (nullable, nonatomic, retain) NSString *upMovies;
@property (nullable, nonatomic, retain) NSString *upPics;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nonatomic) int32_t videos;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nonatomic) int32_t fileIndex;

@end

NS_ASSUME_NONNULL_END
