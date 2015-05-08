//
//  CBCreateViewCell.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/2/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCreateViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CBPersonImage;
@property (weak, nonatomic) IBOutlet UILabel *CBPersonName;
@property (weak, nonatomic) IBOutlet UIImageView *CBPersonCheckbox;
@property (weak, nonatomic) IBOutlet UIImageView *CBLineTop;

@end
