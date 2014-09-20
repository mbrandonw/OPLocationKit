//
//  OPLocationCenter.h
//  OPLocationKit
//
//  Created by Brandon Williams on 6/26/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OPMacros.h"

extern const struct OPLocationCenterNotifications {
  __unsafe_unretained NSString *started;
  __unsafe_unretained NSString *update;
  __unsafe_unretained NSString *ended;

  __unsafe_unretained NSString *error;

  __unsafe_unretained NSString *googleGeocode;
} OPLocationCenterNotifications;

@interface OPLocationCenter : NSObject

OP_SINGLETON_HEADER_FOR(OPLocationCenter, sharedLocationCenter);

@property (nonatomic, retain, readonly) CLLocationManager *manager;

@property (nonatomic, assign) CLLocationAccuracy horizontalAccuracyThreshold;   // how accurate of a coordinate do we require?
@property (nonatomic, assign) NSTimeInterval timestampAccuracyThreshold;        // how old of coordinates are we willing to accept?
@property (nonatomic, assign) NSTimeInterval accuracySearchTimeInterval;        // how long are we willing to leave GPS turned on while we search for a location

@property (nonatomic, assign) BOOL geocodesLocation;                            // should we geocode the location once we get a coordinate?
@property (nonatomic, retain, readonly) NSArray *geocodedResults;               // array of OPGoogleGeocodeResult objects
@property (nonatomic, readonly) NSArray *neighborhoodResults;                   // array of OPGoogleGeocodeResult objects that represent "neighborhoods"

// methods for grabbing location
-(void) pingLocation;
-(void) stopLocation;

// geocoding methods
-(void) loadGeocodedResults;

@end
