//
//  CBMoreViewCell.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/6/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMoreViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CBPersonIcon;
@property (weak, nonatomic) IBOutlet UILabel *CBPersonName;
@property (weak, nonatomic) IBOutlet UILabel *CBPersonCompany;
@property (weak, nonatomic) IBOutlet UILabel *CBPersonDateTime;
@property (weak, nonatomic) IBOutlet UILabel *CBPersonContent;
@property (weak, nonatomic) IBOutlet UIButton *CBButtonEdit;
@property (weak, nonatomic) IBOutlet UIButton *CBButtonDelete;

@end
