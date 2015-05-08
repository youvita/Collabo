//
//  SpinnerView.m
//  FetchNews
//
//  Created by Chan Youvita on 3/6/15.
//  Copyright (c) 2015 kosign. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView

+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView{
    // Create a new view with the same frame size as the superView
    SpinnerView *spinnerView = [[SpinnerView alloc] initWithFrame:superView.bounds];
    
    // Create a new image view, from the image made by our gradient method
    UIImageView *background = [[UIImageView alloc] initWithImage:[spinnerView addBackground]];
    // Make a little bit of the superView show through
    background.alpha = 0.5;
    [spinnerView addSubview:background];
    
//    // If something's gone wrong, abort!
//    if(!spinnerView){ return nil; }
//    // This is the new stuff here ;)
//    UIActivityIndicatorView *indicator =
//    [[UIActivityIndicatorView alloc]
//      initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
//    
//    // Set the resizing mask so it's not stretched
//    indicator.autoresizingMask =
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleLeftMargin;
//    
//    // Place it in the middle of the view
//    indicator.center = superView.center;
//    
//    // Add it into the spinnerView
//    [spinnerView addSubview:indicator];
//    
//    // Start it spinning! Don't miss this step
//    [indicator startAnimating];
//    [indicator release];
    
    NSArray *imageName = @[@"load_01.png",@"load_02.png",@"load_03.png",@"load_04.png",@"load_05.png",@"load_06.png"];
    
    NSMutableArray *imageload = [[NSMutableArray alloc] init];
    for (int i = 0; i<imageName.count; i++) {
        [imageload addObject:[UIImage imageNamed:[imageName objectAtIndex:i]]];
    }
    
    UIImageView *animationLoad = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    animationLoad.animationImages = imageload;
    animationLoad.center = superView.center;
    animationLoad.animationDuration = 1;
    
    [spinnerView addSubview:animationLoad];
    

    // Just to show we've done something, let's make the background black
//    spinnerView.backgroundColor = [UIColor blackColor];
    
    // Add the spinner view to the superView. Boom.
    [superView addSubview:spinnerView];
    [superView release];
    [animationLoad startAnimating];
    return spinnerView;
}

- (UIImage *)addBackground{
    // Create an image context (think of this as a canvas for our masterpiece) the same size as the view
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    
    // Our gradient only has two locations - start and finish. More complex gradients might have more colours
    size_t num_locations = 2;
    
    // The location of the colors is at the start and end
    CGFloat locations[2] = { 0.0, 1.0 };
    
    // These are the colors! That's two RBGA values
    CGFloat components[8] = {
        0.4,0.4,0.4, 0.8,
        0.1,0.1,0.1, 0.5 };
    
    // Create a color space
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    
    // Create a gradient with the values we've set up
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Set the radius to a nice size, 80% of the width. You can adjust this
    float myRadius = (self.bounds.size.width*.8)/2;
    
    // Now we draw the gradient into the context. Think painting onto the canvas
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, self.center, 0, self.center, myRadius, kCGGradientDrawsAfterEndLocation);
    
    // Rip the 'canvas' into a UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // And release memory
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    
    // … obvious.
    return image;
}



- (void)removeSpinnerView{
    [super removeFromSuperview];
}

@end
