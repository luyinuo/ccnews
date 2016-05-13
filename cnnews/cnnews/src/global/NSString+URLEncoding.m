//
//  NSString+URLEncoding.m
//  mercury
//
//  Created by li hongdan on 11-10-11.
//  Copyright 2011年 Phoenix New Media Limited. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoderlog)
-(NSString *)urlEncode{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@+$,/?%#[]&=", kCFStringEncodingUTF8));
}

-(NSString *)urlEncodeComm{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@+$,/?%#[]", kCFStringEncodingUTF8));
}

@end
