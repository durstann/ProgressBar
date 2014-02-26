//
//  ProgressBarViewController.m
//  ProgressBar
//
//  Created by Aaron Schneider on 1/21/14.
//  Copyright (c) 2014 Pod 6. All rights reserved.
//

#import "ProgressBarViewController.h"

@interface ProgressBarViewController ()

@end

#define PI 3.141592656
#define RADTODEG(x) ((x) * (180.0 / PI))
#define DEGTORAD(x) ((x) / 180.0 * PI)

@implementation ProgressBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onStartPressed:(id)sender
{
    [self updateProgressBarToPercentage:0.0f];
}

- (IBAction)onStopPressed:(id)sender
{
    [self updateProgressBarToPercentage:self.currentPercentage];
}

- (IBAction)onResetPressed:(id)sender
{
    [self updateProgressBarToPercentage:1.0f];
}

- (IBAction)onChunkDownPressed:(id)sender
{
    
}

- (IBAction)onChunkUpPressed:(id)sender
{
    
}

- (float)currentPercentage
{
    CALayer* presentationLayer = self.mProgressBarFillView.layer.presentationLayer;
    CATransform3D presentationTransform = presentationLayer.transform;
    float percentage = presentationTransform.m41 / self.mProgressBarFillView.frame.size.width;
    
    return 1.0f + percentage;
}

- (void)updateProgressBarToPercentage:(float)targetPercentage
{
    float offset =  self.mProgressBarFillView.frame.size.width * (1.0f - targetPercentage);
    float duration = 10.0f * fabsf(self.currentPercentage - targetPercentage);
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                            self.mProgressBarFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                            self.mProgressBarFillBackgroundView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                          }
                     completion:^(BOOL completion){
                         //nothing to do here
                     }];
}
@end