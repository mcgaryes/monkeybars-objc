//
//  RSRCTaskProtocol.h
//  Tackk
//
//  Created by Eric McGary on 8/17/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSRCTaskProgress.h"

/**
 * The type of task 
 */
typedef enum : NSInteger
{
	RSRCParallelTaskType,
	RSRCSequenceTaskType,
	RSRCSimpleTaskType
} RSRCTaskType;

/**
 * The state of the task
 */
typedef enum : NSInteger
{
	RSRCTaskStateInitialized,
	RSRCTaskStateStarted,
	RSRCTaskStateCanceled,
	RSRCTaskStateFaulted,
	RSRCTaskStateCompleted
} RSRCTaskState;

@protocol RSRCTaskProtocol <NSObject>

/**
 * Kicks off the task execution
 */
-(void) start;

/**
 *
 */
-(void) progress:(RSRCTaskProgress*) progress;

/**
 * sets the tasks canceled status
 */
-(void) cancel;

/**
 * Called from subclass when the task is complete
 * @param {RSRCTask} task - reference to the subclass itself
 */
-(void) complete;

/**
 * to be called if the subtask fails in any way
 * @param {NSError} error - error to be filled with relevant info about the fault
 */
-(void) fault:(NSError*)error;

/**
 * runs the task. this is the area where a concrete task will perform its core functionality
 */
-(void) performTask;

/**
 * Perform a block of code on the tasks queue rather than the main queue
 */
-(void) performActionOnTaskQueue:(void (^)(void))action;

/**
 * Perform a block of code on the main queue instead of the task queue which main be on a background
 * thread and thus not thread safe
 */
-(void) performActionOnMainQueue:(void (^)(void))action;

/**
 * description
 * @param {Block} block - description
 */
-(void) setExecutionBlock:(void(^)(RSRCTaskState state, RSRCTaskProgress* progress, NSError* error))block;

@end
