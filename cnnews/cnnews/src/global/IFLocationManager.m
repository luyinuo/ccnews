//
//  IFLocationManager.m
//  IfengNews
//
//  Created by Ryan on 15-3-17.
//
//

#import "IFLocationManager.h"

@implementation IFLocation_response

@end

@interface IFLocationManager ()

@property (nonatomic,copy) void (^callbackFunction)(IFLocation_response *response);

@end

@implementation IFLocationManager

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [self.locationMgr stopUpdatingLocation];
    self.locationMgr=nil;
    
    if(newLocation){
        
        CLLocationCoordinate2D collocationcoor =newLocation.coordinate;
       
        
        CLGeocoder *geo=[[CLGeocoder alloc] init];
        // __weak typeof(self) me=self;
        
        NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                                objectForKey:@"AppleLanguages"];
        // 强制 成 简体中文
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                                  forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        __weak typeof(self) me=self;
        [geo reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
           
           [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize];
             me.isLocating=NO;
            for (CLPlacemark * placeMark in placemarks)
            {
                NSDictionary *addressDic=placeMark.addressDictionary;
                
                NSString *country = [addressDic sgrGetStringForKey:@"Country"];
                
                NSString *lastState = [addressDic sgrGetStringForKey:@"State"];
                NSString *city = [addressDic sgrGetStringForKey:@"City"];
                NSString *lastCity = _isStrNULL(city)?lastState:city;
                lastCity=[lastCity stringByReplacingOccurrencesOfString:@"市辖区" withString:@""];
                NSString *lastSubLocality = [addressDic sgrGetStringForKey:@"SubLocality"];
                NSString *street = [addressDic sgrGetStringForKey:@"Street"];
                NSString *name = [addressDic sgrGetStringForKey:@"Name"];
                double latitude = placeMark.location.coordinate.latitude;
                double longitude = placeMark.location.coordinate.longitude;
                
                if(_isStrNULL(lastState) && _isStrNULL(lastCity))
                    continue;
                else{
                    IFLocation_response *response = [[IFLocation_response alloc] init];
                    response.isSuccess = YES;
                    response.responseObject = addressDic;
                    if (self.callbackFunction) self.callbackFunction(response);
                    return ;
                }
                
            }
            
            
        }];
        
    }else{
        self.isLocating=NO;
        IFLocation_response *response = [[IFLocation_response alloc] init];
        response.isSuccess = NO;
        response.responseObject = nil;
        if (self.callbackFunction) self.callbackFunction(response);
    }
    
    
}

-(void)startLocationCallback:(void (^)(IFLocation_response *response))block
{
    self.callbackFunction = block;
    if(self.locationMgr){
        self.locationMgr=nil;
    }
    self.locationMgr=[[CLLocationManager alloc] init];
    if (AtLeastIOS8) {
        [self.locationMgr requestWhenInUseAuthorization];
        [self.locationMgr performSelector:@selector(requestWhenInUseAuthorization)];
    }
    
    
    self.locationMgr.delegate=self;
    self.locationMgr.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
    self.isLocating=YES;
    [self.locationMgr startUpdatingLocation];
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    self.isLocating=NO;
    IFLocation_response *response = [[IFLocation_response alloc] init];
    response.isSuccess = NO;
 
    if (self.callbackFunction) self.callbackFunction(response);
}


@end
