//
//  RSRCSequenceTask.h
//  SequenceTask
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "RSRCTaskGroup.h"

@interface RSRCSequenceTask : RSRCTaskGroup

-(void) startNextSubTask;

@end
