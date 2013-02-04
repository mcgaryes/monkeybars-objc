//
//  MBTaskGroupTests.m
//  MBTask
//
//  Created by Eric McGary on 9/23/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

#import "MBTaskGroupTests.h"
#import "SimpleTask.h"
#import "MBSequenceTask.h"

@interface MBTaskGroupTests()

@end

@implementation MBTaskGroupTests

#pragma mark - Setup/Teardown

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

#pragma mark - SubTasks

-(void) test_addSubTask
{
	MBTaskGroup* group = [[MBTaskGroup alloc] init];
	SimpleTask* task = [[SimpleTask alloc] init];
	NSInteger origTotal = group.tasks.count;
	NSMutableArray* origTasks = group.tasks;
	[group addSubTask:task];
	assertThatInt(group.tasks.count,equalToInt(origTotal+1));
	assertThat(origTasks, equalTo(group.tasks));
}

-(void) test_addSubTaskAfterTask
{
	MBTaskGroup* group = [[MBTaskGroup alloc] init];
	NSInteger origTotal = group.tasks.count;
	SimpleTask* task1 = [[SimpleTask alloc] init];
	SimpleTask* task2 = [[SimpleTask alloc] init];
	[group addSubTask:task1];
	[group addSubTask:task2 afterTask:task1];
	
	assertThatInt(group.tasks.count,equalToInt(origTotal+2));
	assertThat(task2, equalTo([group.tasks objectAtIndex:group.tasks.count-1]));
}

-(void) test_removeSubTask
{
	MBTaskGroup* group = [[MBTaskGroup alloc] init];
	SimpleTask* task1 = [[SimpleTask alloc] init];
	SimpleTask* task2 = [[SimpleTask alloc] init];
	
	[group addSubTask:task1];
	[group addSubTask:task2];
	[group removeSubTask:task1];
	
	assertThatInt(group.tasks.count,equalToInt(1));
}

-(void) test_setTasks
{
	MBTaskGroup* group = [[MBTaskGroup alloc] init];
	group.tasks = [@[
				   [[SimpleTask alloc] init],
				   [[SimpleTask alloc] init],
				   [[SimpleTask alloc] init]]mutableCopy];
	assertThatInt(group.tasks.count,equalToInt(3));
}

#pragma mark - Dependency Tests

@end
