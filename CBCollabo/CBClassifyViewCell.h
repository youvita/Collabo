//
//  CBClassifyViewCell.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/13/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBClassifyViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CBClassifyFolderName;
@property (weak, nonatomic) IBOutlet UIButton *CBClassifyEditButton;
- (IBAction)onCheckFolderButtonPress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *CBClassifyCheckBox;

@end
