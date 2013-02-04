//
//  MBParallelTaskTests.m
//  MBTask
//
//  Created by Eric McGary on 9/24/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

#import "MBParallelTaskTests.h"
#import "MBParallelTask.h"

@implementation MBParallelTaskTests

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
	MBParallelTask* group = [[MBParallelTask alloc] init];
	[group start];
	assertThatInt(group.state,equalToInt(MBTaskStateCompleted));
}

@end
