//
//  BTCronParserTests.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCronParser.h"
#import "XCTestCase+CronTestBaseDates.h"

@interface BTCronParserTests : XCTestCase
@property (nonatomic, strong) BTCronParser *parser;
@end

@implementation BTCronParserTests

- (void)setUp
{
    [super setUp];
    self.parser = [[BTCronParser alloc] init];
    self.parser.baseDate = [self bt_baseDateForTests];
    self.parser.timezone = [self bt_timezone];
}

- (void)testDefaultBaseIsJanuary1970
{
    XCTAssertEqualObjects(self.parser.baseDate, [self bt_dateFromIsoString:@"1970-01-01 00:00"]);
}

- (void)testFirstDayOfJune
{
    // Default Base: January 1, 1970
    XCTAssertEqualObjects([self.parser nextDateForLine:@"0 0 1 6 * /bin/bash"],
                          [self bt_dateFromIsoString:@"1970-06-01 00:00"]);
}

- (void)testPredefinedDaily
{
    // Base: January 1, 1970
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@daily /bin/bash"],
                          [self bt_dateFromIsoString:@"1970-01-02 00:00"]);
}

- (void)testDailyStartingMidday
{
    // Base May 29, 2001; next midnight is May 30
    self.parser.baseDate = [self bt_dateFromIsoString:@"2001-05-29 12:36"];
    
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@daily /bin/bash"],
                          [self bt_dateFromIsoString:@"2001-05-30 00:00"]);
}

- (void)testYearly
{
    self.parser.baseDate = [self bt_dateFromIsoString:@"2001-05-29 12:36"];
    
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@yearly /bin/bash"],
                          [self bt_dateFromIsoString:@"2002-01-01 00:00"]);
}

- (void)testMonthly
{
    self.parser.baseDate = [self bt_dateFromIsoString:@"2001-05-29 12:36"];
    
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@monthly /bin/bash"],
                          [self bt_dateFromIsoString:@"2001-06-01 00:00"]);
}

- (void)testWeekly
{
    // Tuesday, May 29, 2001
    // Weekly runs on Sunday morning => June 3
    self.parser.baseDate = [self bt_dateFromIsoString:@"2001-05-29 12:36"];
    
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@weekly /bin/bash"],
                          [self bt_dateFromIsoString:@"2001-06-03 00:00"]);
}

- (void)testHourly
{
    self.parser.baseDate = [self bt_dateFromIsoString:@"2001-05-29 12:36"];
    
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@hourly /bin/bash"],
                          [self bt_dateFromIsoString:@"2001-05-29 13:00"]);
}

@end
