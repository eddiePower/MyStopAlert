//
//  StationTableViewCell.m
//  MyStopAlert
//
//  Description:
//  StationTableViewCell is the cell Controller that
//  builds each cell from the API data pulled in this is
//  a simple representation of each JSON array.
//  It is not stored in a class as that will come later
//  as a Alert object storing this info for alerting.
//
//  Created by Eddie Power on 8/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//

#import "StationTableViewCell.h"

@implementation StationTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
