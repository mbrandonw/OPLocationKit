//
//  OPLocationCenter.m
//  OPLocationKit
//
//  Created by Brandon Williams on 6/26/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPLocationCenter.h"

const struct OPLocationCenterNotifications OPLocationCenterNotifications = {
  .error = @"OPLocationCenterNotifications.error",
  .started = @"OPLocationCenterNotifications.started",
  .update = @"OPLocationCenterNotifications.update",
  .ended = @"OPLocationCenterNotifications.ended",
};

@interface OPLocationCenter (/**/) <CLLocationManagerDelegate>
@property (nonatomic, retain, readwrite) CLLocationManager *manager;
@property (nonatomic, assign, getter=isUpdatingLocation) BOOL updatingLocation;
@end

@implementation OPLocationCenter

#pragma mark Singleton methods
static OPLocationCenter *_sharedLocationCenter = nil;
static dispatch_once_t _onceToken = 0;
+(instancetype) sharedLocationCenter {
  dispatch_once(&_onceToken, ^{
    if (! _sharedLocationCenter) {
      _sharedLocationCenter = [[[self class] alloc] init];
    }
  });
  return _sharedLocationCenter;
}
#pragma mark -


#pragma mark Initialization methods
-(id) init {
  if (! (self = [super init]))
    return nil;

  // create and configure the location manager
  _manager = [[CLLocationManager alloc] init];
  _manager.delegate = self;
  _manager.desiredAccuracy = kCLLocationAccuracyBest;

  // how much accuracy do we want before sending out notifications?
  _horizontalAccuracyThreshold = 200.0f;       // ~ 1 city block

  // how old of a cached coordinate are we willing to deal with?
#ifdef DEBUG
  _timestampAccuracyThreshold = 10.0f;         // 10 seconds
#else
  _timestampAccuracyThreshold = 60.0f * 10.0f; // 10 minutes
#endif

  // kill location search after some time
  _accuracySearchTimeInterval = 30.0f;         // 30 secs

  return self;
}
#pragma mark -


#pragma mark Methods for grabbing location
-(void) pingLocation {
  if (! CLLocationManager.locationServicesEnabled) {
    return;
  }

  if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)] &&
      CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {

    [self.manager requestWhenInUseAuthorization];

  } else if (! self.updatingLocation) {
    [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.started object:nil];

    [self.manager startUpdatingLocation];
    self.updatingLocation = YES;

    // turn of GPS after some time
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.accuracySearchTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self stopLocation];
    });
  }
}

-(void) stopLocation {

  if (self.updatingLocation) {
    [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.ended object:nil];
    [self.manager stopUpdatingLocation];
    self.updatingLocation = NO;
  }
}
#pragma mark -


#pragma mark CLLocationManagerDelegate methods
-(void) locationManager:(CLLocationManager *)theManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

  // if we have gotten enough accuracy then we can stop monitoring location
  if (newLocation.horizontalAccuracy <= self.horizontalAccuracyThreshold && [newLocation.timestamp timeIntervalSinceNow] >= -self.timestampAccuracyThreshold) {
    [self stopLocation];
  } else {
    // otherwise we need to keep searching for location
    return ;
  }

  // let all interested parties know that we obtained a new location coordinate
  [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.update object:nil];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [self pingLocation];
  }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

  // let all interested parties know that we failed to find a location
  [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.error
                                                      object:nil
                                                    userInfo:@{@"error": error}];
}
#pragma mark -

@end
