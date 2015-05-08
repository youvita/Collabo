//
//  CustomCell.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/24/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
