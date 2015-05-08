//
//  CBGroupViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/8/15.
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

@protocol CBGroupViewControllerDelegate <NSObject>

@optional
- (void)didUpdated;
@end


@interface CBGroupViewController : WCViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak)id<CBGroupViewControllerDelegate> delegate;

@property (nonatomic, copy)NSString *COLABO_SRNO;
@property (nonatomic, copy)NSString *READ_USER_CNT;
@property (nonatomic, copy)NSString *USER_ID;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *CBPopPersonIcon;
@property (weak, nonatomic) IBOutlet UILabel *CBPopPersonName;
@property (weak, nonatomic) IBOutlet UILabel *CBPopPersonPhone;
@property (weak, nonatomic) IBOutlet UILabel *CBPopPersonTelephone;
@property (weak, nonatomic) IBOutlet UILabel *CBPopPersonMail;
@property (weak, nonatomic) IBOutlet UILabel *CBPopPersonCompany;
- (IBAction)onClosePopupPress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *CBPopupView;
- (IBAction)onAddGroupButtonPress:(UIButton *)sender;

@end
