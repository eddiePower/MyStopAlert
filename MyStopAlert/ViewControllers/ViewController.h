//
//  ViewController.h
//  MyStopAlert
//
//  Created by Eddie Power on 2/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenerateSigniture.h"
#import "StationTableViewCell.h"
#import "StopDetailViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *myTable;
    NSMutableArray *myMutableArray;
    NSArray *sortedArray;
}


@end

