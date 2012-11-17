//
//  RSRCTaskGroupTests.m
//  RSRCTask
//
//  Created by Eric McGary on 9/23/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

#import "RSRCTaskGroupTests.h"
#import "SimpleTask.h"
#import "RSRCSequenceTask.h"

@interface RSRCTaskGroupTests()

@end

@implementation RSRCTaskGroupTests

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
	RSRCTaskGroup* group = [[RSRCTaskGroup alloc] init];
	SimpleTask* task = [[SimpleTask alloc] init];
	NSInteger origTotal = group.tasks.count;
	NSMutableArray* origTasks = group.tasks;
	[group addSubTask:task];
	assertThatInt(group.tasks.count,equalToInt(origTotal+1));
	assertThat(origTasks, equalTo(group.tasks));
}

-(void) test_addSubTaskAfterTask
{
	RSRCTaskGroup* group = [[RSRCTaskGroup alloc] init];
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
	RSRCTaskGroup* group = [[RSRCTaskGroup alloc] init];
	SimpleTask* task1 = [[SimpleTask alloc] init];
	SimpleTask* task2 = [[SimpleTask alloc] init];
	
	[group addSubTask:task1];
	[group addSubTask:task2];
	[group removeSubTask:task1];
	
	assertThatInt(group.tasks.count,equalToInt(1));
}

-(void) test_setTasks
{
	RSRCTaskGroup* group = [[RSRCTaskGroup alloc] init];
	group.tasks = [@[
				   [[SimpleTask alloc] init],
				   [[SimpleTask alloc] init],
				   [[SimpleTask alloc] init]]mutableCopy];
	assertThatInt(group.tasks.count,equalToInt(3));
}

#pragma mark - Dependency Tests

@end
