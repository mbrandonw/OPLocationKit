//
//  OPFoursquareVenueLocation.h
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OPFoursquareVenueLocation : NSObject

@property (nonatomic, retain, readonly) NSString *address;
@property (nonatomic, retain, readonly) NSString *crossStreet;
@property (nonatomic, assign, readonly) CLLocationDegrees latitude;
@property (nonatomic, assign, readonly) CLLocationDegrees longitude;
@property (nonatomic, assign, readonly) CGFloat distance;
@property (nonatomic, retain, readonly) NSString *postalCode;
@property (nonatomic, retain, readonly) NSString *city;
@property (nonatomic, retain, readonly) NSString *state;
@property (nonatomic, retain, readonly) NSString *country;

-(id) initWithDictionary:(NSDictionary*)location;
-(void) updateWithDictionary:(NSDictionary*)location;

@end
