//
//  MBSequenceTask.h
//  SequenceTask
//
//  Created by Eric McGary on 8/14/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "MBTaskGroup.h"

@interface MBSequenceTask : MBTaskGroup

-(void) startNextSubTask;

@end
