//
//  StationTableViewCell.h
//  MyStopAlert
//
//  Created by Eddie Power on 8/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *txtStopId;
@property (strong, nonatomic) IBOutlet UILabel *txtStopName;
@property (strong, nonatomic) IBOutlet UILabel *txtStopSuburb;
@property (strong, nonatomic) IBOutlet UILabel *txtstopLongitude;
@property (strong, nonatomic) IBOutlet UILabel *txtStopLatitude;

@end

NS_ASSUME_NONNULL_END
