//
//  UploadTask.m
//  TaskLibrary
//
//  Created by Eric McGary on 9/17/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import "UploadTask.h"
#import "AFNetworking.h"

@interface UploadTask()

@property (nonatomic,strong) AFHTTPRequestOperation* operation;

@end

@implementation UploadTask

-(void) performTask
{
	
	AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://tackk.ril4b.com/services"]];
	
	UIImage* image = [UIImage imageNamed:@"image.jpg"];
	NSData *imageData = UIImagePNGRepresentation(image);
	NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
															  path:@"/upload"
														parameters:nil
										 constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
											 
											 [formData appendPartWithFileData:imageData
																		 name:@"image"
																	 fileName:@"image"
																	 mimeType:@"image/jpg"];

										 }];
	
	_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[_operation start];
	
}

-(void) cancel
{
	// cancel the operation
	[super cancel];
}

@end
