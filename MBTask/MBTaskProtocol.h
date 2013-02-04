//
//  MBTaskProtocol.h
//  Tackk
//
//  Created by Eric McGary on 8/17/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTaskProgress.h"

/**
 * The type of task 
 */
typedef enum : NSInteger
{
	MBParallelTaskType,
	MBSequenceTaskType,
	MBSimpleTaskType
} MBTaskType;

/**
 * The state of the task
 */
typedef enum : NSInteger
{
	MBTaskStateInitialized,
	MBTaskStateStarted,
	MBTaskStateCanceled,
	MBTaskStateFaulted,
	MBTaskStateCompleted
} MBTaskState;

@protocol MBTaskProtocol <NSObject>

/**
 * Kicks off the task execution
 */
-(void) start;

/**
 *
 */
-(void) progress:(MBTaskProgress*) progress;

/**
 * sets the tasks canceled status
 */
-(void) cancel;

/**
 * Called from subclass when the task is complete
 * @param {MBTask} task - reference to the subclass itself
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
-(void) setExecutionBlock:(void(^)(MBTaskState state, MBTaskProgress* progress, NSError* error))block;

/**
 * A way to perform a task inline instead of having to write a seperate class
 */
+ (void) performTaskWithBlock:(void(^)(id task))task
            andExecutionBlock:(void(^)(MBTaskState state, MBTaskProgress* progress, NSError* error))block;

@end
