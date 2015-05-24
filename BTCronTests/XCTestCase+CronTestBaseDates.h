//
//  XCTestCase+CronTestBaseDates.h
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (CronTestBaseDates)

/**
 *  Base date for all tests - Thursday, January 1, 1970
 *
 *  @return Returns the base date for all tests (GMT)
 */
- (NSDate *)bt_baseDateForTests;

/**
 *  Base date timezone (GMT)
 *
 *  @return Returns the base date timezone (GMT)
 */
- (NSTimeZone *)bt_timezone;

/**
 *  Given an ISO string, returns the corresponding NSDate
 */
- (NSDate *)bt_dateFromIsoString:(NSString *)iso;

@end
