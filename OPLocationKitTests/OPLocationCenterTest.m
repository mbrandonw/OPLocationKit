//
//  OPLocationCenterTest.m
//  OPLocationKit
//
//  Created by Brandon Williams on 1/7/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <GHUnitIOS/GHTestCase.h>

#import "OPLocationCenter.h"

@interface OPLocationCenterTest : GHTestCase

@property (nonatomic, strong) NSCondition *condition;
@end

@implementation OPLocationCenterTest

@synthesize condition;

-(void) setUp {
    
    self.condition = [NSCondition new];
}

-(void) tearDown {
    self.condition = nil;
}

@end
