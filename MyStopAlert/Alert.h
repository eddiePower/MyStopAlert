
//
//  Alert.h
//  MyStopAlert
//
//  Created by Eddie Power on 9/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//

#ifndef Alert_h
#define Alert_h
#import <Foundation/Foundation.h>

@interface Alert : NSObject

@property (nonatomic, retain) NSNumber *alarmAlertRadius;
@property (nonatomic, retain) NSNumber *alarmIsActive;
@property (nonatomic, retain) NSDate   *alarmTime;
@property (nonatomic, retain) NSString *alarmTitle;
@property (nonatomic, retain) NSString *alarmDistance;

@end

#endif /* Alert_h */
