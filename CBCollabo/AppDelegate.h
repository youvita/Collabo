//
//  AppDelegate.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/18/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBIntroViewController.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "AppUtils.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SecurityManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CBIntroViewController *CBIntro;
@property (strong, nonatomic) UINavigationController *navigation;

@end

