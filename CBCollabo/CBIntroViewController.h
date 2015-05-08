//
//  CBIntroViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/23/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "JSON.h"

@interface CBIntroViewController : UIViewController

- (IBAction)sendLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *slide1;
@property (weak, nonatomic) IBOutlet UIView *slide2;
@property (weak, nonatomic) IBOutlet UIView *slide3;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollMenu;

@end
