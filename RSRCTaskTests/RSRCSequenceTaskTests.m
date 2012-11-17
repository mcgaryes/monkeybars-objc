//
//  RSRCSequenceTaskTests.m
//  RSRCTask
//
//  Created by Eric McGary on 9/23/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

#import "RSRCSequenceTaskTests.h"
#import "RSRCSequenceTask.h"
#import "SimpleTask.h"

@interface RSRCSequenceTaskTests()

@property (nonatomic,strong) NSMutableArray* tasks;

@end

@implementation RSRCSequenceTaskTests

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
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	group.tasks = _tasks;
	[group start];
	[group cancel];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(1));
}

-(void) test_doesNotStartNextAfterComplete
{
	// assert that the group does not incriment after complete
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	group.tasks = _tasks;
	[group complete];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(0));
}

-(void) test_doesNotStartNextAfterCanceled
{
	// assert that does not incriment after canceled
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	group.tasks = _tasks;
	[group cancel];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(0));
}

-(void) test_doesNotStartNextAfterFaulted
{
	// assert that does not incriment after faulted
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	group.tasks = _tasks;
	[group fault:nil];
	[group startNextSubTask];
	assertThatInt(group.currentIndex,equalToInt(0));
}

-(void) test_startsNextAfterSubTaskCanceles
{
	// assert taht group incriments after sub task canceles
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	group.tasks = _tasks;
	SimpleTask* task = [group.tasks objectAtIndex:0];
	[group start];
	[task cancel];
	assertThatInt(group.currentIndex,equalToInt(2));
}

-(void) test_startsNextAfterSubTaskCompletes
{
	// assert taht group incriments after sub task canceles
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	group.tasks = _tasks;
	SimpleTask* task = [group.tasks objectAtIndex:0];
	[group start];
	[task complete];
	assertThatInt(group.currentIndex,equalToInt(2));
}

-(void) test_faultsAfterSubTaskFaults
{
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	SimpleTask* task = [[SimpleTask alloc] init];
	[group addSubTask:task];
	[group start];
	[task fault:nil];
	assertThatInt(group.state,equalToInt(RSRCTaskStateFaulted));
}

-(void) test_didIncrementCurrentIndex
{
	RSRCSequenceTask* group = [[RSRCSequenceTask alloc] init];
	SimpleTask* task1 = [[SimpleTask alloc] init];
	SimpleTask* task2 = [[SimpleTask alloc] init];
	group.tasks = [@[task1,task2]mutableCopy];
	[group start];
	[task1 complete];
	assertThatInt(group.currentIndex,equalToInt(2));
}

@end
