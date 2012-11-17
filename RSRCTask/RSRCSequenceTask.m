//
//  RSRCSequenceTask.m
//  SequenceTask
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "RSRCSequenceTask.h"

@interface RSRCSequenceTask()

@end

@implementation RSRCSequenceTask

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
	[self startNextSubTask];
}

-(void) startNextSubTask
{
	if(self.state >= RSRCTaskStateCanceled) return;
	if (self.tasks && self.currentIndex < self.tasks.count)
	{
		BOOL skipped = [self processSubTask:[self.tasks objectAtIndex:self.currentIndex++]];
		if (skipped) [self startNextSubTask];
	}
	else
	{
		[self complete];
	}
}

-(void) onSubTaskComplete
{
	if(self.state == RSRCTaskStateCanceled) return;
	[self progress:[[RSRCTaskProgress alloc] init]];
	[self startNextSubTask];
}

-(void) onSubTaskCancel:(id<RSRCTaskProtocol>)task
{
	[super onSubTaskCancel:task];
	if(self.state != RSRCTaskStateCanceled) [self startNextSubTask];
}

-(void) progress:(RSRCTaskProgress*)progress
{
	progress.size = self.tasks.count - self.canceledIndex;
	progress.complete = self.currentIndex - self.canceledIndex;
	progress.task = [[self.tasks objectAtIndex:self.currentIndex-1] name];
	progress.group = self.name;
	[super progress:progress];
}

#pragma Getters/Setters

-(RSRCTaskType) type
{
	return RSRCSequenceTaskType;
}

@end
