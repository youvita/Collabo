//
//  CBClassifyViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/13/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "AppUtils.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "SpinnerView.h"
#import "AllUtils.h"

@interface CBClassifyViewController : WCViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)NSString *COLABO_SRNO;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *CBNoneFolderBg;
- (IBAction)onCreateFolderButtonPress:(UIButton *)sender;

@end
