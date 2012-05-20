//
//  OPFoursquareVenue.m
//  OPLocationKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPFoursquareVenue.h"
#import "NSDictionary+Opetopic.h"
#import "OPFoursquareVenueLocation.h"

@interface OPFoursquareVenue (/**/)
@property (nonatomic, retain, readwrite) NSString *venueID;
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) OPFoursquareVenueContact *contact;
@property (nonatomic, retain, readwrite) OPFoursquareVenueLocation *location;
@property (nonatomic, retain, readwrite) NSArray *categories;
@property (nonatomic, assign, readwrite) BOOL verified;
@property (nonatomic, assign, readwrite) NSUInteger statCheckinsCount;
@property (nonatomic, assign, readwrite) NSUInteger statUsersCount;
@property (nonatomic, assign, readwrite) NSUInteger statTipCount;
@property (nonatomic, assign, readwrite) NSUInteger hereNowCount;
@end

@implementation OPFoursquareVenue

@synthesize venueID;
@synthesize name;
@synthesize contact;
@synthesize location;
@synthesize categories;
@synthesize verified;
@synthesize statCheckinsCount;
@synthesize statUsersCount;
@synthesize statTipCount;
@synthesize hereNowCount;

-(id) initWithDictionary:(NSDictionary*)venue {
    if (! (self = [super init]))
        return nil;
    
    [self updateWithDictionary:venue];
    
    return self;
}

-(void) updateWithDictionary:(NSDictionary*)venue {
    
    self.venueID = [venue stringForKey:@"id"];
    self.name = [venue stringForKey:@"name"];
    self.location = [[OPFoursquareVenueLocation alloc] initWithDictionary:[venue dictionaryForKey:@"location"]];
    self.verified = [[venue numberForKey:@"verified"] boolValue];
    self.statCheckinsCount = [[[venue dictionaryForKey:@"stats"] numberForKey:@"checkinsCount"] unsignedIntValue];
    self.statUsersCount = [[[venue dictionaryForKey:@"stats"] numberForKey:@"usersCount"] unsignedIntValue];
    self.statTipCount = [[[venue dictionaryForKey:@"stats"] numberForKey:@"tipCount"] unsignedIntValue];
    self.hereNowCount = [[[venue dictionaryForKey:@"hereNow"] numberForKey:@"count"] unsignedIntValue];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"%@\n  Name: %@\n  Location: %@", [super description], self.name, self.location];
}

@end
