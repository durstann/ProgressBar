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

@end