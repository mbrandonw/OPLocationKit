//
//  OPGoogleGeocodeAddressComponent.m
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPGoogleGeocodeAddressComponent.h"
#import "NSDictionary+Opetopic.h"

@interface OPGoogleGeocodeAddressComponent (/**/)
@property (nonatomic, retain, readwrite) NSString *longName;
@property (nonatomic, retain, readwrite) NSString *shortName;
@property (nonatomic, retain, readwrite) NSArray *types;
@end

@implementation OPGoogleGeocodeAddressComponent

@synthesize longName;
@synthesize shortName;
@synthesize types;

-(id) initWithDictionary:(NSDictionary*)addressComponent {
    if (! (self = [super init]))
        return nil;
    
    [self updateWithDictionary:addressComponent];
    
    return self;
}

-(void) updateWithDictionary:(NSDictionary*)addressComponent {
    
    self.longName = [addressComponent stringForKey:@"long_name"];
    self.shortName = [addressComponent stringForKey:@"short_name"];
    self.types = [addressComponent arrayForKey:@"types"];
}

@end
