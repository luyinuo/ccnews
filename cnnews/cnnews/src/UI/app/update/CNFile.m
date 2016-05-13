//
//  CNFile.m
//  cnnews
//
//  Created by wanglb on 16/4/28.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import "CNFile.h"

@implementation CNFile

-(CNFile*)initWithDictionary:(NSDictionary *)dic
{
    if (dic == nil) {
        return nil;
    }
    self.fileType = dic[@"fileType"];
    self.filePath = dic[@"filePath"];
    self.fileName = dic[@"fileName"];
    self.fileSize = [dic[@"fileSize"] integerValue];
    self.fileInfo = dic[@"fileInfo"];
    self.fileImage = dic[@"fileImage"];
    
    self.fileArr = [NSMutableArray array];

    NSInteger chunks = (self.fileSize%1024==0)?((int)(self.fileSize/1024*1024)):((int)(self.fileSize/(1024*1024) + 1));//总片数
    for (NSInteger i = 0; i< chunks; i++) {
        [self.fileArr addObject:@"wait"];//wait  loading  finish
    }
    self.trunks = chunks;
    return self;
}

@end
