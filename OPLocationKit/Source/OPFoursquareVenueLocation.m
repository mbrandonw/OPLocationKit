//
//  OPFoursquareVenueLocation.m
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPFoursquareVenueLocation.h"
#import "NSDictionary+Opetopic.h"

@interface OPFoursquareVenueLocation (/**/)
@property (nonatomic, retain, readwrite) NSString *address;
@property (nonatomic, retain, readwrite) NSString *crossStreet;
@property (nonatomic, assign, readwrite) CLLocationDegrees latitude;
@property (nonatomic, assign, readwrite) CLLocationDegrees longitude;
@property (nonatomic, assign, readwrite) CGFloat distance;
@property (nonatomic, retain, readwrite) NSString *postalCode;
@property (nonatomic, retain, readwrite) NSString *city;
@property (nonatomic, retain, readwrite) NSString *state;
@property (nonatomic, retain, readwrite) NSString *country;
@end

@implementation OPFoursquareVenueLocation

@synthesize address;
@synthesize crossStreet;
@synthesize latitude;
@synthesize longitude;
@synthesize distance;
@synthesize postalCode;
@synthesize city;
@synthesize state;
@synthesize country;

-(id) initWithDictionary:(NSDictionary*)location {
    if (! (self = [super init]))
        return nil;
    
    [self updateWithDictionary:location];
    
    return self;
}

-(void) updateWithDictionary:(NSDictionary*)location {
    
    self.address = [location stringForKey:@"address"];
    self.crossStreet = [location stringForKey:@"crossStreet"];
    self.latitude = [[location numberForKey:@"lat"] doubleValue];
    self.longitude = [[location numberForKey:@"lng"] doubleValue];
    self.distance = [[location numberForKey:@"distance"] floatValue];
    self.postalCode = [location stringForKey:@"postalCode"];
    self.city = [location stringForKey:@"city"];
    self.state = [location stringForKey:@"state"];
    self.country = [location stringForKey:@"country"];
}

@end
