//
//  MBParallelTask.m
//  SequenceTask
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "MBParallelTask.h"

@interface MBParallelTask()

@end

@implementation MBParallelTask

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
	for (MBTask* task in self.tasks)
	{
		if(task.state != MBTaskStateCanceled) return false;
	}
	return true;
}

-(void) processSubTasks
{
	for (MBTask* task in self.tasks)
	{
		self.currentIndex++;
		[self processSubTask:task];
	}
}

-(void) addSubTask:(MBTask*)task
{
	if (task == nil || task.state == MBTaskStateCanceled) return;
	self.currentIndex++;
	[self.tasks addObject:task];
	[self processSubTask:task];
}

-(void) onSubTaskComplete
{
	[self progress:[[MBTaskProgress alloc] init]];
	// run complete
	if(self.currentIndex-- <= 1)
	{
		_completed = YES;
		[self complete];
	}
}

-(void) progress:(MBTaskProgress*)progress
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

-(MBTaskType) type
{
	return MBParallelTaskType;
}

@end
