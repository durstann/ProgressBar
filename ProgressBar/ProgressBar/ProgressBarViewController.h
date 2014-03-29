//
//  ProgressBarViewController.h
//  ProgressBar
//
//  Created by Aaron Schneider on 1/21/14.
//  Copyright (c) 2014 Aaron Schneider. All rights reserved.
//

/*********************************
 Specification for the view controller that drives the progress bar example code.
 *********************************/
#import <UIKit/UIKit.h>

@interface ProgressBarViewController : UIViewController

//This is the piece that moves inside the progress bar.  It is a child of a view that is setup to do nothing
//except clip the bar as it moves so that it appears to get smaller.
@property (nonatomic, retain) IBOutlet UIView* mProgressBarFillView;

//This piece lives behind mProgressBarFillView.  When the view is chunking down it waits for a bit then
//begins to move.  For other operations it is simply hidden.
@property (nonatomic, retain) IBOutlet UIView* mProgressBarChunkFillView;

//To provide a pleasing roundness to the views we add all the pieces of the progress bar here and then use
//UIKit's builtin functionality to round the corners.
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray* mViewsToApplyCornerRadius;

//These are all the button press handlers.  For more information see their individual implementations.
- (IBAction)onStartPressed:(id)sender;
- (IBAction)onStopPressed:(id)sender;
- (IBAction)onResetPressed:(id)sender;
- (IBAction)onChunkDownPressed:(id)sender;
@end