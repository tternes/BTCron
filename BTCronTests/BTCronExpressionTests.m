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

@interface BTCronExpressionTests : XCTestCase
@end

@implementation BTCronExpressionTests

- (void)testFirstDayOfJune
{
    BTCronExpression *expression = [self expressionForString:@"0 0 1 6 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1970-06-01 00:00"]);
}

- (void)testFirstDayOfFebruary
{
    BTCronExpression *expression = [self expressionForString:@"0 0 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1970-02-01 00:00"]);
}

- (void)testFirstDayOfJanuary
{
    // Next first-of-year is in 1971..
    BTCronExpression *expression = [self expressionForString:@"0 0 1 1 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1971-01-01 00:00"]);
}

- (void)testFebruaryTwentyEight
{
    BTCronExpression *expression = [self expressionForString:@"0 0 28 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1970-02-28 00:00"]);
}

- (void)testFebruaryTwentyNine
{
    // The next February 29 after 1970 was in 1972
    BTCronExpression *expression = [self expressionForString:@"0 0 29 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1972-02-29 00:00"]);
}

- (void)testNoon
{
    BTCronExpression *expression = [self expressionForString:@"0 12 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1970-02-01 12:00"]);
}

- (void)testOnePM
{
    BTCronExpression *expression = [self expressionForString:@"0 13 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1970-02-01 13:00"]);
}

- (void)testOneFortyFivePM
{
    BTCronExpression *expression = [self expressionForString:@"45 13 1 2 *"];
    XCTAssertEqualObjects([expression nextDate],
                          [self dateFromIsoString:@"1970-02-01 13:45"]);
}

#pragma mark - Helpers

- (BTCronExpression *)expressionForString:(NSString *)string
{
    BTCronExpression *expression = [[BTCronExpression alloc] initWithCronLine:string];
    expression.baseDate = [self baseDateForTests];
    expression.timezone = [self timezone];
    return expression;
}

- (NSDate *)baseDateForTests
{
    return [self dateFromIsoString:@"1970-01-01 00:00"];
}

- (NSTimeZone *)timezone
{
    return [NSTimeZone timeZoneForSecondsFromGMT:0];
}

- (NSDate *)dateFromIsoString:(NSString *)iso
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [formatter setTimeZone:[self timezone]];
    return [formatter dateFromString:iso];
}

@end
