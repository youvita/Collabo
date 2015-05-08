//
//  CBSearchList102ViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/30/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "CBCustomCellSearch.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "AllUtils.h"
#import "SpinnerView.h"

@interface CBSearchList102ViewController : WCViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *CBSearchBox;
- (IBAction)CBCloseButtonPress:(UIButton *)sender;
- (IBAction)CBSearchButtonPress:(UIButton *)sender;

@end
