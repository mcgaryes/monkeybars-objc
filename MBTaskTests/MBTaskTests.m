//
//  MBTaskTest.m
//  MBTask
//
//  Created by Eric McGary on 9/23/12.
//  Copyright (c) 2012 Resource. All rights reserved.
//

/*
 
 MBTask States
 
 MBTaskStateInitialized,
 MBTaskStateStarted,
 MBTaskStateCanceled,
 MBTaskStateFaulted,
 MBTaskStateCompleted
 
 */

#import "MBTaskTests.h"
#import "SimpleTask.h"

@implementation MBTaskTests

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

#pragma mark - Initial State

-(void) test_taskShouldInitWithInitializedState
{
	SimpleTask* task = [[SimpleTask alloc] init];
	assertThatInt(task.state,equalToInt(MBTaskStateInitialized));
}

#pragma mark - Cancel/Fault/Complete/Start

-(void) test_taskDidCancel
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task cancel];
	assertThatInt(task.state,equalToInt(MBTaskStateCanceled));
}

-(void) test_taskDidFault
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task fault:nil];
	assertThatInt(task.state,equalToInt(MBTaskStateFaulted));
}

-(void) test_taskDidComplete
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task complete];
	assertThatInt(task.state,equalToInt(MBTaskStateCompleted));
}

-(void) test_taskDidStart
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task start];
	assertThatInt(task.state,equalToInt(MBTaskStateStarted));
}

#pragma mark - Should Not Cancel

-(void) test_taskShouldNotCancelAfterComplete
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task complete];
	[task cancel];
	assertThatInt(task.state,equalToInt(MBTaskStateCompleted));
}

-(void) test_taskShouldNotCancelAfterFault
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task complete];
	[task fault:nil];
	assertThatInt(task.state,equalToInt(MBTaskStateCompleted));
}

#pragma mark - Should Not Complete

-(void) test_taskShouldNotCompleteAfterCancel
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task cancel];
	[task complete];
	assertThatInt(task.state,equalToInt(MBTaskStateCanceled));
}

-(void) test_taskShouldNotCompleteAfterFault
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task fault:nil];
	[task complete];
	assertThatInt(task.state,equalToInt(MBTaskStateFaulted));
}

#pragma mark - Should Not Fault

-(void) test_taskShouldNotFaultAfterComplete
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task complete];
	[task fault:nil];
	assertThatInt(task.state,equalToInt(MBTaskStateCompleted));
}

-(void) test_taskShouldNotFaultAfterCanceled
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task cancel];
	[task fault:nil];
	assertThatInt(task.state,equalToInt(MBTaskStateCanceled));
}

#pragma mark - Should Not Start

-(void) test_taskShouldNotStartAfterCanceled
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task cancel];
	[task start];
	assertThatInt(task.state,equalToInt(MBTaskStateCanceled));
}

-(void) test_taskShouldNotStartAfterFaulted
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task fault:nil];
	[task start];
	assertThatInt(task.state,equalToInt(MBTaskStateFaulted));
}

-(void) test_taskShouldNotStartAfterCompleted
{
	SimpleTask* task = [[SimpleTask alloc] init];
	[task complete];
	[task start];
	assertThatInt(task.state,equalToInt(MBTaskStateCompleted));
}

@end
