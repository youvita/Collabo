//
//  CBList102ViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/24/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "SlideNavigationController.h"

@interface CBList102ViewController : WCViewController <SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    //====== For pull to Refresh
    BOOL isDragging;
    BOOL isLoading;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//===========Pull to Refresh Property ===========//
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UIImageView *refreshArrow;

@property (weak, nonatomic) IBOutlet UIView *NoticeBg;
@property (weak, nonatomic) IBOutlet UILabel *NoticeNum;
- (IBAction)onAlarmButtonPress:(UIButton *)sender;
- (IBAction)onSearchButtonPress:(UIButton *)sender;
- (IBAction)onSlideButtonPress:(UIButton *)sender;
- (IBAction)onCreateButtonPress:(UIButton *)sender;

- (IBAction)onMoreMenuButtonPress:(UIButton *)sender;
- (IBAction)onLongPressButtonCell:(UILongPressGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onTopSearchView;

@end
