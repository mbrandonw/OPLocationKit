//
//  OPGoogleGeocodeResultGeometry.h
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const OPGoogleGeocodeLocationTypeRooftop;
extern NSString* const OPGoogleGeocodeLocationTypeRangeInterpolated;
extern NSString* const OPGoogleGeocodeLocationTypeGeometricCenter;
extern NSString* const OPGoogleGeocodeLocationTypeApproximate;

@interface OPGoogleGeocodeResultGeometry : NSObject

@property (nonatomic, assign, readonly) CLLocationCoordinate2D location;
@property (nonatomic, retain, readonly) NSString *locationType;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D viewportNortheast;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D viewportSouthwest;

-(id) initWithDictionary:(NSDictionary*)geometry;
-(void) updateWithDictionary:(NSDictionary*)geometry;

@end
