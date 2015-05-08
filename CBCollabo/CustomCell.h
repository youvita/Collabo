//
//  CustomCell.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/24/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CBlistImage;
@property (weak, nonatomic) IBOutlet UIImageView *CBBgImage;
@property (weak, nonatomic) IBOutlet UILabel *CBlistTitle;
@property (weak, nonatomic) IBOutlet UILabel *CBlistSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *CBlistDateTime;
@property (weak, nonatomic) IBOutlet UILabel *CBNoticeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *CBBgNumber;
@property (weak, nonatomic) IBOutlet UIView *CBNoticeView;

@property (weak, nonatomic) IBOutlet UIImageView *CBAtchFile;

@end
