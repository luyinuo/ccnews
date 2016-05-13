//
//  CNDetail.h
//  cnnews
//
//  Created by Ryan on 16/4/26.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNDetail : NSObject

@property (nonatomic,strong) NSString *deatilId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,strong) NSString *createtime;
@property (nonatomic,strong) NSArray *thumimg;
@property (nonatomic,strong) NSArray *videosfilesize;
@property (nonatomic,strong) NSArray *videosfiletype;

@property (nonatomic,strong) NSArray *imagesurl;
@property (nonatomic,strong) NSArray *imagesfilesize;
@property (nonatomic,strong) NSArray *imagesfiletype;



@end
