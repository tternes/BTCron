//
//  BTCronExpressionTests.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BTCronExpression.h"
#import "XCTestCase+CronTestBaseDates.h"

@interface BTCronExpressionTests : XCTestCase
@end

@implementation BTCronExpressionTests

- (void)testFirstDayOfJune
{
    BTCronExpression *expression = [self expressionForString:@"0 0 1 6 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-06-01 00:00"]);
}

- (void)testFirstDayOfFebruary
{
    BTCronExpression *expression = [self expressionForString:@"0 0 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-02-01 00:00"]);
}

- (void)testFirstDayOfJanuary
{
    // Next first-of-year is in 1971..
    BTCronExpression *expression = [self expressionForString:@"0 0 1 1 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1971-01-01 00:00"]);
}

- (void)testFebruaryTwentyEight
{
    BTCronExpression *expression = [self expressionForString:@"0 0 28 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-02-28 00:00"]);
}

- (void)testFebruaryTwentyNine
{
    // The next February 29 after 1970 was in 1972
    BTCronExpression *expression = [self expressionForString:@"0 0 29 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1972-02-29 00:00"]);
}

- (void)testNoon
{
    BTCronExpression *expression = [self expressionForString:@"0 12 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-02-01 12:00"]);
}

- (void)testOnePM
{
    BTCronExpression *expression = [self expressionForString:@"0 13 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-02-01 13:00"]);
}

- (void)testOneFortyFivePM
{
    BTCronExpression *expression = [self expressionForString:@"45 13 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-02-01 13:45"]);
}

- (void)testNextSunday
{
    // Jan 1, 1970 was a Thursday
    // The next Sunday was Jan 4
    BTCronExpression *expression = [self expressionForString:@"0 0 * * 0"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-01-04 00:00"]);
}

- (void)testWednesdayAtFiveAm
{
    // Jan 1, 1970 was a Thursday
    // The next Wednesday was Jan 7
    BTCronExpression *expression = [self expressionForString:@"0 5 * * 3"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-01-07 05:00"]);
}

- (void)testFridayAfterFebruaryFirst
{
    // Sunday, February 1, 1970
    // Friday = 5 in cron
    // Friday was February 6, 1970
    BTCronExpression *expression = [self expressionForString:@"0 0 * * 5"];
    expression.baseDate = [self bt_dateFromIsoString:@"1970-02-01 00:00"];
    XCTAssertEqualObjects([expression nextDate],
                          [self bt_dateFromIsoString:@"1970-02-06 00:00"]);
}

- (void)testFridaysInMarch
{
    // Thursday, March 1, 1990
    // Friday = 5 in cron
    BTCronExpression *expression = [self expressionForString:@"0 0 * * 5"];
    expression.baseDate = [self bt_dateFromIsoString:@"1990-03-01 00:00"];
    
    // first
    NSDate *firstFriday = [expression nextDate];
    XCTAssertEqualObjects(firstFriday, [self bt_dateFromIsoString:@"1990-03-02 00:00"]);
    
    // second (after first)
    expression.baseDate = firstFriday;
    NSDate *secondFriday = [expression nextDate];
    XCTAssertEqualObjects(secondFriday, [self bt_dateFromIsoString:@"1990-03-09 00:00"]);
    
    // third (...)
    expression.baseDate = secondFriday;
    NSDate *thirdFriday = [expression nextDate];
    XCTAssertEqualObjects(thirdFriday, [self bt_dateFromIsoString:@"1990-03-16 00:00"]);
    
    // fourth
    expression.baseDate = thirdFriday;
    NSDate *fourth = [expression nextDate];
    XCTAssertEqualObjects(fourth, [self bt_dateFromIsoString:@"1990-03-23 00:00"]);
    
    // fifth
    expression.baseDate = fourth;
    NSDate *fifth = [expression nextDate];
    XCTAssertEqualObjects(fifth, [self bt_dateFromIsoString:@"1990-03-30 00:00"]);
    
    // sixth moves to April
    expression.baseDate = fifth;
    NSDate *sixthInApril = [expression nextDate];
    XCTAssertEqualObjects(sixthInApril, [self bt_dateFromIsoString:@"1990-04-06 00:00"]);
}

- (void)testEveryHour
{
    // Start on July 4, 1776
    BTCronExpression *expression = [self expressionForString:@"0 * * * *"];
    expression.baseDate = [self bt_dateFromIsoString:@"1776-06-04 00:00"];
    
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 01:00"]);

    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 02:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 03:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 04:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 05:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 06:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 07:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 08:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 09:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 10:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 11:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 12:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 13:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 14:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 15:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 16:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 17:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 18:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 19:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 20:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 21:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 22:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-04 23:00"]);
    
    expression.baseDate = [expression nextDate];
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1776-06-05 00:00"]);
}

- (void)testEveryMinute
{
    // Start September 1, 1988
    BTCronExpression *expression = [self expressionForString:@"* * * * *"];
    expression.baseDate = [self bt_dateFromIsoString:@"1988-09-01 08:00"];
    
    for(NSInteger minute = 1; minute < 60; minute++)
    {
        NSString *expectedIsoString = [NSString stringWithFormat:@"1988-09-01 08:%02li", (long)minute];
        XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:expectedIsoString]);
        expression.baseDate = [expression nextDate];
    }
    
    // Next minute should roll to 9am
    XCTAssertEqualObjects([expression nextDate], [self bt_dateFromIsoString:@"1988-09-01 09:00"]);
}

#pragma mark - Helpers

- (BTCronExpression *)expressionForString:(NSString *)string
{
    BTCronExpression *expression = [[BTCronExpression alloc] initWithCronLine:string];
    expression.baseDate = [self bt_baseDateForTests];
    expression.timezone = [self bt_timezone];
    return expression;
}

@end
