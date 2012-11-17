//
//  RSRCTaskGroup.m
//  SequenceTask
//
//  Abstract class for group task queues. Should be overridden.
//
//  TaskGroups are responsible for cleaning up after themselves. This is because
//  a sequence could possibly rety its entire flow when one task fails. So nullifying
//  tasks could cause unforseen issues.
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//


#import "RSRCTaskGroup.h"

@interface RSRCTaskGroup()

/**
 * A dictionary of dependencies for sub tasks
 */
@property (nonatomic,strong) NSMutableDictionary* dependencyMap;

@end

@implementation RSRCTaskGroup

#pragma mark - Initialization

-(id) init
{
	if(self = [super init])
	{
		_tasks = [@[] mutableCopy];
		_dependencyMap = [@{} mutableCopy];
		_canceledIndex = 0;
	}
	return self;
}

#pragma mark - Task Group Funcitonality

-(BOOL) processSubTask:(RSRCTask *)task
{
	
	if (task == nil) @throw [NSException exceptionWithName:@"RSRCTaskGroup processSubTask Invocation"
													reason:@"You cannot process a task with a nil value."
												  userInfo:nil];
	
	if(task.state == RSRCTaskStateCanceled)
	{
		// We are running the sub task canceled functionality here
		// because there is a chance that the task being about to run
		// was dependent on a task that was previously canceled in the queue
		// and we need to make sure that it notifies any tasks that may
		// be dependent on itself that they also should be canceled
		NSLog(@"\t--\tRSRCTask:    Skipped:\t%@",task.name);
		[self onSubTaskCancel:task];
		return YES;
	}
	
	// set concurrency for the sub tasks
	task.concurrent = self.concurrent;
	task.group = self;
	
	// set execution block
	__weak RSRCTask* wTask = task;
	[task setExecutionBlock:^(RSRCTaskState s, RSRCTaskProgress* p, NSError *e)
	 {
		 if(s == RSRCTaskStateCompleted)[self onSubTaskComplete];
		 else if(s == RSRCTaskStateFaulted)[self onSubTaskFault:e];
		 else if(s == RSRCTaskStateCanceled) [self onSubTaskCancel:wTask];
	 }];
	
	[task start];
	
	return NO;
}

-(void) onSubTaskComplete
{
	@throw [NSException exceptionWithName:@"RSRCTaskGroup onSubTaskComplete Invocation"
								   reason:@"This is an abstract method and must be implemented in a subclass."
								 userInfo:nil];
}

-(void) onSubTaskFault:(NSError*)error
{
	[self fault:error];
}

-(void) onSubTaskCancel:(RSRCTask*)task
{
	for (NSString* uuid in [_dependencyMap objectForKey:task.uuid])
	{
		for (RSRCTask* dependency in _tasks)
		{
			if([dependency.uuid isEqualToString:uuid])
			{
				_canceledIndex++;
				dependency.state = RSRCTaskStateCanceled;
			}
		}
	}
}

-(void) addSubTask:(RSRCTask*)task
{
	if (task == nil || self.state == RSRCTaskStateCanceled) return;
	[self setDependeciesForTask:task];
	[_tasks addObject:task];
}

-(void) addSubTask:(RSRCTask*)task
		 afterTask:(RSRCTask *)afterTask
{
	if (task == nil || self.state == RSRCTaskStateCanceled) return;
	[self setDependeciesForTask:task];
	NSInteger index = [_tasks indexOfObject:afterTask];
	[_tasks insertObject:task atIndex:(index+1)];
}

-(void) removeSubTask:(RSRCTask*)task
{
	if (task == nil) return;
	NSInteger index = [_tasks indexOfObject:task];
	if (index >= 0) [_tasks removeObjectAtIndex:index];
}

-(void) cancel
{
	[super cancel];
	for (RSRCTask* task in _tasks)
	{
		// we only want to cancel those tasks that are currently running
		// otherwise we want to set the canceled flag
		if (task.state>RSRCTaskStateInitialized)[task cancel];
		else task.state = RSRCTaskStateCanceled;
	}
}

#pragma mark - Getters/Setters

-(void) setTasks:(NSMutableArray *)tasks
{
	_tasks = tasks;
	for (RSRCTask* task in tasks) [self setDependeciesForTask:task];
}

#pragma mark - Private Methods

- (void) setDependeciesForTask:(RSRCTask*)task
{
	[_dependencyMap setObject:[@[] mutableCopy] forKey:task.uuid];
	for (RSRCTask* dependency in task.dependencies)
	{
		[[_dependencyMap objectForKey:dependency.uuid] addObject:task.uuid];
	}
}

@end
