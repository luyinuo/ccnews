//
//  IFLocationManager.h
//  IfengNews
//
//  Created by Ryan on 15-3-17.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface IFLocation_response : NSObject
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) NSDictionary *responseObject;

@end



@interface IFLocationManager : NSObject<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,assign) BOOL isLocating;
@property(nonatomic,strong)CLLocationManager *locationMgr;
-(void)startLocationCallback:(void (^)(IFLocation_response *response))block;
@end
