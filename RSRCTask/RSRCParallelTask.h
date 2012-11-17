//
//  RSRCParallelTask.h
//  SequenceTask
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "RSRCTaskGroup.h"

@interface RSRCParallelTask : RSRCTaskGroup

/**
 * In some cases two seperate tasks running parellel may complete at exactely the same time
 * this prop is set after the completion functionality is run the first time so that
 * it is not run a second time.
 */
@property (nonatomic) BOOL completed;

@end
