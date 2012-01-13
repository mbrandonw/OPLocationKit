//
//  OPGoogleGeocodeResult.m
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPGoogleGeocodeResult.h"
#import "OPGoogleGeocodeResultGeometry.h"
#import "OPGoogleGeocodeAddressComponent.h"
#import "NSDictionary+Opetopic.h"
#import "NSArray+Opetopic.h"
#import "BlocksKit.h"

NSString* const OPGoogleGeocodeTypeStreetAddress                = @"street_address";
NSString* const OPGoogleGeocodeTypeRoute                        = @"route";
NSString* const OPGoogleGeocodeTypeIntersection                 = @"intersection";
NSString* const OPGoogleGeocodeTypePolitical                    = @"political";
NSString* const OPGoogleGeocodeTypeCountry                      = @"country";
NSString* const OPGoogleGeocodeTypeAdministrativeAreaLevel1     = @"administrative_area_level_1";
NSString* const OPGoogleGeocodeTypeAdministrativeAreaLevel2     = @"administrative_area_level_2";
NSString* const OPGoogleGeocodeTypeAdministrativeAreaLevel3     = @"administrative_area_level_3";
NSString* const OPGoogleGeocodeTypeColloquialArea               = @"colloquial_area";
NSString* const OPGoogleGeocodeTypeLocality                     = @"locality";
NSString* const OPGoogleGeocodeTypeSublocality                  = @"sublocality";
NSString* const OPGoogleGeocodeTypeNeighborhood                 = @"neighborhood";
NSString* const OPGoogleGeocodeTypeBusStation                   = @"bus_station";
NSString* const OPGoogleGeocodeTypeTransitStation               = @"transit_station";
NSString* const OPGoogleGeocodeTypePremise                      = @"premise";
NSString* const OPGoogleGeocodeTypeSubpremise                   = @"subpremise";
NSString* const OPGoogleGeocodeTypePostalCode                   = @"postal_code";
NSString* const OPGoogleGeocodeTypeNaturalFeature               = @"natural_feature";
NSString* const OPGoogleGeocodeTypeAirport                      = @"airport";
NSString* const OPGoogleGeocodeTypePark                         = @"park";
NSString* const OPGoogleGeocodeTypePointOfInterest              = @"point_of_interest";
NSString* const OPGoogleGeocodeTypePostBox                      = @"postal_box";
NSString* const OPGoogleGeocodeTypeStreetNumber                 = @"street_number";
NSString* const OPGoogleGeocodeTypeFloor                        = @"floor";
NSString* const OPGoogleGeocodeTypeRoom                         = @"room";

@interface OPGoogleGeocodeResult (/**/)
@property (nonatomic, retain, readwrite) NSArray *addressComponents;
@property (nonatomic, retain, readwrite) NSString *formattedAddress;
@property (nonatomic, retain, readwrite) OPGoogleGeocodeResultGeometry *geometry;
@property (nonatomic, retain, readwrite) NSArray *types;
@end

@implementation OPGoogleGeocodeResult

@synthesize addressComponents;
@synthesize formattedAddress;
@synthesize geometry;
@synthesize types;

-(id) initWithDictionary:(NSDictionary*)result {
    if (! (self = [super init]))
        return nil;
    
    [self updateWithDictionary:result];
    
    return self;
}

-(void) updateWithDictionary:(NSDictionary*)result {
    
    self.addressComponents = [[result arrayForKey:@"address_components"] map:^id(id obj) {
        return [[OPGoogleGeocodeAddressComponent alloc] initWithDictionary:obj];
    }];
    self.formattedAddress = [result stringForKey:@"formatted_address"];
    self.geometry = [[OPGoogleGeocodeResultGeometry alloc] initWithDictionary:[result dictionaryForKey:@"geometry"]];
    self.types = [result arrayForKey:@"types"];
}
#pragma mark -


#pragma mark Smart properties

-(NSString*) address {
    
    NSString *streetAddress = [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeStreetAddress];
    }] longName];
    
    if (streetAddress)
        return streetAddress;
    
    NSString *streetNumber = [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeStreetNumber];
    }] longName];
    
    NSString *route = [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeRoute];
    }] longName];
    
    return [NSString stringWithFormat:@"%@ %@", streetNumber, route];
}

-(NSString*) neighborhood {
    
    return [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsAnObjectIn:$array(OPGoogleGeocodeTypeNeighborhood, OPGoogleGeocodeTypeSublocality, OPGoogleGeocodeTypeLocality, OPGoogleGeocodeTypeAdministrativeAreaLevel1, OPGoogleGeocodeTypeAdministrativeAreaLevel2)];
    }] longName];
    
}

-(NSString*) city {
    
    return [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsAnObjectIn:$array(OPGoogleGeocodeTypeLocality, OPGoogleGeocodeTypeAdministrativeAreaLevel2)];
    }] longName];
}

-(NSString*) state {
    
    return [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeAdministrativeAreaLevel1];
    }] longName];
}

-(NSString*) postalCode {
    
    return [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypePostalCode];
    }] longName];
}

-(NSString*) country {
    
    return [[self.addressComponents match:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeCountry];
    }] longName];
}

@end
