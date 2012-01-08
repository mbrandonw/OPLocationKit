//
//  OPFoursquareVenue.h
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPFoursquareVenueLocation;
@class OPFoursquareVenueContact;

@interface OPFoursquareVenue : NSObject

@property (nonatomic, retain, readonly) NSString *venueID;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) OPFoursquareVenueContact *contact;
@property (nonatomic, retain, readonly) OPFoursquareVenueLocation *location;
@property (nonatomic, retain, readonly) NSArray *categories;
@property (nonatomic, assign, readonly) BOOL verified;
@property (nonatomic, assign, readonly) NSUInteger statCheckinsCount;
@property (nonatomic, assign, readonly) NSUInteger statUsersCount;
@property (nonatomic, assign, readonly) NSUInteger statTipCount;
@property (nonatomic, assign, readonly) NSUInteger hereNowCount;

-(id) initWithDictionary:(NSDictionary*)venue;
-(void) updateWithDictionary:(NSDictionary*)venue;

@end
