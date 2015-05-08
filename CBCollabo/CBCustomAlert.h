//
//  CBCustomAlert.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/25/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCustomAlert : UIView
{
    id delegate;
    UIView *alertView;
}

@property id delegate;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)AlertDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (void)showInView:(UIView*)view;

@end

@protocol CustomAlertDelegate

- (void)customAlertView:(CBCustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
