//
//  RITaskOperation.m
//  Tackk
//
//  Created by Eric McGary on 8/2/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//
//

#import "MBTask.h"

@interface MBTask()

@property (nonatomic,strong) ExecutionBlock block;
@property (nonatomic,strong) NSOperationQueue* queue;
@property (nonatomic,strong) TaskBlock taskBlock;

@end

@implementation MBTask

#pragma mark - Initialization

-(id) init
{
	if(self=[super init])
	{
		_concurrent = NO;
		_state = MBTaskStateInitialized;
	}
	return self;
}

#pragma mark - Static Methods

+ (void) performTaskWithBlock:(void(^)(id t))task
            andExecutionBlock:(void(^)(MBTaskState state, MBTaskProgress* progress, NSError* error))block
{
    MBTask* blockTask = [[MBTask alloc] init];
    blockTask.concurrent = YES;
    blockTask.taskBlock = task;
    blockTask.block = block;
    [blockTask start];
}

#pragma mark - Public Methods

-(void) start
{
	if(_state >= MBTaskStateStarted) return;
	_state = MBTaskStateStarted;
	NSLog(@"\tO\tMBTask: %@ Starting:\t%@",(!self.group?@"**":@"  "),self.name);
	
	if(_block) _block(_state,nil,nil);
	
	if(_concurrent)
	{
		[_queue addOperationWithBlock:^{
			//@synchronized(self) {
			[self performTask];
			//}
		}];
	}
	else
	{
		[self performTask];
	}
	
}

-(void) progress:(MBTaskProgress*)progress
{
	if(_concurrent && !self.group)
	{
		[_queue addOperationWithBlock:^(void) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				// @TODO: Fix The progress execution block
				//if(_block) _block(_state,progress,nil);
			}];
		}];
	}
	else if (!self.group)
	{
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			//if(_block)_block(_state,nil,nil);
		}];
	}
	else
	{
		// @TODO: Fix The progress execution block
		//if(_block) _block(_state,progress,nil);
	}
}

-(void) performTask
{
	@throw [NSException exceptionWithName:@"Abstract Method Invocation - performTask"
								   reason:@"This is an abstract method and must be implemented in a subclass."
								 userInfo:nil];
}

-(void) complete
{
	if(_state > MBTaskStateStarted) return;
	_state = MBTaskStateCompleted;
	NSLog(@"\tI\tMBTask: %@ Completed:\t%@",(!self.group?@"**":@"  "),self.name);
	
	if(_concurrent && !self.group)
	{
		[self performActionOnMainQueue:^{
			if(_block) _block(_state,nil,nil);
			[_queue cancelAllOperations];
		}];
	}
	else if (!self.group)
	{
		[self performActionOnMainQueue:^{
			if(_block) _block(_state,nil,nil);
		}];
	}
	else
	{
		if(_block) _block(_state,nil,nil);
	}
	
}

-(void) fault:(NSError*)error
{
	if (_state >= MBTaskStateCanceled) return;
	_state = MBTaskStateFaulted;
	NSLog(@"\tF\tMBTask:    Faulted:\t%@",self.name);
	
	if(_concurrent && !self.group)
	{
		[_queue addOperationWithBlock:^(void) {
			[self performActionOnMainQueue:^{
				if(_block) _block(_state,nil,error);
				[_queue cancelAllOperations];
			}];
		}];
	}
	else if (!self.group)
	{
		[self performActionOnMainQueue:^{
			if(_block) _block(_state,nil,error);
		}];
	}
	else
	{
		if(_block) _block(_state,nil,error);
	}
	
}

-(void) cancel
{
	
	if(_state > MBTaskStateStarted) return;
	_state = MBTaskStateCanceled;
	NSLog(@"\tI\tMBTask:    Canceled:\t%@",self.name);
	
	if(_concurrent && !self.group)
	{
		[_queue addOperationWithBlock:^(void) {
			[self performActionOnMainQueue:^{
				if(_block) _block(_state,nil,nil);
				[_queue cancelAllOperations];
			}];
		}];
	}
	else if (!self.group)
	{
		[self performActionOnMainQueue:^{
			if(_block) _block(_state,nil,nil);
		}];
	}
	else
	{
		if(_block) _block(_state,nil,nil);
	}
}

-(void) performActionOnTaskQueue:(void (^)(void))action
{
	if(_concurrent)
	{
		[_queue addOperationWithBlock:^{
			//@synchronized(self){
			action();
			//}
		}];
	}
	else
	{
		[self performActionOnMainQueue:action];
	}
	
}

-(void) performActionOnMainQueue:(void (^)(void))action
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{ action(); }];
}

#pragma mark - Getters/Setters

- (NSString *)uuid
{
	if(!_uuid)
	{
		CFUUIDRef theUUID = CFUUIDCreate(NULL);
		NSString *uuidString = (__bridge_transfer NSString *) CFUUIDCreateString(NULL, theUUID);
		CFRelease(theUUID);
		_uuid = [self.name stringByAppendingFormat:@"-%@",uuidString];
	}
    return _uuid;
}

-(NSString*) name
{
	if(!_name) return NSStringFromClass([self class]);
	return _name;
}

-(MBTaskType) type
{
	return MBSimpleTaskType;
}

-(void) setConcurrent:(BOOL)concurrent
{
	_concurrent = concurrent;
	if(_concurrent)
	{
		_queue = [[NSOperationQueue alloc] init];
		_queue.name = self.name;
	}
}

-(void) setExecutionBlock:(void (^)(MBTaskState, MBTaskProgress* progress, NSError *))block
{
	_block = block;
}

@end
