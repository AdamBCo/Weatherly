//
//  UserLocationController.m
//  PunctualTime
//
//  Created by Adam Cooper on 10/31/14.
//  Copyright (c) 2014 The Timers. All rights reserved.
//

#import "UserLocationManager.h"
#import <CoreMotion/CoreMotion.h>
#import "AppDelegate.h"

@interface UserLocationManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *userLocationManager;
@end

@implementation UserLocationManager

+(UserLocationManager *) sharedInstance
{
    static UserLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.distanceFilter = 100; // meters
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)requestLocationFromUser {
    [self.userLocationManager requestWhenInUseAuthorization];
}

-(void)dealloc
{
    [self.userLocationManager setDelegate:nil];
}

- (void)startUpdatingLocation
{
    NSLog(@"Starting location updates");
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"Location %f, %f",self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations{
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We couldn't determine your current location."
                                                    message:@"Please make sure that Pixifly can use your current location."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Error: %@", error.userInfo);
}

+ (BOOL)canGetLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    return NO;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
            NSLog(@"The user has not authorized our application!");
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"The user has authorized the application!");
    }
}

@end
