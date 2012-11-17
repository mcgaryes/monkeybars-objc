//
//  ViewController.h
//  TaskLibrary
//
//  Created by Eric McGary on 8/17/12.
//  Copyright (c) 2012 Eric McGary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *concurrentSwitch;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *appendLabel;

- (IBAction)runTaskButtonTap:(id)sender;
- (IBAction)cancelTaskButtonTap:(id)sender;

@end
