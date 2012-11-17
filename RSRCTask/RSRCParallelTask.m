//
//  RSRCParallelTask.m
//  SequenceTask
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "RSRCParallelTask.h"

@interface RSRCParallelTask()

@end

@implementation RSRCParallelTask

-(id) init
{
	if(self = [super init])
	{
		self.currentIndex = 0;
	}
	return self;
}

-(void) performTask
{
	if ([self hasNoEnabledSubTasks])
	{
		[self complete];
	}
	else
	{
		[self processSubTasks];
	}
}

-(BOOL)hasNoEnabledSubTasks
{
	for (RSRCTask* task in self.tasks)
	{
		if(task.state != RSRCTaskStateCanceled) return false;
	}
	return true;
}

-(void) processSubTasks
{
	for (RSRCTask* task in self.tasks)
	{
		self.currentIndex++;
		[self processSubTask:task];
	}
}

-(void) addSubTask:(RSRCTask*)task
{
	if (task == nil || task.state == RSRCTaskStateCanceled) return;
	self.currentIndex++;
	[self.tasks addObject:task];
	[self processSubTask:task];
}

-(void) onSubTaskComplete
{
	[self progress:[[RSRCTaskProgress alloc] init]];
	// run complete
	if(self.currentIndex-- <= 1)
	{
		_completed = YES;
		[self complete];
	}
}

-(void) progress:(RSRCTaskProgress*)progress
{
	/*
	progress.size = self.tasks.count;
	progress.complete = (self.tasks.count + 1) - self.currentIndex;
	progress.task = [[self.tasks objectAtIndex:self.tasks.count - self.currentIndex] name];
	progress.group = self.name;
	[super progress:progress];
	 */
}

#pragma Getters/Setters

-(RSRCTaskType) type
{
	return RSRCParallelTaskType;
}

@end
