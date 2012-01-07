//
//  OPGoogleGeocodeAddressComponent.h
//  OPKit
//
//  Created by Brandon Williams on 12/15/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGoogleGeocodeAddressComponent : NSObject

@property (nonatomic, retain, readonly) NSString *longName;
@property (nonatomic, retain, readonly) NSString *shortName;
@property (nonatomic, retain, readonly) NSArray *types;

-(id) initWithDictionary:(NSDictionary*)addressComponent;
-(void) updateWithDictionary:(NSDictionary*)addressComponent;

@end
