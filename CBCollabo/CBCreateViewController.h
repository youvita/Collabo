//
//  CBCreateViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/2/15.
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

@interface CBCreateViewController : WCViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *CBScrollViewListDelete;
@property (weak, nonatomic) IBOutlet UIImageView *CBScrollViewListImage;
@property (weak, nonatomic) IBOutlet UILabel *CBScrollViewListName;
@property (weak, nonatomic) IBOutlet UIImageView *CBTabRecentLine;
@property (weak, nonatomic) IBOutlet UIImageView *CBTabPhoneLine;
@property (weak, nonatomic) IBOutlet UIImageView *CBTabPeopleLine;
@property (weak, nonatomic) IBOutlet UIImageView *CBTabContactLine;
@property (retain, nonatomic) IBOutlet UIView *CBContentViewController;

- (IBAction)CBScrollViewListDeleteButtonPress:(UIButton *)sender;

- (IBAction)CBTabGroupButtonPress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *CBTabView;

@end
