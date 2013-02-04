//
//  MBTaskProgress.m
//  TaskLibrary
//
//  Created by Eric McGary on 8/20/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "MBTaskProgress.h"

@implementation MBTaskProgress

-(float) percentage
{
	if(_percentage) return _percentage;
	if(_size && _complete) return (_complete/_size)*100;
	return 0;
}

@end
