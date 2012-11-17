//
//  ViewController.m
//  TaskLibrary
//
//  Created by Eric McGary on 8/17/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "ViewController.h"
#import "AppModel.h"
#import "RSRCSequenceTask.h"
#import "RSRCParallelTask.h"
#import "LoadTask.h"

@interface ViewController ()

@property (nonatomic,strong) RSRCTaskGroup* group;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_stateLabel.text = @"Waiting";
	
	//[self animateBox];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleLoadTaskComplete:)
												 name:@"LoadTaskCompleted"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleLoadTaskCanceled:)
												 name:@"LoadTaskCanceled"
											   object:nil];
	
	_scrollView.contentSize = CGSizeMake(320,1200);
	
}


-(void) handleLoadTaskComplete:(NSNotification*)note
{
	_appendLabel.text = @"SubTask Complete";
}

-(void) handleLoadTaskCanceled:(NSNotification*)note
{
	_appendLabel.text = @"SubTask Canceled";
}


- (void)viewDidUnload
{
	[self setStateLabel:nil];
	[self setBoxView:nil];
	[self setScrollView:nil];
	[self setContainerView:nil];
	[self setAppendLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)runTaskButtonTap:(id)sender
{
	
	
	// create the group we'll be running
	_group = [[RSRCParallelTask alloc] init];
	_group.name = @"Parent";
	// create the sub tasks that will be added to the group
	NSMutableArray* tasks = [@[] mutableCopy];
	for (NSInteger i= 0; i<3; i++)
	{
		LoadTask* task = [[LoadTask alloc] init];
		task.name = [NSString stringWithFormat:@"Child-%i",i];
		if(arc4random_uniform(10)>5 && i!=0)task.dependencies = @[[tasks objectAtIndex:i-1]];
		[tasks addObject:task];
	}
	
	// set some defaults
	_group.tasks = tasks;
	_group.concurrent = _concurrentSwitch.on;
	
	// set our execution block for the task group
	[_group setExecutionBlock:^(RSRCTaskState state, RSRCTaskProgress *progress, NSError *error) {
		if(state == RSRCTaskStateStarted)_stateLabel.text = @"Task group Running.";
		else if (state == RSRCTaskStateCompleted)_stateLabel.text = @"Task group complete.";
		else if (state == RSRCTaskStateFaulted)_stateLabel.text = [NSString stringWithFormat:@"Error: %@",error.localizedDescription];
		else if (state == RSRCTaskStateCanceled)_stateLabel.text = @"Task group canceled.";
	}];
	
	// kick off the task group
	[_group start];
	
}

- (IBAction)cancelTaskButtonTap:(id)sender
{
	[_group cancel];
}

@end
