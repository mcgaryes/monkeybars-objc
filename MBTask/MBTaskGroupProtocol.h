//
//  MBTaskGroupProtocol.h
//  Tackk
//
//  Created by Eric McGary on 8/17/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTaskProtocol.h"

@protocol MBTaskGroupProtocol <NSObject>

/**
 * Adds a sub task to the tasks array
 * @param {id<MBTaskProtocol>} task - a task instance from the tasks array
 */
-(void) addSubTask:(id<MBTaskProtocol>)task;

/**
 * Adds a sub task to the tasks array after a specified task
 * @param {id<MBTaskProtocol>} task - a task instance from the tasks array
 * @param {id<MBTaskProtocol>} afterTask - a task instance from the tasks array
 */
-(void) addSubTask:(id<MBTaskProtocol>)task afterTask:(id<MBTaskProtocol>)afterTask;

/**
 * Removes a sub task from the tasks array
 * @param {id<MBTaskProtocol>} task - a task instance from the tasks array
 */
-(void) removeSubTask:(id<MBTaskProtocol>)task;

/**
 * Processing for a sub task that sets completion blocks as well as starts
 * the sub task
 * @param {id<MBTaskProtocol>} task - a task instance from the tasks array
 */
-(BOOL) processSubTask:(id<MBTaskProtocol>)task;

/**
 * Functionality to be performed on a sub tasks completion. This method
 * should be ovverriden in the concrete implementation.
 */
-(void) onSubTaskComplete;

/**
 * Functionality to be performed on a sub tasks fault. This method
 * should be ovverriden in the concrete implementation.
 * @param {NSError*} error - error thrown from sub task fault
 */
-(void) onSubTaskFault:(NSError*)error;

/**
 *
 */
-(void) onSubTaskCancel:(id<MBTaskProtocol>)task;

@end
