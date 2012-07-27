//
//  OPGoogleGeocodeResultGeometry.m
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPGoogleGeocodeResultGeometry.h"

NSString* const OPGoogleGeocodeLocationTypeRooftop               = @"ROOFTOP";
NSString* const OPGoogleGeocodeLocationTypeRangeInterpolated     = @"RANGE_INTERPOLATED";
NSString* const OPGoogleGeocodeLocationTypeGeometricCenter       = @"GEOMETRIC_CENTER";
NSString* const OPGoogleGeocodeLocationTypeApproximate           = @"APPROXIMATE";

@interface OPGoogleGeocodeResultGeometry (/**/)
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D location;
@property (nonatomic, retain, readwrite) NSString *locationType;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D viewportNortheast;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D viewportSouthwest;
@end

@implementation OPGoogleGeocodeResultGeometry

-(id) initWithDictionary:(NSDictionary*)geometry {
    if (! (self = [super init]))
        return nil;
    
    [self updateWithDictionary:geometry];
    
    return self;
}

-(void) updateWithDictionary:(NSDictionary*)geometry {
    
    self.location = CLLocationCoordinate2DMake([[geometry objectForKey:@"lat"] doubleValue], [[geometry objectForKey:@"lng"] doubleValue]);
    self.locationType = [geometry objectForKey:@"location_type"];
    self.viewportNortheast = CLLocationCoordinate2DMake([[[[geometry objectForKey:@"viewport"] objectForKey:@"northeast"] objectForKey:@"lat"] doubleValue],
                                                        [[[[geometry objectForKey:@"viewport"] objectForKey:@"northeast"] objectForKey:@"lng"] doubleValue]);
    self.viewportSouthwest = CLLocationCoordinate2DMake([[[[geometry objectForKey:@"viewport"] objectForKey:@"southwest"] objectForKey:@"lat"] doubleValue],
                                                        [[[[geometry objectForKey:@"viewport"] objectForKey:@"southwest"] objectForKey:@"lng"] doubleValue]);
}

@end
