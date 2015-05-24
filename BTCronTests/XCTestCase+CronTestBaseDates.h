//
//  XCTestCase+CronTestBaseDates.h
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (CronTestBaseDates)

- (NSDate *)bt_baseDateForTests;
- (NSTimeZone *)bt_timezone;
- (NSDate *)bt_dateFromIsoString:(NSString *)iso;

@end
