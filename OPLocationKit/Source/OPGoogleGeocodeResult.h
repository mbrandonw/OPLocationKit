//
//  OPGoogleGeocodeResult.h
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const OPGoogleGeocodeTypeStreetAddress;
extern NSString* const OPGoogleGeocodeTypeRoute;
extern NSString* const OPGoogleGeocodeTypeIntersection;
extern NSString* const OPGoogleGeocodeTypePolitical;
extern NSString* const OPGoogleGeocodeTypeCountry;
extern NSString* const OPGoogleGeocodeTypeAdministrativeAreaLevel1;
extern NSString* const OPGoogleGeocodeTypeAdministrativeAreaLevel2;
extern NSString* const OPGoogleGeocodeTypeAdministrativeAreaLevel3;
extern NSString* const OPGoogleGeocodeTypeColloquialArea;
extern NSString* const OPGoogleGeocodeTypeLocality;
extern NSString* const OPGoogleGeocodeTypeSublocality;
extern NSString* const OPGoogleGeocodeTypeNeighborhood;
extern NSString* const OPGoogleGeocodeTypeBusStation;
extern NSString* const OPGoogleGeocodeTypeTransitStation;
extern NSString* const OPGoogleGeocodeTypePremise;
extern NSString* const OPGoogleGeocodeTypeSubpremise;
extern NSString* const OPGoogleGeocodeTypePostalCode;
extern NSString* const OPGoogleGeocodeTypeNaturalFeature;
extern NSString* const OPGoogleGeocodeTypeAirport;
extern NSString* const OPGoogleGeocodeTypePark;
extern NSString* const OPGoogleGeocodeTypePointOfInterest;
extern NSString* const OPGoogleGeocodeTypePostBox;
extern NSString* const OPGoogleGeocodeTypeStreetNumber;
extern NSString* const OPGoogleGeocodeTypeFloor;
extern NSString* const OPGoogleGeocodeTypeRoom;

@class OPGoogleGeocodeResultGeometry;

@interface OPGoogleGeocodeResult : NSObject

@property (nonatomic, retain, readonly) NSArray *addressComponents;
@property (nonatomic, retain, readonly) NSString *formattedAddress;
@property (nonatomic, retain, readonly) OPGoogleGeocodeResultGeometry *geometry;
@property (nonatomic, retain, readonly) NSArray *types;

// smart properties
-(NSString*) address;
-(NSString*) neighborhood:(BOOL)short_;
-(NSString*) city:(BOOL)short_;
-(NSString*) state:(BOOL)short_;
-(NSString*) postalCode:(BOOL)short_;
-(NSString*) country:(BOOL)short_;

-(id) initWithDictionary:(NSDictionary*)result;
-(void) updateWithDictionary:(NSDictionary*)result;

@end
