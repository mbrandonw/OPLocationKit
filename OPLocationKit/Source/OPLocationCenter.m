//
//  OPLocationCenter.m
//  OPKit
//
//  Created by Brandon Williams on 6/26/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPLocationCenter.h"
#import "NSArray+Opetopic.h"
#import "BlocksKit.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+Opetopic.h"
#import "NSArray+Opetopic.h"
#import "NSString+Opetopic.h"
#import "OPCache.h"
#import "OPMacros.h"

#import "OPGoogleGeocodeResult.h"
#import "OPFoursquareVenue.h"

#define kGoogleGeocodingStatusOK                @"OK"
#define kGoogleGeocodingStatusZeroResults       @"ZERO_RESULTS"
#define kGoogleGeocodingStatusOverQueryLimit    @"OVER_QUERY_LIMIT"
#define kGoogleGeocodingStatusRequestDenied     @"REQUEST_DENIED"
#define kGoogleGeocodingStatusInvalidRequest    @"INVALID_REQUEST"

NSString* const kOPLocationCenterErrorNotification                  = @"OPLocationCenterErrorNotification";
NSString* const kOPLocationCenterUpdateNotification                 = @"OPLocationCenterUpdateNotification";
NSString* const kOPLocationCenterGoogleGeocodeUpdateNotification    = @"OPLocationCenterGoogleGeocodeUpdateNotification";
NSString* const kOPLocationCenterFoursquareVenueUpdateNotification  = @"OPLocationCenterFoursquareVenueUpdateNotification";

@interface OPLocationCenter (/**/)
@property (nonatomic, retain) AFJSONRequestOperation *geocodeOperation;
@property (nonatomic, retain) AFJSONRequestOperation *foursquareOperation;
@property (nonatomic, retain, readwrite) CLLocationManager *manager;
@property (nonatomic, retain, readwrite) NSArray *geocodedResults;
@property (nonatomic, retain, readwrite) NSArray *foursquareVenues;
@end

@implementation OPLocationCenter

@synthesize geocodeOperation;
@synthesize foursquareOperation;
@synthesize manager;
@synthesize geocodedResults;
@synthesize geocodeLocation;
@synthesize findFoursquareVenues;
@synthesize foursquareConsumerKey;
@synthesize foursquareConsumerSecret;
@synthesize foursquareVenues;
@synthesize horizontalAccuracyThreshold;
@synthesize timestampAccuracyThreshold;
@synthesize accuracySearchTimeInterval;

#pragma mark Singleton methods
OP_SYNTHESIZE_SINGLETON_FOR_CLASS(OPLocationCenter, sharedLocationCenter)
#pragma mark -


#pragma mark Initialization methods
-(id) init {
	if (! (self = [super init]))
		return nil;
	
	// create and configure the location manager
	manager = [[CLLocationManager alloc] init];
	manager.delegate = self;
	manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // init ivars
    horizontalAccuracyThreshold = 200.0f;       // ~ 1 city block
    timestampAccuracyThreshold = 60.0f * 30.0f; // 1 hour
    accuracySearchTimeInterval = 30.0f;         // 30 secs
	
	return self;
}
#pragma mark -


#pragma mark Methods for grabbing location
-(void) pingLocation {
	
	if ([CLLocationManager locationServicesEnabled])
	{
		[self.manager startUpdatingLocation];
        
        // turn of GPS after some time
        [NSObject performBlock:^{
            [self.manager stopUpdatingLocation];
        } afterDelay:self.accuracySearchTimeInterval];
	}
}

-(void) stopLocation {
	
	[self.manager stopUpdatingLocation];
}
#pragma mark -


#pragma mark CLLocationManagerDelegate methods
-(void) locationManager:(CLLocationManager *)theManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	DLog(@"%@", newLocation);
	
	// if we have gotten enough accuracy then we can stop monitoring location
	if (newLocation.horizontalAccuracy <= self.horizontalAccuracyThreshold && [newLocation.timestamp timeIntervalSinceNow] >= -self.timestampAccuracyThreshold) {
		[self stopLocation];
	} else {
		// otherwise we need to keep searching for location
		return ;
	}
	
	// let all interested parties know that we obtained a new location coordinate
	[[NSNotificationCenter defaultCenter] postNotificationName:kOPLocationCenterUpdateNotification object:self userInfo:nil];
	
    
    // check if we should geocode our location
    if (self.geocodeLocation)
    {
        [self loadGeocodedResults];
    }
    
    
    // check if we should hit up foursquare to find nearby venues
    if (self.findFoursquareVenues && self.foursquareConsumerKey && self.foursquareConsumerSecret)
    {
        [self loadFoursquareVenues];
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	// let all interested parties know that we failed to find a location
	[[NSNotificationCenter defaultCenter] postNotificationName:kOPLocationCenterErrorNotification
														object:self
													  userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
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
         
         [[NSNotificationCenter defaultCenter] postNotificationName:kOPLocationCenterGoogleGeocodeUpdateNotification object:nil];
         
     } failure:nil];
    [self.geocodeOperation start];
}

-(void) loadFoursquareVenues {
    [self loadFoursquareVenuesWithQuery:nil];
}

-(void) loadFoursquareVenuesWithQuery:(NSString*)query {
    
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
         
         [[NSNotificationCenter defaultCenter] postNotificationName:kOPLocationCenterFoursquareVenueUpdateNotification object:nil];
         
     } failure:nil];
    [self.foursquareOperation start];
}
#pragma mark -


#pragma mark Custom getters
-(NSArray*) neighborhoodResults {
    
    if ([self.geocodedResults count] == 0)
        return nil;
    
    return [[OPCache sharedCache] objectForKey:[NSString stringWithFormat:@"OPLocationCenter/neighborhoodResults/%i", self.geocodedResults] withGetter:^id(void){
        
        return [self.geocodedResults select:^BOOL(id obj) {
            
            OPGoogleGeocodeResult *result = (OPGoogleGeocodeResult*)obj;
            
            // neighborhoods are the results that are of specific types
            return [result.types containsAnObjectIn:$arr(OPGoogleGeocodeTypeNeighborhood, OPGoogleGeocodeTypeSublocality, OPGoogleGeocodeTypeAdministrativeAreaLevel2, OPGoogleGeocodeTypeColloquialArea)];
            
        }];
        
    }];
}


@end
