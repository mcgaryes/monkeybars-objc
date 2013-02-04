//
//  MBTaskGroup.m
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


#import "MBTaskGroup.h"

@interface MBTaskGroup()

/**
 * A dictionary of dependencies for sub tasks
 */
@property (nonatomic,strong) NSMutableDictionary* dependencyMap;

@end

@implementation MBTaskGroup

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

-(BOOL) processSubTask:(MBTask *)task
{
	
	if (task == nil) @throw [NSException exceptionWithName:@"MBTaskGroup processSubTask Invocation"
													reason:@"You cannot process a task with a nil value."
												  userInfo:nil];
	
	if(task.state == MBTaskStateCanceled)
	{
		// We are running the sub task canceled functionality here
		// because there is a chance that the task being about to run
		// was dependent on a task that was previously canceled in the queue
		// and we need to make sure that it notifies any tasks that may
		// be dependent on itself that they also should be canceled
		NSLog(@"\t--\tMBTask:    Skipped:\t%@",task.name);
		[self onSubTaskCancel:task];
		return YES;
	}
	
	// set concurrency for the sub tasks
	task.concurrent = self.concurrent;
	task.group = self;
	
	// set execution block
	__weak MBTask* wTask = task;
	[task setExecutionBlock:^(MBTaskState s, MBTaskProgress* p, NSError *e)
	 {
		 if(s == MBTaskStateCompleted)[self onSubTaskComplete];
		 else if(s == MBTaskStateFaulted)[self onSubTaskFault:e];
		 else if(s == MBTaskStateCanceled) [self onSubTaskCancel:wTask];
	 }];
	
	[task start];
	
	return NO;
}

-(void) onSubTaskComplete
{
	@throw [NSException exceptionWithName:@"MBTaskGroup onSubTaskComplete Invocation"
								   reason:@"This is an abstract method and must be implemented in a subclass."
								 userInfo:nil];
}

-(void) onSubTaskFault:(NSError*)error
{
	[self fault:error];
}

-(void) onSubTaskCancel:(MBTask*)task
{
	for (NSString* uuid in [_dependencyMap objectForKey:task.uuid])
	{
		for (MBTask* dependency in _tasks)
		{
			if([dependency.uuid isEqualToString:uuid])
			{
				_canceledIndex++;
				dependency.state = MBTaskStateCanceled;
			}
		}
	}
}

-(void) addSubTask:(MBTask*)task
{
	if (task == nil || self.state == MBTaskStateCanceled) return;
	[self setDependeciesForTask:task];
	[_tasks addObject:task];
}

-(void) addSubTask:(MBTask*)task
		 afterTask:(MBTask *)afterTask
{
	if (task == nil || self.state == MBTaskStateCanceled) return;
	[self setDependeciesForTask:task];
	NSInteger index = [_tasks indexOfObject:afterTask];
	[_tasks insertObject:task atIndex:(index+1)];
}

-(void) removeSubTask:(MBTask*)task
{
	if (task == nil) return;
	NSInteger index = [_tasks indexOfObject:task];
	if (index >= 0) [_tasks removeObjectAtIndex:index];
}

-(void) cancel
{
	[super cancel];
	for (MBTask* task in _tasks)
	{
		// we only want to cancel those tasks that are currently running
		// otherwise we want to set the canceled flag
		if (task.state>MBTaskStateInitialized)[task cancel];
		else task.state = MBTaskStateCanceled;
	}
}

#pragma mark - Getters/Setters

-(void) setTasks:(NSMutableArray *)tasks
{
	_tasks = tasks;
	for (MBTask* task in tasks) [self setDependeciesForTask:task];
}

#pragma mark - Private Methods

- (void) setDependeciesForTask:(MBTask*)task
{
	[_dependencyMap setObject:[@[] mutableCopy] forKey:task.uuid];
	for (MBTask* dependency in task.dependencies)
	{
		[[_dependencyMap objectForKey:dependency.uuid] addObject:task.uuid];
	}
}

@end
