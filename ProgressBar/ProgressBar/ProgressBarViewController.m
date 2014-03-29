//
//  ProgressBarViewController.m
//  ProgressBar
//
//  Created by Aaron Schneider on 1/21/14.
//  Copyright (c) 2014 Aaron Schneider. All rights reserved.
//

/*********************************
 Implementation for the view controller that drives the progress bar example code.
 *********************************/
#import "ProgressBarViewController.h"

@implementation ProgressBarViewController

- (void)chunkProgressBarToPercentage:(float)targetPercentage
{
    float offset =  self.mProgressBarFillView.frame.size.width * (1.0f - targetPercentage);
    [self updateProgressBarToPercentage:self.currentPercentage];
    self.mProgressBarChunkFillView.hidden = NO;
    self.mProgressBarFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
    [UIView animateWithDuration:0.7f
                          delay:0.3f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.mProgressBarChunkFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                     }
                     completion:^(BOOL completion){
                         //nothing to do here
                     }];
}

- (void)updateProgressBarToPercentage:(float)targetPercentage
{
    float offset =  self.mProgressBarFillView.frame.size.width * (1.0f - targetPercentage);
    float duration = 10.0f * fabsf(self.currentPercentage - targetPercentage);
    self.mProgressBarChunkFillView.hidden = YES;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.mProgressBarFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                         self.mProgressBarChunkFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                          }
                     completion:^(BOOL completion){
                         //nothing to do here
                     }];
}

- (float)currentPercentage
{
    CALayer* presentationLayer = self.mProgressBarFillView.layer.presentationLayer;
    CATransform3D presentationTransform = presentationLayer.transform;
    float percentage = presentationTransform.m41 / self.mProgressBarFillView.frame.size.width;
    
    return 1.0f + percentage;
}

/*********************************
 Here is some initialization code that is called automatically when the view is loaded.
 *********************************/
- (void) viewDidLoad
{
    //Loop through all the views related to our progress bar and apply a nice corner radius.
    //There is no way to set this through interface builder so we have to do it programatically.
    for (UIView* cornerView in self.mViewsToApplyCornerRadius)
    {
        //By basing the corner radius on the height of the view we make each view
        //perfectly rounded at the ends.
        cornerView.layer.cornerRadius = cornerView.frame.size.height * 0.5f;
    }
}

/*********************************
 Button press handlers. 
 Note that these are triggered on the "Touch Up Inside" event for the buttons. This is a common practice in iOS
 and allows the user to cancel their action by sliding their finger off the button.
 *********************************/
- (IBAction)onStartPressed:(id)sender
{
    // Start moving the bar to empty, or 0 percent
    [self updateProgressBarToPercentage:0.0f];
}

- (IBAction)onStopPressed:(id)sender
{
    // "Stopping" is achieved by "moving" the bar to wherever it currently is located.
    [self updateProgressBarToPercentage:self.currentPercentage];
}

- (IBAction)onResetPressed:(id)sender
{
    // "Reset" the bar to 100 percent full
    [self updateProgressBarToPercentage:1.0f];
}

- (IBAction)onChunkDownPressed:(id)sender
{
    // Calculate where we want to be by taking the current percentage and subtracting 10%
    // This gives us ten chunks that we can perform.
    // Note also that we use the MAX macro to make sure we don't end up with a negative percentage
    float newPercentage = MAX(0.0f, self.currentPercentage - 0.1f);
 
    // Call the chunking code
    [self chunkProgressBarToPercentage:newPercentage];
}

/*********************************
 The following is some standard view controller code that handles initialization and
 Allows the app to rotate when the phone is turned upside down.
 *********************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Any custom initialization code would be done here.
        // As an example app, this code is not necessary but is left here for the sake of completeness.
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end

////////// END OF FILE
