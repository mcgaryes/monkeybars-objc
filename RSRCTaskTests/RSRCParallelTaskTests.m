//
//  RSRCParallelTaskTests.m
//  RSRCTask
//
//  Created by Eric McGary on 9/24/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

#import "RSRCParallelTaskTests.h"
#import "RSRCParallelTask.h"

@implementation RSRCParallelTaskTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void) test_noSubTasksShouldComplete
{
	RSRCParallelTask* group = [[RSRCParallelTask alloc] init];
	[group start];
	assertThatInt(group.state,equalToInt(RSRCTaskStateCompleted));
}

@end
