//
//  CBSingupViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/3/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysUtils.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "AppUtils.h"
#import "SpinnerView.h"
#import "WCViewController.h"

@interface CBSingupViewController : WCViewController
@property (weak, nonatomic) IBOutlet UIImageView *CBProfileIcon;
@property (weak, nonatomic) IBOutlet UILabel *CBProfileName;
@property (weak, nonatomic) IBOutlet UILabel *CBProfileCompany;
@property (weak, nonatomic) IBOutlet UILabel *CBProfilePhone;
@property (weak, nonatomic) IBOutlet UILabel *CBProfileMail;
- (IBAction)onAlarmRowPress:(UITapGestureRecognizer *)sender;
- (IBAction)onMoreRowPress:(UITapGestureRecognizer *)sender;
- (IBAction)onGroupAppButtonPress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *CBAppVersion;

@end
