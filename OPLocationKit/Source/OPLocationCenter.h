//
//  OPLocationCenter.h
//  OPLocationKit
//
//  Created by Brandon Williams on 6/26/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const kOPLocationCenterErrorNotification;
extern NSString* const kOPLocationCenterUpdateNotification;
extern NSString* const kOPLocationCenterGoogleGeocodeUpdateNotification;
extern NSString* const kOPLocationCenterFoursquareVenueUpdateNotification;

@interface OPLocationCenter : NSObject

@property (nonatomic, retain, readonly) CLLocationManager *manager;

@property (nonatomic, assign) CLLocationAccuracy horizontalAccuracyThreshold;   // how accurate of a coordinate do we require?
@property (nonatomic, assign) NSTimeInterval timestampAccuracyThreshold;        // how old of coordinates are we willing to accept?
@property (nonatomic, assign) NSTimeInterval accuracySearchTimeInterval;        // how long are we willing to leave GPS turned on while we search for a location

@property (nonatomic, retain) NSString *foursquareConsumerKey;                  // consumer key needed to hit foursquare's api
@property (nonatomic, retain) NSString *foursquareConsumerSecret;               // consumer key needed to hit foursquare's api
@property (nonatomic, assign) BOOL findsFoursquareVenues;                        // should we grab foursquare venues once we get a coordinate?
@property (nonatomic, retain, readonly) NSArray *foursquareVenues;              // array of OPFoursquareVenue objects

@property (nonatomic, assign) BOOL geocodesLocation;                             // should we geocode the location once we get a coordinate?
@property (nonatomic, retain, readonly) NSArray *geocodedResults;               // array of OPGoogleGeocodeResult objects
@property (nonatomic, readonly) NSArray *neighborhoodResults;                   // array of OPGoogleGeocodeResult objects that represent "neighborhoods"

// singleton methods
+(OPLocationCenter*) sharedLocationCenter;

// methods for grabbing location
-(void) pingLocation;
-(void) stopLocation;

// geocoding and venue methods
-(void) loadGeocodedResults;
-(void) loadFoursquareVenues;
-(void) loadFoursquareVenuesWithQuery:(NSString*)query;

@end
