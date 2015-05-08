//
//  CBGroupViewCell.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/8/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGroupViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CBGPersonIcon;
@property (weak, nonatomic) IBOutlet UILabel *CBGPersonName;
@property (weak, nonatomic) IBOutlet UILabel *CBGPersonCompany;
@property (weak, nonatomic) IBOutlet UIImageView *CBGSendingType;
@property (weak, nonatomic) IBOutlet UIButton *CBGButtonOut;

@end
