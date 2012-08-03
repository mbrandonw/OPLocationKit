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
#import "NSObject+Opetopic.h"
#import "OPEnumerable.h"

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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

-(NSString*) address {
    
    NSString *streetAddress = [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeStreetAddress];
    }] longName];
    
    if (streetAddress)
        return streetAddress;
    
    NSString *streetNumber = [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeStreetNumber];
    }] longName];
    
    NSString *route = [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeRoute];
    }] longName];
    
    return [NSString stringWithFormat:@"%@ %@", streetNumber, route];
}

-(NSString*) neighborhood:(BOOL)short_ {
    
    return [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsAnObjectIn:@[OPGoogleGeocodeTypeNeighborhood, OPGoogleGeocodeTypeSublocality, OPGoogleGeocodeTypeLocality, OPGoogleGeocodeTypeAdministrativeAreaLevel1, OPGoogleGeocodeTypeAdministrativeAreaLevel2]];
    }] performSelector:short_ ? @selector(shortName) : @selector(longName)];
    
}

-(NSString*) city:(BOOL)short_ {
    
    return [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsAnObjectIn:@[OPGoogleGeocodeTypeLocality, OPGoogleGeocodeTypeAdministrativeAreaLevel2]];
    }] performSelector:short_ ? @selector(shortName) : @selector(longName)];
}

-(NSString*) state:(BOOL)short_ {
    
    return [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeAdministrativeAreaLevel1];
    }] performSelector:short_ ? @selector(shortName) : @selector(longName)];
}

-(NSString*) postalCode:(BOOL)short_ {
    
    return [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypePostalCode];
    }] performSelector:short_ ? @selector(shortName) : @selector(longName)];
}

-(NSString*) country:(BOOL)short_ {
    
    return [[self.addressComponents find:^BOOL(id obj) {
        return [[obj types] containsObject:OPGoogleGeocodeTypeCountry];
    }] performSelector:short_ ? @selector(shortName) : @selector(longName)];
}

#pragma clang diagnostic pop

@end
