//
//  TKAppModel.h
//  Tackk
//
//  Created by Kristopher Schultz on 5/21/12.
//  Copyright (c) 2012 Resource Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject


@property (nonatomic,strong) NSMutableArray* array;
@property (nonatomic,strong) NSString* string;
@property (nonatomic) NSInteger number;

/**
 Returns a reference to the single shared instance of this class. Use this to 
 access an AppModel instance rather than instantiating a new instance of
 AppModel.
 */
+ (id)sharedInstance;

@end
