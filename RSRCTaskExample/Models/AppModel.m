//
//  TKAppModel.m
//  Tackk
//
//  Created by Kristopher Schultz on 5/21/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

#pragma mark - Static methods

+ (AppModel *)sharedInstance 
{
	static AppModel *_sharedInstance;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
        _sharedInstance = [[self alloc] init];
    });
	return _sharedInstance;
}

#pragma mark - Overridden Methods


- (id)init
{
    self = [super init];
    
    if (self)
	{
		self.array = [@[] mutableCopy];
	}
    
    return self;
}


@end
