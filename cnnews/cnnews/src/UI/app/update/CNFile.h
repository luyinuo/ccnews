//
//  CNFile.h
//  cnnews
//
//  Created by wanglb on 16/4/28.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNFile : NSObject

@property (nonatomic,copy) NSString* fileType;//image  or  movie
@property (nonatomic,copy) NSString* filePath;
@property (nonatomic,copy) NSString* fileName;
@property (nonatomic,assign) NSInteger fileSize;
@property (nonatomic,assign) NSInteger trunks;
@property (nonatomic,copy) NSString* fileInfo;
@property (nonatomic,strong) UIImage* fileImage;//文件缩略图
@property (nonatomic,strong) NSMutableArray* fileArr;//标记每片的上传状态

- (CNFile*)initWithDictionary:(NSDictionary*)dic;
@end
