//
//  OPLocationCenter.h
//  OPLocationKit
//
//  Created by Brandon Williams on 6/26/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

@import Foundation;
@import CoreLocation;

extern const struct OPLocationCenterNotifications {
  __unsafe_unretained NSString *started;
  __unsafe_unretained NSString *update;
  __unsafe_unretained NSString *ended;
  __unsafe_unretained NSString *error;
} OPLocationCenterNotifications;

@interface OPLocationCenter : NSObject

+(instancetype) sharedLocationCenter;

@property (nonatomic, retain, readonly) CLLocationManager *manager;

@property (nonatomic, assign) CLLocationAccuracy horizontalAccuracyThreshold;   // how accurate of a coordinate do we require?
@property (nonatomic, assign) NSTimeInterval timestampAccuracyThreshold;        // how old of coordinates are we willing to accept?
@property (nonatomic, assign) NSTimeInterval accuracySearchTimeInterval;        // how long are we willing to leave GPS turned on while we search for a location

// methods for grabbing location
-(void) pingLocation;
-(void) stopLocation;

@end
