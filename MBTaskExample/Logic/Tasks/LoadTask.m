//
//  LoadTask.m
//  TaskLibrary
//
//  Created by Eric McGary on 8/18/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "LoadTask.h"
#import "AFNetworking.h"

@interface LoadTask()

@property (nonatomic) NSInteger iterations;
@property (nonatomic,strong) AFJSONRequestOperation *operation;
@property (nonatomic,strong) NSTimer* timer;

@end

@implementation LoadTask

#pragma mark - Custom Methods

-(id) initWithIterations:(NSInteger)iterations
{
	if(self = [super init]) _iterations = iterations;
	return self;
}

-(void) handleTimer:(NSTimer*)timer
{
	
	[self performActionOnMainQueue:^{
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadTaskCanceled"
															object:self
														  userInfo:nil];
	}];
	
	[self cancel];
}

#pragma mark - Overridden Methods

-(void) performTask
{
	
	if(NO)//arc4random_uniform(10)>5)
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:2.0
												  target:self
												selector:@selector(handleTimer:)
												userInfo:nil
												 repeats:NO];
		
		[[NSRunLoop currentRunLoop] run];
	}
	else
	{
		
		NSURL *url = [NSURL URLWithString:@"http://tackk.r1l4b.com/services/tackks.php?num=5000"];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		_operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
			
			if(self.state == MBTaskStateCanceled) return;
			
			[self performActionOnTaskQueue:^{
				
				for (NSInteger i=0; i<10000000; i++)
				{
					if([@"b" isEqualToString:@"c"]) NSLog(@"b");
				}
				
				[self complete];
				
			}];
			
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
			
			[self performActionOnTaskQueue:^{
				[self fault:error];
			}];
			
		}];
		
		[_operation start];
	}
	
}

-(void) complete
{
	if([_timer isValid]) [_timer invalidate];
	
	[self performActionOnMainQueue:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadTaskCompleted"
															object:self
														  userInfo:nil];
	}];
	
	[super complete];
}

-(void) cancel
{
	[_operation cancel];
	[super cancel];
}

@end