//
//  LoginViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/23/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"

@interface CBLoginViewController : WCViewController<UITextFieldDelegate>
- (IBAction)loginButtonPress:(UIButton *)sender;
- (IBAction)checkLogin:(UIButton *)sender;
- (IBAction)onGroupButtonPressed:(UIButton *)sender;

@end
