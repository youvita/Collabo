//
//  LeftMenuViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/27/15.
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

@interface CBLeftMenuViewController : WCViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
