//
//  MBSequenceTaskTests.m
//  MBTask
//
//  Created by Eric McGary on 9/23/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

#import "MBSequenceTaskTests.h"
#import "MBSequenceTask.h"
#import "SimpleTask.h"

@interface MBSequenceTaskTests()

@property (nonatomic,strong) NSMutableArray* tasks;

@end

@implementation MBSequenceTaskTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	_tasks = [@[
			  [[SimpleTask alloc] init],
			  [[SimpleTask alloc] init],
			  [[SimpleTask alloc] init]]mutableCopy];
	
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void) test_doesNotStartNextAfterCancel
{
	// assert taht group incriments after sub task canceles
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	group.tasks = _tasks;
	[group start];
	[group cancel];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(1));
}

-(void) test_doesNotStartNextAfterComplete
{
	// assert that the group does not incriment after complete
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	group.tasks = _tasks;
	[group complete];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(0));
}

-(void) test_doesNotStartNextAfterCanceled
{
	// assert that does not incriment after canceled
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	group.tasks = _tasks;
	[group cancel];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(0));
}

-(void) test_doesNotStartNextAfterFaulted
{
	// assert that does not incriment after faulted
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	group.tasks = _tasks;
	[group fault:nil];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(0));
}

-(void) test_startsNextAfterSubTaskCanceles
{
	// assert taht group incriments after sub task canceles
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	group.tasks = _tasks;
	SimpleTask* task = [group.tasks objectAtIndex:0];
	[group start];
	[task cancel];
	assertThatInt(group.currentIndex,equalToInt(2));
}

-(void) test_startsNextAfterSubTaskCompletes
{
	// assert taht group incriments after sub task canceles
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	group.tasks = _tasks;
	SimpleTask* task = [group.tasks objectAtIndex:0];
	[group start];
	[task complete];
	assertThatInt(group.currentIndex,equalToInt(2));
}

-(void) test_faultsAfterSubTaskFaults
{
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	SimpleTask* task = [[SimpleTask alloc] init];
	[group addSubTask:task];
	[group start];
	[task fault:nil];
	assertThatInt(group.state,equalToInt(MBTaskStateFaulted));
}

-(void) test_didIncrementCurrentIndex
{
	MBSequenceTask* group = [[MBSequenceTask alloc] init];
	SimpleTask* task1 = [[SimpleTask alloc] init];
	SimpleTask* task2 = [[SimpleTask alloc] init];
	group.tasks = [@[task1,task2]mutableCopy];
	[group start];
	[task1 complete];
	assertThatInt(group.currentIndex,equalToInt(2));
}

@end
