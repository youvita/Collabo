//
//  CBAlarmList101.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/27/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "AllUtils.h"

@interface CBAlarmList101ViewController:WCViewController <UITableViewDelegate,UITableViewDataSource>{
    //====== For pull to Refresh
    BOOL isDragging;
    BOOL isLoading;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//===========Pull to Refresh Property ===========//
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UIImageView *refreshArrow;

@end
