//
//  CBMoreViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/6/15.
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
#import "ToastView.h"

@interface CBMoreViewController : WCViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy)NSString *COLABO_SRNO;
@property (nonatomic, copy)NSString *SENDIENCE_GB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onReplyButtonPress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *CBReplyButton;



@end
