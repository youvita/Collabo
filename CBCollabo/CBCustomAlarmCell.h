//
//  CBCustomAlarmCell.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/27/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCustomAlarmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CBAlarmPerson;
@property (weak, nonatomic) IBOutlet UILabel *CBAlarmTitle;
@property (weak, nonatomic) IBOutlet UILabel *CBAlarmSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *CBAlarmDateTime;

@end
