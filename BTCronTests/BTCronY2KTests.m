//
//  BTCronY2KTests.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/24/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCronParser.h"
#import "XCTestCase+CronTestBaseDates.h"

/**
 *  These tests don't necessarily have anything to do with Y2K - they're
 *  more just goofy tests to test a few really extreme cases
 */
@interface BTCronY2KTests : XCTestCase
@property (nonatomic, strong) BTCronParser *parser;
@end

@implementation BTCronY2KTests

- (void)setUp
{
    [super setUp];
    self.parser = [[BTCronParser alloc] init];
    
    // Friday, December 31, 1999
    self.parser.baseDate = [self bt_dateFromIsoString:@"1999-12-31 23:00"];
    self.parser.timezone = [self bt_timezone];
}

- (void)testHourly
{
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@hourly /drop/the/ball"],
                          [self bt_dateFromIsoString:@"2000-01-01 00:00"]);
}

- (void)testTwelveOhOneAm
{
    XCTAssertEqualObjects([self.parser nextDateForLine:@"1 0 1 1 * /usr/bin/yes"],
                          [self bt_dateFromIsoString:@"2000-01-01 00:01"]);
}

- (void)testUnixTimestampOverflow
{
    // http://en.wikipedia.org/wiki/Unix_time#Representing_the_number
    // One second after 03:14:07 UTC 2038-01-19 this representation will overflow.
    self.parser.baseDate = [self bt_dateFromIsoString:@"2038-01-19 03:14"];
    XCTAssertEqualObjects([self.parser nextDateForLine:@"* * * *    * /usr/bin/false"],
                          [self bt_dateFromIsoString:@"2038-01-19 03:15"]);
}

- (void)testTheYearThreeThousand
{
    self.parser.baseDate = [self bt_dateFromIsoString:@"3000-01-01 00:00"];
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@yearly * /usr/bin/true"],
                          [self bt_dateFromIsoString:@"3001-01-1 00:00"]);
}

- (void)testTheEndOfBtCron
{
    self.parser.baseDate = [self bt_dateFromIsoString:@"9999-01-01 00:00"];
    XCTAssertEqualObjects([self.parser nextDateForLine:@"@yearly * /usr/bin/true"],
                          [self bt_dateFromIsoString:@"10000-01-1 00:00"]); // 👀
}

@end
