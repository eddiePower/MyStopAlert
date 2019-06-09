//
//  StopDetailViewController.h
//  MyStopAlert
//
//  Created by Eddie Power on 8/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface StopDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *txtStopDetailHeader;
@property (strong, nonatomic) IBOutlet UILabel *txtStopNameDetail;
@property (strong, nonatomic) IBOutlet UILabel *txtStopSuburb;
@property (strong, nonatomic) IBOutlet UILabel *txtStopLong;
@property (strong, nonatomic) IBOutlet UILabel *txtStopLatt;
@property (strong, nonatomic) IBOutlet UISegmentedControl *detailMapTypeSelector;
//set values from table view vc.
@property (strong, nonatomic) NSString *stopHeader;
@property (strong, nonatomic) NSString *stopName;
@property (strong, nonatomic) NSString *stopSuburb;
@property (strong, nonatomic) NSString *stopLong;
@property (strong, nonatomic) NSString *stopLatt;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UIView *infoView;
@end

NS_ASSUME_NONNULL_END
