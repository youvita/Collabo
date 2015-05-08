//
//  SpinnerView.h
//  FetchNews
//
//  Created by Chan Youvita on 3/6/15.
//  Copyright (c) 2015 kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
-(void)removeSpinnerView;
@end
