//
//  RSRCTaskGroup.m
//  SequenceTask
//
//  Abstract class for group task queues. Should be overridden.
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "RSRCTask.h"
#import "RSRCTaskGroupProtocol.h"

@interface RSRCTaskGroup : RSRCTask <RSRCTaskGroupProtocol>

/**
 * Array of tasks to preform in the group
 */
@property (nonatomic,strong) NSMutableArray* tasks;

/**
 * The index of the task currently executing
 */
@property (nonatomic) NSInteger currentIndex;

/**
 * The number of tasks that have been canceled. Number is important
 * for reporting task progress
 */
@property (nonatomic) NSInteger canceledIndex;

@end

