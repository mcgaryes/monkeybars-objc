//
//  MBTaskProgress.h
//  TaskLibrary
//
//  Created by Eric McGary on 8/20/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTaskProgress : NSObject

/**
 * How many tasks have completed if the task is of type task group
 */
@property (nonatomic) NSInteger complete;

/**
 * How many tasks are in the group if the task is of type task group
 */
@property (nonatomic) NSInteger size;

/**
 * The task the progress object is coming from or if its a group 
 */
@property (nonatomic,weak) NSString* task;

/**
 * Reference to the tasks group if it has one
 */
@property (nonatomic,weak) NSString* group;

/**
 * The percentage complete of the task executing
 */
@property (nonatomic) float percentage;

@end
