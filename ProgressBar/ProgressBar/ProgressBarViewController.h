//
//  ProgressBarViewController.h
//  ProgressBar
//
//  Created by Aaron Schneider on 1/21/14.
//  Copyright (c) 2014 Pod 6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarViewController : UIViewController
@property (nonatomic, assign) float mTargetPercentage;

- (IBAction)onStartPressed:(id)sender;
- (IBAction)onStopPressed:(id)sender;
- (IBAction)onResetPressed:(id)sender;
- (IBAction)onChunkDownPressed:(id)sender;
- (IBAction)onChunkUpPressed:(id)sender;
@end