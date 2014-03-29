//
//  ProgressBarViewController.m
//  ProgressBar
//
//  Created by Aaron Schneider on 1/21/14.
//  Copyright (c) 2014 Aaron Schneider. All rights reserved.
//

/*********************************
 Implementation for the view controller that drives the progress bar example code.
 
 It is important to note that when we animate the elements we use the .transform property.
 We could manipulate the .frame property but this causes side effects that can slow down our application 
 significantly.
 For more information visit stonecorridors.blogspot.com
 *********************************/
#import "ProgressBarViewController.h"

@implementation ProgressBarViewController

//Animate the progress bar fill to a specified percentage.
- (void)updateProgressBarToPercentage:(float)targetPercentage
{
    //First thing we do is make sure that the passed in parameter is valid.
    //targetPercentage needs to be no smaller than 0.0 and no larger than 1.0
    targetPercentage = MAX(0.0f, targetPercentage);
    targetPercentage = MIN(1.0f, targetPercentage);
    
    //We are not chunking so we don't want to see any part of the chunk fill view.
    self.mProgressBarChunkFillView.hidden = YES;
    
    //Calculate how far the bar has to move.  This is based on the width of the bar.
    //We subtract the targetPercentage from one so that if we want to show 90% of the bar
    //we move the bar 10% of its width to the left.
    float offset =  self.mProgressBarFillView.frame.size.width * (1.0f - targetPercentage);
    
    //Now we calculate how long the bar should take to move. We want the bar to fully fill or drain
    //in 10 seconds. So the amount of time we take is based on the difference between where we are now
    //and where we want to be. We take the absolute value so that it doesn't matter if we are increasing
    //or decreasing.
    float duration = 10.0f * fabsf(self.currentPercentage - targetPercentage);
    
    //Now we use the UIView animation helpers to setup an animation. Everything from here on out is handled by
    //UIKit.
    //There are two options used here
    //  UIViewAnimationOptionBeginFromCurrentState  - The animation run smoothly from wherever it already is
    //  UIViewAnimationOptionCurveLinear            - The animation runs at the same speed for the duration
    //For more information visit Apple's reference pages
    //  http://developer.apple.com/library/ios/documentation/uikit/reference/uiview_class/uiview/uiview.html
    [UIView animateWithDuration:duration    //Here is the duration we calculated previously
                          delay:0.0f        //Start immediately.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         //We set the final transform here. The animateWithDuration function will move the
                         //view from its current position to the position we have specified here.
                         //We use the negative of the offset because we want the bar to drain to the left.
                         self.mProgressBarFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                         
                         //Even though we hid it we still animate the chunk fill view so that it starts
                         //from the correct location if this animation gets interrupted by a chunking animation
                         self.mProgressBarChunkFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                          }
                     completion:nil]; //we don't have anything we want to do when the animation is finished
}

//Chunking is common in fighting games.  By leaving a shadow behind the main progress fill the user has a window
//of time where they can see the bar's previous values and current value at the same time.
- (void)chunkProgressBarToPercentage:(float)targetPercentage
{
    //First thing we do is make sure that the passed in parameter is valid.
    //targetPercentage needs to be no smaller than 0.0 and no larger than 1.0
    targetPercentage = MAX(0.0f, targetPercentage);
    targetPercentage = MIN(1.0f, targetPercentage);
    
    
    //Calculate how far the bar has to move.  This is based on the width of the bar.
    //We subtract the targetPercentage from one so that if we want to show 90% of the bar
    //we move the bar 10% of its width to the left.
    float offset =  self.mProgressBarFillView.frame.size.width * (1.0f - targetPercentage);
    
    //Stop any current animations. This is the same code use in the onStopPressed button handler
    //This is slightly inefficient but means we have fewer places where we have to fix any bugs that occur.
    [self updateProgressBarToPercentage:self.currentPercentage];
    
    //Make sure the chunking fill is not hidden. Do it after the updateProgressBarToPercentage function call
    //to make sure it is not hidden.
    self.mProgressBarChunkFillView.hidden = NO;
    
    //Immediately move the fill to the desired position.
    //We use the negative of the offset because we want the bar to drain to the left.
    self.mProgressBarFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
    
    //Now we use the UIView animation helpers to setup an animation. Everything from here on out is handled by
    //UIKit.
    //There are two options used here
    //  UIViewAnimationOptionBeginFromCurrentState  - The animation run smoothly from wherever it already is
    //  UIViewAnimationOptionCurveLinear            - The animation runs at the same speed for the duration
    //For more information visit Apple's reference pages
    //  http://developer.apple.com/library/ios/documentation/uikit/reference/uiview_class/uiview/uiview.html
    [UIView animateWithDuration:0.7f    //The whole chunk action takes a total of 1.0 second (duration + delay)
                          delay:0.3f    //Wait for a little time before starting to move the chunk fill.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         //We set the final transform here. The animateWithDuration function will move the
                         //view from its current position to the position we have specified here.
                         //We use the negative of the offset because we want the bar to drain to the left.
                         self.mProgressBarChunkFillView.transform = CGAffineTransformMakeTranslation(-offset, 0);
                     }
                     completion:nil]; //we don't have anything we want to do when the animation is finished
}

//This is a helper function that figures out the current percentage the progress bar is at even in the middle
//of an animation.
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
