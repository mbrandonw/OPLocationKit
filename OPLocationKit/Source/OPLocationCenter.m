//
//  OPLocationCenter.m
//  OPLocationKit
//
//  Created by Brandon Williams on 6/26/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPLocationCenter.h"
#import "NSArray+Opetopic.h"
#import "GCD+Opetopic.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+Opetopic.h"
#import "NSArray+Opetopic.h"
#import "NSString+Opetopic.h"
#import "NSCache+Opetopic.h"
#import "NSObject+Opetopic.h"
#import "OPEnumerable.h"

#import "OPGoogleGeocodeResult.h"
#import "OPFoursquareVenue.h"

#define kGoogleGeocodingStatusOK                @"OK"
#define kGoogleGeocodingStatusZeroResults       @"ZERO_RESULTS"
#define kGoogleGeocodingStatusOverQueryLimit    @"OVER_QUERY_LIMIT"
#define kGoogleGeocodingStatusRequestDenied     @"REQUEST_DENIED"
#define kGoogleGeocodingStatusInvalidRequest    @"INVALID_REQUEST"

const struct OPLocationCenterNotifications OPLocationCenterNotifications = {
    .error = @"OPLocationCenterNotifications.error",
    .started = @"OPLocationCenterNotifications.started",
    .update = @"OPLocationCenterNotifications.update",
    .ended = @"OPLocationCenterNotifications.ended",
    .googleGeocode = @"OPLocationCenterNotifications.googleGeocode",
    .foursquareVenues = @"OPLocationCenterNotifications.foursquareVenue",
};

@interface OPLocationCenter (/**/) <CLLocationManagerDelegate>
@property (nonatomic, retain) AFJSONRequestOperation *geocodeOperation;
@property (nonatomic, retain) AFJSONRequestOperation *foursquareOperation;
@property (nonatomic, retain, readwrite) CLLocationManager *manager;
@property (nonatomic, retain, readwrite) NSArray *geocodedResults;
@property (nonatomic, retain, readwrite) NSArray *foursquareVenues;
@property (nonatomic, assign, getter=isUpdatingLocation) BOOL updatingLocation;

-(void) _loadFoursquareVenuesWithQuery:(NSString*)query;
@end

@implementation OPLocationCenter

#pragma mark Singleton methods
OP_SINGLETON_IMPLEMENTATION_FOR(OPLocationCenter, sharedLocationCenter)
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
	
	if ([CLLocationManager locationServicesEnabled])
	{
        if (! self.updatingLocation)
            [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.started object:nil];
        
		[self.manager startUpdatingLocation];
        self.updatingLocation = YES;
        
        // turn of GPS after some time
        dispatch_after_delay(self.accuracySearchTimeInterval, ^{
            [self stopLocation];
        });
	}
}

-(void) stopLocation {
    
    if (self.updatingLocation)
        [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.ended object:nil];
    
	[self.manager stopUpdatingLocation];
    self.updatingLocation = NO;
}
#pragma mark -


#pragma mark CLLocationManagerDelegate methods
-(void) locationManager:(CLLocationManager *)theManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	DLogSimple(@"%@", newLocation);
	
	// if we have gotten enough accuracy then we can stop monitoring location
	if (newLocation.horizontalAccuracy <= self.horizontalAccuracyThreshold && [newLocation.timestamp timeIntervalSinceNow] >= -self.timestampAccuracyThreshold) {
		[self stopLocation];
	} else {
		// otherwise we need to keep searching for location
		return ;
	}
	
	// let all interested parties know that we obtained a new location coordinate
	[[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.update object:nil];
	
    
    // check if we should geocode our location
    if (self.geocodesLocation)
    {
        [self loadGeocodedResults];
    }
    
    
    // check if we should hit up foursquare to find nearby venues
    if (self.findsFoursquareVenues && self.foursquareConsumerKey && self.foursquareConsumerSecret)
    {
        [self loadFoursquareVenues];
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	// let all interested parties know that we failed to find a location
	[[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.error
														object:nil
													  userInfo:@{@"error": error}];
}
#pragma mark -


#pragma mark 
// geocoding and venue methods
-(void) loadGeocodedResults {
    
    // build the API call for google
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", self.manager.location.coordinate.latitude, self.manager.location.coordinate.longitude];
    
    // stop previous geocoding request, and start a fresh one
    [self.geocodeOperation cancel];
    self.geocodeOperation = 
    [AFJSONRequestOperation 
     JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]  
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         
         self.geocodedResults = [[JSON arrayForKey:@"results"] map:^id(id obj) {
             return [[OPGoogleGeocodeResult alloc] initWithDictionary:obj];
         }];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.googleGeocode object:nil];
         
     } failure:nil];
    [self.geocodeOperation start];
}

-(void) loadFoursquareVenues {
    [self loadFoursquareVenuesWithQuery:nil];
}

-(void) loadFoursquareVenuesWithQuery:(NSString*)query {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(_loadFoursquareVenuesWithQuery:) withObject:query afterDelay:0.5f];
}

-(void) _loadFoursquareVenuesWithQuery:(NSString*)query {
    
    // build the API call for foursquare
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?intent=checkin&limit=30&v=20111215&ll=%f,%f&llAcc=%f&client_id=%@&client_secret=%@&query=%@", self.manager.location.coordinate.latitude, self.manager.location.coordinate.longitude, self.manager.location.horizontalAccuracy, self.foursquareConsumerKey, self.foursquareConsumerSecret, [query?query:@"" URLEncodedString]];
    
    // stop the previous foursquare request and start a new one
    [self.foursquareOperation cancel];
    self.foursquareOperation = 
    [AFJSONRequestOperation 
     JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] 
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         
         self.foursquareVenues = [[[JSON dictionaryForKey:@"response"] arrayForKey:@"venues"] map:^id(id obj) {
             return [[OPFoursquareVenue alloc] initWithDictionary:obj];
         }];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationCenterNotifications.foursquareVenues object:nil];
         
     } failure:nil];
    [self.foursquareOperation start];
}
#pragma mark -


#pragma mark Custom getters
-(NSArray*) neighborhoodResults {
    
    if ([self.geocodedResults count] == 0)
        return nil;
    
    return [[NSCache sharedCache] fetch:[NSString stringWithFormat:@"OPLocationCenter/neighborhoodResults/%p", self.geocodedResults] do:^id(void){
        
        NSArray *neighborhoods = [self.geocodedResults findAll:^BOOL(id obj) {
            
            OPGoogleGeocodeResult *result = (OPGoogleGeocodeResult*)obj;
            
            // neighborhoods are the results that are of specific types
            return [result.types containsAnObjectIn:@[OPGoogleGeocodeTypeNeighborhood, OPGoogleGeocodeTypeSublocality, OPGoogleGeocodeTypeAdministrativeAreaLevel2, OPGoogleGeocodeTypeColloquialArea]];
            
        }];
        
        return neighborhoods ? neighborhoods : @[];
    }];
}

@end
