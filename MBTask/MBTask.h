//
//  Task.h
//  Tackk
//
//  Abstract class should not be instantiated, rather subclassed.
//
//  Created by Eric McGary on 8/2/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTaskGroupProtocol.h"
#import "MBTaskProtocol.h"

/**
 * execution block for callback functionality
 */
typedef void (^ExecutionBlock)(MBTaskState, MBTaskProgress *, NSError *);
typedef void (^TaskBlock)(id task);

@interface MBTask : NSObject <MBTaskProtocol>

/**
 * YES - multithread capable 
 */
@property (nonatomic) BOOL concurrent;

/**
 * Unique identifier for the task
 */
@property (nonatomic,strong) NSString* uuid;

/**
 * the string representation of the class (for debugging purposes)
 */
@property (nonatomic,strong) NSString* name;

/**
 * The type of task (e.g. parellel, sequence, simple (a.k.a. Task))
 */
@property (nonatomic,readonly) MBTaskType type;

/**
 * The current state of the task
 */
@property (nonatomic) MBTaskState state;

/**
 * The group in which this task belongs will be nil if it does not belong to a group
 */
@property (nonatomic,strong) id<MBTaskGroupProtocol> group;

/**
 * Tasks this task is dependent on... only used if task is contained in a group
 */
@property (nonatomic,strong) NSArray* dependencies;

@end