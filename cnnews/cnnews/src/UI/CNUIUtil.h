//
//  CNUIUtil.h
//  cnnews
//
//  Created by Ryan on 16/4/20.
//  Copyright © 2016年 hongdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define GlobleWidth  [CNUIUtil sharedInstance].globleWidth
#define GlobleHeight [CNUIUtil sharedInstance].globleHeight


#define IFiphone62iphone6p 1.104f


#define IFScreenFit(ip5s,ip6,ip6p) ((GlobleWidth==375)?ip6:((GlobleWidth==414)?ip6p:ip5s))

#define IFScreenFitF(ip4s,ip5s,ip6,ip6p) ((GlobleWidth==375)?ip6:((GlobleWidth==414)?ip6p:(GlobleHeight==568?ip5s:ip4s)))

#define IFFitFloat(ip5s) ((ip5s)/320.f*GlobleWidth)

#define IFFitFloat6(ip6s) ((ip6s)/375.f*GlobleWidth)

#define IFScreenFit2(ip5s,ip6) IFScreenFit((ip5s),ip6,((ip6)*IFiphone62iphone6p))

#define IFScreenFit2s(ip5s) IFScreenFit(ip5s,ip5s,((ip5s)*IFiphone62iphone6p))

#define CCTopHeight IFScreenFit2(64.f ,64.f)


#define IFIndexCellEdgeCap IFScreenFit2(11.f,13.f)
#define IFIndexBeaCellEdgeCap IFScreenFit2(11.f,11.f)
#define IFIndexCellSportLiveEdgeCap IFScreenFit2s(16.f)
#define IFindexCellADappIconSize IFScreenFit2(45,51)

#define CNFont(a) [[CNUIUtil sharedInstance] fontWithSize:a]
#define CNBold(a) [[CNUIUtil sharedInstance] boldWithSize:a]
#define CNSubFont(a) [[CNUIUtil sharedInstance] futuraWithSize:a]


@interface CNUIUtil : NSObject

@property (nonatomic,unsafe_unretained)float globleHeight;
@property (nonatomic,unsafe_unretained)float globleWidth;

@property (nonatomic,strong)NSObject *dispatchLock;


SGR_SINGLETION(CNUIUtil)

- (BOOL)checkAnimationLock:(NSObject *)lock;
- (void)cleanAnimationLock;

- (UIFont *)fontWithSize:(float)size;

- (UIFont *)boldWithSize:(float)size;

- (UIFont *)futuraWithSize:(float)size;

+ (float)suggestHeightOfString:(NSString *)str withWidth:(float)width font:(UIFont *)_font;

@end
